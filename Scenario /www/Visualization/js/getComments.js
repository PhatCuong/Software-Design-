$(document).ready(function () {
  var claQuery = $("#Class").val(); // get value from Class ID
  var lecQuery = $("#Lecturer").val(); //get value from Lecturer ID
  $("#visualizeBtn").on("click", function (event) {
    setUrl = "/Questionnaire/api/questionnaire?action=getComments";
    if (claQuery != "" && lecQuery != "") {
      // execute only when Class and Lecturer is chosen
      setUrl += "&cid=" + claQuery + "&lid=" + lecQuery;
      console.log("claQuery: " + claQuery + " lecQuery: " + lecID);
      $.ajax({
        url: setUrl,
        type: "GET",
        dataType: "json",
        success: function (data) {
          console.log(data);
          document.getElementById("q18Comment").innerHTML = data;
        },
      });
    }
  });
});
