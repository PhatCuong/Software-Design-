-- Modified for current procedures + tests (22/03/21)
CALL GetTotalClassesSize(2005,'WS01' ,'Computer And Engineering', 'Electrical Engineering' , 'Calculus','1', @statusCode);
-- Expected code results - 401

CALL GetTotalClassesSize(2001,'WS' ,'Computer And Engineering', 'Electrical Engineering' , 'Calculus','1', @statusCode);
-- Expected code results - 402

CALL GetTotalClassesSize(2001,'WS01' ,'Nursery', 'Electrical Engineering' , 'Calculus','1', @statusCode);
-- Expected code results - 403

CALL GetTotalClassesSize(2001,'WS01' ,'Computer And Engineering', 'Pharmacy' , 'Calculus','1', @statusCode);
-- Expected code results - 404

CALL GetTotalClassesSize(2001,'WS01' ,'Computer And Engineering', 'Electrical Engineering' , 'Wizardry','1', @statusCode);
-- Expected code results - 405

CALL GetTotalClassesSize(2001,'WS01' ,'Computer And Engineering', 'Electrical Engineering' , 'Calculus','1', @statusCode);
-- Expected result - 20
