var lecID = [],
  classID = [],
  questionID = [];

function deleteQRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var lecIDData = lecID[rIndex - 1];
  var classIDData = classID[rIndex - 1];
  var questionIDData = questionID[rIndex - 1];
  document.getElementById("Q").deleteRow(rIndex);
  var sendlecID = parseInt(lecIDData);
  var sendclassID = parseInt(classIDData);
  var sendquestionID = parseInt(questionIDData);
  sendQDelete(sendlecID, sendclassID, sendquestionID);
}

function sendQDelete(lid, cid, qid) {
  $.ajax({
    type: "Delete",
    url:
      "/Questionnaire/api/questionnaire?lid=" +
      lid +
      "&cid=" +
      cid +
      "&qid=" +
      qid,
    //contentType: "application/json",
    //dataType: "text",
    success: function (data, textStatus, jqXHR) {
      alert(textStatus);
      console.log(data);
    },
  });
}

$(document).ready(function () {
  $.ajax({
    url: "/Questionnaire/api/questionnaire?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        lecID.push(value.LecturerID);
        classID.push(value.ClassID);
        questionID.push(value.QuestionnaireID);
      });
      console.log(JSON.stringify(data));
      var txt = "",
        x;
      txt += "<table border='1' stripe='1' id='Q'>";
      txt += "<th>" + " LecturerID" + "</th>";
      txt += "<th>" + " ClassID" + "</th>";
      txt += "<th>" + " QuestionnaireID" + "</th>";
      txt += "<th>" + " Total students" + "</th>";
      for (x in data) {
        txt += "<tr><td>" + JSON.stringify(data[x].LecturerID) + "</td>";
        txt += "<td>" + JSON.stringify(data[x].ClassID) + "</td>";
        txt += "<td>" + JSON.stringify(data[x].QuestionnaireID) + "</td>";
        txt += "<td>" + JSON.stringify(data[x].gender) + "</td>";
        txt +=
          "<td>" +
          "<button class='delQButton' id='delQButton'onclick='deleteQRow(this)'>Delete</button></td></tr>";
      }
      txt += "<tr><td><input id='QID' name='QID' type='text'>" + "</td>";
      txt += "<td><input id='LID' name='LID' type='text'>" + "</td>";
      txt += "<td><input id='CID' name='CID' type='text'>" + "</td>";
      txt += "<td><input id='Gender' name='Gender' type='text'>" + "</td>";
      txt += "<td>" + "<button id='addQButton'>Add</button></td></tr>";
      txt += "</table>";
      document.getElementById("QuestionaireID").innerHTML = txt;
    },
  });
});
