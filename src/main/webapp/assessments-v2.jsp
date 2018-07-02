<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
  
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
				<h1>Assessment Summary</h1>
				<p>View the summary of assesssment results and review output.</p>
			</div>
		</section>
		
		<%@include file="breadcrumbs.jsp"%>
		<!--
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
				<li><span id="breadcrumb"></span></li>
			</ul>
		</div>
		-->
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<script>
					var customerId=Utils.getParameterByName("customerId");
					var appsCount=assessed=unassessed=notReviewed=reviewed=0;
					
					$(document).ready(function() {
						var done=false;
						
						// ### Get Customer Details
						httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
							// ### Populate the header with the Customer Name
							//document.getElementById("customerName").innerHTML=customer.CustomerName;
							//document.getElementById("breadcrumb").innerHTML=customer.CustomerName;
							
							if (undefined!=setBreadcrumbs){
				        setBreadcrumbs("assessments", customer);
				      }
						});
						
					});
					
				</script>
				
				<div class="row">
					<div class="col-sm-4">
						
						<!-- ### Progress -->
						
						<script src="assets/js/progressbar-kimmobrunfeldt-1.0.0.js"></script>
						<script src="assets/js/progressbar-functions.js"></script>
						<link href="assets/css/progressbar.css" rel="stylesheet" />
						<h2>Progress</h2>
						<div id="assessedProgress" class="progress-bar"></div>
						<div id="reviewedProgress" class="progress-bar"></div>
						
						<center>
							<a href="report.jsp?customerId=<%=request.getParameter("customerId")%>"><button>Generate Report</button></a>
						</center>
						
						<!-- ### Pie Chart Canvas -->
						<div id="piechartAss" style="width: 500px; height: 500px; float: left;"></div>
						
						
						<!-- potentially add pie charts for Decision & Effort? -->
						
						
					</div>
					<div class="col-sm-8">
						<h2>Assessments</h2>
						<!-- #### DATATABLE ### -->
						<script>
							function onDatatableRefresh(json){
								console.log("onDatatableRefresh: apps/assessments.length="+json.length);
								var assessed=reviewed=0;
			          for(var i=0;i<json.length;i++){
			            if (json[i].Assessed) assessed+=1;
			            if (json[i].ReviewDate!=null) reviewed+=1;
			          }
								setProgress("assessedProgress", (100/json.length)*assessed, "Assessed");
								setProgress("reviewedProgress", (100/json.length)*reviewed, "Reviewed");
								buttonEnablement();
							}
							$(document).ready(function() {
								// ### Datatable load (has to be done after customer load because some links require the customer GUID ###
								var dTable=$('#example').DataTable( {
					        "ajax": {
					            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentSummary",
					            "dataSrc": "",
					            "dataType": "json"
					        },
					        "fnInitComplete" : function(oSettings, json){ //unfortunately this method isnt called again on ajax refresh, so we have to push the update to another function that can ben called on both init and refresh events
					        	onDatatableRefresh(json);
					        },
					        "scrollCollapse": true,
					        "paging":         false,
					        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
					        "pageLength" : 10, // default page entries
					        "bInfo" : false, // removes "Showing N entries" in the table footer
					        "searching" : false,
					        "order" : [[2,"desc"],[3,"desc"],[1,"asc"]],  //reviewed, assessed then app name
					        "columns": [
					            { "data": "Id" },
					            { "data": "Name" },
					            { "data": "Assessed" },
					            { "data": "ReviewDate" },
					            { "data": "BusinessPriority" },
					            { "data": "Decision" },
					            { "data": "WorkEffort" },
					            { "data": "ReviewDate" },
					            { "data": "LatestAssessmentId" }
					        ]
					        ,"columnDefs": [
					        		{ "targets": 0, "orderable": false, "render": function (data,type,row){
					              return "<input type='checkbox' name='appId' value='"+row['Id']+"'></input><input type='hidden' name='"+row['Id']+"_name' value='"+row['Name']+"'></input>";
											}},
					        		{ "targets": 1, "orderable": true, "render": function (data,type,row){
					              return "<a href='viewAssessment.jsp?app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'>"+row["Name"]+"</a>";
											}},
					        		{ "targets": 2, "orderable": true, "render": function (data,type,row){
					              return "<span class='"+(row["Assessed"]==true?"messageGreen'>Yes":"messageRed'><a href='survey-v2.jsp?customerId="+customerId+"&applicationId="+row['Id']+"'>No</a>")+"</span>";
											}},
											{ "targets": 3, "orderable": true, "render": function (data,type,row){
												if (row["ReviewDate"]==null && row["Assessed"]==true){
												  return "<a href='viewAssessment.jsp?review=true&app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'><img height='24px' src='images/review.png'></a>";
												}else if (row["ReviewDate"]==null){
													return "";
												}else{
													return "Yes";
												}
											}},
											{ "targets": 5, "orderable": true, "render": function (data,type,row){
					              return row['Decision']==null?"":row['Decision']; 
											}},
											{ "targets": 6, "orderable": true, "render": function (data,type,row){
					              return row['WorkEffort']==null?"":row['WorkEffort'];
											}},
						          { "targets": 8, "orderable": false, "render": function (data,type,row){
					            	return row["Assessed"]!=true?"":"<a href='viewAssessment.jsp?app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'><img src='images/details.png'/></a>";
											}}
					        ]
						    });
						    
						    // ### END Datatable load

							} );
							
							
							// ### Model form functions ###
							
							function form_save(formId, saveUrl){
							  var data = {};
							  var op="";
							  var form=document.getElementById(formId);
							  for (var i = 0, ii = form.length; i < ii; ++i) {
							    if (form[i].name) data[form[i].name]=form[i].value;
							  }
							  
							  
							  var apps=$('#clone_newAppNames').val();
							  console.log("apps="+apps);
							  
							  post(saveUrl, apps.split("\n"));
							  form_reset();
							}
							
							function form_reset(){
						    document.getElementById("modal-ok").innerHTML="Create";
						    document.getElementById("modalLabel").innerHTML=document.getElementById("modalLabel").innerHTML.replace("Update", "New");
						    var form=$('#form').get();
						    for (var i = 0, ii = form.length; i < ii; ++i)
						      form[i].value="";
							}
							
							function showCloneDialog(caller){
								$('#example input[name="appId"]').each(function() {
									if ($(this).is(":checked")) {
										
										// set properties
									  $('#clone_appId').val($(this).val());
									  $('#clone_appName').val($("input[name='"+$(this).val()+"_name']").val());
									  
										caller.disabled=true;
										
									  // show form
										$('#clone_formDialog').modal();
									}
								});
							}
							function btnDelete_onclick(caller){
								if (!confirm("Are you sure? This will remove all associated assessments and reviews.")){
										return false;
								}else{
								  var appIdsToDelete=[];
									$('#example input[name="appId"]').each(function() {
										if ($(this).is(":checked")) {
										  appIdsToDelete[appIdsToDelete.length]=$(this).val();
											//deleteApp(caller, $(this).val());
										}
									});
									//deleteApps(caller, appIdsToDelete);
									
									caller.disabled=true;
									var url=Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applications/";
									console.log("DELETE APPS: "+url+" ["+appIdsToDelete+"]");
									httpDelete(url, appIdsToDelete);
									
								}
							}
							
							
							// ### enable/disable handlers for buttons on buttonbar
							$(document).on('click', "input[type=checkbox]", function() {
								buttonEnablement();
							});
							buttonEnablement();
							function buttonEnablement(){
							  enabledIf($('button[name="btnCloneApps"]'),  $('#example input[name="appId"]:checked').length==1);
							  enabledIf($('button[name="btnRemoveApps"]'), $('#example input[name="appId"]:checked').length>0);
							}
							function enabledIf(jqueryObj, condition){
								jqueryObj.attr("disabled", !condition);
							}
							// ### End: enable/disable handlers for buttons on buttonbar
							
							
						</script>
				  	<div id="wrapper">
					    <div id="buttonbar" style="position:relative;top:0px;width:100%;">
					    	<button style="position:relative;height:30px;width:125px;left:0px;top:0px;" class="btn" name="New"                        onclick="editFormReset();" type="button" data-toggle="modal" data-target="#exampleModal" data-whatever="@new">Add Application</button>
					    	<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="btnRemoveApps"     disabled onclick="btnDelete_onclick(this);" type="button">Remove Application(s)</button>
					    	<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="removeAssessments" disabled onclick="" type="button">Clear Assessment(s)</button>
					    	<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="removeReviews"     disabled onclick="" type="button">Clear Review(s)</button>
					    	<button style="position:relative;height:30px;width:165px;left:0px;top:0px;" class="btn" name="btnCloneApps"      disabled onclick="showCloneDialog(this);" type="button">Clone Applications(s)</button>
					    </div>
					    <div id="tableDiv">
						    <table id="example" class="display" cellspacing="0" width="100%">
					        <thead>
				            <tr>
			                <th align="left"></th>
			                <th align="left">Application</th>
			                <th align="left">Assessed</th>
			                <th align="left">Review</th>
			                <th align="left">Business Priority</th>
			                <th align="left">Decision</th>
			                <th align="left">Effort</th>
			                <th align="left">Review Date</th>
			                <th align="left"></th>
				            </tr>
					        </thead>
						    </table>
						  </div>
				  	</div>
				  	
					</div>
				</div>
				
				
				
				<div class="highlights">
				</div>
			</div>
		</section>
		
		<%@include file="newApplicationForm.jsp"%>
		
		
		
		<!-- ################ CLONE APP FORM #################-->
