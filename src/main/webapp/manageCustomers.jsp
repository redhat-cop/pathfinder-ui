<!DOCTYPE HTML>
<html>
  <%@include file="head.jsp"%>
  <!--
  <link rel="import" href="head.jsp">
  <link rel="import" href="nav.jsp">
  -->
	
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
  
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <!-- Firefox doesnt support link imports yet
  <link rel="import" href="datatables-dependencies.jsp">
  -->
  <%@include file="datatables-dependencies.jsp"%>
	
	<body class="is-preload">
		<%@include file="nav.jsp"%>
		
		<section id="banner2">
			<div class="inner">
				<h1>Pathfinder Admin</h1>
				<p>Create customers and applications.</div>
		</section>
		
		<!--
		<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
			</ul>
		</div>
		-->
		
		<!-- #### DATATABLES ### -->
		<script>
			
			// mat - move this to the edit form script, this is not datatable code
			function load(id){
			  document.getElementById("edit-ok").innerHTML="Update";
			  document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("New", "Update");
			  var xhr = new XMLHttpRequest();
			  var ctx = "${pageContext.request.contextPath}";
			  xhr.open("GET", addAuthToken(getLoadUrl(id)), true);
			  xhr.send();
			  xhr.onloadend = function () {
			    var json=JSON.parse(xhr.responseText);
			    var form=document.getElementById("form");
			    for (var i = 0, ii = form.length; i < ii; ++i) {
			      if (typeof json[form[i].name] == "undefined"){
			        form[i].value="";
			      }else{
			        form[i].value=json[form[i].name];
			      }
			    }
			  }
			}
			function onDatatableRefresh(json){
				buttonEnablement();
			}
			
			$(document).ready(function() {
			    $('#example').DataTable( {
			        "ajax": {
			            "url": Utils.SERVER+'/api/pathfinder/customers/',
			            //"beforeSend": function(xhr){
					        //    xhr.setRequestHeader(jwtToken);
					        //},
					        "data":{"_t":jwtToken},
			            "dataSrc": "",
			            "dataType": "json"
			        },
			        "scrollCollapse": true,
			        "paging":         false,
			        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
			        "pageLength" : 10, // default page entries
			        "bInfo" : false, // removes "Showing N entries" in the table footer
			        "columns": [
			            { "data": "CustomerId" },
			            { "data": "CustomerName" },
			            { "data": "CustomerDescription" },
			            { "data": "CustomerId" },
			            { "data": "CustomerPercentageComplete" },
			            { "data": "CustomerId" },
			            { "data": "CustomerId" },
				        ]
			        ,"columnDefs": [
			           { "targets": 0, "orderable": true, "render": function (data,type,row){
			              return "<input type='checkbox' name='id' value='"+row['CustomerId']+"'></input>";
								 }},
			           { "targets": 1, "orderable": true, "render": function (data,type,row){
			              return "<a href='#' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>"+row["CustomerName"]+"</a>";
								 }},
								 { "targets": 3, "orderable": false, "render": function (data,type,row){
								    return "";//<a href='report.jsp?customerId="+row["CustomerId"]+"'>Report</a>";
								 }},
								 { "targets": 4, "orderable": false, "render": function (data,type,row){
							     var percentComplete=row['CustomerPercentageComplete'];
							     var link="<a href='assessments-v2.jsp?customerId="+row["CustomerId"]+"'>Assessments&nbsp;("+percentComplete+"%)</a>";
							     return "<div class='progress'><div class='progress-bar-success' role='progressbar' aria-valuenow='"+percentComplete+"' aria-valuemin='0' aria-valuemax='100' style='width:"+percentComplete+"%'><center>"+link+"</center></div></div>";
								 }},
			           { "targets": 5, "orderable": false, "render": function (data,type,row){
								    return "<a href='manageCustomerApplications.jsp?customerId="+row["CustomerId"]+"'>Applications ("+row['CustomerAppCount']+")</a>";
								 }},
			           { "targets": 6, "orderable": false, "render": function (data,type,row){
								    return "<a href='members.jsp?customerId="+row["CustomerId"]+"'>Members ("+row['CustomerMemberCount']+")</a>";
								 }}
				         //,{ "targets": 6, "orderable": false, "render": function (data,type,row){
								 //   return "<div class='btn-image btn btn-edit' title='Edit' onclick='load(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'></div>";
								 // }}
				         //,{ "targets": 7, "orderable": false, "render": function (data,type,row){
								 //   return "<div class='btn-image btn btn-delete' title='Delete' onclick='return deleteItem(\""+row["CustomerId"]+"\");'></div>";
								 // }}
			        ]
			    } );
			} );
			
			// ### enable/disable handlers for buttons on datatable buttonbar
			$(document).on('click', "input[type=checkbox]", function() {
				buttonEnablement();
			});
			buttonEnablement();
			function buttonEnablement(){
			  $('button[name="btnDelete"]').attr('disabled', $('#example input[name="id"]:checked').length<1);
			}
			// ### End: enable/disable handlers for buttons on buttonbar
			
			function btnDelete_onclick(caller){
				if (!confirm("Are you sure? This will also remove any applications, assessments and/or associated reviews for the selected customers(s).")){
						return false;
				}else{
				  var idsToDelete=[];
					$('#example input[name="id"]').each(function() {
						if ($(this).is(":checked")) {
						  idsToDelete[idsToDelete.length]=$(this).val();
						}
					});
					
					caller.disabled=true;
					httpDelete(Utils.SERVER+"/api/pathfinder/customers/", idsToDelete);
				}
			}
		</script>
  	<div id="wrapper">
	    <div id="buttonbar">
	        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"  class="btn" name="New"       onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
					<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="btnDelete" disabled onclick="btnDelete_onclick(this);" type="button">Remove Customers(s)</button>
	    </div>
	    <div id="tableDiv">
		    <table id="example" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		                <th align="left"></th>
		                <th align="left">Customer Name</th>
		                <th align="left">Customer Details</th>
		                <th align="left"></th>
		                <th align="left"></th>
		                <th align="left"></th>
		                <th align="left"></th>
		                <!--
		                <th align="left">Edit</th>
		                <th align="left">Delete</th>
		                -->
		            </tr>
		        </thead>
		    </table>
		  </div>
  	</div>
    



