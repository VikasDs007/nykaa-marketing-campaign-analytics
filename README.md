# Nykaa Marketing Campaign Performance Analytics (SQL + Power BI)

## 📌 Business Problem

Nykaa runs marketing campaigns across multiple digital channels, but without a unified view of performance it's hard to know which campaigns are driving real revenue and which are burning budget. This project builds a full analytics pipeline to identify the most efficient channels, audiences, and campaign types — so marketing spend can be allocated where it actually converts.

---

## 📊 Data Source

- **Source:** [Nykaa Marketing Campaign Performance Dataset – Kaggle](https://www.kaggle.com/datasets/nalisha/nykaa-marketing-campaign-performance-dataset)
- **Raw file:** `data/raw/nykaa_campaign_raw.csv`
- Dataset contained **55,555 rows** and **16 columns**.
- Key variables included: `Campaign_ID`, `Campaign_Type`, `Target_Audience`, `Channel_Used`, `Impressions`, `Clicks`, `Leads`, `Conversions`, `Revenue`, `Acquisition_Cost`, `ROI`, `Engagement_Score`, `Language`, `Customer_Segment`, `Duration`, `Date`

---

## 🛠️ Tools & Methodology

- **Tools Used:** MySQL (MySQL Workbench), Power BI
- **Methodology:**
  1. Raw CSV imported into MySQL via Table Data Import Wizard → `nykaa_campaign_raw`
  2. Data cleaning & date parsing (`STR_TO_DATE`) → `fact_nykaa_campaign_performance`
  3. Aggregation by campaign × channel × audience → `agg_nykaa_campaign_performance`
  4. Derived marketing metrics (CTR, CPC, CPA, Conversion Rate, ROAS) → `vw_nykaa_campaign_metrics`
  5. Exported view to CSV → connected to Power BI for interactive dashboards

---

## 💡 Key Business Insights

- **Channel efficiency gap:** A small subset of channels consistently delivered ROAS above the overall average, while others showed high acquisition cost with low conversion — clear candidates for budget reallocation.
- **Audience targeting matters:** Certain target audience segments converted at significantly higher rates, suggesting campaigns should be concentrated on these segments rather than spread evenly.
- **Funnel drop-off:** The biggest drop in the funnel occurs between Leads and Conversions, not between Clicks and Leads — indicating the issue is post-interest follow-up, not ad creative or reach.
- **Campaign type ROI:** Some campaign types generated strong impressions and clicks but poor ROAS, meaning high visibility does not equal high return — efficiency metrics (CPA, ROAS) tell a different story than volume metrics alone.

---

## 🖼️ Visualizations

### Page 1 – Campaign Performance
![Campaign Performance Dashboard](images/Nykaa_Marketing_Campaign_dashboard_1.png)

### Page 2 – Funnel & Optimization
![Funnel & Optimization Dashboard](images/Nykaa_Marketing_Campaign_dashboard_2.png)

---

## 💻 How to Run This Project

1. Clone this repository:
   ```bash
   git clone https://github.com/VikasDs007/nykaa-marketing-campaign-analytics.git
   ```

2. **Set up the database** in MySQL Workbench:
   - Run `sql/00_use_database.sql` to create and select the `nykaa_marketing` database.
   - Import `data/raw/nykaa_campaign_raw.csv` into a table named `nykaa_campaign_raw` using the Table Data Import Wizard.
   - Run the remaining scripts in order:
     ```
     sql/01_raw_table_note.sql       ← schema reference only
     sql/02_fact_nykaa_campaign_performance.sql
     sql/03_agg_nykaa_campaign_performance.sql
     sql/04_vw_nykaa_campaign_metrics.sql
     sql/05_export_for_power_bi.sql  ← export result to data/processed/vw_nykaa_campaign_metrics.csv
     ```

3. **Open Power BI:**
   - Open `docs/Nykaa_Marketing_Campaign_Performance_Dashboard.pbix`
   - Or create a new report and connect to `data/processed/vw_nykaa_campaign_metrics.csv`

---

## 🗂️ Project Structure

```
├── .gitignore
├── README.md
├── Dashboard Report/
│   ├── Nykaa Marketing Campaign Performance Report.docx
│   └── Nykaa Marketing Campaign Performance Report.pdf
├── data/
│   ├── raw/
│   │   └── nykaa_campaign_raw.csv
│   └── processed/
│       ├── fact_nykaa_campaign_performance.csv
│       ├── agg_nykaa_campaign_performance.csv
│       └── vw_nykaa_campaign_metrics.csv
├── docs/
│   └── Nykaa_Marketing_Campaign_Performance_Dashboard.pbix
├── images/
│   ├── Nykaa logo.png
│   ├── Nykaa_Marketing_Campaign_dashboard_1.png
│   └── Nykaa_Marketing_Campaign_dashboard_2.png
└── sql/
    ├── 00_use_database.sql
    ├── 01_raw_table_note.sql
    ├── 02_fact_nykaa_campaign_performance.sql
    ├── 03_agg_nykaa_campaign_performance.sql
    ├── 04_vw_nykaa_campaign_metrics.sql
    └── 05_export_for_power_bi.sql
```

---

## 🧠 Skills Demonstrated

- **SQL (MySQL):** data cleaning, date parsing, aggregation with `GROUP BY`, reusable metric views
- **Marketing analytics:** CTR, CPC, CPA, Conversion Rate, ROAS, funnel analysis
- **Power BI:** data modeling, DAX measures, interactive dashboards, funnel and performance visualizations
- **Business communication:** translating raw numbers into actionable budget and strategy decisions
