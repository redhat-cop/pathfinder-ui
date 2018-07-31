<html>
  <%@include file="head.jsp"%>
  <body class="is-preload">
  	<link href="assets/css/bootstrap-3.3.7.min.css" rel="stylesheet" />
  	<script src="assets/js/bootstrap-3.3.7.min.js"></script>
  	
  	<%@include file="nav.jsp"%>
  	
  	
		<section id="banner2">
			<div class="inner">
				<h1>Application Assessment</h1>
				<p>Perform the application assessment.</p>
			</div>
		</section>
		
		<%@include file="breadcrumbs.jsp"%>
		
		<section class="wrapper">
			<div class="inner">
				
				<script src="assets/js/datatables-functions.js"></script>
				<script src="utils.jsp"></script>
				<script>
					$(document).ready(function() {
						// ### Get Customer Details
						httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId"), function(customer){
							if (undefined!=setBreadcrumbs){
				        setBreadcrumbs("assessments", customer);
				      }
						});
					});
					
				</script>
				
				<!-- #### page content here #### -->
		    <script src="https://unpkg.com/jquery"></script>
		
		    <script src="https://surveyjs.azureedge.net/1.0.23/survey.jquery.js"></script>
		    <link href="https://surveyjs.azureedge.net/1.0.23/survey.css" type="text/css" rel="stylesheet"/>
		
		    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.4/css/select2.min.css" rel="stylesheet"/>
		    <!--
		    <link rel="stylesheet" href="https://unpkg.com/bootstrap@3.3.7/dist/css/bootstrap.min.css">
		    -->
		    <script src="https://unpkg.com/surveyjs-widgets"></script>
		    <!--<link rel="stylesheet" href="./context/index.css">-->
		    <script src="https://unpkg.com/icheck@1.0.2"></script>
		    <link rel="stylesheet" href="https://unpkg.com/icheck@1.0.2/skins/square/blue.css">
		    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
		    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
		    <link rel="stylesheet" type="text/css" href="http://overpass-30e2.kxcdn.com/overpass.css"/>
				<style type="text/css">
					body {font-family: Overpass;}
				</style>
				
		    <div id="surveyElement"></div>
		    <div id="surveyResult"></div>
				
				<script src="utils.jsp"></script>
				
				<style>
				.sv_main .sv_container .sv_body .sv_p_root fieldset.sv_qcbc {
				  line-height: 0em;
          padding-top: 0.0em;
				}
				.sv_header{
					display:none;
				}
				.sv_main.sv_default_css .sv_body {
					border-color: #111;
				}
				/*
				.sv_main.sv_default_css .sv_q_dropdown_control {
					border-color: #111;
				}
				.sv_q_dropdown_control ::Before{
					border-color: #111;
					background-color: #111;
				}
				.sv_main.sv_default_css select {
					border-color: #111;
				}
				*/
				.sv_main .sv_p_root > .sv_row {
					border-bottom: 1px solid #e7e7e7;
					border-color: #111;
					background-color: #111;
					
				}
				/* buttons */
				.sv_main.sv_default_css input[type="button"], .sv_default_css button {
				    color: white;
				    background-color: #eee;
				}
				/* buttons:hover */
				.sv_main.sv_default_css input[type="button"]:hover, .sv_default_css button:hover {
				    background-color: #ccc;
				    border-color: #111;
				    font-color: #111
				}
				/*
				.sv_main.sv_default_css .sv_progress {
				    background-color: #111;
				}
				*/
				</style>
				<script>
					
					$(document).ready(function() {
					});
					
					var surveyJsUrl=Utils.SERVER+"/api/pathfinder/survey";
					var surveyJSElement=document.createElement('script');
					surveyJSElement.src=surveyJsUrl;
					document.getElementsByTagName('head')[0].appendChild(surveyJSElement);
				</script>
				
				
			</div>
		</section>	
		
	</body>
</html>
