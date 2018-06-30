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
	
	<!-- #### CHARTS DEPENDENCIES ### -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
		
	<body class="is-preload">
  	<%@include file="nav.jsp"%>
  	
		<section id="banner2">
			<div class="inner">
				<h1>Assessment Details for <span id="customerName"/></h1>
				<p>View the results of an assessment and review output.</p>
			</div>
		</section>
		
  	<div id="breadcrumbs">
			<ul class="breadcrumb">
				<li><a href="manageCustomers.jsp">Customers</a></li>
				<li><span id="breadcrumb1"></span></li>
				<li><span id="breadcrumb2"></span></li>
			</ul>
		</div>
		
		<section class="wrapper">
			<div class="inner">
				
				<!-- ### Page specific stuff here ### -->
				
				<script>
				var customerId=Utils.getParameterByName("customer");
				var appId=Utils.getParameterByName("app");
				var assessmentId=Utils.getParameterByName("assessment");
				var beenReviewed=false;
				
				$(document).ready(function() {
					httpGetObject(Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/"+appId, function(application){
						document.getElementById("breadcrumb2").innerHTML=application.Name;
						document.getElementById("applicationName").innerHTML=application.Name;
						beenReviewed=application.Review!=null;
					  //console.log("app.count="+progress.Appcount+", assessed="+progress.Assessed+", reviewed="+progress.Reviewed);
					});
					
					// ### Get Customer Details
					httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId, function(customer){
						// ### Populate the header with the Customer Name
						document.getElementById("customerName").innerHTML=customer.CustomerName;
						document.getElementById("breadcrumb1").innerHTML="<a href='assessments-v2.jsp?customerId="+customer.CustomerId+"'>"+customer.CustomerName+"</a>";

					});
					
				});
				
				</script>

<script>
var defaultRadiusMyChart;
var addRadiusMargin = -10;
var currentSelectedPieceLabel = "";

function filterDatatable(myChart){
	// ### Filters the datatable based on the pie chart selection
  var activePoints=myChart.getElementsAtEvent(event);
  if (activePoints[0]) {
    var chartData=activePoints[0]['_chart'].config.data;
    var idx=activePoints[0]['_index'];
		
    var label=chartData.labels[idx];
    var value=chartData.datasets[0].data[idx];
		
    var table=$('#example').DataTable();
    table.columns(2).search(label).draw();
  }
}
function resetDatatable(){
	var table=$('#example').DataTable();
  table.columns(2).search("").draw();
}

function onClickHandlers(myChart) {
	var defaultRadiusMyChart = myChart.outerRadius;
	$('#pieChart').on('click', function (event) {
		
		// ### Explode segment					      
    var activePoints = myChart.getElementsAtEvent(event);
    
    if (activePoints.length > 0) {    	    
      //get the internal index of slice in pie chart
      var clickedElementindex = activePoints[0]["_index"];

      //get specific label by index
      var clickedLabel = myChart.data.labels[clickedElementindex];

      if (currentSelectedPieceLabel.toUpperCase() == "") {
        // no piece selected yet, save piece label
        currentSelectedPieceLabel = clickedLabel.toUpperCase();

				filterDatatable(myChart);

        // clear whole pie
        myChart.outerRadius = defaultRadiusMyChart;
        myChart.update();

        // update selected pie
        activePoints[0]["_model"].outerRadius = defaultRadiusMyChart + addRadiusMargin;
      }
      else {
        if (clickedLabel.toUpperCase() == currentSelectedPieceLabel.toUpperCase()) {
          // already selected piece clicked, clear the chart
          currentSelectedPieceLabel = "";

					resetDatatable();

          // clear whole pie
          myChart.outerRadius = defaultRadiusMyChart;
          myChart.update();

          // update selected pie
          activePoints[0]["_model"].outerRadius = defaultRadiusMyChart;
        }
        else {
          // other piece clicked
          currentSelectedPieceLabel = clickedLabel.toUpperCase();

					filterDatatable(myChart);

          // clear whole pie
          myChart.outerRadius = defaultRadiusMyChart;
          myChart.update();

          // update the newly selected piece
          activePoints[0]["_model"].outerRadius = defaultRadiusMyChart + addRadiusMargin;
        }
      }
      myChart.render(500, false);
    }
  })};
