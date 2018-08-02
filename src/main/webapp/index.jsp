<!DOCTYPE HTML>
<!--
	Industrious by TEMPLATED
	templated.co @templatedco
	Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>
  <%@include file="head.jsp"%>
  
		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>
		  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
					  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">  
	<body class="is-preload">

		<!-- Header -->
			<header id="header">
				<a class="logo" href="index.jsp">Pathfinder</a>
				<nav>
					<a href="#menu">Menu</a>
				</nav>
			</header>

    <%@include file="nav.jsp"%>

		<!-- Banner -->
			<section id="banner">
				<div class="inner">
					<h1>Pathfinder</h1>
					<p>Pathfinder is an application assessment which can quickly assist a customer with creating a strategy for containerisation of their applications.</div>
				<video autoplay loop muted playsinline src="images/path-photo-clip.png"></video>
			</section>

		<!-- Highlights -->
			<section class="wrapper">
				<div class="inner">
					<header class="special">

					</header>
					<div class="highlights">
					
									<%if (request.getSession().getAttribute("x-access-token")!=null){%>
		<section id="banner2">
		</section>
		
		<script>
		$(document).ready(function(){
			$("#loginForm").submit(function () {
        $("#submit").attr("disabled", true);
			  e.preventDefault();
        return true;
	    });
		});
		</script>
		
  			<%if (null!=request.getParameter("error")){%>
					<div class="modal-content">
						<%=request.getParameter("error")%>
					</div>
				<%}%>
				<div class="modal-content" style="margin: auto;">
				<h3>Please login</h3>
					<div class="modal-body">
						<form id="loginForm" action="api/pathfinder/login" method="post">
		          <div class="form-group">
		            <label for="username" class="control-label">Username:</label>
		            <input id="username" name="username" type="text" class="form-control">
		          </div>
		          <div class="form-group">
		            <label for="password" class="control-label">Password:</label>
		            <input id="password" name="password" type="password" class="form-control">
		          </div>
							<br/><input id="submit" type="submit" value="Submit">
						</form>
					</div>
				</div>
  <!-- 					<a class="logo" href="login.jsp">Login</a> -->
				<%}else{%>

						
							<div class="content" style="margin: auto;">
								<header  style="margin: auto;">
									<a href="manageCustomers.jsp" class="icon fa-line-chart"><span class="label">Icon</span>
									<h3>Admin & Assessments</h3></a>
								</header>
							</div>
						
				<%}%>
			</div>
				</div>
			</section>

		<!-- CTA -->
			<section id="cta" class="wrapper">
				<div class="inner">
					<h2>EMEA Red Hat Value from Technology Team</h2>
				</div>
			</section>



	</body>
</html>
