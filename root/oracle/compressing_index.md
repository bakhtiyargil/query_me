Compression of a B-Tree index is performed within a leaf block where Oracle effectively
de-duplicates the index entries (or parts thereof). This means that a highly repeated index value
might need to be stored repeatedly in each leaf block.
Bitmap index entries on the other hand can potentially span the entire table and only need to be split if the overall
size of the index entries exceeds 1/2 a block. Therefore, the number of indexed values stored in a
Bitmap Index can be far less than with a B-tree.

[Compressed index](compressing_index.sql)(:9)

However, it’s in the area of storing the associated rowids where Bitmap Indexes can have the main advantage.
With a B-tree index, even when highly compressed, each and every index entry must have an associated rowid stored in the
index.
If you have say 1 million index entries, that’s 1 million rowids that need to be stored,
regardless of the compression ratio. With a Bitmap Index, an index entry has 2 rowids to specify the range of rows
covered
by the index entry, but this might be sufficient to cover the entire table. So depending on the number of distinct
values being indexed in say a million row table, there may be dramatically fewer than 1 million rowids stored in the
Bitmap Index.
credits:
https://richardfoote.wordpress.com/2014/10/31/index-advanced-compression-vs-bitmap-indexes-candidate/