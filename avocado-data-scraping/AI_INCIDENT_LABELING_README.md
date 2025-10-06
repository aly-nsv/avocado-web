# AI-Based Incident Labeling System

Automatically label traffic incidents using GPT-4 based on incident descriptions. This system queries incidents from the database, sends descriptions to OpenAI's GPT-4 API, and stores structured label predictions back to the database.

## 🚀 Quick Start

### 1. Database Setup

First, apply the database migration to add the labels column to incidents:

```bash
cd /Users/alyshahudson/Desktop/repos/avocado/avocado-data-scraping

# Connect to your PostgreSQL database and run the migration
psql -h 34.42.128.70 -d fl511_incidents -U fl511_user -f migrations/add_labels_column_to_incidents.sql
```

### 2. Install Dependencies

Install the required Python packages:

```bash
pip install openai psycopg2-binary
```

### 3. Configure OpenAI API Key

You have two options for providing your OpenAI API key:

**Option A: Environment Variable (Recommended)**
```bash
export OPENAI_API_KEY="your-api-key-here"
```

**Option B: Command Line Parameter**
```bash
python incident_labeling_ai.py --openai-key "your-api-key-here" --test-batch 10

```

### 4. Test with Small Batch

Start with a test batch of 10 incidents to make sure everything works:

```bash
python incident_labeling_ai.py --test-batch 10
```

### 5. Run Full Processing

Once you're satisfied with the results, process all unlabeled incidents:

```bash
python incident_labeling_ai.py --all
```

## 📋 Usage Examples

### Process 10 incidents for testing
```bash
python incident_labeling_ai.py --test-batch 10
```

### Process all unlabeled incidents
```bash
python incident_labeling_ai.py --all
```

### Process with custom batch size (default is 25)
```bash
python incident_labeling_ai.py --all --batch-size 50
```

### Provide API key via command line
```bash
python incident_labeling_ai.py --test-batch 5 --openai-key "sk-your-key-here"
```

## 🔧 How It Works

1. **Database Query**: Fetches incidents that don't have labels (`labels IS NULL OR labels = '[]'::jsonb`)
2. **GPT-4 Analysis**: Sends incident descriptions to GPT-4 with structured prompts based on `label-types.json`
3. **Label Prediction**: GPT-4 returns predictions with confidence scores (only labels ≥ 0.6 confidence are kept)
4. **Database Storage**: Stores predictions as JSONB in the `incidents.labels` column

## 📊 Label Types

The system uses label definitions from `label-types.json` which includes:

**Incident Labels:**
- collision, stationary_vehicle, impediment, vru_incident
- fod_hazardous_material, fod_generic_debris, fatal
- roadway_departure, queue_present, congestion, harsh_braking
- swerving, duration_based_severity, cmv_involved, speeding

**Actor Labels:**
- passenger_vehicle, commercial_vehicle, emergency_vehicle
- motorcycle, pedestrian, debris_generic, hazmat_presence
- disabled_vehicle, bus, bicycle, trailer, tire
- channelizing_device, heavy_equipment, unspecified_actor

## 💾 Database Schema

Labels are stored as JSONB in the `incidents.labels` column:

```json
[
  {
    "label_type": "collision",
    "confidence": 0.90,
    "source": "ai",
    "model": "gpt-4",
    "timestamp": "2025-09-09T20:15:00Z",
    "metadata": {
      "from_description": true,
      "batch_id": "550e8400-e29b-41d4-a716-446655440001",
      "category": "Collision",
      "reasoning": "Description explicitly mentions vehicle collision",
      "description_analyzed": "Vehicle collision on I-4 westbound..."
    }
  }
]
```

## 🚨 Important Notes

### API Rate Limits
- The script includes 1-second delays between API calls
- Includes 5-second delays between batches
- Default batch size is 25 incidents

### Cost Considerations
- GPT-4 API calls cost money (approximately $0.03 per 1K tokens)
- Each incident analysis uses ~500-1000 tokens
- Estimated cost: ~$0.02-0.05 per incident
- For 1000 incidents: ~$20-50

### Successive Runs
The script automatically skips incidents that already have labels, so you can run it multiple times safely. It will only process newly added incidents that don't have labels yet.

## 📈 Monitoring and Logs

The script creates detailed logs in:
- `incident_labeling.log` - File log with all processing details
- Console output with real-time progress

Example log output:
```
2025-09-09 20:15:00 - INFO - 🤖 AI Incident Labeler initialized
2025-09-09 20:15:01 - INFO -    Loaded 37 label types
2025-09-09 20:15:02 - INFO - 📊 Found 1250 unlabeled incidents
2025-09-09 20:15:03 - INFO - 🧪 TEST MODE: Processing 10 incidents
2025-09-09 20:15:04 - INFO - 🚀 Starting batch processing: 10 incidents
```

## 🔍 Querying Results

After processing, you can query labeled incidents:

```sql
-- Find incidents with collision labels
SELECT incident_id, description, labels 
FROM incidents 
WHERE labels @> '[{"label_type": "collision"}]';

-- Count incidents by label type
SELECT 
  label->>'label_type' as label_type,
  COUNT(*) as incident_count
FROM incidents, jsonb_array_elements(labels) as label
WHERE labels IS NOT NULL
GROUP BY label->>'label_type'
ORDER BY incident_count DESC;

-- Find high-confidence predictions
SELECT incident_id, description, labels
FROM incidents, jsonb_array_elements(labels) as label  
WHERE (label->>'confidence')::float > 0.9;
```

## 🐛 Troubleshooting

### "OpenAI package not installed"
```bash
pip install openai
```

### "OpenAI API key not provided"
Set your API key:
```bash
export OPENAI_API_KEY="sk-your-key-here"
```

### "label-types.json not found"
Make sure you're running from the avocado-data-scraping directory, or that label-types.json is in the parent directory.

### Database connection issues
Verify the database credentials in the script match your setup.

### API rate limit errors
The script includes rate limiting, but if you hit limits, you can:
- Reduce batch size: `--batch-size 10`
- The script will automatically retry failed incidents

## 📝 Next Steps

1. **Start with test batch**: `python incident_labeling_ai.py --test-batch 10`
2. **Review results** in database and logs
3. **Adjust parameters** if needed (batch size, etc.)
4. **Run full processing**: `python incident_labeling_ai.py --all`
5. **Set up periodic runs** for new incidents (cron job, etc.)

---

**Need help?** Check the logs in `incident_labeling.log` for detailed error messages and processing information.