</script>
				
				
				<div class="row">
					<div class="col-sm-4">
						<!-- ### CHART GOES HERE -->
						
						<h2>Assessment for: <span id="applicationName"></span></h2>
						<script>
						  
							$(document).ready(function() {
								//var canvas = document.getElementById("pieChart");
								var xhr = new XMLHttpRequest();
//								xhr.open("GET", "api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/chart2", true);
//								xhr.open("GET", "http://pathfinder-frontend-vft-dashboard.int.open.paas.redhat.com/api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary", true);
//use this until the method is moved to server end
								//xhr.open("GET", "api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary", true);
								//xhr.open("GET", "http://localhost:8080/api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary", true);
//should use this one once the method is moved to the server end
								xhr.open("GET", Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary", true);
								xhr.send();
								xhr.onloadend = function () {
									var data=JSON.parse(xhr.responseText);
									
									var i;
									var newdata={};
									for (i=0;i<data.length;i++) { 
										if (newdata[data[i]['rating']]==undefined) newdata[data[i]['rating']]=0;
									  newdata[data[i]['rating']]=newdata[data[i]['rating']]+1;
									}
									//console.log("newdata="+JSON.stringify(newdata));
									
									var result={};
									result.labels=[];
									result.datasets=[];
									result.datasets[0]={data:[],backgroundColor:[]}
									
									i=0
									for(var key in newdata){
									  result.labels[i]=key;
									  result.datasets[0].data[i]=newdata[key];
									  result.datasets[0].backgroundColor[i]=Utils.chartColors[key];
									  i=i+1;
									}
									//console.log(JSON.stringify(data));
									
									//data=result;
									
									// ### LOAD CHART DATA ###
									var ctx = document.getElementById("pieChart").getContext("2d");
									var myDoughnutChart = new Chart(ctx, {
										type: 'doughnut',
										data: result,
							    	options: {
								    	hover: {
									      onHover: function(e, el) {
									         $("#pieChart").css("cursor", e[0] ? "pointer" : "default");
									      }
									   	},
							        legend: {
						            display: false,
		            		}}
									});
									
									//ctx.canvas.width
									//ctx.canvas.height=400;
									//var defaultRadiusMyChart = myDoughnutChart.outerRadius;

    							onClickHandlers(myDoughnutChart);  
									
							    // ### LOAD DATATABLE DATA ###
									$('#example').DataTable( {
//							        "ajax": {
//							            //"url": Utils.SERVER+'/api/pathfinder/customers/'+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary",
////							            "url": '<%=request.getContextPath()%>/api/pathfinder/customers/'+customerId+"/applications/"+appId+"/assessments/"+assessmentId+"/viewAssessmentSummary",
////							            "dataSrc": "",
//							            "data": data
////							            "dataType": "json"
//							        },
							        "data": data,
							        "scrollCollapse": true,
							        "paging":         false,
							        "lengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]], // page entry options
							        "pageLength" : 10, // default page entries
							        "bInfo" : false, // removes "Showing N entries" in the table footer
							        "searching" : true,
							        //"order" : [[1,"desc"],[2,"desc"],[0,"asc"]],
							        "columns": [
							            { "data": "question" },
							            { "data": "answer" },
							            { "data": "rating" },
							        ]
							        ,"columnDefs": [
							        		{ "targets": 2, "orderable": true, "render": function (data,type,row){
							        		  return "<span style='color:"+Utils.chartColors[row["rating"]]+"'>"+row['rating']+"</span>";
													}}
							        ]
							    } );
							    
							    
								}
							});
						</script>
						<canvas id="pieChart"></canvas>
						<style>
						#example_filter label{
							display:none; //hide the search box on datatables, but search has to be enabled so the chart can filter the data 
						}
						</style>
						
						
					</div>
					<div class="col-sm-8">
						
						<div class="row">

