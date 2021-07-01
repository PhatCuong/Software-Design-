# Submit.js
- This script has 2 functions: `GetSubmitData()` and `SendSubmitData()`
### `GetSubmitData()`:
- This function will take input values of the questionnaire form, wrap it into a JSON called `sendData` for further processing.
  - `sendData` comprise of 5 properties:
    - `lecturerID`
    - `classID`
    - `gender`
    - `qa` (an array of answers encoded using integer)
    - `comment` of the student.
- In order to submit the questionnaire form, the user must answer every question.

### `SendSubmitData(sendData)`:
**Parameter:**<br>
- `sendData` is a JSON that is described in `GetSubmitData()`.<br>

**Functionality:**
- This function is used to send a `PUT` request to the server to save information in the filled questionnaire to database.
- Upon successful submission (i.e. answering every question and pressing `Submit` button), an alert box telling the user that the form has been "Submitted" will appear.
- If the user leave any question unanswered then pressing the `Submit` button, an alert box with the following message will appear: `"Please select an option for every question."`
- If there's any unexpected error, an alert box `"Error when submitting, please try again."` will appear.
<br><br><br>
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# getClassOptions.js

## Notice:
- There are global variables in this JS file and can be used by any of the files in the same directory:
  - `arrAY`, `arrSem`, `arrFal`, `arrPro`, `arrMod`, `arrCla`, `arrLecture`
  - `AYQuery`, `semQuery`, `falQuery`, `proQuery`, `modQuery`, `claQuery`, `lecQuery`
- Consider carefully if you want to use/create/modify variables that have the same name as the listed above.

## Details:

**Functionality:**

- There are 7 functions that send `GET` requests to different endpoints:
  1. `ShowAYDropdown()`: `/Questionnaire/api/academicYear?action=dump`<br>
	2. `ShowSDropdown()`: `/Questionnaire/api/semester?action=dump`<br>
    **- Return values are `Academic Years` and `Semesters`, respectively.<br><br>**

  3. `ShowFDropdown()`: `/Questionnaire/api/facultyInAcademicYear?action=getFaculties&yid=AcademicYearValue`<br>
	4. `ShowPDropdown()`: `/Questionnaire/api/programInFacultyInAcademicYear?action=getPrograms&yid=AcademicYearValue&fid=FacultyID`<br>
	5. `ShowMDropdown()`: `/Questionnaire/api/moduleInProgramInAcademicYear?action=getModules&yid=AcademicYearValue&pid=ProgramID`<br>
	6. `ShowCDropdown()`: `/Questionnaire/api/moduleInProgramInAcademicYear?action=getClasses&sid=SemesterID&pid=ProgramID&mid=ModuleID`<br>
	7. `ShowLDropdown()`: `/Questionnaire/api/teaching?action=getLecturers&cid=ClassID`<br>
    **- Return values of these `GET` requests are after the `?action=get*`.<br>**
    **- Return values correspond to the supplied parameters.<br><br>**

- After each `GET` request, the return data will be put into a dropdown selection.
- Every option must be selected, if not, an alert box will appear `"Please select an option"`.
