# API endpoints and calls

## API endpoints

The following endpoints can be reached at `/Questionnaire/api/endpoint_name`, where `endpoint_name` is replaced with the appropriate endpoint

- `academicYear`
- `class`
- `faculty`
- `facultyInAcademicYear`
- `lecturer`
- `module`
- `moduleInProgramInAcademicYear`
- `program`
- `programInFacultyInAcademicYear`
- `questionnaire`
- `semester`
- `teaching`

## `GET`

### General actions

These are possible values for the `action` parameter handled by *all* endpoints

#### `dump`

This dumps the entire table for each resource/endpoint. The response is formatted as follows:

```json
[
    {
        name1: value1,
        name2: value2,
        name3: value3,
    },
    {
        name1: value4,
        name2: value5,
        name3: value6,
    },
]
```

### Endpoint-specific actions

#### `questionnaire`

##### `getCounts`

Calls to `questionnaire?action=getCounts` can have the following parameters:

- `yid`: AcademicYearID
- `sid`: SemesterID
- `fid`: FacultyID
- `pid`: ProgramID
- `mid`: ModuleID
- `cid`: ClassID
- `lid`: LecturerID
- `q`: Question

The parameters `yid`, `sid`, `fid`, `pid`, `mid`, `cid`, and `lid` are optional, must `q` must be present. `q` can be an integer in the range 0-17 or the string "gender".

The response is formatted as follows:

- `question=gender`

```json
{
    "M": 0,
    "F": 0,
    "O": 0,
}
```

- questions 0-17

```json
{
    "1": 0,
    "2": 0,
    "3": 0,
    "4": 0,
    "5": 0,
}
```


Replace the `0`s with real counts.

##### `getMaxResponseCount`

Calls to `questionnaire?action=getMaxResponseCount` can have the following parameters:

- `yid`: AcademicYearID
- `sid`: SemesterID
- `fid`: FacultyID
- `pid`: ProgramID
- `mid`: ModuleID
- `cid`: ClassID
- `lid`: LecturerID

All the listed parameters are optional. The response is an integer representing the number of all possible Questionnaire responses for the provided parameters.

##### `getCommments`

Calls to `questionnaire?action=getCommments` can have the following parameters:

- `cid`: ClassID
- `lid`: LecturerID

Both parameters are required. The result is a JSON array of comment strings.

#### `class`

##### `getClassOptions`

Calling `class?action=getClassOptions&cid=_ClassID_` will return lists of semesters, faculties, programs and lecturers.

The response is formatted as follows:

```json
{
    "semester": {"SemesterID": _SemesterID_, "AYearID": _AcademicYearID_},
    "faculty": {"FacultyID": _FacultyID_, "FacultyName": _FacultyName_},
    "program": {"ProgramID": _ProgramID_, "ProgramName": _ProgramName_},
    "lecturers": [
        {"id": "1a", "name": "John Doe"},
        {"id": "2b", "name": "Joe Smith"}
    ]
}
```

## `PUT`

To add an object to the database, make a `PUT` request to the corresponding resource with a JSON request body formatted as listed. (All parameters are `String`s unless specified otherwise; `id` values have a max length of 10, `name` values have a max length of 100)

### `academicYear`

```json
{
    "yid": _AcademicYearID_
}
```

`yid` must be an `int`

### `class`

```json
{
    "cid": _ClassID_,
    "size": _ClassSize_,
    "sid": _SemesterID_,
    "mid": _ModuleID_
}
```

`size` must be an `int`

### `faculty`

```json
{
    "id": _FacultyID_,
    "name": _FacultyName_
}
```

### `facultyInAcademicYear`

```json
{
    "fid": _FacultyID_,
    "yid": _AcademicYearID_
}
```

`yid` must be an `int`

### `lecturer`

```json
{
    "id": _LecturerID_,
    "name": _LecturerName_
}
```

### `module`

```json
{
    "id": _ModuleID_,
    "name": _ModuleName_
}
```

### `moduleInProgramInAcademicYear`

```json
{
    "mid": _ModuleID_,
    "yid": _AcademicYearID_
}
```

`yid` must be an `int`

### `program`

```json
{
    "id": _ProgramID_,
    "name": _ProgramName_
}
```

### `programInFacultyInAcademicYear`

```json
{
    "pid": _ProgramID_,
    "fid": _FacultyID_,
    "yid": _AcademicYearID_
}
```

`yid` must be an `int`

### `questionnaire`

```json
{
    "lid": _LecturerID_,
    "cid": _ClassID_,
    "gender": _Gender_,
    "qa": [_answers_],
    "comment": _Comment_,
}
```

`qa` is an `int` array of length 18, where each element can be in the range 0-5 (except 5,6,7) and `0` represents "N/A".

`comment`'s max length is 500.

### `semester`

```json
{
    "sid": _SemesterID_,
    "yid": _AcademicYearID_
}
```

`yid` must be an `int`

### `teaching`

```json
{
    "lid": _LecturerID_,
    "cid": _ClassID_
}
```

## `DELETE`

 To delete a resource/object from the database, make a `DELETE` request to the corresponding resource in `api/` with the provided parameters:

- `academicYear`: `yid` (AcademicYearID)
- `class`: `cid` (ClassID)
- `faculty`: `id` (FacultyID)
- `facultyInAcademicYear`: `fid` (FacultyID), `yid` (AcademicYearID)
- `lecturer`: `lid` (LecturerID)
- `module`: `mid` (ModuleID)
- `moduleInProgramInAcademicYear`: `mid` (ModuleID), `pid` (ProgramID), `yid` (AcademicYearID)
- `program`: `pid` (ProgramID)
- `programInFacultyInAcademicYear`: `pid` (ProgramID), `yid` (AcademicYearID)
- `questionnaire`: `lid` (LecturerID), `cid` (ClassID), `qid` (QuestionnaireID)
- `semester`: `sid` (SemesterID)
- `teaching`: `lid` (LecturerID), `cid` (ClassID)
