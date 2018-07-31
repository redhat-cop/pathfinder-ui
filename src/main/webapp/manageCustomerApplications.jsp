<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
	
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
  
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <!-- Firefox doesnt support link imports yet
  <link rel="import" href="datatables-dependencies.jsp">
  -->
  <%@include file="datatables-dependencies.jsp"%>

  <!-- #### DATATABLES ### -->
  
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1>Pathfinder Admin</h1>
				<p>Create customers and applications.</div>
		</section>
		
		<%@include file="breadcrumbs.jsp"%>
  	
  	
  	<!-- #### DATATABLES ### -->
		<script>
			var customerId=Utils.getParameterByName("customerId");
			function deleteItem(custId, appId){
			  httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+custId+"/applications/"+appId);
			}
			function onDatatableRefresh(json){
				buttonEnablement();
			}
			$(document).ready(function() {
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						if (undefined!=setBreadcrumbs) setBreadcrumbs("applications", customer);
					});
					
					// ### populate the customer applications in the datatable
			    $('#example').DataTable( {
			        "ajax": {
			            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/"+request.getParameter("customerId")+"/applications/',
			            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+'/applications/',
			            "data":{"_t":jwtToken},
			            "dataSrc": "",
			            "dataType": "json"
			        },
			        "scrollCollapse": true,
			        "paging":         false,
			        
			        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
			        "pageLength" : 10, // default page entries
			        "bInfo" : false, // removes "Showing N entries" in the table footer
			        "order" : [[1,"asc"]],
			        "columns": [
			            { "data": "Id" },
			            { "data": "Name" },
			            { "data": "Description" },
			        ]
			        ,"columnDefs": [
			        	{ "targets": 0, "orderable": false, "render": function (data,type,row){
									return "<input type='checkbox' name='id' value='"+row['Id']+"'></input>";
								}},
				      	{ "targets": 1, "orderable": true, "render": function (data,type,row){
									return "<a href='#' onclick='loadEntity(\""+row["Id"]+"\"); return false;' data-toggle='modal' data-target='#exampleModal'>"+row['Name']+"</a>";
								}},
			        ]
			    } );
			} );
			
			// ### enable/disable handlers for buttons on datatable buttonbar
			$(document).on('click', "input[type=checkbox]", function() {
				buttonEnablement();
			});
			buttonEnablement();
			function buttonEnablement(){
			  $('button[name="btnRemove"]').attr('disabled', $('#example input[name="id"]:checked').length<1);
			}
			// ### End: enable/disable handlers for buttons on buttonbar
			
			function btnDelete_onclick(caller){
				if (!confirm("Are you sure? This will also remove any associated assessments and/or reviews for the selected application(s).")){
						return false;
				}else{
				  var idsToDelete=[];
					$('#example input[name="id"]').each(function() {
						if ($(this).is(":checked")) {
						  idsToDelete[idsToDelete.length]=$(this).val();
						}
					});
					
					caller.disabled=true;
					httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId")+"/applications/", idsToDelete);
				}
			}

		</script>
    	<div id="wrapper">
		    <div id="buttonbar">
	        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;"  class="btn" name="New"    onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
					<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="btnRemove"     disabled onclick="btnDelete_onclick(this);" type="button">Remove Application(s)</button>
		    </div>
		    <div id="tableDiv">
			    <table id="example" class="display" cellspacing="0" width="100%">
			        <thead>
			            <tr>
			                <th align="left"></th>
			                <th align="left">Application Name</th>
			                <th align="left">Description</th>
			                <!--th align="left">Edit</th-->
			                <!--th align="left">Delete</th-->
			            </tr>
			        </thead>
			    </table>
			  </div>
    </div>
    

		<%@include file="newApplicationForm.jsp"%>

	</body>
</html>