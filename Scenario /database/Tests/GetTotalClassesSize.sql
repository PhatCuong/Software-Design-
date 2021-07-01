CALL GetTotalClassesSize('2005-2006','WS01' ,'CENG', 'EE' , 'Calculus','1','1', @statusCode);
-- Expected code results - 401

CALL GetTotalClassesSize('2001-2002','WS' ,'CENG', 'EE' , 'EECa','1','1', @statusCode);
-- Expected code results - 402

CALL GetTotalClassesSize(2001,'WS01' ,'Nursery', 'EE' , 'EECa','1','1', @statusCode);
-- Expected code results - 413

CALL GetTotalClassesSize('2001-2002','WS01' ,'CENG', 'Pharmacy' , 'EECa','1','1', @statusCode);
-- Expected code results - 414

CALL GetTotalClassesSize('2001-2002','WS01' ,'CENG', 'EE' , 'Wizardry','1','1', @statusCode);
-- Expected code results - 415

CALL GetTotalClassesSize('2001-2002','WS01' ,'CENG', 'EE' , 'EECa','10','1', @statusCode);
-- Expected code results - 416

CALL GetTotalClassesSize('2001-2002','WS01' ,'CENG', 'EE' , 'EECa','1','10', @statusCode);
-- Expected code results - 407

CALL GetTotalClassesSize('2001-2002','WS01' ,'CENG', 'EE' , 'EECa','1','1', @statusCode);
-- Expected result - 20 and code results - 200
