#!/usr/bin/env python3
"""
AI-Based Incident Labeling System

Uses GPT-4 to automatically predict labels for traffic incidents based on their descriptions.
Labels are defined in label-types.json and predictions are stored in the incidents table.

This script:
1. Queries incidents from database in batches (unlabeled ones only)  
2. Calls OpenAI GPT-4 API with structured prompts
3. Gets label predictions with confidence scores
4. Stores results back to database as JSONB

Usage:
    python incident_labeling_ai.py --test-batch 10    # Process 10 incidents for testing
    python incident_labeling_ai.py --all              # Process all unlabeled incidents
    python incident_labeling_ai.py --batch-size 50    # Process in batches of 50
"""

import os
import json
import logging
import psycopg2
import uuid
from datetime import datetime, timezone
from typing import Dict, List, Optional, Tuple
import argparse
import time
from dataclasses import dataclass

# OpenAI imports
try:
    from openai import OpenAI
except ImportError:
    print("❌ OpenAI package not installed. Run: pip install openai")
    exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('incident_labeling.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class Incident:
    """Represents an incident from the database"""
    incident_id: int
    description: str
    incident_type: str
    roadway_name: str
    region: str
    severity: Optional[str] = None

@dataclass
class LabelPrediction:
    """Represents a label prediction from GPT-4"""
    label_type: str
    confidence: float
    category: str
    reasoning: str

class IncidentLabeler:
    """AI-powered incident labeling using GPT-4"""
    
    def __init__(self, openai_api_key: Optional[str] = None):
        """
        Initialize the incident labeler
        
        Args:
            openai_api_key: OpenAI API key (if None, reads from environment)
        """
        # Setup OpenAI client
        api_key = openai_api_key or os.getenv('OPENAI_API_KEY')
        if not api_key:
            raise ValueError("OpenAI API key not provided. Set OPENAI_API_KEY environment variable or pass as parameter.")
        
        self.client = OpenAI(api_key=api_key)
        
        # Database config (matches crash_alert_monitor.py)
        self.db_config = {
            'host': '34.42.128.70',
            'database': 'fl511_incidents',
            'user': 'fl511_user',
            'password': 'AfUa9sQ7r6PcXufDVPJhwK'
        }
        
        # Load label types from JSON
        self.label_types = self._load_label_types()
        
        logger.info("🤖 AI Incident Labeler initialized")
        logger.info(f"   Loaded {len(self.label_types['incidents']) + len(self.label_types['actors'])} label types")
        
    def _load_label_types(self) -> Dict:
        """Load label types from label-types.json"""
        try:
            with open('../label-types.json', 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            try:
                with open('label-types.json', 'r') as f:
                    return json.load(f)
            except FileNotFoundError:
                raise FileNotFoundError("label-types.json not found. Please ensure it's in the current directory or parent directory.")
    
    def get_unlabeled_incidents(self, limit: Optional[int] = None) -> List[Incident]:
        """
        Get incidents that don't have labels yet
        
        Args:
            limit: Maximum number of incidents to return (None for all)
            
        Returns:
            List of unlabeled incidents
        """
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor()
            
            # Query for incidents without labels
            query = """
                SELECT incident_id, description, incident_type, roadway_name, region, severity
                FROM incidents 
                WHERE (labels IS NULL OR labels = '[]'::jsonb)
                  AND description IS NOT NULL 
                  AND description != ''
                ORDER BY incident_id DESC
            """
            
            if limit:
                query += f" LIMIT {limit}"
            
            cur.execute(query)
            results = cur.fetchall()
            
            incidents = []
            for row in results:
                incidents.append(Incident(
                    incident_id=row[0],
                    description=row[1] or "",
                    incident_type=row[2] or "",
                    roadway_name=row[3] or "",
                    region=row[4] or "",
                    severity=row[5]
                ))
            
            conn.close()
            logger.info(f"📊 Found {len(incidents)} unlabeled incidents")
            return incidents
            
        except Exception as e:
            logger.error(f"❌ Error querying unlabeled incidents: {e}")
            return []
    
    def _create_labeling_prompt(self, incident: Incident) -> str:
        """Create a structured prompt for GPT-4 to predict labels"""
        
        # Extract relevant label types for the prompt
        incident_labels = [
            f"- {label['label_type']}: {label['description']}"
            for label in self.label_types['incidents']
        ]
        
        actor_labels = [
            f"- {label['label_type']}: {label['description']}"
            for label in self.label_types['actors']
        ]
        
        prompt = f"""You are an expert traffic incident analyst. Analyze the following traffic incident description and predict which labels apply.

INCIDENT DETAILS:
- ID: {incident.incident_id}
- Type: {incident.incident_type}
- Location: {incident.roadway_name}, {incident.region}
- Severity: {incident.severity or 'Unknown'}
- Description: "{incident.description}"

AVAILABLE INCIDENT LABELS:
{chr(10).join(incident_labels)}

AVAILABLE ACTOR LABELS:
{chr(10).join(actor_labels)}

INSTRUCTIONS:
1. Only predict labels that you are confident apply based on the incident description
2. For each label you predict, provide a confidence score between 0.0 and 1.0
3. Only include labels with confidence >= 0.6
4. Provide brief reasoning for each prediction
5. Respond in valid JSON format

RESPONSE FORMAT:
{{
    "predictions": [
        {{
            "label_type": "collision",
            "confidence": 0.95,
            "category": "Collision", 
            "reasoning": "Description explicitly mentions vehicle collision"
        }},
        {{
            "label_type": "passenger_vehicle",
            "confidence": 0.85,
            "category": "Passenger Vehicle (Car/Small Vehicle)",
            "reasoning": "Typical vehicle involved in described incident"
        }}
    ]
}}

Analyze the incident and provide your predictions:"""
        
        return prompt
    
    def predict_labels(self, incident: Incident) -> List[LabelPrediction]:
        """
        Use GPT-4 to predict labels for an incident
        
        Args:
            incident: Incident to analyze
            
        Returns:
            List of label predictions
        """
        try:
            prompt = self._create_labeling_prompt(incident)
            
            logger.info(f"🤖 Analyzing incident {incident.incident_id}: {incident.description[:100]}...")
            
            response = self.client.chat.completions.create(
                model="gpt-4",  # Using GPT-4 as requested
                messages=[
                    {
                        "role": "system",
                        "content": "You are an expert traffic incident analyst. Respond only with valid JSON."
                    },
                    {
                        "role": "user", 
                        "content": prompt
                    }
                ],
                temperature=0.1,  # Low temperature for consistent results
                max_tokens=1000
            )
            
            # Parse GPT-4 response
            response_text = response.choices[0].message.content.strip()
            
            try:
                response_data = json.loads(response_text)
                predictions = []
                
                for pred in response_data.get('predictions', []):
                    predictions.append(LabelPrediction(
                        label_type=pred['label_type'],
                        confidence=pred['confidence'],
                        category=pred['category'],
                        reasoning=pred['reasoning']
                    ))
                
                logger.info(f"✅ Predicted {len(predictions)} labels for incident {incident.incident_id}")
                return predictions
                
            except json.JSONDecodeError as e:
                logger.error(f"❌ Failed to parse GPT-4 response as JSON for incident {incident.incident_id}: {e}")
                logger.error(f"   Raw response: {response_text}")
                return []
                
        except Exception as e:
            logger.error(f"❌ Error getting predictions for incident {incident.incident_id}: {e}")
            return []
    
    def store_predictions(self, incident: Incident, predictions: List[LabelPrediction], batch_id: str):
        """
        Store label predictions in the database
        
        Args:
            incident: The incident that was analyzed
            predictions: List of predictions from GPT-4
            batch_id: UUID for tracking this batch
        """
        if not predictions:
            logger.warning(f"⚠️ No predictions to store for incident {incident.incident_id}")
            return
        
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor()
            
            # Convert predictions to JSON format
            labels_json = []
            timestamp = datetime.now(timezone.utc).isoformat()
            
            for pred in predictions:
                label_obj = {
                    "label_type": pred.label_type,
                    "confidence": pred.confidence,
                    "source": "ai",
                    "model": "gpt-4",
                    "timestamp": timestamp,
                    "metadata": {
                        "from_description": True,
                        "batch_id": batch_id,
                        "category": pred.category,
                        "reasoning": pred.reasoning,
                        "description_analyzed": incident.description[:200]  # Store snippet for reference
                    }
                }
                labels_json.append(label_obj)
            
            # Update incident with labels
            cur.execute(
                "UPDATE incidents SET labels = %s WHERE incident_id = %s",
                (json.dumps(labels_json), incident.incident_id)
            )
            
            conn.commit()
            conn.close()
            
            logger.info(f"💾 Stored {len(predictions)} labels for incident {incident.incident_id}")
            
        except Exception as e:
            logger.error(f"❌ Error storing predictions for incident {incident.incident_id}: {e}")
    
    def process_batch(self, incidents: List[Incident], batch_id: Optional[str] = None) -> Dict[str, int]:
        """
        Process a batch of incidents
        
        Args:
            incidents: List of incidents to process
            batch_id: Optional batch ID (generates UUID if None)
            
        Returns:
            Processing statistics
        """
        if not batch_id:
            batch_id = str(uuid.uuid4())
        
        stats = {
            'total_processed': 0,
            'successful': 0,
            'failed': 0,
            'total_labels': 0
        }
        
        logger.info(f"🚀 Starting batch processing: {len(incidents)} incidents")
        logger.info(f"   Batch ID: {batch_id}")
        
        for i, incident in enumerate(incidents, 1):
            try:
                logger.info(f"📋 Processing incident {i}/{len(incidents)}: {incident.incident_id}")
                
                # Get predictions from GPT-4
                predictions = self.predict_labels(incident)
                
                # Store in database
                self.store_predictions(incident, predictions, batch_id)
                
                stats['total_processed'] += 1
                stats['successful'] += 1
                stats['total_labels'] += len(predictions)
                
                # Rate limiting - avoid overwhelming OpenAI API
                time.sleep(1)  # 1 second between requests
                
            except Exception as e:
                logger.error(f"❌ Failed to process incident {incident.incident_id}: {e}")
                stats['failed'] += 1
                stats['total_processed'] += 1
        
        logger.info(f"✅ Batch processing complete!")
        logger.info(f"   Total processed: {stats['total_processed']}")
        logger.info(f"   Successful: {stats['successful']}")
        logger.info(f"   Failed: {stats['failed']}")
        logger.info(f"   Total labels created: {stats['total_labels']}")
        
        return stats

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description='AI-powered incident labeling using GPT-4')
    parser.add_argument('--test-batch', type=int, help='Process N incidents for testing (e.g., --test-batch 10)')
    parser.add_argument('--all', action='store_true', help='Process all unlabeled incidents')
    parser.add_argument('--batch-size', type=int, default=25, help='Batch size for processing (default: 25)')
    parser.add_argument('--openai-key', help='OpenAI API key (or set OPENAI_API_KEY env var)')
    
    args = parser.parse_args()
    
    # Validate arguments
    if not args.test_batch and not args.all:
        print("❌ Please specify either --test-batch N or --all")
        parser.print_help()
        return
    
    try:
        # Initialize labeler
        labeler = IncidentLabeler(openai_api_key=args.openai_key)
        
        # Determine how many incidents to process
        if args.test_batch:
            limit = args.test_batch
            logger.info(f"🧪 TEST MODE: Processing {limit} incidents")
        else:
            limit = None
            logger.info(f"🏭 FULL MODE: Processing all unlabeled incidents")
        
        # Get unlabeled incidents
        incidents = labeler.get_unlabeled_incidents(limit=limit)
        
        if not incidents:
            logger.info("✅ No unlabeled incidents found!")
            return
        
        # Process in batches
        batch_size = args.batch_size
        total_stats = {'total_processed': 0, 'successful': 0, 'failed': 0, 'total_labels': 0}
        
        for i in range(0, len(incidents), batch_size):
            batch = incidents[i:i + batch_size]
            batch_num = (i // batch_size) + 1
            total_batches = ((len(incidents) - 1) // batch_size) + 1
            
            logger.info(f"📦 Processing batch {batch_num}/{total_batches} ({len(batch)} incidents)")
            
            batch_stats = labeler.process_batch(batch)
            
            # Aggregate stats
            for key in total_stats:
                total_stats[key] += batch_stats[key]
            
            # Wait between batches to be respectful to the API
            if i + batch_size < len(incidents):
                logger.info("⏱️ Waiting 5 seconds before next batch...")
                time.sleep(5)
        
        # Final summary
        logger.info("🎉 ALL PROCESSING COMPLETE!")
        logger.info(f"   Total incidents processed: {total_stats['total_processed']}")
        logger.info(f"   Successful: {total_stats['successful']}")
        logger.info(f"   Failed: {total_stats['failed']}")
        logger.info(f"   Total labels generated: {total_stats['total_labels']}")
        logger.info(f"   Average labels per incident: {total_stats['total_labels']/max(total_stats['successful'], 1):.1f}")
        
    except Exception as e:
        logger.error(f"💥 Fatal error: {e}")
        raise

if __name__ == "__main__":
    main()
