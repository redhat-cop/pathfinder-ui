<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
  <%@include file="head.jsp"%>
	
  <link href="assets/css/breadcrumbs.css" rel="stylesheet" />
  
  <!-- #### DATATABLES DEPENDENCIES ### -->
  <!-- Firefox doesnt support link imports yet
  <link rel="import" href="datatables-dependencies.jsp">
  -->
  <%@include file="datatables-dependencies.jsp"%>
	
	<body class="is-preload">
		<%@include file="nav.jsp"%>
		
		<section id="banner2">
			<div class="inner">
				<h1>Pathfinder Login</h1>
				<p></p>
			</div>
		</section>
		
  	<div id="wrapper">
			<center>
				<div class="modal-content">
					<div class="modal-body">
						<form action="api/pathfinder/login" method="post">
		          <div class="form-group">
		            <label for="username" class="control-label">Username:</label>
		            <input id="username" name="username" type="text" class="form-control">
		          </div>
		          <div class="form-group">
		            <label for="password" class="control-label">Password:</label>
		            <input id="password" name="password" type="password" class="form-control">
		          </div>
							<br/><input type="submit" value="Submit">
						</form>
					</div>
				</div>
			</center>
  	</div>

	</body>
</html>