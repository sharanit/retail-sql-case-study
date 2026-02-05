# retail SQL Business Case Study 🎯

[![SQL](https://img.shields.io/badge/SQL-BigQuery-blue.svg)](https://cloud.google.com/bigquery)
[![Data Analysis](https://img.shields.io/badge/Data-Analysis-green.svg)](https://github.com)

## 📋 Table of Contents
- [Overview](#overview)
- [Dataset Description](#dataset-description)
- [Database Schema](#database-schema)
- [Business Questions & Analysis](#business-questions--analysis)
- [Key Insights](#key-insights)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [How to Use](#how-to-use)

## 🎯 Overview

This project analyzes retail's e-commerce operations in Brazil, focusing on 100,000 orders placed between 2016 and 2018. The analysis provides insights into customer behavior, sales trends, delivery performance, and economic impact through comprehensive SQL queries and data exploration.

### Business Context
retail is a globally renowned brand and prominent retailer in the United States. This case study focuses on understanding:
- Order processing patterns
- Pricing strategies
- Payment and shipping efficiency
- Customer demographics
- Product characteristics
- Customer satisfaction levels

## 📊 Dataset Description

The dataset consists of **8 CSV files** with comprehensive e-commerce data:

| File | Description | Key Columns |
|------|-------------|-------------|
| `customers.csv` | Customer information | customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state |
| `sellers.csv` | Seller details | seller_id, seller_zip_code_prefix, seller_city, seller_state |
| `order_items.csv` | Order line items | order_id, order_item_id, product_id, seller_id, price, freight_value |
| `geolocation.csv` | Geographic coordinates | geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city |
| `payments.csv` | Payment information | order_id, payment_type, payment_installments, payment_value |
| `orders.csv` | Order details | order_id, customer_id, order_status, order_purchase_timestamp, delivery dates |
| `reviews.csv` | Customer reviews | review_id, order_id, review_score, review_comment_title |
| `products.csv` | Product catalog | product_id, product_category_name, dimensions, weight |

**Dataset Link:** [Google Drive](****)

## 🗄️ Database Schema

![ER Diagram](images/er-diagram.png)

### Relationships:
- **orders** ↔ **customers** (via customer_id)
- **orders** ↔ **order_items** (via order_id)
- **orders** ↔ **payments** (via order_id)
- **orders** ↔ **reviews** (via order_id)
- **order_items** ↔ **products** (via product_id)
- **order_items** ↔ **sellers** (via seller_id)
- **customers** ↔ **geolocation** (via zip_code_prefix)
- **sellers** ↔ **geolocation** (via zip_code_prefix)

## 📈 Business Questions & Analysis

### 1. Exploratory Data Analysis
- [x] Data types validation
- [x] Time range identification (2016-2018)
- [x] Geographic distribution analysis

### 2. Trend Analysis
- [x] **Year-over-Year Growth**: 136.98% increase in orders from 2016 to 2018
- [x] **Seasonal Patterns**: Peak months (March-August) vs low months (September-October)
- [x] **Time-of-Day Analysis**: Afternoon (38,135 orders) and Night (28,331 orders) are peak periods

### 3. Economic Impact
- [x] **Revenue Growth**: 136.98% increase in payment value (Jan-Aug 2017 vs 2018)
- [x] **State-wise Revenue**: São Paulo dominates with highest order values
- [x] **Freight Analysis**: Regional variations in shipping costs

### 4. Delivery Performance
- [x] **Average Delivery Time**: 12-15 days across major cities
- [x] **Delivery Delays**: Northeast regions (MA, PB, RN, BA) show longer delivery times (42-45 days)
- [x] **Early Deliveries**: Identified top 5 states with faster-than-estimated delivery

### 5. Payment Behavior
- [x] **Payment Methods**: Month-on-month trends by payment type
- [x] **Installment Patterns**: Distribution of orders by installment count

## 💡 Key Insights

### 📊 Growth Metrics
- **329 orders (2016)** → **45,101 orders (2017)** → **54,011 orders (2018)**
- Massive 13,600% growth between 2016-2017 indicates successful market entry
- Sustained 19.8% growth in 2018 shows market maturity

### 🗓️ Seasonal Trends
- **Peak Season**: March to August (10,000+ orders/month)
- **Low Season**: September-October (4,000-5,000 orders/month)
- August is the highest with 10,843 orders

### ⏰ Customer Behavior
- **Afternoon (1-6 PM)**: 38,135 orders (38.4%)
- **Night (7-11 PM)**: 28,331 orders (28.5%)
- **Morning (7 AM-12 PM)**: 27,733 orders (27.9%)
- **Dawn (12-6 AM)**: 5,242 orders (5.2%)

### 🌎 Geographic Insights
- **São Paulo**: 15,540 customers (dominant market)
- **Rio de Janeiro**: 6,882 customers
- **Belo Horizonte**: 2,773 customers
- Concentration in Southeast and Southern Brazil

### 💰 Economic Impact
- **2017 Payment Value (Jan-Aug)**: R$ 3,669,022.12
- **2018 Payment Value (Jan-Aug)**: R$ 8,694,733.84
- **Growth**: 136.98% increase

### 🚚 Delivery Challenges
- **Fast Delivery States**: Major urban centers
- **Slow Delivery States**: Northeast regions (42-45 days average)
- Infrastructure gaps in remote areas need attention

## 🛠️ Technologies Used

- **Database**: Google BigQuery
- **Query Language**: SQL (Standard SQL)
- **Analysis**: Data aggregation, window functions, CTEs, temporal analysis
- **Visualization**: SQL query results

## 📁 Project Structure

```
retail-sql-case-study/
│
├── README.md                          # Main project documentation
├── images/
│   └── er-diagram.png                 # Database schema diagram
│
├── sql-queries/
│   ├── 01-exploratory-analysis.sql    # Data exploration queries
│   ├── 02-trend-analysis.sql          # Growth and seasonality analysis
│   ├── 03-economic-impact.sql         # Revenue and pricing analysis
│   ├── 04-delivery-analysis.sql       # Delivery performance queries
│   └── 05-payment-analysis.sql        # Payment behavior analysis
│
├── documentation/
│   ├── ANALYSIS_REPORT.md             # Detailed analysis report
│   └── BUSINESS_RECOMMENDATIONS.md    # Strategic recommendations
│
└── LICENSE                            # Project license
```

## 🚀 How to Use

### Prerequisites
- Google Cloud Platform account
- BigQuery access
- Dataset uploaded to BigQuery

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/sharanit/retail-sql-case-study.git
cd retail-sql-case-study
```

2. **Upload dataset to BigQuery**
- Create a new dataset in BigQuery
- Upload all 8 CSV files to your dataset
- Update project name in SQL queries

3. **Run SQL queries**
```sql
-- Update project reference in all queries
-- Replace: sharan-dsml-sql.business_case_retail
-- With: your-project-id.your-dataset-name
```

4. **Execute queries**
- Navigate to `sql-queries/` folder
- Run queries in sequential order
- Analyze results

## 📊 Sample Query Results

### Year-over-Year Growth
| Year | Total Orders | Growth Rate |
|------|--------------|-------------|
| 2016 | 329          | -           |
| 2017 | 45,101       | 13,608%     |
| 2018 | 54,011       | 19.8%       |

### Top 5 Cities by Customers
| City | State | Customers |
|------|-------|-----------|
| São Paulo | SP | 15,540 |
| Rio de Janeiro | RJ | 6,882 |
| Belo Horizonte | MG | 2,773 |
| Brasília | DF | 2,131 |
| Curitiba | PR | 1,521 |

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Your Name**
- GitHub: [@sharanit](https://github.com/sharanit)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/sharanvora)

## 🙏 Acknowledgments

- Dataset provided by retail Brazil operations
- Analysis performed as part of data analytics case study
- BigQuery for powerful SQL processing capabilities

---

**Note**: This is an educational project for analytical purposes. All data has been anonymized and is used for learning objectives only.
