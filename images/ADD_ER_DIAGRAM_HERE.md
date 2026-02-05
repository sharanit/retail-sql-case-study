# 📝 IMPORTANT: Add Your ER Diagram

## Action Required

Please add your ER diagram image to complete the repository:

1. **Copy your ER diagram screenshot to:**
   ```
   images/er-diagram.png
   ```

2. **The diagram should show:**
   - All 8 tables (customers, sellers, orders, order_items, products, payments, reviews, geolocation)
   - Relationships between tables
   - Primary and foreign keys
   - Clear, readable layout

3. **Recommended image specifications:**
   - Format: PNG or JPG
   - Minimum width: 1200px
   - Clear, high-resolution
   - Shows all connections

## Alternative: Create Diagram Online

If you need to recreate the diagram:

### Option 1: dbdiagram.io
```
1. Go to https://dbdiagram.io
2. Use DBML syntax to define tables
3. Export as PNG
4. Save to images/ folder
```

### Option 2: draw.io
```
1. Go to https://draw.io
2. Create new diagram
3. Add tables and relationships
4. Export as PNG
5. Save to images/ folder
```

### Option 3: Generate from BigQuery
```sql
-- Export schema information
SELECT 
    table_name,
    column_name,
    data_type
FROM `your-project.INFORMATION_SCHEMA.COLUMNS`
WHERE table_schema = 'retail_brazil';
```

Then use the schema to create diagram in visualization tool.

---

**Once added, remove this file and proceed with git push!**
