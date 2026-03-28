--Deleting is example below u can still keep the data copied
---- Disclaimer: below parent-child relationships not considered
--
/*
    1. Insert - delete method (slow - not suggested)
*/
insert into archive_table
select *
from transfer_table
where insert_date <= 'some_date';

delete
transfer_table
       where insert_date <= 'some_date';
/*
    2. Copy with temp table
        2.1 Copy necessary data to temp table
        2.2 Empty or do something in main table
        2.3 Swap data back to main
*/
/*
    3. Alter table method (slow)
*/
alter table table_name
    move
    including rows
    where rows_to_keep = 'Y';

/*
    4. Partitioning method (fast)
*/
1. exec dbms_redefinitions...;


2. alter table table_name
    modify partition by...;

alter table table_name drop partition partition_name;
----------------------------------------------------------------------------------------------------
--archiving
---
--
create table table_name as
select *
from main_table
where 1 = 0;

/*
    Partitioning method (fast) - Only exchanges metadata, that's all. (if partitioned) ---START
*/
alter table table_name
    exchange partition
    with table other_table;
-----------ORA-14097 column type or size mismatch ---------START
alter table table_name
    set unused column some_column;

alter table table_name
    modify ... invisible ...;
--solution
create table arch_table
    for exchange with table table_name; -- created table will not be partitioned

create table arch_table
    partition by ...
    for exchange with table table_name; --partitioned
-----------ORA-14097 column type or size mismatch ---------END
-----------ORA-02266 unique/primary keys in table referenced...  ---------START
create table parent (
    insert_date, ....
) partition by range (
    insert_date
);
--doing same in child
create table child (
    insert_date, ....
) partition by range (
    insert_date
);
--or partitioning by reference (foreign_key) !!!!
create table child (
    insert_date, ....
    constraint fk foreign key ...
    on delete cascade
) partition by reference (fk);
--for existing table
alter table table_name
modify partition by refernce (fk);

alter table table_name
    exchange partition
    with table other_table
    cascade;--for child table -- for only one (1)

-----------ORA-02266 unique/primary keys in table referenced...  ---------END

--------Note!! cant exchange to partitioned table to partitioned table
    ------Solution: create middle staging table non-partitioned and then move archive table
/*
    Partitioning method (fast) - Only exchanges metadata, that's all. (if partitioned) ---END
*/

create table table_name
(...)
row archival;

update table_name
set ora_archival_state = '1'
where ...;  --hiding rows