<!--#################-->
<!-- EDIT MODAL FORM -->
<!--#################-->

<script>
	function getLoadUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/"+id+"/";
	}
	function getSaveUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/";
	}
	function getIdFieldName(){
		return "CustomerId";
	}
</script>



<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document"> <!-- make wider by adding " modal-lg" to class -->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">New Customer</h4>
      </div>
      <div class="modal-body">
        <form id="form">
        	<!-- ### Hidden ID field -->
        	<div id="form-id" class="form-group" style="display:none">
            <label for="CustomerId" class="control-label">Customer Name:</label>
            <input id="CustomerId" name="CustomerId" type="text" class="form-control"/>
          </div>
          
          <div id="form-id" class="form-group">
            <label for="CustomerName" class="control-label">Customer Name:</label>
            <input id="CustomerName" name="CustomerName" type="text" class="form-control"/>
          </div>
          <div class="form-group">
            <label for="CustomerDescription" class="control-label">Customer Description:</label>
            <input id="CustomerDescription" name="CustomerDescription" type="text" class="form-control">
          </div>
          <div class="form-group">
            <label for="CustomerVertical" class="control-label">Customer Vertical:</label>
            <select name="CustomerVertical" id="CustomerVertical" class="form-control">
							<option value="Agriculture">Agriculture</option>
							<option value="Business Services">Business Services</option>
							<option value="Construction & Real Estate">Construction & Real Estate</option>
							<option value="Education">Education</option>
							<option value="Energy, Raw Materials & Utilities">Energy, Raw Materials & Utilities</option>
							<option value="Finance">Finance</option>
							<option value="Government">Government</option>
							<option value="Healthcare">Healthcare</option>
							<option value="IT">IT</option>
							<option value="Leisure & Hospitality">Leisure & Hospitality</option>
							<option value="Libraries">Libraries</option>
							<option value="Manufacturing">Manufacturing</option>
							<option value="Media & Internet">Media & Internet</option>
							<option value="Non-Profit & Professional Orgs.">Non-Profit & Professional Orgs.</option>
							<option value="Retail">Retail</option>
							<option value="Software">Software</option>
							<option value="Telecommunications">Telecommunications</option>
							<option value="Transportation">Transportation</option>
						</select>
          </div>
          <div class="form-group">
            <label for="CustomerAssessor" class="control-label">Customer Assessor:</label>
            <input id="CustomerAssessor" name="CustomerAssessor" type="text" class="form-control">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button id="edit-ok" type="button" data-dismiss="modal" onclick="save('form'); return false;">Create</button>
      </div>
    </div>
  </div>
</div>

	</body>
</html>