-- 02_fact_nykaa_campaign_performance.sql
USE nykaa_marketing;

-- Clean fact table with proper types and parsed date.
DROP TABLE IF EXISTS fact_nykaa_campaign_performance;

CREATE TABLE fact_nykaa_campaign_performance AS
SELECT
    Campaign_ID,
    Campaign_Type,
    Target_Audience,
    Channel_Used,
    Language,
    Customer_Segment,
    -- Raw Date is in d-m-Y format; convert to DATE as campaign_date
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

-- Quick check
SELECT campaign_date, Campaign_ID, Campaign_Type, Channel_Used
FROM fact_nykaa_campaign_performance
LIMIT 10;
