PostgreSQL: No Filtering Before Visibility Check
The PostgreSQL database has a limitation when it comes to applying filters on the index level.
The short story is that it doesn’t do it, except in a few cases.
Even worse, some of those cases only work when the respective data is stored in the key part of the index,
not in the include clause. That means moving columns to the include clause may negatively affect performance,
even if the above-described logic still applies.

The long story starts with the fact that PostgreSQL keeps old row versions in the table until they become 
invisible to all transactions and the vacuum process removes them at some later point in time.
To know whether a row version is visible (to a given transaction) or not, 
each table has two extra attributes that indicate when a row version was created and deleted: xmin and xmax. 
The row is only visible if the current transaction falls within the xmin/xmax range.

Unfortunately, the xmin/xmax values are not stored in indexes.
That means that whenever PostgreSQL is looking at an index entry, it cannot tell whether that entry is visible
to the current transaction. It could be a deleted entry or an entry that has not yet been committed.
The canonical way to find out is to look into the table and check the xmin/xmax values.

A consequence is that there is no such thing as an index-only scan in PostgreSQL. 
No matter how many columns you put into an index, PostgreSQL will always need to check the visibility, 
which is not available in the index.

Yet there is an Index Only Scan operation in PostgreSQL—but that still needs to check the visibility of each row version
by accessing data outside the index. Instead of going to the table, the Index Only Scan first checks the so-called 
visibility map. This visibility map is very dense so the number of read operations is (hopefully)
less than fetching xmin/xmax from the table. However, the visibility map does not always give a definite answer:
the visibility map either states that that the row is known to be visible, or that the visibility is not known. 
In the latter case, the Index Only Scan still needs to fetch xmin/xmax from the table (shown as “Heap Fetches” in explain analyze).

After this short visibility digression, we can return to filtering on the index level.

There is one exception to this general rule. As the visibility cannot be checked while searching an index,
operators that can be used for searching must always be safe to use. These are the operators that are defined in 
the respective operator class. If a simple comparison filter uses an operation from such an operator class, PostgreSQL 
can apply that filter before checking the visibility because it knows that these operators are safe to use. The crux is 
that only key columns have an operator class associated with them. Columns in the include clause don’t—filters based on 
them are not applied before their visibility is confirmed. This is my understanding from a thread on the PostgreSQL 
hackers mailing list.
[1: Index - xmin/xmax](xmin_xmax.sql)(:1)

Note that this is not a particularity of the **include** column in this case.
Moving the include columns into the index key gives the same result.
[1: Index - xmin/xmax](xmin_xmax.sql)(:20)
This is because the like operator is not part of the operator class so it is not considered to be safe.
If you use an operation from the operator class, e.g. equals, the execution plan changes.

credits: Markus Winand

https://use-the-index-luke.com/blog/2019-04/include-columns-in-btree-indexes



