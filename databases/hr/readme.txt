If you inadvertently remove OracleXE's (default provided) HR user, you can rebuild it.
    See https://docs.oracle.com/database/121/EXMPL/toc.htm#CHDEAEJG.
    The source files are in ORAHOME/demo/scheman/human_resources/.

This is a mysql conversion of the hr database created by Micah Ng, CS 342, Spring, 2015.
According to his notes, it can be loaded by extracting and executing it, or more easily with:

	echo CREATE DATABASE hr | mysql -u <user_name> -p
	cat hr.sql | mysql -u <user_name> -p hr

The only change to the schema is that it enforces the check constraints using triggers. 

