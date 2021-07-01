var semID = [];
var AyIDFromAy = [];

function RequestGETS() {
  $.ajax({
    url: "/Questionnaire/api/semester?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      semID = [];
      $.each(data, function (index, value) {
        semID.push(value.SemesterID);
      });

      ShowSTable(data);
      AddS();
    },
  });
}

function ShowSTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='S'>";
  txt += "<th>" + " SemesterID" + "</th>";
  txt += "<th>" + " AcademicYearID" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].SemesterID + "</td>";
    txt += "<td> " + data[x].AYearID + "</td>";
    txt +=
      "<td>" +
      "<button class='delSButton' id='data[x].AYearID'onclick='deleteSRow(this)'>Delete</button></td></tr>";
  }
  txt += "<tr><td><input id='SID' name='SID' type='text'>" + "</td>";

  txt +=
    "<td><select id='AyID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/academicYear?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.AYearID);
        AyIDFromAy.push(value.AYearID);
      });
      $.each(AyIDFromAy, function (index, value) {
        $("#AyID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt += "<td>" + "<button id='addSButton'>Add</button></td></tr>";
  document.getElementById("semesterID").innerHTML = txt;
}

function AddS() {
  $("#addSButton").on("click", function (event) {
    var SID = $('input[name="SID"]').val();
    var AYID = $("#AyID").val();
    var sendData = {
      sid: SID,
      yid: AYID,
    };
    console.log("sendData: " + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/semester",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data, jqXHR) {
        AyIDFromAy = []; //Empty array after each time a new record is added.

        if (data !== "OK") {
          alert("Cannot add, invalid input.");
          return;
        }
        alert(
          'Added "' +
            "Semester ID: " +
            SID +
            " - Academic Year: " +
            AYID +
            '" to Semester successfully.'
        );
        console.log("return: " + data + JSON.stringify(jqXHR));
        $("#S").load("#S"); //Refresh the entire page
      },
    });
  });
}

function deleteSRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueToDelete = semID[rIndex - 1];
  console.log(valueToDelete);
  document.getElementById("S").deleteRow(rIndex);
  console.log(typeof valueToDelete + valueToDelete);
  sendSDelete(valueToDelete);
}

function sendSDelete(valueToDelete) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/semester?sid=" + valueToDelete,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot add, invalid input.");
        return;
      }
      alert(
        'Added "' +
          "Semester ID: " +
          SID +
          " - Academic Year: " +
          AYID +
          '" to Semester successfully.'
      );
      console.log("return: " + data + JSON.stringify(jqXHR));
      console.log(this.url);
      $("#S").load("#S"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETS();
});
