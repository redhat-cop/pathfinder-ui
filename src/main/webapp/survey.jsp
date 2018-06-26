<!DOCTYPE HTML>
<!--
	Industrious by TEMPLATED
	templated.co @templatedco
	Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>
  <%@include file="head.jsp"%>
  
  <head>
    <title>Pathfinder</title>
    <script src="https://unpkg.com/jquery"></script>

    <script src="https://surveyjs.azureedge.net/1.0.23/survey.jquery.js"></script>
    <link href="https://surveyjs.azureedge.net/1.0.23/survey.css" type="text/css" rel="stylesheet"/>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.4/css/select2.min.css" rel="stylesheet"/>
    <script src="https://unpkg.com/surveyjs-widgets"></script>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@3.3.7/dist/css/bootstrap.min.css">
    <!--<link rel="stylesheet" href="./context/index.css">-->
    <script src="https://unpkg.com/icheck@1.0.2"></script>
    <link rel="stylesheet" href="https://unpkg.com/icheck@1.0.2/skins/square/blue.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
    <link rel="stylesheet" type="text/css" href="http://overpass-30e2.kxcdn.com/overpass.css"/>
		<style type="text/css">
			body {font-family: Overpass;}
		</style>
  </head>
	<body class="is-preload">
    <div id="surveyElement"></div>
    <div id="surveyResult"></div>
		
		<script src="utils.jsp"></script>
		
		<script>
			var surveyJsUrl=Utils.SERVER+"/api/pathfinder/survey";
			var surveyJSElement=document.createElement('script');
			surveyJSElement.src=surveyJsUrl;
			document.getElementsByTagName('head')[0].appendChild(surveyJSElement);
		</script>
		
	</body>
</html>
