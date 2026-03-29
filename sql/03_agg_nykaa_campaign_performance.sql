-- 03_agg_nykaa_campaign_performance.sql
USE nykaa_marketing;

-- Aggregate to campaign × channel × audience level.
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

-- Quick check
SELECT * FROM agg_nykaa_campaign_performance LIMIT 10;
