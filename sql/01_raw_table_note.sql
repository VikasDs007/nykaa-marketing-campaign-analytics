-- 01_raw_table_note.sql
USE nykaa_marketing;

-- NOTE: The raw table `nykaa_campaign_raw` was created via MySQL Workbench
-- "Table Data Import Wizard" by importing the Kaggle CSV directly.
--
-- Schema (from DESCRIBE):
--   Campaign_ID        TEXT / VARCHAR
--   Campaign_Type      TEXT
--   Target_Audience    TEXT
--   Duration           INT
--   Channel_Used       TEXT
--   Impressions        INT
--   Clicks             INT
--   Leads              INT
--   Conversions        INT
--   Revenue            INT
--   Acquisition_Cost   DOUBLE
--   ROI                DOUBLE
--   Language           TEXT
--   Engagement_Score   DOUBLE
--   Customer_Segment   TEXT
--   Date               TEXT  -- stored as d-m-Y in the raw file

-- Quick sanity check:
SELECT *
FROM nykaa_campaign_raw
LIMIT 10;
