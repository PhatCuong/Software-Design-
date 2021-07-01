# Stored procedures

## `AllAddProcedures.sql`

### `AddAcademicYear(IN inAYearId, OUT statusCode)`

Add all the attributes of a new Academic Year to the database by the given AYearId.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *490 - DUPLICATION OF Academic Year*

**Return** `R()`

### `AddSemester(IN inSemesterId,IN inAYearId, OUT statusCode)`

Add all the attributes of a new Semester within an Academic Year to the database by the given SemesterId, AYearId.

**Arguments**

+ `inSemesterId - VARCHAR(10)` is a characters sequence that uniquely identifies a Semester.
+ `inAYearId - VARCHAR(10)` is a characters sequence that identifies an Academic Year of the Semester.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *490 - DUPLICATION OF Semester*

**Return** `R()`

### `AddFaculty(IN inFacultyId,IN inFacultyName, OUT statusCode)`

Add all the attributes of a new Faculty to the database by the given FacultyId, FacultyName.

**Arguments**

+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inFacultyName - VARCHAR(100)` is a characters sequence that represent a Faculty Name.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *403 - NON-EXISTENT/INVALID Faculty Name*
    + *490 - DUPLICATION OF Faculty Id*

**Return** `R()`

### `AddProgram(IN inProgramId,IN inProgramName, OUT statusCode)`

Add all the attributes of a new Program to the database by the given ProgramId, ProgramName.

**Arguments**

+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inProgramName - VARCHAR(100)` is a characters sequence that represent a Program Name.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *404 - NON-EXISTENT/INVALID Program Name*
    + *490 - DUPLICATION OF Program Id*

**Return** `R()`

### `AddModule(IN inModuleId,IN inModuleName, OUT statusCode)`

Add all the attributes of a new Faculty to the database by the given FacultyId, FacultyName.

**Arguments**

+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `inModuleName - VARCHAR(100)` is a characters sequence that represent a Module Name.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *405 - NON-EXISTENT/INVALID Module Name*
    + *490 - DUPLICATION OF Module ID*

**Return** `R()`

### `AddFacultyInAcademicYear(IN inFacultyId,IN inAYearId, OUT statusCode)`

Add all the attributes of a new connection of Faculty to an Academic Year to the database by the given FacultyId, AYearId.

**Arguments**

+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *490 - DUPLICATION OF the combination Faculty Id + Academic Year ID*

**Return** `R()`

### `AddProgramInFacultyInAcademicYear(IN inProgramId, IN inFacultyId, IN inAYearId, OUT statusCode)`

Add all the attributes of a new connection of Program to Faculty in an Academic Year to the database by the given ProgramId,FacultyId, AYearId.

**Arguments**

+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *490 - DUPLICATION OF the combination Program ID + Faculty ID + Academic Year ID*

**Return** `R()`

### `AddModuleInProgramInAcademicYear(IN inModuleId, IN inProgramId, IN inAYearId, OUT statusCode)`

Add all the attributes of a new connection of Module to Program in an Academic Year to the database by the given ModuleId, ProgramId, AYearId.

**Arguments**

+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *490 - DUPLICATION OF the combination Module ID + Program ID + Academic Year ID*

**Return** `R()`

### `AddLecturer(IN inLecturerId, IN inLecturerName, IN inUserName, OUT statusCode)`

Add all the attributes of a Lecturer to the database by the given LecturerId,  LecturerName, UserName.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inLecturerName - VARCHAR(100)` is a characters sequence that represent a Lecturer's name.
+ `inUserName - VARCHAR(20)` is a characters sequence that uniquely identifies a UserName.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *406 - NON-EXISTENT/INVALID Lecturer Name*
    + *420 - NON-EXISTENT/INVALID Username*
    + *490 - DUPLICATION OF the Lecturer ID*

**Return** `R()`

### `AddClass(IN inClassId, IN inSize, IN inSemesterId, IN inModuleId, OUT statusCode)`

Add all the attributes of a new Class to the database by the given ClassId, Size, ModuleId, SemesterId.

**Arguments**

+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `inSize - INT` is an integer that identifies the size of the given Class Id.
+ `inSemesterID - VARCHAR(10)` is a characters sequence that uniquely identifies a Semester.
+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *427 - NON-EXISTENT/INVALID Class Size*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *490 - DUPLICATION OF the Class ID*

**Return** `R()`

### `AddTeaching(IN inLecturerId, IN inClassId, OUT statusCode)`

Add all the attributes of a new connection Teaching to the database by the given ClassId, LecturerId.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *490 - DUPLICATION OF the combination of Lecturer ID + Class ID*

**Return** `R()`

### `AddQuestionnaire(IN inLecturerId, IN inClassId, IN inGender, IN inQuestion(0-17),IN inComment, OUT statusCode)`

Add all the attributes of a new Questionnaire to the database by the given ClassId, LecturerId, Gender, Question from 0 to 17, Comment.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `inGender - ENUM('M','F','O')` is a string object represent the genders.
+ `inQuestion0 - ENUM('1','2','3','4','5')` is a string object represent the attendance.
+ `inQuestion1 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 1.
+ `inQuestion2 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 2.
+ `inQuestion3 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 3.
+ `inQuestion4 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 4.
+ `inQuestion5 - ENUM('1','2','3','4','5')` is a string object represent all of the possible answers of question 5.
+ `inQuestion6 - ENUM('1','2','3','4','5')` is a string object represent all of the possible answers of question 6.
+ `inQuestion7 - ENUM('1','2','3','4','5')` is a string object represent all of the possible answers of question 7.
+ `inQuestion8 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 8.
+ `inQuestion9 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 9.
+ `inQuestion10 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 10.
+ `inQuestion11 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 11.
+ `inQuestion12 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 12.
+ `inQuestion13 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 13.
+ `inQuestion14 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 14.
+ `inQuestion15 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 15.
+ `inQuestion16 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 16.
+ `inQuestion17 - ENUM('1','2','3','4','5','N/A')` is a string object represent all of the possible answers of question 17.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *407 - NON-EXISTENT/INVALID Class ID*

