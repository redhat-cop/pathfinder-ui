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
	-->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>

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
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
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
				
				
				<div class="row">
					<div class="col-sm-4">
					<!--
						apps list in draggable checkboxed list
					-->
						
						<h2>Applications</h2>
						
						<script>
							$(document).ready(function() {
							    $('#example').DataTable( {
							        "ajax": {
							            "url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applicationAssessmentSummary",
							            "data":{"_t":jwtToken},
							            "dataSrc": "",
							            "dataType": "json"
							        },
							        "scrollCollapse": true,
							        "paging":         true,
							        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" : 10, // default page entries
							        "searching" : false,
							        //"order" : [[1,"desc"],[2,"desc"],[0,"asc"]],  //reviewed, assessed then app name
							        "columns": [
							            { "data": "Id" },
							            { "data": "Name" },
							            { "data": "BusinessPriority" },
							            { "data": "Decision" },
							            { "data": "WorkEffort" },
							        ]
							        ,"columnDefs": [
							        		{ "targets": 0, "orderable": true, "render": function (data,type,row){
							              return "<input type='checkbox' value='"+row['Id']+"' style='background-color:red;width:10px'/>";
													}},
													{ "targets": 3, "orderable": true, "render": function (data,type,row){
							              return row['Decision']==null?"":row['Decision'];
													}},
													{ "targets": 4, "orderable": true, "render": function (data,type,row){
							              return row['WorkEffort']==null?"":row['WorkEffort'];
													}}
							        ]
							    } );
							} );
						</script>
				  	<div id="wrapper">
					    <div id="buttonbar">
					    </div>
					    <div id="tableDiv">
						    <table id="example" class="display" cellspacing="0" width="100%">
					        <thead>
				            <tr>
			                <th align="left"></th>
			                <th align="left">Application</th>
			                <th align="left">Business Priority</th>
			                <th align="left">Decision</th>
			                <th align="left">Effort</th>
				            </tr>
					        </thead>
						    </table>
						  </div>
				  	</div>

<div id="dialog" title="Dependency Map">
<div id="mynetwork"></div>							
</div>
 
<button id="opener">Open Dependency Map</button>						
<script>
$(document).ready(function(){
    $("table tbody").sortable({
        items: 'tr',
        stop : function(event, ui){
          //alert($(this).sortable('toArray'));
        }
    });
  //$("table tbody").disableSelection();
});//ready
</script>
						<!--
						-->
					  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
					  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
				<div class="row">						

						</div>
						

					</div>
					<div class="col-sm-8">
						<h2>Priority Analysis</h2>
						x=business priority, y=# of dependencies, size=effort, color=Action (REHOST=red, )
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
						  decisionColors['REHOST']    ="#cc0000"; //red
						  decisionColors['REFACTOR']  ="#004153"; //dark blue
						  decisionColors['REPLATFORM']="#A3DBE8"; //light blue 
						  decisionColors['REPURCHASE']="#3B0083"; //purple
						  decisionColors['RETAIN']    ="#92d400"; //green
						  decisionColors['RETIRE']    ="#f0ab00"; //amber
						  decisionColors['NULL']      ="#808080"; //grey
						  var sizing=[];
						  sizing['0']=0;
						  sizing['SMALL']=60;
						  sizing['MEDIUM']=40;
						  sizing['LARGE']=20;
						  sizing['EXTRA LARGE']=10;
						  
							var data;
							httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applicationAssessmentSummary", function(customer){
								var label=[];
								var innerData=[];
								var backgroundColor=[];
								data={};
								//data={label:[],data:[],backgroundColor:[]};
								
								//console.log("customer="+JSON.stringify(customer));
								var i;
								for(i=0;i<customer.length;i++){
									var app=customer[i];
									
									var name=app['Name'];
									var businessPriority=app['BusinessPriority'];
									var decision=app['Decision'];
									var workEffort=app['WorkEffort'];
									//var inboundDependencies=5; // TODO: not implemented in the back end yet
									var inboundDependencies=Math.floor(Math.random() * 10) + 0;
									
									//TODO: this shouldnt be possible unless the assessment is incomplete
									if (businessPriority==null) businessPriority=0;
									if (workEffort==null) workEffort=0;
									
									label.push({name});
									if (decision!=null){
										backgroundColor.push(decisionColors[decision]);
									}else{
										backgroundColor.push(decisionColors.NULL);
									}
									// {"x":1,"y":8,"r":10}
									//console.log(workEffort);
									innerData.push({"x":businessPriority,"y":inboundDependencies,"r":sizing[workEffort]})
									
								}
								data['label']=label;
								data['backgroundColor']=backgroundColor;
								data['data']=innerData;
								
								//console.log("data="+JSON.stringify(data));
								
								new Chart(document.getElementById("chartjs-6"),{
									"type":"bubble",
									"data": {"datasets":[
										data
									]},
									options:{
										aspectRatio: 1,
			legend: false,
			tooltips: false,
									}
								});
							});
							
						</script>
						
						<div class="chartjs-wrapper">
							<canvas id="chartjs-6" class="chartjs" width="undefined" height="undefined"></canvas>
							<script>
