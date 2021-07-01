var FID = [];

function RequestGETF() {
  $.ajax({
    url: "/Questionnaire/api/faculty?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      FID = [];
      $.each(data, function (index, value) {
        FID.push(value.FacultyID);
      });
      console.log(JSON.stringify(data));

      ShowFTable(data);
      AddF();
    },
  });
}

function ShowFTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='F'>";
  txt += "<th>" + "FacultyID" + "</th>";
  txt += "<th>" + "FacultyName" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].FacultyID + "</td>";
    txt += "<td>" + data[x].FacultyName + "</td>";
    txt +=
      "<td><button class='delFButton' id='delFButton'onclick='deleteFRow(this)'>Delete</button></td></tr>";
  }
  txt +=
    "<tr><td><input id='facultyID' name='facultyID' type='text'>" + "</td>";
  txt +=
    "<td><input id='facultyName' name='facultyName' type='text'>" + "</td>";
  txt += "<td>" + "<button id='addFButton'>Add</button></td></tr>";
  txt += "</table>";
  document.getElementById("facultyID_2").innerHTML = txt;
}

function AddF() {
  $("#addFButton").on("click", function (event) {
    var facultyID = $('input[name="facultyID"]').val();
    var facultyName = $('input[name="facultyName"]').val();
    var sendData = {
      fid: facultyID,
      fname: facultyName,
    };
    console.log("sendData: " + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/faculty",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data) {
        if (data !== "OK") {
          alert("Cannot add, invalid input");
          return;
        }
        alert(
          'Added "' +
            "Faculty ID: " +
            facultyID +
            " - Faculty Name: " +
            facultyName +
            '" to Faculty successfully.'
        );
        console.log(data);
        $("#F").load("#F"); //Refresh the entire page
      },
    });
  });
}

function deleteFRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueToDelete = FID[rIndex - 1];
  console.log(valueToDelete);
  document.getElementById("F").deleteRow(rIndex);
  console.log(typeof valueToDelete + valueToDelete);
  sendFDelete(valueToDelete);
}

function sendFDelete(valueToDelete) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/faculty?fid=" + valueToDelete,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot delete.");
      }
      alert(
        'Deleted "' +
          "Faculty ID: " +
          valueToDelete +
          '" from Faculty successfully.'
      );
      console.log("error: " + data + textStatus + JSON.stringify(jqXHR));
      $("#F").load("#F"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETF();
});
