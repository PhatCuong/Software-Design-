function get_Total_Count() {
  //GET request to get total students
  $.ajax({
    url: setUrlGetTotal,
    type: "GET",
    dataType: "json",
    success: function (data) {
      totalClassSize = data;
      console.log("getTotal: " + data);
    },
  });
}

function get_Gender() {
  //GET request to get total Respondents
  $.ajax({
    url: setUrlGetQuestions + "&q=gender",
    type: "GET",
    dataType: "json",
    success: function (data) {
      console.log(data);
      totalRespondents = jStat.sum([data["M"], data["F"], data["O"]]);
      ResponseRate =
        Math.round(((totalRespondents * 100) / totalClassSize) * 100) / 100;
      //ResponseRate = totalRespondents * 100 / totalClassSize;
      var txt = "Total questionnaire received: " + totalRespondents; //Total respondents
      document.getElementById("numberAnswer").innerHTML = txt; //display total respondents
      Chart_Gender(data);
    },
  });
}

function get_Questions(i) {
  //Get Request for 18 questions
  $.ajax({
    url: setUrlGetQuestions + "&q=" + i,
    type: "GET",
    dataType: "json",
    success: function (data) {
      console.log(data);
      totalAnswer1 += data[1]; //store answer 1
      totalAnswer2 += data[2]; //store answer 2
      totalAnswer3 += data[3]; //store answer 3
      totalAnswer4 += data[4]; //store answer 4
      totalAnswer5 += data[5]; //store answer 5
      Chart_Questions(i, data); //Put the received data into Chart
      if (i == 17) {
        Chart_Total();
      }
    },
  });
}

function Chart_Questions(i, data) {
  //Draw Chart for question 0-17
  meanData[i] =
    Math.round(
      ((data[1] + data[2] * 2 + data[3] * 3 + data[4] * 4 + data[5] * 5) /
        totalRespondents) *
        100
    ) / 100; //Calculate mean

  var varianceData1 = Math.pow(1 - meanData[i], 2);
  var varianceData2 = Math.pow(2 - meanData[i], 2);
  var varianceData3 = Math.pow(3 - meanData[i], 2);
  var varianceData4 = Math.pow(4 - meanData[i], 2);
  var varianceData5 = Math.pow(5 - meanData[i], 2);
  var totalVariance =
    (varianceData1 * data[1] +
      varianceData2 * data[2] +
      varianceData3 * data[3] +
      varianceData4 * data[4] +
      varianceData5 * data[5]) /
    totalRespondents; //Calculate Variance

  var std = Math.round(Math.sqrt(totalVariance) * 100) / 100; //Calculate standard deviation
  var halfstd = std / 2; //split into 2 parts for draw in chart

  var numberOfResponse = jStat.sum([
    data[1],
    data[2],
    data[3],
    data[4],
    data[5],
  ]); // number of Respondents (except N/A)

  var ResponseQuestion = numberOfResponse / totalClassSize; //Response rate for each question(except N/A)

  answer1[i] = (data[1] / totalRespondents) * 100; //Percentages of respondents choose answer1
  answer2[i] = (data[2] / totalRespondents) * 100; //Percentages of respondents choose answer2
  answer3[i] = (data[3] / totalRespondents) * 100; //Percentages of respondents choose answer3
  answer4[i] = (data[4] / totalRespondents) * 100; //Percentages of respondents choose answer4
  answer5[i] = (data[5] / totalRespondents) * 100; //Percentages of respondents choose answer5

  if (checkQuestions[i] == 1) {
    myChartQuestions[i].destroy();
    checkQuestions[i] = 0;
    Chart_Questions(i, data);
    return;
  }

  //check if there is already a chart
  checkQuestions[i] = 1;

  var ctx = document.getElementById("q" + i + "Chart").getContext("2d"); // get ID for each question
  myChartQuestions[i] = new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["Never", "Rarely", "Sometimes", "Often", "Always"],
      datasets: [
        {
          label: "Percentages",
          data: [answer1[i], answer2[i], answer3[i], answer4[i], answer5[i]],
        },
      ],
    },
    options: {
      scales: {
        y: {
          //fixed range for y scale
          min: 0,
          max: 100,
        },
        x: {
          //fixed range for x scale
          min: 0,
          max: 5,
        },
      },
      plugins: {
        title: {
          display: true,
          text:
            "n: " +
            numberOfResponse +
            "\n   ResponseRate: " +
            ResponseRate +
            "\n  mean: " +
            meanData[i] +
            "\n   std: " +
            std,
          align: "end",
        },
        annotation: {
          annotations: {
            point1: {
              type: "point",
              xValue: meanData[i] - 0.5, // -0.5 because of the chart offset
              yValue: 70,
              borderColor: "red",
              backgroundColor: "red",
              radius: 3,
              label: {
                Content: "Mean",
                display: true,
                position: "right",
              },
            },
            line1: {
              type: "line",
              xMin: meanData[i] - 0.5 - halfstd, // -0.5 because of the chart offset
              xMax: meanData[i] - 0.5 + halfstd, // -0.5 because of the chart offset
              yMin: 70,
              yMax: 70,
            },
          },
        },
      },
    },
  });
}

