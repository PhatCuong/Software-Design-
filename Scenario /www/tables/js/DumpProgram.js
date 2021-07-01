var arrayPData = [];

function RequestGETP()
{
	$.ajax(
	{
		url: "/Questionnaire/api/program?action=dump",
        type: 'GET',
        dataType: 'json',
        success: function(data)
		{
			arrayPData = [];
			$.each(data, function(index, value)
			{
				arrayPData.push(value.ProgramID);
			});
            console.log(JSON.stringify(data));
			
			ShowPTable(data);
			AddP();
        }
	});
};

function ShowPTable(data)
{
	var txt = "", x;
	txt += "<table border='1' stripe='1' id='P'>"
	txt += "<th>" +' ProgramID' + "</th>"
	txt += "<th>" +' ProgramName' + "</th>"
	for (x in data)
	{
		txt += "<tr><td>" + data[x].ProgramID +"</td>";
		txt += "<td>" + data[x].ProgramName + "</td>";
		txt += "<td><button class='delPButton' id='delPButton'onclick='deletePRow(this)'>Delete</button></td></tr>";
	}
	txt += "<tr><td><input id='PID' name='PID' type='text'>" + "</td>";
	txt += "<td><input id='PName' name='PName' type='text'>" + "</td>";
	txt += "<td>" + "<button id='addPButton'>Add</button></td></tr>";
	txt += "</table>"
	document.getElementById("ProgramID").innerHTML = txt;
};

function AddP()
{
	$("#addPButton").on("click", function(event)
	{
		var PID = $('input[name="PID"]').val();
		var PName = $('input[name="PName"]').val();
		var sendData =
		{
			"pid": PID,
			"pname": PName
		};
		console.log("sendData: " + JSON.stringify(sendData));
		$.ajax(
		{
			url: '/Questionnaire/api/program',
			type: 'PUT',
			processData: false,
			data: JSON.stringify(sendData),
			success: function(data, jqXHR)
			{
				if (data !== 'OK')
				{
					alert("Cannot add, invalid input.");
				}
				else
				{
					alert("Added \"" + "Program ID: " + PID + " - Program Name: " + PName + "\" to Program successfully.");
				}
				console.log("return: " + data + JSON.stringify(jqXHR));
				console.log(this.url);
				$('#P').load('#P');		//Refresh the entire page
			}
		});
	});
};

function deletePRow(r)
{
	var rIndex = r.parentNode.parentNode.rowIndex;
	console.log("row index: " + rIndex);
	var valueToDelete = arrayPData[rIndex-1];
	console.log(valueToDelete);
	document.getElementById("P").deleteRow(rIndex);
	var sendDelData = valueToDelete;
	console.log(typeof sendDelData + sendDelData);
	sendPDelete(sendDelData);
};

function sendPDelete(sendDelData)
{
	$.ajax
	({
		type: 'Delete',
		url: "/Questionnaire/api/program?pid=" + sendDelData,
		success: function(data,textStatus,jqXHR)
		{
			if (data !== 'OK')
			{
				alert("Cannot delete.");
			}
			else
			{
				alert("Deleted \"" + "Program ID: " + sendDelData + "\" from Program successfully.");
			}
			console.log(data);
			$('#P').load('#P');		//Refresh the entire page
		}
	});
};

$(document).ready(function()
{
	RequestGETP();
});
