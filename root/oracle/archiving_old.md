Methods for Archiving Data
In-Database Archiving: This feature, available in Oracle Database 12c and later, 
uses a hidden column (ORA_ARCHIVE_STATE) to logically mark rows as archived.

Process: Enable row archiving on a table using ALTER TABLE ... ROW ARCHIVAL;. 

Update the ORA_ARCHIVE_STATE value (e.g., from '0' for active to '1' for archived) for the data you want to archive.

Access: By default, standard queries only see active rows. You can 
set the session property ALTER SESSION SET ROW ARCHIVAL VISIBILITY = ALL; to view all rows, including archived ones.

Benefit: Data remains in the same table, simplifying access, but logically separates active from 
historical data to aid performance and manageability.
External Archiving (Physical Separation): This method involves exporting data from the production database 
to a separate location, such as another database instance, flat files, or cloud storage.

Process: Data is typically identified based on criteria (e.g., age of data, transaction status).
It is then moved to archive tables, exported (e.g., to Parquet, CSV, or XML format files), and deleted from the production tables.
Storage Options: Options include Oracle Cloud Infrastructure (OCI) Archive Storage for cost-effective,
long-term storage, or third-party cloud storage solutions like Amazon S3.
Tools: Native Oracle products like Oracle Data Pump can be used, or third-party tools like AWS DMS 
or AWS Glue for cloud-based solutions.
Partitioning: This involves partitioning large tables by a date range (e.g., monthly partitions). 
As partitions become obsolete, they can be moved to a data warehouse or detached from the main table, keeping the primary database size manageable.

General Archiving Considerations
Define a Policy: Determine what data needs archiving and for how long, based on business needs and regulatory compliance.
Maintain Integrity: Ensure that referential integrity is maintained during the move, so you don't end up with "dangling" foreign key references in your production database.
Plan for Access: Decide how you will access the archived data if needed in the future (e.g., via a separate application, database links, or data visualization tools).
Purge Data: Archiving often goes hand-in-hand with purging, which is the permanent deletion of data that is no longer required by the system at all.
