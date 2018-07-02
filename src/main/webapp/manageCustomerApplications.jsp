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
			function deleteItem(custId, appId){
			  httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+custId+"/applications/"+appId);
			}
			$(document).ready(function() {
					// ### Populate the breadcrumb customer names
					var customerId=Utils.getParameterByName("customerId");
				  var xhr = new XMLHttpRequest();
				  var url=Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId");
				  xhr.open("GET", url, true);
			    xhr.send();
					xhr.onloadend = function () {
					  var customer=JSON.parse(xhr.responseText);
				    //document.getElementById("breadcrumb").innerHTML=customer.CustomerName;
				    
				    if (undefined!=setBreadcrumbs){
				      setBreadcrumbs("applications", customer);
				    }
				    
				  };
					// ### populate the customer applications in the datatable
			    $('#example').DataTable( {
			        "ajax": {
			            //"url": '${pageContext.request.contextPath}/api/pathfinder/customers/"+request.getParameter("customerId")+"/applications/',
			            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+'/applications/',
			            "dataSrc": "",
			            "dataType": "json"
			        },
			        "scrollCollapse": true,
			        "paging":         false,
			        
			        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
			        "pageLength" : 10, // default page entries
			        "bInfo" : false, // removes "Showing N entries" in the table footer
			        "columns": [
			            { "data": "Name" },
			            { "data": "Description" },
			            { "data": "Id" },
			            { "data": "Id" },
			        ]
			        ,"columnDefs": [
				      	 { "targets": 2, "orderable": false, "render": function (data,type,row){
									return "<div class='btn btn-image btn-edit' title='Edit' onclick='loadEntity(\""+row["Id"]+"\");' data-toggle='modal' data-target='#exampleModal'></div>";
								}}
			        	,{ "targets": 3, "orderable": false, "render": function (data,type,row){
									return "<div class='btn btn-image btn-delete' title='Delete' onclick='deleteItem(\""+customerId+"\",\""+row["Id"]+"\");'></div>";
								}}
			        ]
			    } );
			} );
		</script>
    	<div id="wrapper">
		    <div id="buttonbar">
	        <button style="position:relative;height:30px;width:75px;left:0px;top:0px;" class="btn" name="New"    onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">New</button>
		    </div>
		    <div id="tableDiv">
			    <table id="example" class="display" cellspacing="0" width="100%">
			        <thead>
			            <tr>
			                <th align="left">Application Name</th>
			                <th align="left">Application Description</th>
			                <th align="left">Edit</th>
			                <th align="left">Delete</th>
			            </tr>
			        </thead>
			    </table>
			  </div>
    </div>
    

		<%@include file="newApplicationForm.jsp"%>

	</body>
</html>