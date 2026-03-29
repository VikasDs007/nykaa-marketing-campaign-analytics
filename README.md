# Nykaa Marketing Campaign Performance Analytics (SQL + Power BI)

## 1. Project overview

This project analyzes **Nykaa's digital marketing campaigns** to answer:

- Which **channels and campaigns** drive the most **revenue and conversions**?
- Which are most **efficient** in terms of **ROAS** (Return on Ad Spend) and **CPA** (Cost per Acquisition)?
- How does the **funnel** perform from **Impressions → Clicks → Leads → Conversions**?
- Which campaigns should be **scaled, fixed, or stopped** based on data?

The workflow mirrors how a working **Marketing / Product Analyst** would approach the problem:  
**raw CSV → SQL cleaning & aggregation → metric view → Power BI dashboards → optimization note.**

---

## 2. Dataset

- **Source:** [Nykaa Marketing Campaign Performance Dataset – Kaggle](https://www.kaggle.com/datasets/nalisha/nykaa-marketing-campaign-performance-dataset)
- **Raw file in this repo:** `data/raw/nykaa_campaign_raw.csv`

### Key fields

Each row represents performance for a Nykaa marketing campaign:

- Campaign details: `Campaign_ID`, `Campaign_Type`, `Target_Audience`, `Customer_Segment`, `Language`
- Channel & duration: `Channel_Used`, `Duration`, `Date`
- Funnel metrics: `Impressions`, `Clicks`, `Leads`, `Conversions`
- Financials: `Revenue`, `Acquisition_Cost`, `ROI`
- Engagement: `Engagement_Score`

Raw `Date` is provided as text in `dd-mm-yyyy` format and is converted to a proper `DATE` field in SQL.

---

## 3. Tech stack

- **Database:** MySQL (via MySQL Workbench)
- **Query language:** SQL
- **Visualization:** Power BI
- **Version control:** Git & GitHub

---

## 4. SQL data pipeline

Database used: `nykaa_marketing`

All SQL scripts are stored in the `sql/` folder.

### 4.1 Raw import

- Table: `nykaa_campaign_raw`
- Created by importing the Kaggle CSV into MySQL Workbench using the **Table Data Import Wizard**.
- Script: `01_raw_table_note.sql` documents the schema and a quick sanity check.

```sql
USE nykaa_marketing;

SELECT *
FROM nykaa_campaign_raw
LIMIT 10;
```

### 4.2 Clean fact table

- Table: `fact_nykaa_campaign_performance`
- Purpose: Clean types and convert `Date` (text) into a proper `campaign_date` (`DATE`).
- Script: `02_fact_nykaa_campaign_performance.sql`

```sql
DROP TABLE IF EXISTS fact_nykaa_campaign_performance;

CREATE TABLE fact_nykaa_campaign_performance AS
SELECT
    Campaign_ID,
    Campaign_Type,
    Target_Audience,
    Channel_Used,
    Language,
    Customer_Segment,
    STR_TO_DATE(Date, '%d-%m-%Y') AS campaign_date,
    Duration,
    Impressions,
    Clicks,
    Leads,
    Conversions,
    Revenue,
    Acquisition_Cost,
    ROI,
    Engagement_Score
FROM nykaa_campaign_raw;
```

### 4.3 Aggregated campaign table

- Table: `agg_nykaa_campaign_performance`
- Grain: **Campaign_ID × Campaign_Type × Target_Audience × Channel_Used × Language × Customer_Segment**
- Purpose: Aggregate performance across time for each campaign/channel/audience combination.
- Script: `03_agg_nykaa_campaign_performance.sql`

```sql
DROP TABLE IF EXISTS agg_nykaa_campaign_performance;

CREATE TABLE agg_nykaa_campaign_performance AS
SELECT
    Campaign_ID,
    Campaign_Type,
    Target_Audience,
    Channel_Used,
    Language,
    Customer_Segment,
    MIN(campaign_date)    AS campaign_start_date,
    MAX(campaign_date)    AS campaign_end_date,
    SUM(Duration)         AS total_duration_days,
    SUM(Impressions)      AS impressions,
    SUM(Clicks)           AS clicks,
    SUM(Leads)            AS leads,
    SUM(Conversions)      AS conversions,
    SUM(Revenue)          AS revenue,
    SUM(Acquisition_Cost) AS acquisition_cost,
    AVG(ROI)              AS avg_roi,
    AVG(Engagement_Score) AS avg_engagement_score
FROM fact_nykaa_campaign_performance
GROUP BY
    Campaign_ID,
    Campaign_Type,
    Target_Audience,
    Channel_Used,
    Language,
    Customer_Segment;
```

### 4.4 Metrics view for BI

- View: `vw_nykaa_campaign_metrics`
- Purpose: Add core performance metrics used by the dashboard.
- Script: `04_vw_nykaa_campaign_metrics.sql`

```sql
DROP VIEW IF EXISTS vw_nykaa_campaign_metrics;

CREATE VIEW vw_nykaa_campaign_metrics AS
SELECT
    Campaign_ID,
    Campaign_Type,
    Target_Audience,
    Channel_Used,
    Language,
    Customer_Segment,
    campaign_start_date,
    campaign_end_date,
    total_duration_days,
    impressions,
    clicks,
    leads,
    conversions,
    revenue,
    acquisition_cost,
    avg_roi,
    avg_engagement_score,

    -- Click-through rate
    CASE
        WHEN impressions > 0 THEN clicks / impressions
        ELSE 0
    END AS ctr,

    -- Cost per click
    CASE
        WHEN clicks > 0 THEN acquisition_cost / clicks
        ELSE NULL
    END AS cpc,

    -- Click → Conversion rate
    CASE
        WHEN clicks > 0 THEN conversions / clicks
        ELSE 0
    END AS conversion_rate,

    -- Cost per acquisition
    CASE
        WHEN conversions > 0 THEN acquisition_cost / conversions
        ELSE NULL
    END AS cpa,

    -- Return on ad spend
    CASE
        WHEN acquisition_cost > 0 THEN revenue / acquisition_cost
        ELSE NULL
    END AS roas

FROM agg_nykaa_campaign_performance;
```

### 4.5 Export to Power BI

The metrics view is exported as CSV and used as the Power BI dataset.  
Script: `05_export_for_power_bi.sql`

```sql
SELECT * FROM vw_nykaa_campaign_metrics;
```

In MySQL Workbench:  
Result grid → right-click → **Export Resultset** → save as `data/processed/vw_nykaa_campaign_metrics.csv`.

---

## 5. Power BI dashboards

Power BI report: `docs/Nykaa_Marketing_Campaign_Performance_Dashboard.pbix`

Screenshots:
- `images/Nykaa_Marketing_Campaign_dashboard_1.png` (Campaign Performance)
- `images/Nykaa_Marketing_Campaign_dashboard_2.png` (Funnel & Optimization)

### 5.1 Data model

- Single table imported from `data/processed/vw_nykaa_campaign_metrics.csv`
- Core measures (examples):

```DAX
Total Impressions     = SUM(vw_nykaa_campaign_metrics[impressions])
Total Clicks          = SUM(vw_nykaa_campaign_metrics[clicks])
Total Leads           = SUM(vw_nykaa_campaign_metrics[leads])
Total Conversions     = SUM(vw_nykaa_campaign_metrics[conversions])
Total Revenue         = SUM(vw_nykaa_campaign_metrics[revenue])
Total Acquisition Cost = SUM(vw_nykaa_campaign_metrics[acquisition_cost])

Overall CTR             = DIVIDE([Total Clicks], [Total Impressions])
Overall Conversion Rate = DIVIDE([Total Conversions], [Total Clicks])
Overall CPA             = DIVIDE([Total Acquisition Cost], [Total Conversions])
Overall ROAS            = DIVIDE([Total Revenue], [Total Acquisition Cost])
```

*(Replace table name if Power BI imported it with a different name.)*

### 5.2 Page 1 – Campaign Performance

Focus: **"What is working overall?"**

Key elements:

- **KPI cards**
  - Total Revenue
  - Total Conversions
  - Overall ROAS (ratio, not currency)
  - Overall CPA (₹)
  - Overall Conversion Rate (%)

- **Visuals**
  - Bar chart: **Total Revenue by Channel**
  - Donut chart: **Total Revenue by Target Audience**
  - Scatter plot: **Overall ROAS vs Overall CPA by Campaign Type**
  - Matrix: **Campaign Type** with Total Revenue, Total Acquisition Cost, Overall ROAS, Overall CPA

- **Slicers**
  - Channel
  - Campaign Type
  - Target Audience
  - Language
  - Campaign Start Date (date range)

This page helps stakeholders quickly see which channels and audiences drive the most revenue and which campaign types are efficient.

### 5.3 Page 2 – Funnel & Optimization

Focus: **"Where is the funnel leaking and which campaigns to scale/stop?"**

Key elements:

- **Overall funnel visual**
  - Stages: Total Impressions → Total Clicks → Total Leads → Total Conversions

- **Funnel by channel (matrix)**
  - Rows: Channel
  - Columns: Total Impressions, Total Clicks, Total Leads, Total Conversions
  - Optional: Click-through rate, Lead conversion rate, Purchase conversion rate

- **Top & bottom campaigns**
  - Bar chart: **Top 5 Campaigns by ROAS (Efficiency)**
  - Bar chart: **Bottom 5 Campaigns by ROAS (Need Optimization)**

- **Slicers**
  - Channel
  - Campaign Type
  - Target Audience
  - Language
  - Customer Segment
  - Date Range

This page supports decisions like **"scale these campaigns," "fix landing page here," "pause or cut spend here."**

---

## 6. Business insights (short summary)

At a high level:

- A small set of **channels and audience segments** drive a large share of revenue at attractive ROAS and CPA.
- **Top campaigns** can be safely **scaled or protected** in the budget.
- Several campaigns show **low ROAS and high CPA**, especially in specific channels, indicating spend that should be **optimized or reallocated**.
- Funnel analysis highlights where users drop off between **clicks, leads, and conversions**, guiding where to improve creatives, targeting, and landing pages.

---

## 7. How to run this project

1. **Database**
   - Create a MySQL schema named `nykaa_marketing` (or run `00_use_database.sql`).
   - Import `data/raw/nykaa_campaign_raw.csv` into a table `nykaa_campaign_raw` using MySQL Workbench.
   - Run the SQL scripts in `sql/` in order:
     1. `00_use_database.sql`
     2. `01_raw_table_note.sql` (reference only — documents the raw table schema)
     3. `02_fact_nykaa_campaign_performance.sql`
     4. `03_agg_nykaa_campaign_performance.sql`
     5. `04_vw_nykaa_campaign_metrics.sql`
     6. `05_export_for_power_bi.sql` → export result to `data/processed/vw_nykaa_campaign_metrics.csv`

2. **Power BI**
   - Open `docs/Nykaa_Marketing_Campaign_Performance_Dashboard.pbix` (or create a new report).
   - Connect to `data/processed/vw_nykaa_campaign_metrics.csv`.
   - Inspect or recreate the two pages:
     - *Campaign Performance*
     - *Funnel & Optimization*

3. **Screenshots**
   - Dashboard screenshots are available in `images/`.

4. **Report**
   - A written performance report is available in `Dashboard Report/` as both `.docx` and `.pdf`.

---

## 8. Skills demonstrated

- **SQL (MySQL):** data cleaning, date parsing, aggregation with `GROUP BY`, creation of reusable metric views.
- **Marketing analytics:** understanding of CTR, CPC, CPA, conversion rate, ROAS and campaign funnel behavior.
- **Power BI:** data modeling, DAX measures, interactive dashboards, funnel and performance visualizations.
- **Communication:** translating numbers into budget and strategy decisions.
