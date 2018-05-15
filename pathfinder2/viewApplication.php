<!DOCTYPE HTML>
<!--
	Industrious by TEMPLATED
	templated.co @templatedco
	Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>
	<head>
		<title>Pathfinder</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<link rel="stylesheet" href="assets/css/main.css" />
      <link rel="stylesheet" type="text/css" href="http://overpass-30e2.kxcdn.com/overpass.css"/>

		<script>
	  $( function() {
	    $( "#speed" ).selectmenu();

	    $( "#files" ).selectmenu();

	    $( "#number" )
	      .selectmenu()
	      .selectmenu( "menuWidget" )
	        .addClass( "overflow" );

	    $( "#salutation" ).selectmenu();
	  } );
	  </script>
	</head>
	<body class="is-preload">

		<!-- Header -->
			<header id="header">
				<a class="logo" href="index.php">Pathfinder</a>
				<nav>
					<a href="#menu">Menu</a>
				</nav>
			</header>

<?php
include("functions.php");
putMenu();
?>

		<!-- Banner -->
			<section id="banner2">
				<div class="inner">
					<h1>Pathfinder Results</h1>
					<p>Review Overview</div>
			</section>

		<!-- Highlights -->
			<section class="wrapper">
				<div class="inner">
					<div class="highlights">
	
	<?php
$custId = $_REQUEST['customerId'];
$appId = $_REQUEST['applicationId'];
$reviewId = $_REQUEST['reviewId'];

#$customerDetails = file_get_contents("http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com/api/pathfinder/customers/$cust");
$data = file_get_contents("http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com/api/pathfinder/customers/$custId/applications/$appId/review/$reviewId");
$reviewDetails = json_decode($data);
print_r($reviewDetails);

	 ?>
	 
					</div>
					
				</div>
				
			</section>



		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>
         <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
         


	</body>
</html>
