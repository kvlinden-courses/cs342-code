-- This script retrieves the indexes created on the current system.
-- Refer to an index using the index_name.
-- The "normal" index type is a B-tree; OracleXE 11g doesn't support bitmapped indexes.

SET AUTOTRACE OFF; 
SET SERVEROUTPUT ON;
SET TIMING OFF;
SET WRAP OFF;

SELECT
 	c.index_name,
 	c.table_name,
 	c.column_name,
 	i.index_type
FROM
 	User_Ind_Columns c,
	User_Indexes i
WHERE
	c.index_name = i.index_name
;
 