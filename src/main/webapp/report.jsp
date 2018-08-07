<!DOCTYPE HTML>
<html>
  
  <%@include file="head.jsp"%>
  
  <link href="assets/css/main.css" rel="stylesheet" />
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
	
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <link href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.css" rel="stylesheet">
  <link href="assets/css/bootstrap-3.3.7.min.css" rel="stylesheet" />
	<link href="assets/css/datatables-addendum.css" rel="stylesheet" />
	<!--
  <script src="assets/js/jquery-3.3.1.min.js"></script>
	-->
  <script src="assets/js/bootstrap-3.3.7.min.js"></script>
  <script src="assets/js/jquery.dataTables-1.10.16.js"></script>
  <script src="assets/js/datatables-functions.js?v1"></script>
	<script src="assets/js/datatables-plugins.js"></script>
	<script type="text/javascript" src="utils.jsp"></script>
	
	<!-- for pie/line/bubble graphing -->
	<!--
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
	-->
	<script src="assets/js/Chart-2.6.0.min.js"></script>
	<script src="https://unpkg.com/lodash@4.17.10/lodash.min.js"></script>

	<body class="is-preload">

  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1>Report for <span id="customerName"></span></h1>
			</div>
		</section>
		
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
				<li><span id="breadcrumb1"></span></li>
				<li><span id="breadcrumb2">Report</span></li>
			</ul>
		</div>

		<script>
		var customerId=Utils.getParameterByName("customerId");
		
		$(document).ready(function() {
			
			// ### Get Customer Details
			httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
				// ### Populate the header with the Customer Name
				document.getElementById("customerName").innerHTML=customer.CustomerName;
				document.getElementById("breadcrumb1").innerHTML="<a href='assessments-v2.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";
			});
			
		});
		</script>
						
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				
				<h2>Current Landscape</h2>
				<div class="row">
					<div class="col-sm-3">
						<canvas id="gauge-1" style="width:200px;height:110px;"></canvas>
					</div>
					<div class="col-sm-3">
						<canvas id="gauge-2" style="width:200px;height:110px;"></canvas>
					</div>
					<div class="col-sm-3">
						<canvas id="gauge-3" style="width:200px;height:110px;"></canvas>
					</div>
				</div>
				<%@include file="report-summary.jsp"%>
				<script>
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/report", function(report){
						new Chart(document.getElementById("gauge-1"),buildGuage(report.assessmentSummary.Easy,report.assessmentSummary.Total, "rgb(146,212,0)","rgb(220, 220, 220)","Cloud-Native Ready"));
						new Chart(document.getElementById("gauge-2"),buildGuage(report.assessmentSummary.Medium,report.assessmentSummary.Total, "rgb(240,171,0)","rgb(220, 220, 220)","Modernizable"));
						new Chart(document.getElementById("gauge-3"),buildGuage(report.assessmentSummary.Hard,report.assessmentSummary.Total, "rgb(204, 0, 0)","rgb(220, 220, 220)","Unsuitable for Containers"));
						drawRisks(report);
					});
				</script>
				
				<br/><br/><br/>
				
				
				<h2>Identified Risks</h2>
				<div class="row">
					<div class="col-sm-9">
						
						<script>
							function drawRisks(data){
							  var risks=[];
							  if (data.risks!=undefined) risks=data.risks;
							  
						    $('#risks').DataTable( {
						        "data": risks,
						        "oLanguage": { 
						        	sSearch: "",             // remove the "Search" label text
						        	sLengthMenu: "_MENU_"    // remove the "show X entries" text
						        },
						        "scrollCollapse": true,
						        "paging":         false,
						        //"lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
						        "pageLength" : -1, // default page entries
						        "bInfo" : false, // removes "Showing N entries" in the table footer
						        "columns": [
						            { "data": "question" },
						            { "data": "answer" },
						            { "data": "offendingApps" },
							        ],
						        //"columnDefs": [
						        //   { "targets": 0, "orderable": true, "render": function (data,type,row){
						        //      return row['question'];
										//	 }},
						        //   { "targets": 1, "orderable": true, "render": function (data,type,row){
										//	    return row['offendingApps'];
										//	 }},
						        //]
						    } );
						  }
						</script>
						A list of questions with answers that that could cause migratory risk to a container platform.
						
				  	<div id="wrapper">
					    <div id="tableDiv">
						    <table id="risks" class="display" cellspacing="0" width="100%">
						        <thead>
						            <tr>
						                <th align="left">Question</th>
						                <th align="left">Answer</th>
						                <th align="left">Application(s)</th>
						            </tr>
						        </thead>
						    </table>
						  </div>
				  	</div>

					</div>
				</div>
				
				<br/><br/><br/>
				
				
				<h2>Bubble Chart Title</h2>
				<div class="row">
					<div class="col-sm-4">
						<style>
						  /* override the datatables formatting to compress the screen real-estate used */
							input[type=search] {
								height: 23px;
								//width: 100px;
								padding: 0px;
								line-height: 1;
							}
							.dataTables_filter{
								width:150px;
							}
							.dataTables_length label select{
								height: 23px;
								width:  50px;
								padding: 0px;
							}
							.dataTables_wrapper .dataTables_paginate .paginate_button.current, .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover{
								height: 23px;
								padding: 0px !important;
							}
							table.dataTable thead th, table.dataTable thead td{
								padding: 0px 0px !important;
							}
						</style>
						<script>
							//$(document).ready(function() {
							function redrawApplications(applicationAssessmentSummary){
							    $('#appFilter').DataTable( {
							        //"ajax": {
							        //    "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentSummary",
							        //    "data":{"_t":jwtToken},
							        //    "dataSrc": "",
							        //    "dataType": "json"
							        //},
							        "data": applicationAssessmentSummary,
							        "oLanguage": { 
							        	sSearch: "",             // remove the "Search" label text
							        	sLengthMenu: "_MENU_" }, // remove the "show X entries" text
							        "scrollCollapse": true,
							        "paging":         true,
							        "lengthMenu":     [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" :    10, // default page entries
							        "searching" :     true,
							        "bInfo" :         false, // removes "Showing N entries" in the table footer
							        //"order" :         [[1,"desc"],[2,"desc"],[0,"asc"]],
							        "order" :         [[4,"desc"]],
							        "columns": [
							            { "data": "Id" },
							            { "data": "Name" },
							            { "data": "BusinessPriority" },
							            { "data": "WorkPriority" },
							            { "data": "Confidence" },
							            { "data": "Decision" },
							            { "data": "WorkEffort" },
							        ]
							        ,"columnDefs": [
							        		{ "targets": 0, "orderable": false, "render": function (data,type,row){
							              return "<input onclick='onChange2(this);' checked type='checkbox' value='"+row['Id']+"' style='background-color:red;width:10px'/>";
													}},
							        ]
							    } );
							}; 
							//);
						</script>
				  	<div id="wrapper">
					    <div id="buttonbar">
					    </div>
					    <div id="tableDiv">
					    	<style>
					    		#appFilter tr td{
					    			font-size:10pt;
					    		}
					    	</style>
						    <table id="appFilter" class="display" cellspacing="0" width="100%">
					        <thead>
				            <tr>
			                <th align="left"></th>
			                <th align="left" title="Application Name">Application</th>
			                <th align="left" title="Business Criticality">Critical</th>
			                <th align="left" title="Work Priority">Priority</th>
			                <th align="left" title="Confidence">Confidence</th>
			                <th align="left" title="Recommended Action">Action</th>
			                <th align="left" title="Estimated Effort">Effort</th>
				            </tr>
					        </thead>
						    </table>
						  </div>
				  	</div> <!-- dtable wrapper -->
				  	
						<script>
							var appFilter=[];
							function onChange2(t){
								t.checked?appFilter.push(t.value):appFilter.splice(appFilter.indexOf(t.value),1);
								redrawBubble(applicationAssessmentSummary, false);
							}
						</script>
				  	
					</div> <!-- /col-sm-? -->
					
					<div class="col-sm-8">
					<!--
						x=business priority, y=# of dependencies, size=effort, color=Action (REHOST=red, )
						x=business criticality, y=work priority, size=effort, color=Action (REHOST=red, )
					-->
						x=confidence, y=business criticality, size=effort, color=Action (REHOST=red, )
					
						<!--
						bubble chart
						x=biz priority
						y=deps (inbound)
						color?=action
						size=effort
						//transparency=certainty
						-->
						
						<script>
						  var decisionColors=[];
						  // colors got from https://brand.redhat.com/elements/color/
						  decisionColors['REHOST']    ="#92d400"; //green
						  decisionColors['REFACTOR']  ="#f0ab00"; //amber
						  decisionColors['REPLATFORM']="#cc0000"; //red
						  decisionColors['REPURCHASE']="#3B0083"; //purple
						  decisionColors['RETAIN']    ="#A3DBE8"; //light blue
						  decisionColors['RETIRE']    ="#004153"; //dark blue
						  decisionColors['NULL']      ="#808080"; //grey
						  var sizing=[];
						  sizing['0']=10;
						  sizing['SMALL']=20;
						  sizing['MEDIUM']=40;
						  sizing['LARGE']=60;
						  sizing['EXTRA LARGE']=80;
						  var randomNumbers=[];
						  
						  var bubbleChart;
						  
						  function getData(summary){
								var datasets = _.chain(summary)
								.filter(summaryItem => (appFilter.includes(summaryItem.Id)))
								.map(app => {
									return {
										label: app.Name,
										backgroundColor: app.Decision ? decisionColors[app.Decision] : decisionColors.NULL,
										data: [
											{
												x: app.Confidence || 0,
												y: app.BusinessPriority || 0,
												r: sizing[app.WorkEffort || 0]
											}
										]
									}
								 })
								 .value()
								return {datasets}
						  }
						  
						  function getDataOriginal(summary){
						    	
								var datasets=[];
								var i;
								for(i=0;i<summary.length;i++){
									var app=summary[i];
									
									if (!appFilter.includes(app['Id'])) continue;
									
									var dataset={};
									
									var name=app['Name'];
									var businessPriority=app['BusinessPriority'];
									var workPriority=app['WorkPriority'];
									var decision=app['Decision'];
									var workEffort=app['WorkEffort'];
									//var inboundDependencies=5; // TODO: not implemented in the back end yet
									var inboundDependencies=randomNumbers[i]
									var confidence=app['Confidence'];
									
									//TODO: this shouldnt be possible unless the assessment is incomplete
									if (businessPriority==null) businessPriority=0;
									if (workEffort==null) workEffort=0;
									if (confidence==null) confidence=0;
									
									// label
									dataset['label']=[name];
									
									//data points
									dataset['data']=[];
									dataset['data'].push({"x":confidence,"y":businessPriority,"r":sizing[workEffort]});
									
									// color
									if (decision!=null){
										dataset['backgroundColor']=decisionColors[decision];
									}else{
										dataset['backgroundColor']=decisionColors.NULL;
									}
									
									datasets.push(dataset);
								}
								
								var result={datasets};
								console.log(JSON.stringify(datasets));
								return result;
						  }
						  
						  function redrawBubble(summary, initial){
						  	console.log("redraw -> "+initial);
								
								if (!initial){
									bubbleChart.destroy();
								}else{
									// add all apps to begin with
									for(i=0;i<summary.length;i++){
										appFilter.push(summary[i]['Id']);
									}
								}
								
							  var ctx=document.getElementById("bubbleChart").getContext('2d');
								bubbleChart=new Chart(ctx,{
									"type":"bubble",
									"data": 
										getDataOriginal(summary)
									,
									options:{
									  legend: {
									  	display: false,
									  	position: "top"
									  },
									  //legendCallback: function(chart) {
									  //	return "ASDKJHASKHDKADSA";
									  //},
										animation: {
											duration: initial?1000:1 //so when you click a radio they appear quickly, but animate on startup
										},
										aspectRatio: 1,
										scales: {
											yAxes: [{
												gridLines: {
													lineWidth: 1
												},
												display: true,
												ticks: {
													suggestedMin: 1,
													suggestedMax: 10,
													beginAtZero: true
												},
												scaleLabel:{
													display: true,
													labelString: "Business Criticality",
												}
											}],
											xAxes: [{
												display: true,
												ticks: {
													suggestedMin: 1,
													suggestedMax: 100,
													beginAtZero: true
												},
												scaleLabel:{
													display: true,
													labelString: "Confidence",
												}
											}],
										}
									}
								});
								bubbleChart.generateLegend();
								
						  }
						  
							var data;
							var applicationAssessmentSummary;
							httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applicationAssessmentSummary", function(summary){
								applicationAssessmentSummary=summary;
								redrawApplications(applicationAssessmentSummary);
								redrawBubble(applicationAssessmentSummary, true);
								
								//// draw the goldilocks zone
								//var c = document.getElementById("bubbleChart");
								//var ctx = c.getContext("2d");
								//ctx.beginPath();
								//ctx.arc(95, 80, 70, 0, 2 * Math.PI);
								//ctx.stroke();
								
								
							});
							
						</script>
						
						<div id="bubbleLegend" style="float:right;position:relative;top:30px;left:-30px;">
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#92d400;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#333">REHOST</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#f0ab00;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#EEE">REFACTOR</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#cc0000;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#EEE">REPLATFORM</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#3B0083;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#EEE">REPURCHASE</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#A3DBE8;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#333">RETAIN</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#004153;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#EEE">RETIRE</text>
									</svg>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-1">
									<svg height="25" width="200">
									  <rect width="120" height="25" stroke="black" style="fill:#808080;stroke-width:0;stroke:rgb(0,0,0)" />
									  <text x="7" y="17" font-family="Overpass" font-size="13" fill="#EEE">NOT REVIEWED</text>
									</svg>
								</div>
							</div>
						</div>
						
						
						<div class="chartjs-wrapper" style="width:850px;height:600px;">
							<canvas id="bubbleChart" class="chartjs" width="800px" height="500px;"></canvas>
						</div>
   					
					</div> <!-- col-sm-? -->
				</div> <!-- /row -->
<br/><br/><br/>

				
				<h2>Suggested Adoption Plan</h2>
				<div class="row">
					<div class="col-sm-8">
						
						<div style="width: 1000px; height: 100px;">
							<canvas id="adoption" style="width: 500px; height: 100px;"></canvas>
						</div>
						
						<%@include file="report-adoption.jsp"%>
						
					</div>
						
					</div> <!-- col-sm-? -->
				</div> <!-- /row -->
<br/><br/><br/>

<div class="row">
&nbsp;
</div>

			</div>
		</section>

	</body>
	
</html>




						<!--
					  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
					  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
				
						-->
