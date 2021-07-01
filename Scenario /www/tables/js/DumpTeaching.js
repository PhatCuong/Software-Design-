var LecID = [],
  ClassID = [];
var LecIDFromLecturer = [],
  ClassIDFromClass = [];

function RequestGETT() {
  $.ajax({
    url: "/Questionnaire/api/teaching?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      LecID = [];
      ClassID = [];
      $.each(data, function (index, value) {
        LecID.push(value.LecturerID);
        ClassID.push(value.ClassID);
      });
      console.log(JSON.stringify(data));

      ShowTTable(data);
      AddT();
    },
  });
}

function ShowTTable(data) {
  var txt = "",
    x;
  txt += "<table border='1' stripe='1' id='T'>";
  txt += "<th>" + " LecturerID" + "</th>";
  txt += "<th>" + " ClassID" + "</th>";
  for (x in data) {
    txt += "<tr><td>" + data[x].LecturerID + "</td>";
    txt += "<td>" + data[x].ClassID + "</td>";
    txt +=
      "<td>" +
      "<button class='delTButton' id='delTButton'onclick='deleteTRow(this)'>Delete</button></td></tr>";
  }
  txt +=
    "<td><select id='leID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/lecturer?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.LecturerID);
        LecIDFromLecturer.push(value.LecturerID);
      });
      $.each(LecIDFromLecturer, function (index, value) {
        $("#leID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt +=
    "<td><select id='claID'><option value='-1'>---Select---</option></select></td>";
  $.ajax({
    url: "/Questionnaire/api/class?action=dump",
    type: "GET",
    dataType: "json",
    success: function (data) {
      $.each(data, function (index, value) {
        console.log(value.ClassID);
        ClassIDFromClass.push(value.ClassID);
        ClassIDFromClass.sort(function (a, b) {
          return a - b;
        });
      });
      $.each(ClassIDFromClass, function (index, value) {
        $("#claID").append(
          '<option value="' + value + '">' + value + "</option>"
        );
      });
    },
  });
  txt += "<td>" + "<button id='addTButton'>Add</button></td></tr>";
  document.getElementById("lecturerID_2").innerHTML = txt;
}

function AddT() {
  $("#addTButton").on("click", function (event) {
    // var LeID = $('input[name="LeID"]').val();
    // var classId = $('input[name="classId"').val();
    var LeID = $("#leID").val();
    var classId = $("#claID").val();
    var sendData = {
      lid: LeID,
      cid: classId,
    };
    console.log("sendData: " + JSON.stringify(sendData));
    $.ajax({
      url: "/Questionnaire/api/teaching",
      type: "PUT",
      processData: false,
      data: JSON.stringify(sendData),
      success: function (data, jqXHR) {
        //Empty arrays
        LecIDFromLecturer = [];
        ClassIDFromClass = [];

        if (data !== "OK") {
          alert("Cannot add, invalid input.");
          return;
        }
        alert(
          'Added "' +
            "Lecturer ID: " +
            LeID +
            " - Class ID: " +
            classId +
            '" to Teaching successfully.'
        );
        console.log("return: " + data + JSON.stringify(jqXHR));
        $("#T").load("#T"); //Refresh the entire page
      },
    });
  });
}

function deleteTRow(r) {
  var rIndex = r.parentNode.parentNode.rowIndex;
  console.log("row index: " + rIndex);
  var LecData = LecID[rIndex - 1];
  var ClassData = ClassID[rIndex - 1];
  document.getElementById("T").deleteRow(rIndex);
  sendTDelete(LecData, ClassData);
}

function sendTDelete(lid, cid) {
  $.ajax({
    type: "Delete",
    url: "/Questionnaire/api/teaching?lid=" + lid + "&cid=" + cid,
    success: function (data, textStatus, jqXHR) {
      if (data !== "OK") {
        alert("Cannot delete.");
        return;
      }
      alert(
        'Deleted "' +
          "Lecturer ID: " +
          lid +
          " - Class ID: " +
          cid +
          '" from Teaching successfully.'
      );
      console.log("return: " + data + JSON.stringify(jqXHR));
      $("#T").load("#T"); //Refresh the entire page
    },
  });
}

$(document).ready(function () {
  RequestGETT();
});
