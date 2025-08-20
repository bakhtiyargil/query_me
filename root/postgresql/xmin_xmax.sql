CREATE INDEX idx
    ON sales ( subsidiary_id, ts )
    INCLUDE ( eur_value, notes );

SELECT *
FROM sales
WHERE subsidiary_id = ?
  AND notes LIKE '%search term%';

/*
                QUERY PLAN
----------------------------------------------
Index Scan using idx on sales (actual rows=16)
  Index Cond: (subsidiary_id = 1)
  Filter: (notes ~~ '%search term%')
  Rows Removed by Filter: 240
  Buffers: shared hit=54
 */

CREATE INDEX idx
    ON sales ( subsidiary_id, ts, eur_value, notes);

/*
                   QUERY PLAN
-----------------------------------------------
Bitmap Heap Scan on sales (actual rows=16)
  Recheck Cond: (subsidiary_id = 1)
  Filter: (notes ~~ '%search term%')
  Rows Removed by Filter: 240
  Heap Blocks: exact=52
  Buffers: shared hit=54
  -> Bitmap Index Scan on idx (actual rows=256)
       Index Cond: (subsidiary_id = 1)
       Buffers: shared hit=2
 */