function Chart_Gender(data) {
  //Draw Chart for total Respondents
  if (checkGender == null || checkGender == "") {
    //check if there is already a chart
    checkGender = 1;
    var GenderMale = (data["M"] * 100) / totalRespondents;
    var GenderFemale = (data["F"] * 100) / totalRespondents;
    var GenderOther = (data["O"] * 100) / totalRespondents;
    var ctx = document.getElementById("genderChart").getContext("2d");
    myChartGender = new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["Male", "Female", "Other"],
        datasets: [
          {
            label: "Percentages",
            data: [GenderMale, GenderFemale, GenderOther],
          },
        ],
      },
      options: {
        scales: {
          y: {
            min: 0,
            max: 100,
          },
        },
      },
    });
  } else {
    myChartGender.destroy();
    checkGender = "";
    return Chart_Gender(data);
  }
}

function Chart_Total() {
  //Draw Chart for total answers
  var total1 = [],
    total2 = [],
    total3 = [],
    total4 = [],
    total5 = [];
  total1 = (totalAnswer1 * 100) / (totalRespondents * 18); //Percentages of total respondents choose answer 1
  total2 = (totalAnswer2 * 100) / (totalRespondents * 18); //Percentages of total respondents choose answer 2
  total3 = (totalAnswer3 * 100) / (totalRespondents * 18); //Percentages of total respondents choose answer 3
  total4 = (totalAnswer4 * 100) / (totalRespondents * 18); //Percentages of total respondents choose answer 4
  total5 = (totalAnswer5 * 100) / (totalRespondents * 18); //Percentages of total respondents choose answer 5

  var meanTotal =
    ((totalAnswer1 +
      totalAnswer2 * 2 +
      totalAnswer3 * 3 +
      totalAnswer4 * 4 +
      totalAnswer5 * 5) *
      100) /
    (totalRespondents * 18 * 100); //Calculate total mean

  var varianceTotal1 = Math.pow(1 - meanTotal, 2);
  var varianceTotal2 = Math.pow(2 - meanTotal, 2);
  var varianceTotal3 = Math.pow(3 - meanTotal, 2);
  var varianceTotal4 = Math.pow(4 - meanTotal, 2);
  var varianceTotal5 = Math.pow(5 - meanTotal, 2);
  var varTotal =
    ((varianceTotal1 * totalAnswer1 +
      varianceTotal2 * totalAnswer2 +
      varianceTotal3 * totalAnswer3 +
      varianceTotal4 * totalAnswer4 +
      varianceTotal5 * totalAnswer5) *
      100) /
    (totalRespondents * 18 * 100); //Calculate total Variance

  var stdTotal = Math.round(Math.sqrt(varTotal)); //Calculate Standard Deviation
  var halfstdTotal = stdTotal / 2; // split Standard deviation in half for drawing

  if (checkTotal != 1) {
    // Check if there is already a Chart
    checkTotal = 1;
    var ctx = document.getElementById("totalQuestionnaire").getContext("2d");
    myChartTotal = new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["1", "2", "3", "4", "5"],
        datasets: [
          {
            label: "Percentages",
            data: [total1, total2, total3, total4, total5],
          },
        ],
      },
      options: {
        scales: {
          y: {
            min: 0,
            max: 100,
          },
          x: {
            min: 0,
            max: 5,
          },
        },
        plugins: {
          title: {
            display: true,
            text:
              "n: " +
              totalRespondents +
              "\n   ResponseRate: " +
              ResponseRate +
              "\n  mean: " +
              meanTotal +
              "\n   std: " +
              stdTotal,
            align: "end",
          },
          annotation: {
            annotations: {
              point1: {
                type: "point",
                xValue: meanTotal - 0.5, // -0.5 because of the chart offset
                yValue: 70,
                borderColor: "red",
                backgroundColor: "red",
                radius: 3,
                label: {
                  Content: "Mean",
                  display: true,
                  position: "right",
                },
              },
              line1: {
                type: "line",
                xMin: meanTotal - 0.5 - halfstdTotal, // -0.5 because of the chart offset
                xMax: meanTotal - 0.5 + halfstdTotal, // -0.5 because of the chart offset
                yMin: 70,
                yMax: 70,
              },
            },
          },
        },
      },
    });
  } else {
    checkTotal = null;
    myChartTotal.destroy();
    Chart_Total();
  }
}

