/*
    1. Getting a clustering factor for index.
*/
select index_name, clustering_factor
from user_indexes
where table_name = 'table_name';


/*
    2. Getting table_cached_block property value.
*/
select dbms_stats.get_prefs ('table_cached_blocks', null, 'table_name')
from dual;


/*
    3. Updating table_cached_block property value.
*/
begin
    dbms_stats.set_table_prefs(null, 'table_name', 'table_cached_blocks', 16);
    dbms_stats.gather_table_stats(user, 'table_name');
end;
