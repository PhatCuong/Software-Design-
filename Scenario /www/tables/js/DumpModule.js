var arrayMData = [];

function RequestGETM() {
  $.ajax({
    url: "/Questionnaire/api/module?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      arrayMData = [];
      $.each(data, function (index, value) {
        arrayMData.push(value.ModuleID);
      });
      console.log(JSON.stringify(data));

      ShowMTable(data);
      AddM();
    },
  });
}

function ShowMTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='M'>";
  txt += "<th>" + " ModuleID" + "</th>";
  txt += "<th>" + " ModuleName" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].ModuleID + "</td>";
    txt += "<td>" + data[x].ModuleName + "</td>";
    txt +=
      "<td>" +
      "<button class='delMButton' id='delMButton'onclick='deleteMRow(this)'>Delete</button></td></tr>";
  }
  txt += "<tr><td><input id='MID' name='MID' type='text'>" + "</td>";
  txt += "<td><input id='MName' name='MName' type='text'>" + "</td>";
  txt += "<td>" + "<button id='addMButton'>Add</button></td></tr>";
  txt += "</table>";
  document.getElementById("ModuleID").innerHTML = txt;
}

function AddM() {
  $("#addMButton").on("click", function (event) {
    var MolID = $('input[name="MID"]').val();
    var MolName = $('input[name="MName"').val();
    var sendData = {
      mid: MolID,
      mname: MolName,
    };
    console.log("sendData: " + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/module",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data) {
        if (data !== "OK") {
          alert("Cannot add, invalid input.");
          return;
        }
        alert(
          'Added "' +
            "Module ID: " +
            MolID +
            " - Module Name: " +
            MolName +
            '" to Module successfully.'
        );
        console.log(data);
        $("#M").load("#M"); //Refresh the entire page
      },
    });
  });
}

function deleteMRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueToDelete = arrayMData[rIndex - 1];
  console.log(valueToDelete);
  document.getElementById("M").deleteRow(rIndex);
  console.log(typeof valueToDelete + valueToDelete);
  sendMDelete(valueToDelete);
}

function sendMDelete(valueToDelete) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/module?mid=" + valueToDelete,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot delete.");
        return;
      }
      alert(
        'Deleted "' +
          "Module ID: " +
          valueToDelete +
          '" from Module successfully.'
      );
      console.log(data);
      $("#M").load("#M"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETM();
});
