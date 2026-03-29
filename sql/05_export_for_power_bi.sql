-- 05_export_for_power_bi.sql
USE nykaa_marketing;

-- Run this in Workbench and export the resultset to CSV:
-- File path used in project: data/processed/vw_nykaa_campaign_metrics.csv

SELECT * FROM vw_nykaa_campaign_metrics;
