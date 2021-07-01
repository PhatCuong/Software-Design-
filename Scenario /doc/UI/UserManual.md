# User Manual for VGU SQM's Questionnaire

## Home page (`/Questionnaire`)

The home page has links to the 3 applications:

  - Tables: `Questionnaire/tables/`
  - Questionnaire form: `Questionnaire/Questionnaire/`
  - Visualize: `Questionnaire/Visualize/`

## Tables (`/Questionnaire/tables`)

There are 11 tables in this page:

  - `Faculty in Academic Year`
  - `Academic Year`
  - `Semester`
  - `Faculty`
  - `Program`
  - `Module`
  - `Class`
  - `Lecturer`
  - `Teaching`
  - `Program in Faculty in Academic Year`
  - `Module in Program in Academic Year`

Each table has its own `Hide`/`Show` button, its functionality is to show or hide the corresponding table.

At the end of each record, there's a `Delete` button, it is used to delete a record. If that record does not relate to record(s) of any other tables, then it can be deleted, and the user is alerted of the successful deletion. Otherwise, the user will the alerted that the deletion is unsuccessful.

At the bottom of each table, there's a text field or drop-down selection for the user to add a new record. Upon pressing the `Add` button, if the input value is valid, an alert box telling the value has been added successfully will show up. Otherwise, an error message will appear.

After successfully adding/deleting a record, the table will be refreshed, this will update the table.

## Questionnaire (`/Questionnaire/Questionnaire`)

There are 7 fields in the questionnaire that will be used to identify questionnaires

  - `Academic Year`
  - `Semester`
  - `Faculty`
  - `Program`
  - `Module`
  - `Class`
  - `Lecturer`

To submit a questionnaire answer, the user (students) are to follow these steps:

1. Select the 7 Questionnaire-identifying fields to get the desired Class and Lecturer identifying a Questionnaire
2. Fill in the questions. All 17 multiple-choice questions must be filled, while **Comments** is optional.
3. After selecting every option, the students can press `Submit` button to submit the questionnaire, then the page will refresh.
4. If any compulsory question is not filled, the user cannot submit the form.

## Data Visualization (`/Questionnaire/Visualize`)

There are 7 fields in the questionnaire that will be used to identify what to visualize

  - `Academic Year`
  - `Semester`
  - `Faculty`
  - `Program`
  - `Module`
  - `Class`
  - `Lecturer`

To visualize questionnaire responses, the user (VGU SQM staff) are to follow these steps:

1. Choose the filters (the 7 fields) to visualize for
2. Click the **Visualize** button to get graphs corresponding to the applied filters.
3. 17 questions are then visualized as 17 bar charts. If both `Class` and `Lecturer`, comments will also be shown.
