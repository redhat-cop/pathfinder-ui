	<head style="z-index:-1">
		<title>Pathfinder</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
    <link rel="stylesheet" type="text/css" href="https://rawgit.com/RedHatBrand/Overpass/master/webfonts/overpass-webfont/overpass.css"/>
		<!--
		<link rel="stylesheet" type="text/css" href="assets/css/overpass.css"/>
		<link rel="stylesheet" href="assets/css/main.css" />
		-->
	  <script src="assets/js/jquery-3.3.1.min.js"></script>
	  <script src="utils.jsp"></script>
	  <script>
	  	var jwtToken = "<%=session.getAttribute("x-access-token")!=null?session.getAttribute("x-access-token"):""%>";
	  	var customerId=Utils.getParameterByName("customerId");
	  	var applicationId=Utils.getParameterByName("applicationId");
	  	var assessmentId=Utils.getParameterByName("assessmentId");
	  </script>
	  
	  <!-- We REALLY need to sort out the css for this app at some point SOON!-->
	  <style>
	  	.editLink{
			  vertical-align:super;
			  font-size:0.6em;
	  	}
	  
	  </style>
	</head>