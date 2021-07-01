var arrAY = [],
  arrSem = [],
  arrFal = [],
  arrPro = [],
  arrMod = [],
  arrCla = [],
  arrLecture = [];
var AYQuery, semQuery, falQuery, proQuery, modQuery, claQuery, lecQuery;

function ShowAYDropdown() {
  $.ajax({
    type: "GET",
    url: "/Questionnaire/api/academicYear?action=dump",
    dataType: "json",
    success: function (data) {
      console.log(data);
      $.each(data, function (index, value) {
        arrAY.push(value.AYearID);
      });
      console.log(arrAY);
      $.each(arrAY, function (index, value) {
        $("#Ay").append('<option value="' + value + '">' + value + "</option>");
      });
    },
  });
}

function ShowSDropdown() {
  $("#Ay").on("change", function (event) {
    AYQuery = $("#Ay").val();
    console.log(AYQuery);
    if (AYQuery == -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url: "/Questionnaire/api/semester?action=dump",
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrSem = [];
        $.each(data, function (index, value) {
          arrSem.push(value.SemesterID);
        });
        console.log(arrSem);
        $("#SemesterID")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrSem, function (index, value) {
          $("#SemesterID").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    });
  });
}

function ShowFDropdown() {
  $("#SemesterID").on("change", function (event) {
    semQuery = $("#SemesterID").val();
    console.log(semQuery);
    if (semQuery == -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url:
        "/Questionnaire/api/facultyInAcademicYear?action=getFaculties&yid=" +
        AYQuery,
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrFal = [];
        $.each(data, function (index, value) {
          //arrFal.push(value.FacultyName);
          arrFal.push(value);
        });
        console.log(arrFal);
        $("#FacultyName")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrFal, function (index, value) {
          $("#FacultyName").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    });
  });
}

function ShowPDropdown() {
  $("#FacultyName").on("change", function (event) {
    falQuery = $("#FacultyName").val();
    console.log(falQuery);
    if (falQuery == -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url:
        "/Questionnaire/api/programInFacultyInAcademicYear?action=getPrograms&yid=" +
        AYQuery +
        "&fid=" +
        falQuery,
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrPro = [];
        $.each(data, function (index, value) {
          arrPro.push(value);
        });
        console.log(arrPro);
        $("#ProgramName")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrPro, function (index, value) {
          $("#ProgramName").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    });
  });
}

function ShowMDropdown() {
  $("#ProgramName").on("change", function (event) {
    proQuery = $("#ProgramName").val();
    console.log(proQuery);
    if (proQuery == -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url:
        "/Questionnaire/api/moduleInProgramInAcademicYear?action=getModules&yid=" +
        AYQuery +
        "&pid=" +
        proQuery,
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrMod = [];
        $.each(data, function (index, value) {
          arrMod.push(value);
        });
        console.log(arrMod);
        $("#ModuleName")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrMod, function (index, value) {
          $("#ModuleName").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    });
  });
}

function ShowCDropdown() {
  $("#ModuleName").on("change", function (event) {
    modQuery = $("#ModuleName").val();
    console.log(proQuery);
    if (proQuery == -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url:
        "/Questionnaire/api/moduleInProgramInAcademicYear?action=getClasses&sid=" +
        semQuery +
        "&pid=" +
        proQuery +
        "&mid=" +
        modQuery,
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrCla = [];
        $.each(data, function (index, value) {
          arrCla.push(value);
        });
        console.log(arrMod);
        $("#ClassID")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrCla, function (index, value) {
          $("#ClassID").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    });
  });
}

function ShowLDropdown() {
  $("#ClassID").on("change", function (event) {
    claQuery = $("#ClassID").val();
    console.log(claQuery);
    console.log(
      "semQuery: " +
        semQuery +
        " proQuery: " +
        proQuery +
        " modQuery: " +
        modQuery
    );
    if (claQuery != -1) {
      alert("Please select an option");
      return;
    }
    $.ajax({
      type: "GET",
      url: "/Questionnaire/api/teaching?action=getLecturers&cid=" + claQuery,
      dataType: "json",
      success: function (data) {
        console.log(data);
        arrLecture = [];
        $.each(data, function (index, value) {
          arrLecture.push(value);
        });
        console.log(arrLecture);
        $("#Username")
          .find("option")
          .remove()
          .end()
          .append('<option value="-1">---Select---</option>')
          .val("---Select---");
        $.each(arrLecture, function (index, value) {
          $("#Username").append(
            '<option value="' + value.lid + '">' + value.user + "</option>"
          );
        });
      },
    });
  });
}

$(document).ready(function () {
  ShowAYDropdown();
  ShowSDropdown();
  ShowFDropdown();
  ShowPDropdown();
  ShowMDropdown();
  ShowCDropdown();
  ShowLDropdown();
});
