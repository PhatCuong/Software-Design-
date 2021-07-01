$(document).ready(function () {
  $.get("/Questionnaire/api/module?action=dump", function (data, status) {
    console.log(JSON.stringify(data));
  });
});
