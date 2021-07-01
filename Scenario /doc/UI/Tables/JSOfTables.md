## Notice:
- There are global variables in the 11 following JS files and can be used by any of the files:
  - DumpAcademicYear.js: `arrayData`
  - DumpClass.js: `CData`, `SizeData`, `SemData`, `MoID`, `SemIDFromSemester`, `ModIDFromModule`
  - DumpFaculty.js: `FID`
  - DumpFacultyInAcademicYear.js: `fData`, `aYData`, `FacultyIDFromFaculty`, `AYIDFromAY`
  - DumpLecturer.js: `LID`,
  - DumpModule.js: `arrayMData`
  - DumpModuleInProgramInAcademicYear.js: `moID`, `programID`, `aYearID`, `ModuleIDFromModule`, `ProgIDFromProg`, `AYearIDFromAYear`
  - DumpProgram.js: `arrayPData`
  - DumpProgramInFacultyInAcademicYear.js: `proID`, `facID`, `yearID`, `ProgramIDFromProgram`, `FacIDFromFaculty`, `AYeaIDFromAYea`
  - DumpSemester.js: `semID`, `AyIDFromAy`
  - DumpTeaching.js: `LecID`, `ClassID`, `LecIDFromLecturer`, `ClassIDFromClass`
- Consider carefully if you want to use/create/modify variables that have the same name as the listed above.

## Details of the JavaScript files:
- There are 11 tables, in the code, they are abbreviated as follows: 
  - `Faculty in Academic Year` = `FAY`
  - `Academic Year` = `AY`
  - `Semester` = `S`
  - `Faculty` = `F`
  - `Program` = `P`
  - `Module` = `M`
  - `Class` = `C`
  - `Lecturer` = `L`
  - `Teaching` = `T`
  - `Program in Faculty in Academic Year` = `PFA`
  - `Module in Program in Academic Year` = `MPA`

- In each Dump*.js file, there are 5 functions:
  - `RequestGET*()`: send `GET` requests
  - `Show*Table()`: display tables
  - `Add*()`: add new record
  - `delete*Row()`: delete a row
  - `send*Delete()`: send `DELETE` requests

- Replace the `*` with abbreviations above, for example: in DumpAcademicYear.js, there are:
  - `RequestGETAY()`
  - `ShowAYTable()`
  - `AddAY`
  - `deleteAYRow()`
  - `sendAYDelete()`


### `ShowTable(data)`:
**Parameter:**<br>
- `data` is the returned value of successful `GET` requests to dump resource.<br>

**Functionality:**<br>
- This function is called in `RequestGET*()` to take the returned values from the request and display them in a table.
- It also creates "Add" and "Delete" button to add and delete records.
- Some input fields that can be obtained from the database will be put into dropdown selection via `GET` requests.<br><br>

### `Add()`:
- This function will allow user to add new record to the table if the input does not violate any conditions in the database.
- If there's a violation, the return status is NOT `OK` (or `200`), and an alert box telling the user "Cannot add, invalid input." will pop up.
- Otherwise, upon a successful `PUT` request, an alert box will pop up telling the user "Added `value` to `*` successfully"
(where `value` is the user input and `*` is the name of the table).
- After adding, the table will be refreshed.<br><br>

### `RequestGET()`:
- This function will send a `GET` request to the API endpoint corresponding to its table
- For example: a `GET` request to the following endpoint for dumping resource of Academic Year table: `/Questionnaire/api/academicYear?action=dump`
- The returned value will be used in `ShowTable(data)` and `Add()`.<br><br>

### `deleteRow(r)`:
**Parameter:**<br>
- `r` is the current row of the "Delete" button.<br>

**Functionality:**<br>
- This function will delete the current row in the interface and call `sendDelete()`.<br><br>

### `sendDelete(id)`:
**Parameter:**<br>
- `id` is the value that the the user wants to delete, this value will be obtained based on `deleteRow()`.<br>

**Functionality:**<br>
- This function will allow user to delete a record in the table if the it does not violate any conditions in the database.
- If there's a violation, the return status is NOT `OK` (or `200`), and an alert box telling the user "Cannot delete." will pop up.
- Otherwise, upon a successful `DELETE` request, an alert box will pop up telling the user "Deleted `value` from `*` successfully."
(where `value` is the value that the user wants to delete and `*` is the name of the table).
- After deleting, the table will be refreshed.
