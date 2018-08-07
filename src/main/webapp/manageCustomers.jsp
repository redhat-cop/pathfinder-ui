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
			//function load(id){
			//  document.getElementById("edit-ok").innerHTML="Update";
			//  document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("New", "Update");
			//  var xhr = new XMLHttpRequest();
			//  var ctx = "${pageContext.request.contextPath}";
			//  xhr.open("GET", addAuthToken(getLoadUrl(id)), true);
			//  xhr.send();
			//  xhr.onloadend = function () {
			//    var json=JSON.parse(xhr.responseText);
			//    var form=document.getElementById("form");
			//    for (var i = 0, ii = form.length; i < ii; ++i) {
			//      if (typeof json[form[i].name] == "undefined"){
			//        form[i].value="";
			//      }else{
			//        form[i].value=json[form[i].name];
			//      }
			//    }
			//  }
			//}
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
							      var link="<a href='assessments-v2.jsp?customerId="+row["CustomerId"]+"'>"+row['CustomerName']+"</a>";
							      return link+"&nbsp;<span class='editLink'>(<a href='#' onclick='loadEntity(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>edit</a>)</span>";
			              //return "<a href='#' onclick='loadEntity(\""+row["CustomerId"]+"\");' data-toggle='modal' data-target='#exampleModal'>"+row["CustomerName"]+"</a>";
								 }},
								 { "targets": 3, "orderable": false, "render": function (data,type,row){
								    return "";//<a href='report.jsp?customerId="+row["CustomerId"]+"'>Report</a>";
								 }},
								 { "targets": 4, "orderable": false, "render": function (data,type,row){
							     var percentComplete=row['CustomerPercentageComplete'];
							     var link="<a href='assessments-v2.jsp?customerId="+row["CustomerId"]+"'>Assessments&nbsp;("+percentComplete+"%)</a>";
							     return "<div class='progress'><div class='progress-bar-success' role='progressbar' aria-valuenow='"+percentComplete+"' aria-valuemin='0' aria-valuemax='100' style='width:"+percentComplete+"%'>"+link+"</div></div>";
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
				<div class="row">
					<div class="col-xs-6">
						<button class="btn btn-primary" name="New" onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
						<button class="btn btn-danger" name="btnDelete" disabled onclick="btnDelete_onclick(this);" type="button">Remove Customers(s)</button>
					</div>
				</div>
	    </div>
	    <div id="tableDiv">
		    <table id="example" class="display" cellspacing="0" width="100%">
		        <thead>
		            <tr>
		                <th align="left"></th>
		                <th align="left">Customer Name</th>
		                <th align="left">Customer Description</th>
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
    

		<%@include file="newCustomerForm.jsp"%>

	</body>
</html>