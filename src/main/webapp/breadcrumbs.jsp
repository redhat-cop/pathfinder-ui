
  	<style>
.breadcrumb-buttons {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #333;
    height: 45px;
}
.breadcrumb-buttons li {
    display:inline-block;
    text-decoration: none;
    height:100%;
}
.breadcrumb-buttons li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 20px;
    text-decoration: none;
}
.breadcrumb-buttons li a:hover:not(.active) {
    background-color: #111;
}
.breadcrumb-buttons .active {
    /*
    background-color: #111;
    */
    background-color: #4CAF50;
    
}
.breadcrumb-buttons li {
    background-color: #333;
}
.customer-title{
	  background-color: #ccc !important;
    color: #444;
    font-size: 16pt;
    /*text-align: center;*/
    padding: 6px 16px;
    width: 300px;
    height: 52px;
}
ol, ul {
    list-style: none;
}

/* add grey button separator to distinguish between them */
li {
    border-right: 1px solid #bbb;
}
li:last-child {
    border-right: none;
}
.disabledx a{
	background-color: #AAA !important;
	cursor: default;
}

  	</style>
  	
  	<script>
  		function setBreadcrumbs(active, customer){
		    //$('#breadcrumb-name').attr('innerHTML', customer.CustomerName);
		    //$('#customer').get().innerHTML="X="+customer.CustomerName;
		    //document.getElementById("customer").innerHTML=customer.CustomerName;
		    
		    document.getElementById("customer").innerHTML=customer.CustomerName;
		    
		    //$('#breadcrumb-details>a').attr('href', '#');
		    $('#breadcrumb-applications>a').attr('href', 'manageCustomerApplications.jsp?customerId='+customer.CustomerId);
		    $('#breadcrumb-assessments>a').attr('href', 'assessments-v2.jsp?customerId='+customer.CustomerId);
		    $('#breadcrumb-profiles>a').attr('href', '#');
		    $('#breadcrumb-members>a').attr('href', '#');
		    
		    if (undefined!=$('#breadcrumb-'+active+'>a').get()){
		    	$('#breadcrumb-'+active+'>a').addClass("active");
		    	//$('#breadcrumb-'+active+'>a').attr("href","#"); // prevent navigation to current page
		    }
  		}
  	</script>
  	
  	<div>
			<ul class="breadcrumb-buttons">
				<li id="breadcrumb-name" class="customer-title"><span id="customer"><span style="color:#AAA;">Loading...</span></span></li>
				<!--
				<li id="breadcrumb-details"><a href="#">Details</a></li>
				-->
				<li id="breadcrumb-applications"><a href="#">Applications</a></li>
				<li id="breadcrumb-assessments"><a href="#">Assessments</a></li>
				<li id="breadcrumb-profiles" class="disabled"><a href="#">Profiles</a></li>
				<li id="breadcrumb-members" class="disabled"><a href="#">Members</a></li>
			</ul>
  	</div>
