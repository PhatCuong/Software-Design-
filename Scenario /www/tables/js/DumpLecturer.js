var LID=[];

function RequestGETL()
{
	$.ajax(
	{
		url: "/Questionnaire/api/lecturer?action=dump",
        type: 'GET',
        dataType: 'json',
        success: function(data)
		{
			LID = [];
			$.each(data, function(index, value)
			{
				LID.push(value.LecturerID);
			});
            console.log(JSON.stringify(data));

			ShowLTable(data);
			AddL();
        }
	});
};

function ShowLTable(data)
{
	var txt = "", x;
	txt += "<table border='1' stripe='1' id='L'>"
	txt += "<th>" +' LecturerID' + "</th>"
	txt += "<th>" +' Username' + "</th>"
	for (x in data)
	{
		txt += "<tr><td>" + data[x].LecturerID + "</td>";
		txt += "<td>" + data[x].Username + "</td>";
		txt += "<td>" + "<button class='delLButton' id='delLButton'onclick='deleteLRow(this)'>Delete</button></td></tr>";
	}
	txt += "<tr><td><input id='LecID' name='LecID' type='text'>" + "</td>";
	txt += "<td><input id='LecName' name='LecName' type='text'>" + "</td>";
	txt += "<td>" + "<button id='addLButton'>Add</button></td></tr>";
	txt += "</table>"
	document.getElementById("LecturerID").innerHTML = txt;
};

function AddL()
{
	$("#addLButton").on("click", function(event)
	{
		var LecID = $('input[name="LecID"]').val();
		var LecName = $('input[name="LecName"').val();
		var sendData =
		{
			"lid": LecID,
			"username": LecName
		};
		console.log("sendData: " + JSON.stringify(sendData));
		$.ajax(
		{
			url: '/Questionnaire/api/lecturer',
			type: 'PUT',
			processData: false,
			data: JSON.stringify(sendData),
			success: function(data, jqXHR)
			{
				console.log(this.url);
				console.log("return: " + data + JSON.stringify(jqXHR));
				if (data !== 'OK')
				{
					alert("Cannot add, invalid input.");
				}
				else
				{
					alert("Added \"" + "Lecturer ID: " + LecID + " - Lecturer Name: " + LecName+ "\" to Lecturer successfully.");
				}
				$('#L').load('#L');		//Refresh the entire page
			}
		});
	});
};

function deleteLRow(r)
{
	var rIndex = r.parentNode.parentNode.rowIndex;
	console.log("row index: " + rIndex);
	var valueToDelete = LID[rIndex-1];
	console.log(valueToDelete);
	document.getElementById("L").deleteRow(rIndex);
	console.log(typeof valueToDelete + valueToDelete);
	sendLDelete(valueToDelete);
};

function sendLDelete(valueToDelete)
{
	$.ajax
	({
		type: 'Delete',
		url: "/Questionnaire/api/lecturer?lid=" + valueToDelete,
		success: function(data,textStatus,jqXHR)
		{
			if (data !== 'OK')
			{
				alert("Cannot delete.");
			}
			else
			{
				alert("Deleted \"" + "Lecturer ID: " + valueToDelete + "\" from Lecturer successfully.");
			}
			console.log(data);
			$('#L').load('#L');		//Refresh the entire page
		}
	});
};

$(document).ready(function()
{
	RequestGETL();
});
