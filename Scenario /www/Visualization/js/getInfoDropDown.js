var lecIndex, lecID;
$(document).ready(function () {
  var arrClass = [],
    arrLec = [],
    arrAY = [],
    arrSem = [],
    arrFal = [],
    arrProg = [],
    arrModu = [];
  var arrLecID = [];

  $.ajax(
    //GET Request for AcademicYear
    {
      url: "/Questionnaire/api/academicYear?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        // console.log(data)
        $.each(data, function (index, value) {
          arrAY.push(value.AYearID);
        });
        // console.log(arrAY);
        console.log(JSON.stringify(data));
        $("#AY")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrAY, function (index, value) {
          // console.log("value: " + value);
          $("#AY").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Semester
    {
      url: "/Questionnaire/api/semester?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        $.each(data, function (index, value) {
          arrSem.push(value.SemesterID);
        });
        // console.log(arrSem);
        console.log(JSON.stringify(data));
        $("#Semester")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrSem, function (index, value) {
          // console.log("value: " + value);
          $("#Semester").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Faculty
    {
      url: "/Questionnaire/api/faculty?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        // // console.log(data);
        $.each(data, function (index, value) {
          arrFal.push(value.FacultyID);
        });
        // console.log(arrFal);
        console.log(JSON.stringify(data));
        $("#Faculty")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrFal, function (index, value) {
          // console.log("value: " + value);
          $("#Faculty").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Program
    {
      url: "/Questionnaire/api/program?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        // console.log(data);
        $.each(data, function (index, value) {
          arrProg.push(value.ProgramID);
        });
        // console.log(arrProg);
        console.log(JSON.stringify(data));
        $("#Program")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrProg, function (index, value) {
          // console.log("value: " + value);
          $("#Program").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Class
    {
      url: "/Questionnaire/api/class?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        // console.log(data);
        $.each(data, function (index, value) {
          arrClass.push(value.ClassID);
        });
        // console.log(arrClass);
        console.log(JSON.stringify(data));
        $("#Class")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrClass, function (index, value) {
          // console.log("value: " + value);
          $("#Class").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Module
    {
      url: "/Questionnaire/api/module?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        // console.log(data);
        $.each(data, function (index, value) {
          arrModu.push(value.ModuleID);
        });
        // console.log(arrModu);
        console.log(JSON.stringify(data));
        $("#Module")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrModu, function (index, value) {
          // console.log("value: " + value);
          $("#Module").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $.ajax(
    //GET Request for Lecturer
    {
      url: "/Questionnaire/api/lecturer?action=dump",
      type: "GET",
      dataType: "json",
      success: function (data) {
        $.each(data, function (index, value) {
          arrLec.push(value.Username);
          arrLecID.push(value.LecturerID);
        });
        // console.log(arrLec);
        console.log(JSON.stringify(data));
        $("#Lecturer")
          .find("option")
          .remove()
          .end()
          .append('<option value="">---Select---</option>');
        //console.log(arrLec2);
        $.each(arrLec, function (index, value) {
          // console.log("value: " + value);
          $("#Lecturer").append(
            '<option value="' + value + '">' + value + "</option>"
          );
        });
      },
    }
  );

  $("#Lecturer").on("change", function (event) {
    lecIndex = document.getElementById("Lecturer").selectedIndex - 1;
    lecID = arrLecID[lecIndex];
  });
  return lecID;
});
