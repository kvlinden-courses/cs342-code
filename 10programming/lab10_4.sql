-- Starter code for lab exercise 10.4
--
-- CS 342, Spring, 2017
-- kvlinden

CREATE OR REPLACE PROCEDURE incrementRank (movieIdIn IN Movie.id%type, deltaIn IN integer) AS
	x Movie.rank%type;
BEGIN
	FOR i IN 1..50000 LOOP
		SELECT rank INTO x FROM Movie WHERE id=movieIdIn;
		UPDATE Movie SET rank=x+deltaIn WHERE id=movieIdIn;
        -- Commit each individual update rather than waiting til the end of the loop.
		COMMIT;
	END LOOP;
END;
/