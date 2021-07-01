$(document).ready(function () {
  $("#a[x]").on("click", function () {
    var AcaYear = $("#a[x]").val();
    if (AcaYear != 0) {
      $.ajax({
        type: "DELETE",
        contentType: "application/json",
        url: "/Questionnaire/api/academicYear?action=doDelete" + AcaYear,
        dataType: "text",
        data: {
          p_AYearID: AcaYear,
        },
        success: function (data, textStatus, jqXHR) {
          alert(data);
        },
      });
    }
  });
});