<div class="modal fade" id="clone_formDialog" tabindex="-1" role="dialog" aria-labelledby="modalLabel">
  <div class="modal-dialog" role="document"> <!-- make wider by adding " modal-lg" to class -->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modalLabel">New Application</h4>
      </div>
      <div class="modal-body">
        <form id="clone_form">
        	<!-- ### Hidden ID field -->
        	<!--
        	<div id="form-id" class="form-group" style="display:none">
            <label for="Id" class="control-label">Customer Name:</label>
            <input id="Id" name="Id" type="text" class="form-control"/>
          </div>
          -->
          
          <input id="clone_appId" name="clone_appId" type="hidden">

          <div class="form-group">
            <label for="clone_appName" class="control-label">Application to Clone:</label>
            <input id="clone_appName" name="clone_appName" type="text" class="form-control">
          </div>
          <div class="form-group">
            <label for="clone_newAppNames" class="control-label">New Application Names (new line separated):</label>
            <textarea id="clone_newAppNames" name="clone_newAppNames" class="form-control"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button id="modal-ok" type="button" data-dismiss="modal" onclick="form_save('clone_form', Utils.SERVER+'/api/pathfinder/customers/'+customerId+'/applications/'+document.getElementById('clone_appId').value+'/copy'); return false;">Create</button>
        
        
        
      </div>
    </div>
  </div>
</div>
	</body>
</html>



