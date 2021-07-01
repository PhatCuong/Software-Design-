function GetSubmitData() {
  var gender = $("#genderLabel").val(); //This is "gender"
  var attend = $("#attendClassLabel").val();
  var Q1 = $("#question1Label").val();
  var Q2 = $("#question2Label").val();
  var Q3 = $("#question3Label").val();
  var Q4 = $("#question4Label").val();
  var Q5 = $("#question5Label").val();
  var Q6 = $("#question6Label").val();
  var Q7 = $("#question7Label").val();
  var Q8 = $("#question8Label").val();
  var Q9 = $("#question9Label").val();
  var Q10 = $("#question10Label").val();
  var Q11 = $("#question11Label").val();
  var Q12 = $("#question12Label").val();
  var Q13 = $("#question13Label").val();
  var Q14 = $("#question14Label").val();
  var Q15 = $("#question15Label").val();
  var Q16 = $("#question16Label").val();
  var Q17 = $("#question17Label").val();
  var comment = $('textarea[name="question18Name"]').val();
  var lecturerIDValue = $("#Username").val(); //This is "lid"
  var cId = $("#ClassID").val(); //This is "cid"
  if (
    attend == -1 ||
    gender == -1 ||
    Q1 == -1 ||
    Q2 == -1 ||
    Q3 == -1 ||
    Q4 == -1 ||
    Q5 == -1 ||
    Q6 == -1 ||
    Q7 == -1 ||
    Q8 == -1 ||
    Q9 == -1 ||
    Q10 == -1 ||
    Q11 == -1 ||
    Q12 == -1 ||
    Q13 == -1 ||
    Q14 == -1 ||
    Q15 == -1 ||
    Q16 == -1 ||
    Q17 == -1
  ) {
    alert("Please select an option for every question.");
    return;
  }
  var answers = [
    attend,
    Q1,
    Q2,
    Q3,
    Q4,
    Q5,
    Q6,
    Q7,
    Q8,
    Q9,
    Q10,
    Q11,
    Q12,
    Q13,
    Q14,
    Q15,
    Q16,
    Q17,
  ];
  var answersInt = answers.map(Number);
  var sendData = {
    lid: lecturerIDValue,
    cid: cId,
    gender: gender,
    qa: answersInt,
    comment: comment,
  };

  console.log(JSON.stringify(sendData));
  SendSubmitData(sendData);
}

function SendSubmitData(sendData) {
  $.ajax({
    type: "PUT",
    url: "/Questionnaire/api/questionnaire",
    processData: false,
    data: JSON.stringify(sendData),
    success: function (data, jqXHR) {
      if (data !== "OK") {
        alert("Error when submitting, please try again.");
        console.log("error: " + JSON.stringify(data) + JSON.stringify(jqXHR));
        return;
      }
      alert("Submitted");
      location.reload();
    },
    error: function (data, jqXHR) {
      console.log("error: " + JSON.stringify(data) + JSON.stringify(jqXHR));
    },
  });
}

$(document).ready(function () {
  $("#SubmitQuestionnaireID").on("click", function (event) {
    GetSubmitData();
  });
});
