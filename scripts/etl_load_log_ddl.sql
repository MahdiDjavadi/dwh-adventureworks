/*
=========================================================================
    Load Log Table DDL

    Purpose:
        This table is used to log the execution of ETL packages. It records the start and end times, 
        status, number of rows affected, and any error messages encountered during the execution of the ETL process.
 ========================================================================
 */

USE [DWH_AdventureWorks];
GO

--	=====================================================================
-- This script drops then creates the LoadLog table in the etl schema.
-- ======================================================================
IF OBJECT_ID('[etl].[LoadLog]', 'U') IS NOT NULL
    DROP TABLE [etl].[LoadLog];
GO

CREATE TABLE etl.LoadLog
(
    [log_id]         INT IDENTITY (1,1)   NOT NULL,
    [package_name]   NVARCHAR (255)       NOT NULL,
    [start_time]     DATETIME2 (3)        NOT NULL,
    [end_time]       DATETIME2 (3)            NULL,
    [status]         NVARCHAR (20)        NOT NULL,
    [rows_inserted]  INT                      NULL,
    [rows_updated]   INT                      NULL,
    [rows_deleted]   INT                      NULL,
    [error_source]   NVARCHAR (255)           NULL,
    [error_message]  NVARCHAR (4000)          NULL,

    CONSTRAINT PK_LoadLog PRIMARY KEY CLUSTERED (log_id ASC)
);