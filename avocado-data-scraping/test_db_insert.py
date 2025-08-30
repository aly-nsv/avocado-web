#!/usr/bin/env python3
"""
Quick test to insert a sample incident directly into the database
to verify database connection and schema are working
"""

import os
import sys
from datetime import datetime
from sqlalchemy import create_engine, text
from google.cloud.sql.connector import Connector

# Database connection
PROJECT_ID = "avocado-fl511-video"
REGION = "us-central1"
DATABASE_NAME = "fl511_incidents"
DATABASE_USER = "fl511_user"
DATABASE_PASSWORD = "AfUa9sQ7r6PcXufDVPJhwK"

def test_database_insert():
    """Test database connection and incident insertion"""
    try:
        print("🔗 Setting up database connection...")
        
        # Initialize Cloud SQL Python Connector
        connector = Connector()
        
        def getconn():
            conn = connector.connect(
                f"{PROJECT_ID}:{REGION}:fl511-metadata-db",
                "pg8000",
                user=DATABASE_USER,
                password=DATABASE_PASSWORD,
                db=DATABASE_NAME
            )
            return conn
        
        # Create connection pool
        db_pool = create_engine(
            "postgresql+pg8000://",
            creator=getconn,
            pool_size=5,
            max_overflow=2,
            pool_pre_ping=True,
            pool_recycle=1800,
        )
        
        print("✅ Database connection established")
        
        # Test basic query
        with db_pool.connect() as conn:
            result = conn.execute(text("SELECT COUNT(*) FROM cameras"))
            camera_count = result.fetchone()[0]
            print(f"📊 Found {camera_count} cameras in database")
            
            # Test incident insertion
            test_incident = {
                'incident_id': 999999,
                'dt_row_id': 'TEST001',
                'source_id': 'TEST',
                'roadway_name': 'I-4',
                'county': 'Hillsborough',
                'region': 'Tampa Bay',
                'incident_type': 'Test',
                'severity': 'Minor',
                'direction': 'Eastbound',
                'description': 'Test incident insertion from debug script',
                'start_date': datetime.now(),
                'last_updated': datetime.now(),
                'source': 'DEBUG-SCRIPT',
                'scraped_at': datetime.now()
            }
            
            print("📝 Testing incident insertion...")
            conn.execute(text("""
                INSERT INTO incidents 
                (incident_id, dt_row_id, source_id, roadway_name, county, region, incident_type, 
                 severity, direction, description, start_date, last_updated, source, scraped_at)
                VALUES (:incident_id, :dt_row_id, :source_id, :roadway_name, :county, :region, :incident_type,
                        :severity, :direction, :description, :start_date, :last_updated, :source, :scraped_at)
                ON CONFLICT (incident_id) DO UPDATE SET
                    last_updated = EXCLUDED.last_updated,
                    description = EXCLUDED.description,
                    updated_at = CURRENT_TIMESTAMP
            """), test_incident)
            
            conn.commit()
            print("✅ Test incident inserted successfully!")
            
            # Verify insertion
            result = conn.execute(text("SELECT COUNT(*) FROM incidents WHERE incident_id = 999999"))
            count = result.fetchone()[0]
            print(f"📊 Verified: {count} test incident(s) in database")
            
            # Show recent incidents
            result = conn.execute(text("""
                SELECT incident_id, roadway_name, incident_type, source, scraped_at
                FROM incidents 
                ORDER BY scraped_at DESC 
                LIMIT 5
            """))
            
            print("📋 Recent incidents:")
            for row in result:
                print(f"  - {row[0]}: {row[1]} {row[2]} ({row[3]}) at {row[4]}")
                
    except Exception as e:
        print(f"❌ Database test failed: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    print("✅ Database connection and insertion test completed successfully!")
    return True

if __name__ == "__main__":
    test_database_insert()