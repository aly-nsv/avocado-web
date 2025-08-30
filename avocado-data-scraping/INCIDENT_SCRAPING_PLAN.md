# FL511 Incident Scraping - Full Operational Plan

## 🎯 **OBJECTIVE**
Deploy fully automated FL511 incident scraping system with real-time correlation to video segments at production scale.

## 📊 **TARGET METRICS**
- **Polling Frequency**: Every 3 minutes (20 polls/hour)
- **Expected Incidents**: 20-40 incidents/hour during peak traffic
- **Correlation Rate**: >70% incidents with video evidence within 2km/60min
- **Latency**: <5 minutes from incident occurrence to database storage
- **Reliability**: >99% uptime with automatic error recovery

## 🔧 **TECHNICAL DESIGN**

### **1. Incident Scraping Architecture**
```
FL511 API → Cloud Run Service → PostgreSQL Database → Correlation Engine
    ↓              ↓                    ↓                    ↓
Every 3min    Parse & Store        Clean Schema      Spatial-Temporal
             Error Handling      Duplicate Check      Matching
```

### **2. Data Flow Design**
```python
# Incident Processing Pipeline
1. HTTP GET: FL511 incidents API (paginated)
2. Parse: Convert FL511 format to database schema  
3. Validate: Check required fields, deduplicate
4. Store: Insert to incidents table with conflict resolution
5. Correlate: Run spatial-temporal matching with video segments
6. Monitor: Log metrics and health status
```

### **3. Error Recovery Strategy**
- **API Rate Limits**: Exponential backoff, max 100 requests/hour
- **Network Failures**: 3 retries with 30-second delays
- **Database Errors**: Transaction rollback, dead letter queue
- **Parsing Errors**: Log and continue, don't block pipeline

### **4. Scalability Considerations**
- **Database Connections**: Pool size 5, max 25 concurrent
- **Memory Usage**: 2GB allocation, streaming JSON parsing
- **Storage Growth**: ~50MB/day for incident data
- **Query Performance**: Indexed on roadway, time, region

## 🚀 **IMPLEMENTATION PHASES**

### **Phase 1: Fix Core Issues (30 minutes)**
1. ✅ Repair incident database insertion bug
2. ✅ Deploy updated video capture service  
3. ✅ Test manual incident scraping end-to-end

### **Phase 2: Automated Operations (45 minutes)**
1. ✅ Configure Cloud Scheduler for 3-minute polling
2. ✅ Enable automated correlation after each scrape
3. ✅ Test automated pipeline for 1 hour

### **Phase 3: Production Readiness (30 minutes)**
1. ✅ Setup monitoring and alerting
2. ✅ Create health check endpoints
3. ✅ Document operational procedures

## 🔍 **QUALITY ASSURANCE**

### **Testing Strategy**
- **Unit Tests**: Database insertion functions
- **Integration Tests**: End-to-end API → Database → Correlation
- **Load Tests**: Handle peak traffic scenarios (50+ incidents/hour)
- **Failure Tests**: API downtime, database connection loss

### **Data Quality Checks**
- **Completeness**: All required fields present
- **Accuracy**: Coordinates within Florida bounds
- **Freshness**: No incidents older than 24 hours
- **Duplicates**: Unique incident_id constraint

## 📈 **MONITORING & ALERTING**

### **Key Health Metrics**
```python
# Operational Metrics
- incidents_scraped_per_hour: Target 20-40
- database_insertion_success_rate: Target >95%
- correlation_match_rate: Target >70%
- api_response_time: Target <5 seconds
- pipeline_end_to_end_latency: Target <5 minutes
```

### **Alert Conditions**
- 🚨 **Critical**: No incidents scraped in 30 minutes
- ⚠️  **Warning**: Database insertion failure rate >10%
- ℹ️  **Info**: Correlation rate drops below 50%

### **Health Check Endpoints**
```bash
# Service Health
GET /health → {"status": "healthy", "last_scrape": "2025-08-28T10:30:00Z"}

# Data Pipeline Health  
GET /incidents/health → {"recent_count": 15, "correlation_rate": 0.73}

# Database Health
GET /database/health → {"connections": 3, "last_incident": "5min ago"}
```

## ⚡ **OPERATIONAL PROCEDURES**

### **Deployment Commands**
```bash
# 1. Deploy updated service
gcloud builds submit --tag gcr.io/avocado-fl511-video/fl511-video-capture:latest
./redeploy_service.sh

# 2. Configure automated polling
gcloud scheduler jobs create http fl511-incident-scraper \
  --schedule="*/3 * * * *" \
  --uri="$SERVICE_URL/scrape_incidents" \
  --http-method=POST \
  --headers="Content-Type=application/json" \
  --message-body='{"regions":["Central","Northeast","Southeast","Tampa Bay"]}' \
  --timeout=300s

# 3. Verify operation
curl "$SERVICE_URL/incidents/health"
```

### **Troubleshooting Guide**
```bash
# Check recent incidents
PGPASSWORD=... psql -h 34.42.128.70 -d fl511_incidents -U fl511_user \
  -c "SELECT COUNT(*) FROM incidents WHERE scraped_at >= NOW() - INTERVAL '1 hour';"

# Check Cloud Scheduler logs  
gcloud scheduler jobs logs fl511-incident-scraper --limit=10

# Check service logs
gcloud run services logs read fl511-video-capture --limit=50

# Manual test scraping
curl -X POST "$SERVICE_URL/scrape_incidents" \
  -H "Content-Type: application/json" \
  -d '{"regions":["Tampa Bay"]}'
```

### **Performance Tuning**
```sql
-- Optimize incident queries
CREATE INDEX CONCURRENTLY idx_incidents_recent ON incidents(scraped_at DESC);
CREATE INDEX CONCURRENTLY idx_incidents_roadway_time ON incidents(roadway_name, start_date);

-- Monitor query performance
SELECT query, mean_time, calls FROM pg_stat_statements 
WHERE query LIKE '%incidents%' ORDER BY mean_time DESC;
```

## 🎯 **SUCCESS CRITERIA**

### **Phase 1 Complete When:**
- ✅ Incidents successfully inserting to database
- ✅ Manual scraping returns 50+ incidents
- ✅ No database connection errors

### **Phase 2 Complete When:**  
- ✅ Cloud Scheduler running every 3 minutes
- ✅ Automated correlations creating matches
- ✅ 1 hour of continuous operation with no failures

### **Phase 3 Complete When:**
- ✅ Monitoring dashboards showing healthy metrics
- ✅ Alert system configured and tested
- ✅ Documentation complete and procedures validated

## 🔒 **SECURITY & COMPLIANCE**

### **Data Security**
- **API Keys**: Stored in Cloud Secret Manager
- **Database Access**: VPC-restricted, encrypted connections
- **Data Retention**: 30-day automated cleanup of old incidents
- **Audit Logging**: All database operations logged

### **Rate Limiting**
- **FL511 API**: Respect 100 requests/hour limit
- **Service Quotas**: Monitor GCP quotas and usage
- **Backoff Strategy**: Exponential delays on rate limit hits

---

**Estimated Total Implementation Time: 2 hours**  
**Risk Level: Low** (fixing known issues, not building new functionality)  
**Dependencies: None** (all infrastructure already deployed)