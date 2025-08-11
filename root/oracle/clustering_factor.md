Oracle uses the clustering factor to know how the data for a particular table is divided across
the buckets in physical locations. Low clustering factor leads to good query performance with
an index and low IO operations to get the necessary data.

Clustering factor is calculated in a way that each clustered index asks the previous
index about which cluster it actually stays. If the previous index is in the same cluster with the current index,
it is good, and a factor doesn’t change. If there are in different clusters, the factor is going to be increase.
High clustering factor is bad.

[Step 1: Get clustering factor](clustering_factor.sql)(:4)

The clustering factor is pessimistic. Indexes might not be used with some queries (e.g., when you work with date columns)
because of a high clustering factor. Instead of giving hints to the database to use a particular index 
(which is not recommended for production environments) in these cases, we can simply increase the amount of
table_cached_block property to N which is default 1. Doing this, we are telling the database to ask 
from N previous indexes for the cluster location, and get the information how often particular cluster is visited. 

[Step 2: Get table_cached_block](clustering_factor.sql)(:12)  
[Step 3: Update table_cached_block](clustering_factor.sql)(:19)  
