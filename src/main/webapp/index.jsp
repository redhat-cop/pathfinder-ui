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
					
									<%if (request.getSession().getAttribute("x-access-token")==null){%>
					<a class="logo" href="login.jsp">Login</a>
				<%}else{%>

						<section>
							<div class="content">
								<header>
									<a href="survey.jsp" target=_blank class="icon fa-files-o"><span class="label">Icon</span></a>
									<h3>Run the assessment questionnaire.</h3>
								</header>
								<p>Questions to start you on your way.</p>
							</div>
						</section>
						<section>
							<div class="content">
								<header>
									<a href="manageCustomers.jsp" class="icon fa-line-chart"><span class="label">Icon</span></a>
									<h3>Assessments</h3>
								</header>
								<p>View and edit assessment results.</p>
							</div>
						</section>
						<section>
							<div class="content">
								<header>
									<a href="manageCustomers.jsp" class="icon fa-vcard-o"><span class="label">Icon</span></a>
									<h3>Administration</h3>
								</header>
								<p>Add/edit customers and applications.</p>
							</div>
						</section>
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
