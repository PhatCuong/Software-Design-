var  proID=[], facID=[],yearID=[];
var ProgramIDFromProgram = [], FacIDFromFaculty = [], AYeaIDFromAYea = [];

function RequestGETPFA()
{
	$.ajax(
	{
		url: "/Questionnaire/api/programInFacultyInAcademicYear?action=dump",
        type: 'GET',
        dataType: 'json',
        success: function(data)
		{
			proID = [];
			facID = [];
			yearID = [];
			$.each(data, function(index, value)
			{
				proID.push(value.ProgramID);
				facID.push(value.FacultyID);
				yearID.push(value.AYearID);
			});
            console.log(JSON.stringify(data));
			
			ShowPFATable(data);
			AddPFA();
        }
	});
};

function ShowPFATable(data)
{
	var txt = "", x;
	txt += "<table border='1' stripe='1' id='PFA'>"
	txt += "<th>" +' ProgramID' + "</th>"
	txt += "<th>" +' FacultyID' + "</th>"
	txt += "<th>" +' Academic Year ID' + "</th>"
	for (x in data)
	{
		txt += "<tr><td>" + data[x].ProgramID + "</td>";
		txt += "<td> " + data[x].FacultyID + "</td>";
		txt += "<td> " + data[x].AYearID + "</td>";
		txt += "<td>" + "<button class='delSButton' id='data[x].AYearID'onclick='deletePFARow(this)'>Delete</button></td></tr>";
	}
	
	txt += "<td><select id='ProgID'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/program?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			console.log("ProgramIDFromProgram2: " + ProgramIDFromProgram);
			$.each(data, function(index, value)
			{
				console.log(value.ProgramID);
				ProgramIDFromProgram.push(value.ProgramID);
			});
			$("#ProgID")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			console.log("ProgramIDFromProgram: " + ProgramIDFromProgram);
			$.each(ProgramIDFromProgram, function(index, value)
			{
				$('#ProgID').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	
	txt += "<td><select id='FacuID'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/faculty?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			$.each(data, function(index, value)
			{
				console.log(value.FacultyID);
				FacIDFromFaculty.push(value.FacultyID);
			});
			$("#FacuID")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			$.each(FacIDFromFaculty, function(index, value)
			{
				$('#FacuID').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	
	txt += "<td><select id='AYeaID'><option value='-1'>---Select---</option></select></td>"
	$.ajax(
	{
		url: "/Questionnaire/api/academicYear?action=dump",
		type: 'GET',
		dataType: 'json',
		success: function(data)
		{
			$.each(data, function(index, value)
			{
				console.log(value.AYearID);
				AYeaIDFromAYea.push(value.AYearID);
			});
			$("#AYeaID")
            .find("option")
            .remove()
            .end()
            .append('<option value="-1">---Select---</option>')
            .val("---Select---");
			$.each(AYeaIDFromAYea, function(index, value)
			{
				$('#AYeaID').append('<option value="' + value + '">' + value + '</option>');
			});
		}
	});
	txt += "<td>" + "<button id='addPFAButton'>Add</button></td></tr>";
	
	document.getElementById("PFAcademic").innerHTML = txt;
};

function AddPFA()
{
	$("#addPFAButton").on("click", function(event)
	{
		var ProID = $('#ProgID').val();
		var FacID = $('#FacuID').val();
		var AYearID = $('#AYeaID').val();
		var sendData =
		{
			"pid": ProID,
			"fid": FacID,
			"yid": AYearID
		};
		console.log("sendData: " + JSON.stringify(sendData));
		$.ajax(
		{
			url: '/Questionnaire/api/programInFacultyInAcademicYear',
			type: 'PUT',
			processData: false,
			data: JSON.stringify(sendData),
			success: function(data, jqXHR)
			{
				//Empty arrays
				ProgramIDFromProgram = [];
				FacIDFromFaculty = [];
				AYeaIDFromAYea = [];
				
				if (data !== 'OK')
				{
					alert("Cannot add, invalid input.");
				}
				else
				{
					alert("Added \"" + "Program ID: " + ProID + " - Faculty ID: " + FacID + " - Academic Year: " + AYearID + "\" to Program - Faculty - Academic Year successfully.");
				}
				console.log("return: " + data + JSON.stringify(jqXHR));
				$('#PFA').load('#PFA');		//Refresh the entire page
			}
		});
	});
};

function deletePFARow(r)
{
	var rIndex = r.parentNode.parentNode.rowIndex;
	console.log("row index: " + rIndex);
	var valueProIDToDelete = proID[rIndex-1];
	var valueFacIDToDelete = facID[rIndex-1];
	var valueAYToDelete = yearID[rIndex-1];
	document.getElementById("PFA").deleteRow(rIndex);
	console.log("proID: " + valueProIDToDelete + " facID: " + valueFacIDToDelete + " AY: " + valueAYToDelete);
	sendPFADelete(valueProIDToDelete, valueFacIDToDelete, valueAYToDelete);
};

function sendPFADelete(valueProIDToDelete, valueFacIDToDelete, valueAYToDelete)
{
	$.ajax
	({
		type: 'Delete',
		url: "/Questionnaire/api/programInFacultyInAcademicYear?pid=" + valueProIDToDelete + "&fid="+ valueFacIDToDelete + "&yid=" + valueAYToDelete,
		success: function(data,textStatus,jqXHR)
		{
			console.log(this.url);
			if (data !== 'OK')
			{
				alert("Cannot delete.");
			}
			else
			{
				alert("Deleted \"" + "Program ID: " + valueProIDToDelete + " - Faculty ID: " + valueFacIDToDelete + " - Academic Year: " + valueAYToDelete + "\" from Program - Faculty - Academic Year successfully.");
			}
			console.log(data);
			$('#PFA').load('#PFA');		//Refresh the entire page
		}
	});
};

$(document).ready(function()
{
	RequestGETPFA();
});
