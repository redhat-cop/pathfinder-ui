<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
  
  <link href="assets/css/main.css" rel="stylesheet" />
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
	
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <!-- Firefox doesnt support link imports yet
  <link rel="import" href="datatables-dependencies.jsp">
  -->
  <%@include file="datatables-dependencies.jsp"%>
  
	<!--
  <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.css" rel="stylesheet">
  <link href="assets/css/bootstrap-3.3.7.min.css" rel="stylesheet" />
	<link href="assets/css/datatables-addendum.css" rel="stylesheet" />
  <script src="assets/js/jquery-3.3.1.min.js"></script>
  <script src="assets/js/bootstrap-3.3.7.min.js"></script>
  <script src="assets/js/jquery.dataTables-1.10.16.js"></script>
  <script src="datatables-functions.js"></script>
	<script src="datatables-plugins.js"></script>
	-->
	
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1><span id="customerName"></span> Assessment Summary</h1>
				<p>View the results of an assessment and review output.</p>
			</div>
		</section>
		
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
				<li><span id="breadcrumb"></span> Assessments</li>
			</ul>
		</div>
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<script>
					var customerId=Utils.getParameterByName("customerId");
					//var customerGuid;
					var appsCount=assessed=unassessed=notReviewed=reviewed=0;
					
					$(document).ready(function() {
						var done=false;
						
						// ### Get Customer Details
						httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
							// ### Populate the header with the Customer Name
							document.getElementById("customerName").innerHTML=customer.CustomerName;
							document.getElementById("breadcrumb").innerHTML=customer.CustomerName;
							//customerGuid=customer.CustomerId;
						});
						
						// ### Populate the progress bar
						httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentProgress", function(progress){
						  //console.log("app.count="+progress.Appcount+", assessed="+progress.Assessed+", reviewed="+progress.Reviewed);
						  progress.Appcount=progress.Appcount.toString();
						  progress.Assessed=progress.Assessed.toString();
						  progress.Reviewed=progress.Reviewed.toString();
						  if (progress.Appcount == progress.Assessed && progress.Appcount == progress.Reviewed) {
								console.log("App Count is the same as assessed");			
								document.getElementById("allDone").innerHTML="<img src=images/ok-48.png>";		  
						  }
						  $('#jqmeter-assessed').jQMeter({goal:progress.Appcount,raised:progress.Assessed,width:'290px',height:'40px',bgColor:'#dadada',barColor:'#9b9793',animationSpeed:100,displayTotal:true});
						  $('#jqmeter-reviewed').jQMeter({goal:progress.Appcount,raised:progress.Reviewed,width:'290px',height:'40px',bgColor:'#dadada',barColor:'#9b9793',animationSpeed:100,displayTotal:true});
							
						});
						
						
						
						
						
					});
				
				</script>
				
				<div class="row">
					<div class="col-sm-4">
						
						<!-- ### Progress -->
						
						<script src="assets/js/jqmeter.min.js"></script>
						Assessed
						<div id="jqmeter-assessed"></div>
						Reviewed
						<div id="jqmeter-reviewed"></div>
						<style>
							.therm{height:30px;border-radius:5px;}
							.outer-therm{margin:20px 0;}
							.inner-therm span {color: #fff;display: inline-block;float: right;font-family: Overpass;font-size: 14px;font-weight: bold;}
							.vertical.inner-therm span{width:100%;text-align:center;}
							.vertical.outer-therm{position:relative;}
							.vertical.inner-therm{position:absolute;bottom:0;}
						</style>
						<div id="allDone"></div>
						<a href="report.jsp?customerId=<%=request.getParameter("customerId")%>"><button>Report</button></a>
						
						
						<!-- ### Pie Chart Canvas -->
						<div id="piechartAss" style="width: 500px; height: 500px; float: left;"></div>
					</div>
					<div class="col-sm-8">
						<h2>Assessments</h2>
						<!-- #### DATATABLE ### -->
						<script>
							$(document).ready(function() {
								// ### Datatable load (has to be done after customer load because some links require the customer GUID ###
								$('#example').DataTable( {
					        "ajax": {
					            //"url": 'http://localhost:8083/pathfinder-ui/api/pathfinder/customers/'+customerId+"/assessmentSummary",
					            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentSummary",
					            "dataSrc": "",
					            "dataType": "json"
					        },
					        "scrollCollapse": true,
					        "paging":         false,
					        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
					        "pageLength" : 10, // default page entries
					        "searching" : false,
					        "order" : [[1,"desc"],[2,"desc"],[0,"asc"]],  //reviewed, assessed then app name
					        "columns": [
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
					        		{ "targets": 0, "orderable": true, "render": function (data,type,row){
					              return "<a href='viewAssessment.jsp?app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'>"+row["Name"]+"</a>";
											}},
					        		{ "targets": 1, "orderable": true, "render": function (data,type,row){
					              return "<span class='"+(row["Assessed"]==true?"messageGreen'>Yes":"messageRed'><a href='survey.jsp?customerId="+customerId+"&applicationId="+row['Id']+"'>No</a>")+"</span>";
											}},
											{ "targets": 2, "orderable": true, "render": function (data,type,row){
												if (row["ReviewDate"]==null && row["Assessed"]==true){
												  return "<a href='viewAssessment.jsp?review=true&app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'><img height='24px' src='images/review.png'></a>";
												}else if (row["ReviewDate"]==null){
													return "No";
												}else{
													return "Yes";
												}
											}},
											{ "targets": 4, "orderable": true, "render": function (data,type,row){
					              return row['Decision']==null?"":row['Decision']; 
											}},
											{ "targets": 5, "orderable": true, "render": function (data,type,row){
					              return row['WorkEffort']==null?"":row['WorkEffort'];
											}},
						            { "targets": 7, "orderable": false, "render": function (data,type,row){
					            	return row["Assessed"]!=true?"":"<a href='viewAssessment.jsp?app="+row['Id']+"&assessment="+row['LatestAssessmentId']+"&customer="+customerId+"'><img src='images/details.png'/></a>";
											}}
					        ]
						    });
						    // ### END Datatable load

							} );
						</script>
				  	<div id="wrapper">
					    <div id="buttonbar">
					    </div>
					    <div id="tableDiv">
						    <table id="example" class="display" cellspacing="0" width="100%">
					        <thead>
				            <tr>
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
		
	</body>
</html>