<%
if ("true".equalsIgnoreCase(request.getParameter("review"))){
%>

<p><h2>Architect Review</h2></p>
<p>Please use this section to provide your assessment of the possible migration/modernisation plan and an effort estimation.</p>

<form action="/api/pathfinder/customers/<%=request.getParameter("customer")%>/applications/<%=request.getParameter("app")%>/" id="form" method="post">
	<input type="hidden" id="AssessmentId" name="AssessmentId" value="<%=request.getParameter("assessment")%>"/>
	<!--input type="hidden" id="ReviewTimestamp" name="ReviewTimestamp" value="2018-03-14 03:23:29pm"/-->
	<div class="row">
		<div class="col-sm-3">
			<h4>Proposed Action</h4>
		</div>
		<div class="col-sm-3">
			<h4>Effort Estimate</h4>
		</div>
		<div class="col-sm-6">
			<h4>Supporting Notes</h4>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-3">
			<select name="ReviewDecision" id="ReviewDecision">
				<option value="REHOST">Re-host</option>
				<option value="REPLATFORM">Re-platform</option>
				<option value="REFACTOR">Refactor</option>
				<option value="REPURCHASE">Repurchase</option>
				<option value="RETIRE">Retire</option>
				<option value="RETAIN">Retain</option>
			</select>
		</div>
		<div class="col-sm-3">
			<select name="WorkEffort" id="WorkEffort">
				<option value="SMALL">Small</option>
				<option value="MEDIUM">Medium</option>
				<option value="LARGE">Large</option>
				<option value="XLarge">Extra Large</option>
			</select> 
		</div>
		<div class="col-sm-6">
			<textarea name="ReviewNotes" style="width:400px"></textarea>
		</div>
	</div>
	
	<div class="row">
		<div class="col-sm-3">
			<h4>Business Priority</h4>
		</div>
		<div class="col-sm-3">
			<h4>Work Priority</h4>
		</div>
		<div class="col-sm-3">
		</div>
	</div>
	<div class="row">
		<div class="col-sm-3"> (1=low, 10=high)
			<select type="text" name="BusinessPriority">
				<option>1</option>
				<option>2</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
				<option>8</option>
				<option>9</option>
				<option>10</option>
			</select>
		</div>
		<div class="col-sm-3"> (1=low, 10=high)
			<select type="text" name="WorkPriority">
				<option>1</option>
				<option>2</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
				<option>8</option>
				<option>9</option>
				<option>10</option>
			</select>
		</div>
		<div class="col-sm-3">
			<input type="button" onclick="postReview('form');" value="Submit Review">
			<!--
			<input type="submit" onclick="postReview('form');" value="Submit Review">
			-->
			
		</div>

	</div>
	<script>
		function postReview(formId){
	    var form=document.getElementById(formId);
		  
	    var data = {};
	    for (var i = 0, ii = form.length; i < ii; ++i) {
		    if (form[i].name) data[form[i].name]=form[i].value;
		  }
		  
		  console.log("POSTING: "+JSON.stringify(data));
	    postWait(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/applications/"+appId+"/review", data, new function(response){
		    // wait for the post response before redirecting or else the post will be cancelled
		    console.log("after post: response= "+response);
		    // TODO: this would be much nicer if the server provided a 302 so we could use a submit rather than an artificial wait
		    window.location.href = "assessments-v2.jsp?customerId="+customerId;
	    });
		}
	</script>
	
</form>
<!--
<a href="results.php?customer=<?php echo $_REQUEST['customer'] ?>"><button>Return to Results</button></a>
-->
							
<%
}
%>
							
						</div>
						
						<div class="row">
							
							<!-- ### DATATABLE GOES HERE -->
					  	<div id="wrapper">
						    <div id="buttonbar">
						    </div>
						    <div id="tableDiv">
							    <table id="example" class="display" cellspacing="0" width="100%">
						        <thead>
					            <tr>
				                <th align="left">Question</th>
				                <th align="left">Answer</th>
				                <th align="left">Rating</th>
					            </tr>
						        </thead>
							    </table>
							  </div>
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


