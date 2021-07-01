var CData = [],
  SizeData = [],
  SemData = [],
  MoID = [];
var SemIDFromSemester = [],
  ModIDFromModule = [];

function RequestGETC() {
  $.ajax({
    url: "/Questionnaire/api/class?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      CData = [];
      SizeData = [];
      SemData = [];
      MoID = [];
      $.each(data, function (index, value) {
        CData.push(value.ClassID);
        SizeData.push(value.Size);
        SemData.push(value.SemesterID);
        MoID.push(value.ModuleID);
      });
      //CData.sort(function(a, b){return a - b});
      console.log(JSON.stringify(data));

      ShowCTable(data);
      AddC();
    },
  });
}

function ShowCTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='C'>";
  txt += "<th>" + " ClassID" + "</th>";
  txt += "<th>" + " Size" + "</th>";
  txt += "<th>" + " SemesterID" + "</th>";
  txt += "<th>" + " ModuleID" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].ClassID + "</td>";
    txt += "<td>" + data[x].Size + "</td>";
    txt += "<td>" + data[x].SemesterID + "</td>";
    txt += "<td>" + data[x].ModuleID + "</td>";
    txt +=
      "<td>" +
      "<button class='delCButton' id='delCButton'onclick='deleteCRow(this)'>Delete</button></td></tr>";
  }
  txt += "<tr><td><input id='classID' name='classID' type='text'>" + "</td>";
  txt += "<td><input id='classSize' name='classSize' type='text'>" + "</td>";
  txt +=
    "<td><select id='seID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/semester?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.SemesterID);
        SemIDFromSemester.push(value.SemesterID);
      });
      $.each(SemIDFromSemester, function (index, value) {
        $("#seID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });

  txt +=
    "<td><select id='modID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/module?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.ModuleID);
        ModIDFromModule.push(value.ModuleID);
      });
      $.each(ModIDFromModule, function (index, value) {
        $("#modID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt += "<td>" + "<button id='addCButton'>Add</button></td></tr>";
  txt += "</table>";

  document.getElementById("ClassID").innerHTML = txt;
}

function AddC() {
  $("#addCButton").on("click", function (event) {
    var classID = $('input[name="classID"]').val();
    // var semesterID = $('input[name="semesterID"').val();
    // var moduleID = $('input[name="moduleID"]').val();
    var semesterID = $("#seID").val();
    var moduleID = $("#modID").val();
    var size = $('input[name="classSize"]').val();
    var sizeInt = parseInt(size);
    var sendData = {
      cid: classID,
      size: sizeInt,
      sid: semesterID,
      mid: moduleID,
    };
    console.log("sendData: " + typeof sendData + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/class",
      type: "PUT",
      processData: false,
      dataType: "text",
      data: JSON.stringify(sendData),
      success: function (data) {
        //Empty arrays
        SemIDFromSemester = [];
        ModIDFromModule = [];

        if (data !== "OK") {
          alert("Cannot add, invalid input.");
          return;
        }
        alert(
          'Added "' +
            "Class ID: " +
            classID +
            " - Size: " +
            sizeInt +
            " - Semester ID: " +
            semesterID +
            " - Module ID: " +
            moduleID +
            '" to Class successfully.'
        );
        console.log("sendData: " + typeof sendData + JSON.stringify(sendData));
        console.log(data);
        $("#C").load("#C"); //Refresh the entire page
      },
    });
  });
}

function deleteCRow(r) {
  console.log("CData: " + CData);
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var valueToDelete = CData[rIndex - 1];
  console.log(valueToDelete);
  document.getElementById("C").deleteRow(rIndex);
  var CDataInt = parseInt(CData[rIndex - 1]);
  var sendDelData = JSON.stringify(CDataInt);
  console.log(typeof sendDelData + sendDelData);
  sendCDelete(sendDelData);
}

function sendCDelete(cid) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/class?cid=" + cid,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot delete.");
        return;
      }
      alert('Deleted "' + "Class ID: " + cid + '" from Class successfully.');
      console.log(data);
      $("#C").load("#C"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETC();
});