**Return** `R()`

## `AllDeleteProcedures.sql`

### `DeleteAcademicYear(IN inAYearId, OUT statusCode)`

Delete all the attributes of an existing Academic Year in the database by the given inAYearId.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteSemester(IN inSemesterId, OUT statusCode)`

Delete all the attributes of an existing Semester in the database by the given SemesterId.

**Arguments**

+ `inSemesterId - VARCHAR(10)` is  a characters sequence that uniquely identifies a Semester.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteFaculty(IN inFacultyId, OUT statusCode)`

Delete all the attributes of an existing Faculty in the database by the given FacultyId.

**Arguments**

+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteProgram(IN inProgramId, OUT statusCode)`

Delete all the attributes of an existing Program in the database by the given ProgramId.

**Arguments**

+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.

+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteModule(IN inModuleId, OUT statusCode)`

Delete all the attributes of an existing Module in the database by the given ModuleId.

**Arguments**

+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteFacultyInAcademicYear(IN inFacultyId,IN inAYearId, OUT statusCode)`

Delete all the attributes of an existing connection Faculty in the database by the given FacultyId, AYearId.

**Arguments**

+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteProgramInFacultyInAcademicYear(IN inProgramId, IN inAYearId, OUT statusCode)`

Delete all the attributes of an existing connection Program to Faculty in an Academic Year in the database by the given ProgramId, AYearId.

**Arguments**

+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteModuleInProgramInAcademicYear(IN inModuleId, IN inProgramId,IN inAYearId, OUT statusCode)`

Delete all the attributes of an existing connection of Module to Program in an Academic Year in the database by the given ModuleId, ProgramId, AYearId.

**Arguments**

+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteLecturer(IN inLecturerId, OUT statusCode)`

Delete all the attributes of an existing Lecturer in the database by the given LecturerId.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteClass(IN inClassId, OUT statusCode)`

Delete all the attributes of an existing Class in the database by the given ClassId.

**Arguments**

+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteTeaching(IN inLecturerId, IN inClassId, OUT statusCode)`

Delete all the attributes of an existing connection Teaching in the database by the given ClassId, LecturerId.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *495 - DELETE VIOLATION*

**Return** `R()`

### `DeleteQuestionnaire(IN inLecturerId, IN inClassId, IN inGender, IN QuestionnairePK, OUT statusCode)`

Delete all the attributes of an existing Questionnaire in the database by the given ClassId, LecturerId, QuestionnairePK.

**Arguments**

+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `inQuestionnairePK - INT` is an integer that uniquely identifies a Questionnaire.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *418 - NON-EXISTENT/INVALID Questionnaire*

**Return** `R()`

## `AllDumpingProcedures.sql`

### `DumpAcademicYear`

Dump out a list of Academic Years.

**Return** `R(AYearId)`

### `DumpSemester`

Dump out a list of Semesters in Academic Years.

**Return** `R(SemesterId,AYearId)`

### `DumpFaculty`

Dump out a list of FacultyIDs, Faculty Names.

**Return** `R(FacultyId,FacultyName)`

### `DumpProgram`

Dump out a list of ProgramIDs, Program Names.

**Return** `R(ProgramId,ProgramName)`

### `DumpModule`

Dump out a list of ModuleIDs, Module Names.

**Return** `R(ModuleId,ModuleName)`

### `DumpFacultyInAcademicYear`

Dump out a list of FacultyIDs in Academic Years.

**Return** `R(FacultyId,AYearId)`

### `DumpProgramInFacultyInAcademicYear`

Dump out a list of ProgramIDs in Faculties in Academic Years.

**Return** `R(ProgramId,FacultyId,AYearId)`

### `DumpModuleInProgramInAcademicYear`

Dump out a list of ModuleIDs in Programs in Academic Years.

**Return** `R(ModuleId,ProgramId,AYearId)`

### `DumpLecturer`

Dump out a list of LecturerIDs, Lecturer Names , Lecturer Username.

**Return** `R(LecturerId,LecturerName,UserName)`

### `DumpClass`

Dump out a list of ClassIDs and their Sizes, SemesterIDs, ModuleIDs.

