var arrayData = [];

function RequestGETAY() {
  $.ajax({
    url: "/Questionnaire/api/academicYear?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      arrayData = [];
      $.each(data, function (index, value) {
        arrayData.push(value.AYearID);
      });
      console.log(arrayData);
      console.log(JSON.stringify(data));

      ShowAYTable(data); //After sending a GET request, the function will receive data from database, which will be used as input to show the table.
      AddAY(); //This function will allow the user to add a new Academic Year to the DB.
    },
  });
}

function ShowAYTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='AY'>";
  txt += "<th>" + " AcademicYearID" + "</th>";
  for (x in data) {
    txt += "<tr id ='AYear'><td>" + data[x].AYearID + "</td>";
    txt +=
      "<td>" +
      "<button class='delAYButton' id='data[x].AYearID'onclick='deleteAYRow(this)'>Delete</button></td>";
  }
  txt += "<tr><td><input id='inputAY' name='inputAY' type='text'>" + "</td>";
  txt += "<td>" + "<button id='addAYButton'>Add</button></td></tr>";
  txt += "</table>";
  document.getElementById("AYearID_2").innerHTML = txt;
}

function AddAY() {
  $("#addAYButton").on("click", function (event) {
    var value = $('input[name="inputAY"]').val();
    var sendData = { yid: value };
    console.log("sendData: " + JSON.stringify(sendData));
    console.log(typeof value + value);
    $.ajax({
      url: "/Questionnaire/api/academicYear",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data) {
        if (data !== "OK") {
          alert("Cannot add, invalid input.");
        }
        alert('Added "' + value + '" to Academic Year successfully.');
        console.log(data);
        $("#AY").load("#AY"); //Refresh the entire page
      },
    });
  });
}

function deleteAYRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueToDelete = arrayData[rIndex - 1];
  console.log(valueToDelete);
  document.getElementById("AY").deleteRow(rIndex);
  var value2 = parseInt(arrayData.splice(rIndex - 1, 1));
  console.log(typeof value2 + value2);
  var dataToDelete = { yid: value2 };
  console.log(valueToDelete);
  sendAYDelete(valueToDelete);
}

function sendAYDelete(id) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/academicYear?yid=" + id,
    success: function (data, textStatus, jqXHR) {
      console.log(this.url);
      if (data !== "OK") {
        alert("Cannot delete.");
      }
      alert('Deleted "' + id + '" from Academic Year successfully.');
      console.log("return: " + data + textStatus + JSON.stringify(jqXHR));
      $("#AY").load("#AY"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETAY();
});
