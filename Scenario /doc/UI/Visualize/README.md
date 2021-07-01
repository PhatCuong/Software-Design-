# Visualize

## JS

## ``getInfoDropDown``

Send `GET Request` through API using ajax with the following format:``/Questionnaire/api/endpoint_name?action=dump``.

Where ``endpoint_name`` is replaced with the appropriate endpoint:

```
- academicYear
- semester
- faculty
- program
- class
- module
- lecturer
```

The `data` received from each `GET Request` will be send to the appropriate ``ID_Name`` in the HTML in the form of drop down list using $("``#ID_Name``").

Where ``#`` represents ID and  ``ID_Name``s are the name we put in the html page.

## ``getComments``

When ``Visualize`` button is clicked, if `value` from Class and Lecturer are not chosen, nothing happen.

Otherwise, it will execute the following:

+ send `GET Request` with `"/Questionnaire/api/questionnaire?action=getComments&"` + `value`
+ display the comments on HTML by accessing the comment space unique ID


## ``AllQuestionnaireChart``

After chosing `value` (optional) from 7 drop down lists in HTML (recommend chossing at least 1), if choose more than 1, must have the right combination,otherwise the ``Visualize`` button won't work

example:

- ~~Academic Year: 2002-2003 Semester: WS04~~
-  [x] Academic Year:2002-2003 Semester: WS03

When ``Visualize`` button is clicked, the chosen `value`s (optional) from 7 drop down lists will be used for ``GET Request`` inside these functions:

### get_Total_Count()
---

Send `GET Request` with `"/Questionnaire/api/questionnaire?action=getMaxResponseCount&"` + `value`\

**Parameter:**
+ None

**Return** `data` (total number of students)

### get_Gender()
---

Send `GET Request` with `"/Questionnaire/api/questionnaire?action=getCounts&"` + `value` + `"q=gender"`\

**Parameter:**
+ None

**Return** `data` (students participate in evaluation), `Chart_Gender(data)`

### Chart_Gender(data)
---

**Parameter:** 
+ data from get_Gender()

**Return** `Chart visualization on HTML` by accessing the gender's unique ID

### get_Question(question_i)
---

Send **GET Request** with `"/Questionnaire/api/questionnaire?action=getCounts&"` + `value` + `"q=question_i"`\
**Parameter:** 
+ question_i (loop 18 times for 18 questions)

**Return** `data`, `Chart_Questions(i,data)` 

### Chart_Question(question_i,data)
---

**Parameter:**
+ question_i (loop 18 times for 18 questions)
+ data (loop 18 times for 18 questions)

**Return** `Chart visualization on HTML` by accessing the question's unique ID

### Chart_Total()
---

Access data from get_Question(i) and sum all data for 18 questions

**Parameter:** 
+ None

**Return** `Chart visualization on HTML` by accessing the totalAnswer's unique ID