$(document).ready(function () {
  var checkQuestions = [];
  var checkGender = [];
  var checkTotal = [];
  var checkTotal = [];
  var myChartQuestions = [];
  var myChartGender = [];
  var myChartTotal = [];

  $("#visualizeBtn").on("click", function (event) {
    var AY = $("#AY").val(); //get value from Academic_Year ID
    var Sem = $("#Semester").val(); // get value from Semester ID
    var Fal = $("#Faculty").val(); // get value from Faculty ID
    var Prog = $("#Program").val(); // get value from Program ID
    var Class = $("#Class").val(); // get value from Class ID
    var Lec = $("#Lecturer").val(); // get value from Lecturer ID
    var Mod = $("#Module").val(); // get value from Module ID
    var answer1 = [];
    var answer2 = [];
    var answer3 = [];
    var answer4 = [];
    var answer5 = [];
    var meanData = [];
    var totalClassSize;
    var totalRespondents = [];
    var ResponseRate = [];
    var totalAnswer1 = 0;
    var totalAnswer2 = 0;
    var totalAnswer3 = 0;
    var totalAnswer4 = 0;
    var totalAnswer5 = 0;
    var setUrlGetQuestions =
      "/Questionnaire/api/questionnaire?action=getCounts";
    var setUrlGetTotal =
      "/Questionnaire/api/questionnaire?action=getMaxResponseCount";

    if (AY != "") {
      //optional Academic_Year
      setUrlGetQuestions += "&yid=" + AY;
      setUrlGetTotal += "&yid=" + AY;
    }
    if (Sem != "") {
      //optional Semester
      setUrlGetQuestions += "&sid=" + Sem;
      setUrlGetTotal += "&sid=" + Sem;
    }
    if (Fal != "") {
      //optional Faculty
      setUrlGetQuestions += "&fid=" + Fal;
      setUrlGetTotal += "&fid=" + Fal;
    }

    if (Prog != "") {
      //optional Program
      setUrlGetQuestions += "&pid=" + Prog;
      setUrlGetTotal += "&pid=" + Prog;
    }

    if (Mod != "") {
      //optional Module
      setUrlGetQuestions += "&mid=" + Mod;
      setUrlGetTotal += "&mid=" + Mod;
    }

    if (Class != "") {
      //optional Class
      setUrlGetQuestions += "&cid=" + Class;
      setUrlGetTotal += "&cid=" + Class;
    }

    if (Lec != "") {
      //optional Lecturer
      setUrlGetQuestions += "&lid=" + Lec;
      setUrlGetTotal += "&lid=" + Lec;
    }

    get_Total_Count();
    get_Gender();

    for (
      var i = 0;
      i < 18;
      i++ //Loop 18 questions
    ) {
      get_Questions(i);
    }
  });
});
