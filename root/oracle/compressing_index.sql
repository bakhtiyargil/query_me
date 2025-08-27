--without compression
create index ziggy_weird_i on ziggy (weird) pctfree 0;

select index_name, blevel, leaf_blocks, num_rows
from dba_indexes
where index_name = 'ZIGGY_WEIRD_I';

--with compression
create index ziggy_weird_i on ziggy (weird) pctfree 0 compress advanced low;

select index_name, blevel, leaf_blocks, num_rows
from dba_indexes
where index_name = 'ZIGGY_WEIRD_I';
