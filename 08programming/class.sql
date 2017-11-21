-- Sample queries for unit 8
--
-- CS 342, Spring, 2017
-- kvlinden

SET SERVEROUTPUT ON;

-- 8.3.1.
BEGIN
  dbms_output.put_line('Hello, PL/SQL world!');
END;
/

-- 8.3.2.
DECLARE
  CURSOR namesOut IS
    SELECT firstName, lastName
    FROM Student
    ORDER BY lastName, firstName;
BEGIN
  FOR nameOut IN namesOut LOOP
    dbms_output.put_line(nameOut.firstName || ' ' || nameOut.lastName);
  END LOOP;
END;
/

-- 8.3.3.
CREATE OR REPLACE PROCEDURE skipCount(limit IN integer, step In integer) AS
BEGIN
  FOR i IN 1..limit LOOP
    IF MOD(i, step) = 1 THEN
      dbms_output.put_line(i);
    ELSE
      dbms_output.put_line('-');
    END IF;
  END LOOP;
END;
/

-- 8.3.4.
CREATE OR REPLACE PROCEDURE enrollStudent
	(studentIDIn IN Student.ID%type,
     sectionIDIn IN Section.ID%type
    ) AS
  counter INTEGER;
BEGIN
  SELECT COUNT(*) INTO counter
    FROM Enrollment
    WHERE sectionID = sectionIDIn
      AND studentID = studentIDIn;
  IF counter >= 1 THEN
    RAISE_APPLICATION_ERROR(-20000, 'Student ' || studentIDIn ||
    	' is already enrolled in section ' || sectionIDIn);
  END IF;

  INSERT INTO Enrollment(studentID, sectionID)
  	VALUES (studentIDIn, sectionIDIn);

  dbms_output.put_line('Student ' || studentIDIn ||
  	' enrolled in section ' || sectionIDIn);
END;
/

-- 8.3.5.
CREATE OR REPLACE FUNCTION factorial (n IN POSITIVE) RETURN INTEGER AS
BEGIN
  IF n = 1 THEN
    RETURN 1;
  ELSE
    RETURN n * factorial(n - 1);
  END IF;
END factorial;
/

-- 8.4.
CREATE OR REPLACE TRIGGER PreventSectionOverflow
  BEFORE INSERT ON Enrollment
  FOR each row
DECLARE
  counter INTEGER;
  sectionTooBig EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO counter
    FROM Enrollment
    WHERE sectionID = :new.sectionID;

  dbms_output.put_line('First, check the size of that section.');
  IF counter >= 5 THEN
	raise sectionTooBig;
  END IF;

  EXCEPTION
    WHEN sectionTooBig THEN
	RAISE_APPLICATION_ERROR(-20001,'Illegal attempt to add to a full section: ' || :new.sectionID);
END;
/