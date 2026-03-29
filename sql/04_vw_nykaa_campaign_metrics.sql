-- 04_vw_nykaa_campaign_metrics.sql
USE nykaa_marketing;

-- View with all key marketing metrics used by Power BI.
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

    -- Core performance metrics
    CASE
        WHEN impressions > 0
            THEN clicks / impressions
        ELSE 0
    END AS ctr,                     -- Click-through rate

    CASE
        WHEN clicks > 0
            THEN acquisition_cost / clicks
        ELSE NULL
    END AS cpc,                     -- Cost per click

    CASE
        WHEN clicks > 0
            THEN conversions / clicks
        ELSE 0
    END AS conversion_rate,         -- Click → Conversion rate

    CASE
        WHEN conversions > 0
            THEN acquisition_cost / conversions
        ELSE NULL
    END AS cpa,                     -- Cost per acquisition

    CASE
        WHEN acquisition_cost > 0
            THEN revenue / acquisition_cost
        ELSE NULL
    END AS roas                     -- Return on ad spend

FROM agg_nykaa_campaign_performance;

-- Quick check
SELECT
    Campaign_ID,
    Channel_Used,
    impressions,
    clicks,
    leads,
    conversions,
    acquisition_cost,
    revenue,
    ctr,
    cpc,
    conversion_rate,
    cpa,
    roas
FROM vw_nykaa_campaign_metrics
LIMIT 10;
