-- Sample performance-related queries on the imdb for CS 342, unit 9
--
-- To use this code, run buildOrdinalTables.sql and then run getIndexes.sql to find the index IDs.
-- The code uses anonymous procedures to repeatedly execute queries,
-- with or without indexes, to compare performance times.
--
-- CS 342, Spring, 2017
-- kvlinden


CLEAR SCREEN;
SET AUTOTRACE ON;
SET SERVEROUTPUT ON;
SET TIMING ON;
SET WRAP OFF;

-- Set global variables for the index IDs for the Actor and ActorOrdinal ID indexes.
-- Get the index IDs using @getIndexes; they change for each installation.
DEFINE Actor_Index = SYS_C008140
DEFINE ActorOrdinal_Index = SYS_C008158
-- Compute the actual number of actors (select count(*) from actor (or actorordinal)).
DEFINE ActorCount = 1910

-- 9.1.
-- This single query demonstrates the auto-trace output (with or without the index).
--ALTER INDEX &Actor_Index INVISIBLE;
--ALTER INDEX &ActorOrdinal_Index INVISIBLE;
SELECT a.firstName || ' ' || a.lastName
FROM Actor a, ActorOrdinal ao
WHERE a.id = ao.id
  AND ao.ordinal = (SELECT TRUNC(dbms_random.value(0,&ActorCount-1)) FROM Dual)
;

-- 9.1.b.
-- This example gets a bunch of random records using (or ignoring) the index.
--ALTER INDEX &Actor_Index INVISIBLE;
--ALTER INDEX &ActorOrdinal_Index INVISIBLE;
DECLARE
  nameOut varchar(200);
BEGIN
  FOR i IN 1..1000 LOOP
	SELECT a.firstName || ' ' || a.lastName
		INTO nameOut
		FROM Actor a, ActorOrdinal ao
		WHERE a.id = ao.id
		  AND ao.ordinal = (SELECT TRUNC(dbms_random.value(0,&ActorCount-1)) FROM Dual);
  END LOOP;
END;
/
ALTER INDEX &Actor_Index VISIBLE;
ALTER INDEX &ActorOrdinal_Index VISIBLE;

-- Class 9.1.c.
-- This example forces the Oracle CBO to use the index (normally it would ignore the index in this case).
SET AUTOTRACE TRACEONLY;
BEGIN
	FOR i IN 1..1000 LOOP
--    	FOR t IN (SELECT  /*+ INDEX(Actor, &Actor_Index) */ id, firstName || ' ' || lastName name
    	FOR t IN (SELECT  id, firstName || ' ' || lastName name
    				FROM Actor
    				WHERE id <> 933) LOOP
			NULL;
		END LOOP;
	END LOOP;
END;
/

SET AUTOTRACE OFF;
SET SERVEROUTPUT OFF;
SET TIMING OFF;
SET WRAP ON;