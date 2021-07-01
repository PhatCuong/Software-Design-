var fData = [],
  aYData = [];
var FacultyIDFromFaculty = [],
  AYIDFromAY = [];

function RequestGETFAY() {
  $.ajax({
    url: "/Questionnaire/api/facultyInAcademicYear?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      (fData = []), (aYData = []);
      $.each(data, function (index, value) {
        aYData.push(value.AYearID);
        fData.push(value.FacultyID);
      });
      console.log(aYData);
      console.log(fData);
      console.log(JSON.stringify(data));

      ShowFAYTable(data); //This function will show the table.
      AddFAY(); //This function allows user to add new record.
    },
  });
}

function ShowFAYTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='FAY' class='FAY'>";
  txt += "<th>" + " FacultyID" + "</th>";
  txt += "<th>" + " AYearID" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].FacultyID + "</td>";
    txt += "<td>" + data[x].AYearID + "</td>";
    txt +=
      "<td>" +
      "<button class='delFAYButton' id='delFAYButton'onclick='deleteFAYRow(this)'>Delete</button></td></tr>";
  }

  txt +=
    "<td><select id='FacID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/faculty?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.FacultyID);
        FacultyIDFromFaculty.push(value.FacultyID);
      });
      $.each(FacultyIDFromFaculty, function (index, value) {
        $("#FacID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt +=
    "<td><select id='AYID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/academicYear?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.AYearID);
        AYIDFromAY.push(value.AYearID);
      });
      $.each(AYIDFromAY, function (index, value) {
        $("#AYID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt += "<td>" + "<button id='addFAYButton'>Add</button></td></tr>";

  document.getElementById("facultyID").innerHTML = txt;
}

function AddFAY() {
  $("#addFAYButton").on("click", function (event) {
    var facID = $("#FacID").val();
    var AYearID = $("#AYID").val();
    var sendData = {
      fid: facID,
      yid: AYearID,
    };
    console.log("sendData: " + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/facultyInAcademicYear",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data) {
        //Empty arrays
        FacultyIDFromFaculty = [];
        AYIDFromAY = [];

        console.log(data);
        if (data !== "OK") {
          alert("Cannot add, invalid input.");
          return;
        }
        alert(
          'Added "' +
            "Faculty ID: " +
            facID +
            " - Academic Year: " +
            AYearID +
            '" to Faculty successfully.'
        );

        $("#FAY").load("#FAY"); //Refresh the entire page
      },
    });
  });
}

function deleteFAYRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueFToDelete = fData[rIndex - 1];
  var valueAYToDelete = aYData[rIndex - 1];
  console.log(
    "valueFToDelete: " + valueFToDelete + " valueAYToDelete: " + valueAYToDelete
  );
  document.getElementById("FAY").deleteRow(rIndex);
  sendFAYDelete(valueFToDelete, valueAYToDelete);
}

function sendFAYDelete(valueFToDelete, valueAYToDelete) {
  $.ajax({
    type: "Delete",
    url:
      "/Questionnaire/api/facultyInAcademicYear?fid=" +
      valueFToDelete +
      "&yid=" +
      valueAYToDelete,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot delete.");
        return;
      }
      alert(
        'Deleted "' +
          "Faculty ID: " +
          valueFToDelete +
          " - Academic Year: " +
          valueAYToDelete +
          '" from Faculty successfully.'
      );
      console.log(data);
      $("#FAY").load("#FAY"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETFAY();
});
