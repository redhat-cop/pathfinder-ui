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

				<!-- Scripts -->

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
					<h1>Pathfinder Admin</h1>
					<p>Create customers and applications.</div>
			</section>

		<!-- Highlights -->
			<section class="wrapper">
				<div class="inner">
					<div class="highlights">



					</div>
					<table><thead><tr><td>Customer Name</td><td>Customer Details</td><td>Edit</td><td>Delete</td></tr></thead><tbody>
<?php

# check if there is a customer to add

if (isset($_REQUEST['name'])) {
print '<div id="message" class="message" style="display:none;">' . $_REQUEST['name'] . ' Added</div>';
$custName = $_REQUEST['name'];
$custDesc = $_REQUEST['description'];
$custAssessor = $_REQUEST['assessor'];
$custVertical = $_REQUEST['vertical'];

$data = array("CustomerName" => "$custName", "CustomerDescription" => "$custDesc", "CustomerAssessor" => "$custAssessor", "CustomerVertical" => "$custVertical", "CustomerSize" => "Medium");
$data_string = json_encode($data);                                                                                   

#print_r($data_string);

$ch = curl_init('http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com/api/pathfinder/customers/');
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);                                                                  
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
    'Content-Type: application/json',                                                                                
    'Content-Length: ' . strlen($data_string))                                                                       
);                                                                                                                   
                                                                                                                     
$result = curl_exec($ch);                                                                      
#var_dump($result);
#var_dump($data_string);
}

# Get customer details from mongo

#phpinfo();

$response = file_get_contents('http://pathtest-pathfinder.6923.rh-us-east-1.openshiftapps.com/api/pathfinder/customers/');

#var_dump($response);
foreach (json_decode($response,true) as $customer) {
print "<tr><td>" . $customer['CustomerName'] . "</td>";
$CustomerId = $customer['CustomerId'];
$CustomerDescription = $customer['CustomerDescription'];
print "<td>" . $CustomerDescription . "</td>";
#print "<td>";

print '</td><td><a href=editCustomer.php?customer=' . $CustomerId .'><img src="images/edit.png"></a></td><td><a href="deleteCustomer.php?custId='  . $CustomerId .  '"><img src="images/trash.png" width=32px height=32px></a></td>';
print "</tr>";
}
#print "Customer: " . $response[0]['CustomerName'];

?>
</tbody>
</table>

<div id="aaa"  style="display:none">
<form id="myForm" action="#" method="post"> 
    Customer Name: <input type="text" name="name" /> 
    Customer Description: <input type="text" name="description"></input> 
    Customer Line of Business:     <select name="vertical" id="vertical">
<option value="Agriculture">Agriculture</option>
<option value="Business Services">Business Services</option>
<option value="Construction & Real Estate">Construction & Real Estate</option>
<option value="Education">Education</option>
<option value="Energy, Raw Materials & Utilities">Energy, Raw Materials & Utilities</option>
<option value="Finance">Finance</option>
<option value="Government">Government</option>
<option value="Healthcare">Healthcare</option>
<option value="IT">IT</option>
<option value="Leisure & Hospitality">Leisure & Hospitality</option>
<option value="Libraries">Libraries</option>
<option value="Manufacturing">Manufacturing</option>
<option value="Media & Internet">Media & Internet</option>
<option value="Non-Profit & Professional Orgs.">Non-Profit & Professional Orgs.</option>
<option value="Retail">Retail</option>
<option value="Software">Software</option>
<option value="Telecommunications">Telecommunications</option>
<option value="Transportation">Transportation</option>

</select>

    Customer Assessor: <input type="text" name="assessor"></input>
<br>
    <input type="submit" value="Add" /> 
</form>
</div>

<button>Add New Customer</button>
</div>


				</div>
			</section>


			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
$(document).ready(function(){
	
	$('#message').fadeIn('slow', function(){
               $('#message').delay(5000).fadeOut(); 
            });
            
    $("button").click(function(){
        $("#aaa").toggle();
    });
});
</script>
  <script>
  $( function() {
    $( "#dialog-confirm" ).dialog({
      resizable: false,
      height: "auto",
      width: 400,
      modal: true,
      buttons: {
        "Delete all items": function() {
          $( this ).dialog( "close" );
        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      }
    });
  } );
  </script>

	</body>
</html>
