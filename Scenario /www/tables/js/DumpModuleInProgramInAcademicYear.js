var  moID=[], programID=[],aYearID=[];
var ModuleIDFromModule = [], ProgIDFromProg = [], AYearIDFromAYear = [];

function RequestGETMPA()
{
	$.ajax(
	{
		url: "/Questionnaire/api/moduleInProgramInAcademicYear?action=dump",
        type: 'GET',
        dataType: 'json',
        success: function(data)
		{
			moID = [];
			programID = [];
			aYearID = [];
			$.each(data, function(index, value)
			{
				moID.push(value.ModuleID);
				programID.push(value.ProgramID);
				aYearID.push(value.AYearID);
			});
            console.log(JSON.stringify(data));
			
			ShowMPATable(data);
			AddMPA();
        }
	});
};

function ShowMPATable(data)
{
	var txt = "", x;
	txt += "<table border='1' stripe='1' id='MPA'>"
	txt += "<th>" +' ModuleID' + "</th>"
	txt += "<th>" +' ProgramID' + "</th>"
	txt += "<th>" +' Academic Year ID' + "</th>"
	for (x in data)
	{
		txt += "<tr><td>" + data[x].ModuleID + "</td>";
		txt += "<td> " + data[x].ProgramID + "</td>";
		txt += "<td> " + data[x].AYearID + "</td>";
		txt += "<td>" + "<button class='delMPAButton' id='data[x].AYearID'onclick='deleteMPARow(this)'>Delete</button></td></tr>";
	}
	
	txt += "<td><select id='ModuID'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/module?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			ModuleIDFromModule = [];
			$.each(data, function(index, value)
			{
				console.log(value.ModuleID);
				ModuleIDFromModule.push(value.ModuleID);
			});
			$("#ModuID")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			$.each(ModuleIDFromModule, function(index, value)
			{
				$('#ModuID').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	
	txt += "<td><select id='ProgrID'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/program?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			ProgIDFromProg = [];
			$.each(data, function(index, value)
			{
				console.log(value.ProgramID);
				ProgIDFromProg.push(value.ProgramID);
			});
			$("#ProgrID")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			$.each(ProgIDFromProg, function(index, value)
			{
				$('#ProgrID').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	
	txt += "<td><select id='AYearId'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/academicYear?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			AYearIDFromAYear = [];
			$.each(data, function(index, value)
			{
				console.log(value.AYearID);
				AYearIDFromAYear.push(value.AYearID);
			});
			$("#AYearId")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			$.each(AYearIDFromAYear, function(index, value)
			{
				$('#AYearId').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	txt += "<td>" + "<button id='addMPAButton'>Add</button></td></tr>";
	document.getElementById("MPAcademic").innerHTML = txt;
};

function AddMPA()
{
	$("#addMPAButton").on("click", function(event)
	{
		var MID = $('#ModuID').val();
		var PID = $('#ProgrID').val();
		var AYID = $('#AYearId').val();
		console.log(typeof MID + MID + typeof AYID + AYID);
		var sendData =
		{
			"mid": MID,
			"pid": PID,
			"yid": AYID
		};
		console.log("sendData: " + JSON.stringify(sendData));
		$.ajax(
		{
			url: '/Questionnaire/api/moduleInProgramInAcademicYear',
			type: 'PUT',
			processData: false,
			data: JSON.stringify(sendData),
			success: function(data, jqXHR)
			{
				//Empty arrays
				ModuleIDFromModule = [];
				ProgIDFromProg = [];
				AYearIDFromAYear = [];
				
				if (data !== 'OK')
				{
					alert("Cannot add, invalid input.");
				}
				else
				{
					alert("Added \"" + "Module ID: " + MID + " - Program ID: " + PID + " - Academic Year: " + AYID + "\" to Module - Program - Academic Year successfully.");
				}
				console.log("return: " + data + JSON.stringify(jqXHR));
				$('#MPA').load('#MPA');		//Refresh the entire page
			}
		});
	});
};

function deleteMPARow(r)
{
	var rIndex = r.parentNode.parentNode.rowIndex;
	console.log("row index: " + rIndex);
	var valueModuleIDToDelete = moID[rIndex-1];
	var valueProgramToDelete = programID[rIndex-1];
	var valueAYToDelete = aYearID[rIndex-1];
	document.getElementById("MPA").deleteRow(rIndex);
	sendMPADelete(valueModuleIDToDelete, valueProgramToDelete, valueAYToDelete);
};

function sendMPADelete(valueModuleIDToDelete, valueProgramToDelete, valueAYToDelete)
{
	$.ajax
	({
		type: 'Delete',
		url: "/Questionnaire/api/moduleInProgramInAcademicYear?mid=" + valueModuleIDToDelete +"&pid=" + valueProgramToDelete + "&yid=" + valueAYToDelete,
		success: function(data,textStatus,jqXHR)
		{
			console.log(this.url);
			console.log(JSON.stringify(jqXHR));
			console.log(jqXHR.status);
			if (jqXHR.status != 200)
			{
				alert("Cannot delete.");
			}
			else
			{
				alert("Deleted \"" + "Module ID: " + valueModuleIDToDelete +"- Program: " + valueProgramToDelete + " - Academic Year: " + valueAYToDelete + "\" from Module - Program - Academic Year successfully.");
			}
			$('#MPA').load('#MPA');		//Refresh the entire page
		}
	});
};

$(document).ready(function()
{
	RequestGETMPA();
});
