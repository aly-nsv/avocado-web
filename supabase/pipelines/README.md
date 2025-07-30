# Traffic Camera Data Pipeline

This directory contains data pipeline scripts for migrating traffic camera data from various sources into the Supabase PostgreSQL database.

## 🚀 **Quick Start**

### **Prerequisites**
- Node.js 18+ with npm
- Python 3.8+ (for Python pipeline)
- Supabase project with service role key
- Florida 511 camera JSON data files

### **Environment Setup**
```bash
# In your .env.local file:
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### **Run TypeScript Pipeline (Recommended)**
```bash
# Dry run first
npx tsx supabase/pipelines/migrate-florida-cameras.ts --dry-run

# Execute migration
npx tsx supabase/pipelines/migrate-florida-cameras.ts --execute

# Validate existing data
npx tsx supabase/pipelines/migrate-florida-cameras.ts --validate-only
```

## 📁 **Pipeline Options**

### **1. TypeScript Pipeline** (`migrate-florida-cameras.ts`)
**✨ Recommended for this project**

**Advantages:**
- Uses same Supabase client as main application
- TypeScript type safety with database schema
- Consistent error handling and logging
- Built-in validation and dry-run mode

**Usage:**
```bash
npx tsx supabase/pipelines/migrate-florida-cameras.ts [options]

Options:
  --dry-run        Preview changes without writing to database
  --validate-only  Run validation queries only
  --help          Show help message
```

### **2. Python Pipeline** (`json_to_supabase_migration.py`)
**🐍 For data scientists and Python-first teams**

**Advantages:**
- Rich data processing capabilities with pandas
- Advanced logging with tqdm progress bars
- Robust error handling and recovery
- Batch processing optimization

**Setup:**
```bash
pip install supabase python-dotenv tqdm psycopg2-binary
```

**Usage:**
```bash
python supabase/pipelines/json_to_supabase_migration.py \
  --source avocado-data-scraping/ \
  --dry-run

python supabase/pipelines/json_to_supabase_migration.py \
  --source avocado-data-scraping/ \
  --execute
```

### **3. SQL Pipeline** (`migrate_cameras.sql`)
**⚡ For database administrators and SQL experts**

**Advantages:**
- Pure SQL implementation
- Database-native transformations
- Custom functions for reusable operations
- Direct database access without API overhead

**Usage:**
```sql
-- 1. Load JSON data into temp table
INSERT INTO temp_florida_cameras_json (json_data) 
SELECT jsonb_array_elements(pg_read_file('path/to/cameras.json')::jsonb);

-- 2. Run migration
SELECT * FROM migrate_florida_cameras_from_json();

-- 3. Validate results
SELECT * FROM validate_camera_migration();
```

## 🏗️ **Data Pipeline Architecture**

### **Source → Transform → Load Process**

```
Florida 511 JSON Files
         ↓
   Data Validation
         ↓
   Schema Transformation
         ↓
   Deduplication Check
         ↓
   Supabase Database
         ↓
   API v2 Endpoints
```

### **Data Transformation**

The pipeline transforms Florida 511 camera data as follows:

| FL511 Field | Database Column | Transformation |
|-------------|----------------|----------------|
| `id` | `external_id` | String conversion |
| `name` | `name` | Trim whitespace |
| `latitude`/`longitude` | `latitude`/`longitude` | Numeric validation |
| `region` | `region` | Clean string |
| `video_url` | `video_url` | URL validation |
| `equipment_type` | `equipment_metadata` | JSON object |
| `raw_data` | `raw_data` | Complete preservation |

### **Schema Compatibility**

The universal schema supports:
- **Multiple States**: FL, CA, TX, etc.
- **Various Data Sources**: FL511, Caltrans, TxDOT
- **Equipment Types**: HLS streams, IP cameras, PTZ
- **Metadata Extensibility**: JSON columns for future features

## 🔄 **API Versioning Strategy**

### **v1 API** (`/api/cameras/v1/[state]`)
- **Data Source**: JSON files (static)
- **Use Case**: Development, proof-of-concept
- **Performance**: Fast file reading
- **Limitations**: No real-time updates

### **v2 API** (`/api/cameras/v2/[state]`)
- **Data Source**: Supabase database
- **Use Case**: Production, real-time applications
- **Performance**: Database queries with caching
- **Features**: Filtering, pagination, live updates

### **Migration Path**
1. **Phase 1**: Use v1 for development
2. **Phase 2**: Run data pipeline to populate database
3. **Phase 3**: Switch application to v2 API
4. **Phase 4**: Deprecate v1 (optional)

## 📊 **Monitoring & Validation**

### **Pipeline Metrics**
- Total cameras processed
- Insert/update/error counts
- Processing duration
- Regional distribution
- Data quality scores

### **Data Quality Checks**
- Required field validation
- Geographic coordinate bounds
- URL accessibility tests
- Duplicate detection
- Schema compliance

### **Validation Queries**
```sql
-- Camera count by region
SELECT region, COUNT(*) FROM traffic_cameras 
WHERE data_source = 'fl511' GROUP BY region;

-- Video stream availability
SELECT COUNT(*) FROM traffic_cameras 
WHERE video_url IS NOT NULL AND data_source = 'fl511';

-- Recent updates
SELECT COUNT(*) FROM traffic_cameras 
WHERE updated_at > NOW() - INTERVAL '1 day';
```

## 🚨 **Error Handling & Recovery**

### **Common Issues & Solutions**

| Issue | Cause | Solution |
|-------|-------|----------|
| Duplicate cameras | Re-running pipeline | Built-in deduplication |
| Invalid coordinates | Bad source data | Validation with skip |
| Missing video URLs | Equipment offline | Graceful null handling |
| Schema changes | Database evolution | Migration scripts |

### **Recovery Procedures**
1. **Backup database** before major migrations
2. **Use dry-run mode** to preview changes
3. **Monitor logs** for error patterns
4. **Validate results** after completion

## 🔮 **Future Enhancements**

### **Planned Features**
- **Multi-state support**: Extend to other DOT systems
- **Real-time sync**: WebSocket updates from source APIs
- **ML integration**: Camera quality scoring
- **Performance optimization**: Parallel processing
- **Monitoring dashboard**: Pipeline health metrics

### **Extensibility**
The pipeline architecture supports:
- Additional data sources (Caltrans, TxDOT)
- Custom transformation rules
- Multiple output formats
- Integration with external APIs

---

## 🤝 **Contributing**

When adding new pipelines:
1. Follow the established patterns
2. Include comprehensive error handling
3. Add validation functions
4. Update this documentation
5. Test with dry-run mode

## 📝 **Logs**

Pipeline logs are saved to:
- TypeScript: `supabase/pipelines/migration.log`
- Python: `migration.log`
- SQL: Database logs

Review logs after each migration for errors and performance insights.