# Setup Guide for retail SQL Case Study

## Prerequisites

1. **Google Cloud Platform Account**
   - Create a GCP account at https://cloud.google.com
   - Enable billing (free tier available)

2. **BigQuery Access**
   - Enable BigQuery API in your GCP project
   - Create a new project (e.g., "retail-brazil-analysis")

3. **Dataset Download**
   - Download the dataset from: ****
   - Extract all 8 CSV files

---

## Step 1: Create BigQuery Dataset

1. Go to BigQuery console: https://console.cloud.google.com/bigquery
2. Click on your project name
3. Click "CREATE DATASET"
4. Dataset ID: `retail_brazil` (or your preferred name)
5. Location: Choose closest to Brazil (e.g., `southamerica-east1`)
6. Click "CREATE DATASET"

---

## Step 2: Upload CSV Files to BigQuery

For each CSV file, follow these steps:

### Upload customers.csv
```
1. Click on your dataset name
2. Click "CREATE TABLE"
3. Source: "Upload"
4. Select file: customers.csv
5. Table name: customers
6. Auto-detect schema: ON
7. Click "CREATE TABLE"
```

### Repeat for all files:
- [ ] customers.csv → `customers`
- [ ] sellers.csv → `sellers`
- [ ] orders.csv → `orders`
- [ ] order_items.csv → `order_items`
- [ ] products.csv → `products`
- [ ] payments.csv → `payments`
- [ ] reviews.csv → `reviews`
- [ ] geolocation.csv → `geolocation`

---

## Step 3: Update SQL Queries

In all SQL query files, replace the project reference:

**Find:**
```sql
sharan-dsml-sql.business_case_retail
```

**Replace with:**
```sql
your-project-id.retail_brazil
```

**Example:**
If your project ID is `my-analysis-project`, replace with:
```sql
my-analysis-project.retail_brazil
```

---

## Step 4: Run Queries

### Method 1: BigQuery Console
1. Open BigQuery console
2. Click "Compose New Query"
3. Copy-paste query from SQL files
4. Click "RUN"
5. View results

### Method 2: BigQuery CLI
```bash
# Install gcloud CLI
# Then run:
bq query --use_legacy_sql=false < sql-queries/01-exploratory-analysis.sql
```

### Recommended Order:
1. `01-exploratory-analysis.sql` - Understand the data
2. `02-trend-analysis.sql` - Identify patterns
3. `03-economic-impact.sql` - Revenue insights
4. `04-delivery-analysis.sql` - Logistics performance
5. `05-payment-analysis.sql` - Payment behavior

---

## Step 5: Export Results

### Option A: Download as CSV
1. After running query, click "SAVE RESULTS"
2. Choose "CSV (local file)" or "Google Sheets"

### Option B: Export to Google Sheets
1. Click "EXPLORE DATA" → "Explore with Sheets"
2. Creates new Google Sheet with results

### Option C: Schedule Queries
1. Click "SCHEDULE" button
2. Set up recurring execution
3. Configure destination table

---

## Step 6: Create Visualizations (Optional)

### Using Google Data Studio
1. Go to https://datastudio.google.com
2. Create new report
3. Add BigQuery as data source
4. Select your project and dataset
5. Create charts and dashboards

### Using Tableau/Power BI
1. Connect to BigQuery
2. Import tables or query results
3. Build visualizations

---

## Troubleshooting

### Error: "Dataset not found"
**Solution:** Verify dataset name matches in your queries

### Error: "Table not found"
**Solution:** Ensure all CSV files are uploaded correctly

### Error: "Permission denied"
**Solution:** Check IAM permissions for BigQuery Data Editor role

### Error: "Quota exceeded"
**Solution:** 
- Use free tier: 1 TB query/month limit
- Monitor query costs in BigQuery console
- Optimize queries to scan less data

---

## Cost Optimization Tips

1. **Use query preview** to estimate costs before running
2. **Partition tables** by date for large datasets
3. **Cluster tables** by frequently filtered columns
4. **Limit SELECT \*** usage - specify columns
5. **Use query cache** - same queries within 24 hours are free
6. **Monitor billing** in GCP console

---

## Best Practices

### Query Writing
- Always include WHERE clauses when possible
- Use LIMIT during development
- Comment your queries
- Use meaningful aliases
- Format for readability

### Data Management
- Create views for frequently used queries
- Schedule regular data refreshes
- Document schema changes
- Back up important results

### Collaboration
- Share queries via Git repository
- Use descriptive commit messages
- Document assumptions and findings
- Version control SQL files

---

## Additional Resources

### BigQuery Documentation
- Official docs: https://cloud.google.com/bigquery/docs
- SQL reference: https://cloud.google.com/bigquery/docs/reference/standard-sql

### Learning Resources
- BigQuery sandbox (free tier): https://cloud.google.com/bigquery/docs/sandbox
- BigQuery tutorials: https://cloud.google.com/bigquery/docs/tutorials
- SQL for BigQuery: https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax

### Community
- Stack Overflow: Tag `google-bigquery`
- GCP Community: https://www.googlecloudcommunity.com
- Reddit: r/bigquery

---

## Project Structure Reference

```
retail-sql-case-study/
│
├── README.md                          # Main documentation
├── LICENSE                            # MIT License
├── .gitignore                         # Git ignore rules
├── SETUP.md                           # This file
│
├── images/
│   └── er-diagram.png                 # Database schema
│
├── sql-queries/
│   ├── 01-exploratory-analysis.sql
│   ├── 02-trend-analysis.sql
│   ├── 03-economic-impact.sql
│   ├── 04-delivery-analysis.sql
│   └── 05-payment-analysis.sql
│
└── documentation/
    ├── ANALYSIS_REPORT.md
    └── BUSINESS_RECOMMENDATIONS.md
```

---

## Next Steps

After setup:
1. ✅ Run all queries in order
2. ✅ Review ANALYSIS_REPORT.md
3. ✅ Read BUSINESS_RECOMMENDATIONS.md
4. ✅ Create your own visualizations
5. ✅ Share insights with stakeholders

---

## Support

For issues or questions:
1. Check Troubleshooting section above
2. Review BigQuery documentation
3. Open GitHub issue
4. Contact repository maintainer

---

**Happy Analyzing! 📊**
