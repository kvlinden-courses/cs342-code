-- Sample procedure for unit 10, without transaction code.
--
-- CS 342, Spring, 2017
-- kvlinden

CREATE OR REPLACE PROCEDURE moveStudent
	(studentIdIn IN Student.id%type,
     sourceSectionIdIn IN Section.id%type,
     destinationSectionIdIn IN Section.id%type
    ) AS
  counter INTEGER;
  sectionTooBig EXCEPTION;
BEGIN

	SELECT COUNT(*) INTO counter
	FROM Enrollment
	WHERE sectionID = destinationSectionIDIn;

	IF counter >= 6 THEN
		RAISE sectionTooBig;
	END IF;

	DELETE FROM Enrollment WHERE studentId=studentIdIn AND sectionId=sourceSectionIdIn;
	INSERT INTO Enrollment(studentId, sectionId) VALUES (studentIdIn, destinationSectionIdIn);
	dbms_output.put_line('Moved student ' || studentIdIn || ' from section ' || sourceSectionIdIn || ' to section ' || destinationSectionIdIn);

    EXCEPTION
      WHEN sectionTooBig THEN
        RAISE_APPLICATION_ERROR(-20000, 'Section ' || destinationSectionIdIn || ' is full');
END;
/