//								new Chart(document.getElementById("chartjs-6"),{
//									"type":"bubble",
//									"data": {"datasets":[
//data
//]}
//
////									{
////										"datasets":[{
////											"label":[
////												 "App1"
////												,"App2"
////												,"App3"
////												],
////											"data":[
////												 {"x":1,"y":8,"r":10}
////												,{"x":8,"y":0,"r":30}
////												,{"x":4,"y":2,"r":20}
////											],
////											"backgroundColor":[
////												Utils.chartColors.RED,
////												Utils.chartColors.AMBER,
////												Utils.chartColors.GREEN,
////											]
////										}]
////									}
//									,options: {
//										scales: {
//											xAxes: [{
//				                ticks: {
//								          "ticks.min": "0",
//								          "ticks.max": "10"
//								        }
//								    	}]
//										}
//									}
//								});
							</script>
						</div>
						


<!-- 						<div id="toggleNodes">		
<input type="button"  onclick="getRemoveColouredNodes('#FF0000');" value="Remove Red"></input>
<input type="button"  onclick="getRemoveColouredNodes('#FCC200');" value="Remove Amber"></input>
<input type="button"  onclick="getRemoveColouredNodes('#7BE141');" value="Remove Green"></input>
<input type="reset"  onclick="populateNodeArray();window.location.reload() "></input>
</div>
 -->
   					
					</div>

				</div>

				
				<div class="row">

					<div class="col-sm-12">
						
<div style="width: 75%">
		<canvas id="canvas"></canvas>
	</div>
	<script src="http://www.chartjs.org/samples/latest/utils.js"></script>
	<script>
		
		var barChartData = {
			labels: ['',''],
			datasets: [{
				label: 'App 1',
				backgroundColor: Utils.chartColors.RED,
				data: [
					10,20
				]
			}, {
				label: 'App 2',
				backgroundColor: Utils.chartColors.GREEN,
				data: [
					30,0
				]
			}, {
				label: 'App 3',
				backgroundColor: Utils.chartColors.AMBER,
				data: [
					20,0
				]
			}]

		};
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			window.myBar = new Chart(ctx, {
				type: 'horizontalBar',
				data: barChartData,
				options: {
					title: {
						display: true,
						text: 'Stacked Bar Dependency Graph'
					},
					tooltips: {
						mode: 'index',
						intersect: false
					},
					responsive: true,
					scales: {
						xAxes: [{
							stacked: true,
						}],
						yAxes: [{
							stacked: true
						}]
					}
				}
			});
		};

	</script>
						
						
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">

				</div>
				</div>
								
				<div class="highlights">
				</div>
			</div>
		</section>


		
	</body>
	// Dependency chart stuff
<script type="text/javascript" src="assets/js/vis.js"></script>
<script type="text/javascript" src="assets/js/dependencyMap.js"></script>		
 <script>
  $( function() {
    $( "#dialog" ).dialog({
        width: 1000,
        height: 500,
        autoOpen: false,
      show: {
        effect: "blind",
        duration: 1000
      },
      hide: {
        effect: "blind",
        duration: 1000
      }
    });
 
    $( "#opener" ).on( "click", function() {
      $( "#dialog" ).dialog( "open" );
    });
  } );
  </script>
</html>