**Return** `R(ClassId,Size,SemesterId,ModuleId)`

### `DumpTeaching`

Dump out a list of ClassIDs and LecturerIDs.

**Return** `R(LecturerId,ClassId)`

### `DumpQuestionnaire`

Dump out a list of QuestionnairePKs masked as QuestionnaireIDs, LecturerIDs, ClassIDs, Genders, Question0 as Attendance, Question1 to Question17 and Comments.

**Return** `R(QuestionnaireId,LecturerId,ClassId,Gender,Attendance,Question1,Question2,Question3,Question4,Question5,Question6,Question7,Question8,Question9,Question10,Question11,Question12,Question13,Question14,Question15,Question16,Question17,Comment)`

## `AllGetProcedures.sql`

### `GetFaculties(IN inAYearId, OUT statusCode)`

Get the ID and Name of Faculties by the inserted of AYearID.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*

**Return** `R(FacultyId,FacultyName)`

### `GetPrograms(IN inAYearId,IN FacultyId, OUT statusCode)`

Get the ID and Name of Programs by the inserted of AYearID, FacultyID.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*

**Return** `R(ProgramId,ProgramName)`

### `GetModules(IN inAYearId,IN ProgramId, OUT statusCode)`

Get the ID and Name of Modules by the inserted of AYearID, ProgramID.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *414 - NON-EXISTENT/INVALID Program ID*

**Return** `R(ModuleId,ModuleName)`

### `GetClasses(IN inSemesterId,IN ProgramId,IN ModuleId, OUT statusCode)`

Get the ID of Classes by the inserted of SemesterID, ProgramID, ModuleID.

**Arguments**

+ `inSemesterId - VARCHAR(10)` is a characters sequence that uniquely identifies a Semester.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *415 - NON-EXISTENT/INVALID Module ID*

**Return** `R(ClassId)`

### `GetLecturers(IN inClassId, OUT statusCode)`

Get the ID and UserName of Lecturers by the inserted of ClassID.

**Arguments**

+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *407 - NON-EXISTENT/INVALID Class ID*

**Return** `R(LecturerId,UserName)`

### `GetClassOptions(IN inClassId, OUT statusCode)`

Get Academic Year, Semester, Faculty Name, Program Name, Lecturer Name, ClassID of the inserted Class.

**Arguments**

+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *407 - NON-EXISTENT/INVALID Class ID*

**Return** `R(AYearId,SemesterId,FacultyName,ProgramName,LecturerName,ClassId)`

### `GetComments(IN inClassId,IN inLecturerId, OUT statusCode)`

Get Comments of the Questionnaire for the inserted Class and Lecturer.

**Arguments**

+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*

**Return** `R(Comment)`

### `GetTotalClassesSize(IN inAYearId,IN inSemesterId,IN FacultyId,IN ProgramId,IN ModuleId,IN LecturerId,IN ClassId,OUT statusCode)`

Get Total Classes Size for the optional(null or existed) input of AYearID, SemesterID, FacultyID, ProgramID, ModuleID, LecturerID, ClassID.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `inSemesterId - VARCHAR(10)` is a characters sequence that uniquely identifies a Semester.
+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*
    + *407 - NON-EXISTENT/INVALID Class ID*

**Return** `R(Sum(Size))`

### `GetQuestionnaireCount(IN inAYearId,IN inSemesterId,IN FacultyId,IN ProgramId,IN ModuleId,IN ClassId,IN LecturerId,OUT statusCode)`

Get Total Questionnaire numbers for the optional(null or existed) input of AYearID, SemesterID, FacultyID, ProgramID, ModuleID, ClassID, LecturerID, QuestionNumber.

**Arguments**

+ `inAYearId - VARCHAR(10)` is a characters sequence that uniquely identifies an Academic Year.
+ `inSemesterId - VARCHAR(10)` is a characters sequence that uniquely identifies a Semester.
+ `inFacultyId - VARCHAR(10)` is a characters sequence that uniquely identifies a Faculty.
+ `inProgramId - VARCHAR(10)` is a characters sequence that uniquely identifies a Program.
+ `inModuleId - VARCHAR(10)` is a characters sequence that uniquely identifies a Module.
+ `inClassId - VARCHAR(10)` is a characters sequence that uniquely identifies a Class.
+ `inLecturerId - VARCHAR(10)` is a characters sequence that uniquely identifies a Lecturer.
+ `inQuestion - ENUM ('Gender', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17')` is the optional question number.
+ `statusCode - INT` is set by the data and indicates whether any error happened during the execution:
    + *200 - SUCCESS*
    + *401 - NON-EXISTENT/INVALID Academic Year ID*
    + *402 - NON-EXISTENT/INVALID Semester ID*
    + *413 - NON-EXISTENT/INVALID Faculty ID*
    + *414 - NON-EXISTENT/INVALID Program ID*
    + *415 - NON-EXISTENT/INVALID Module ID*
    + *407 - NON-EXISTENT/INVALID Class ID*
    + *416 - NON-EXISTENT/INVALID Lecturer ID*

**Return** `R(Count(QuestionnairePK))`
