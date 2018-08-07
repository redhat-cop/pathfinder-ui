
			<link rel="stylesheet" href="assets/css/main.css" />
			
			<!-- Header -->
			<header id="header">
				
				<%if (request.getSession().getAttribute("x-access-token")==null){%>
				<a class="logo" href="index.jsp">Pathfinder</a>
				<a class="logo" href="login.jsp">Login</a>
				<%}else{%>
				<a class="logo" href="manageCustomers.jsp">Pathfinder</a>
					<p>Logged in as <%=request.getSession().getAttribute("x-displayName")%> <a href="api/pathfinder/logout"> (Logout)</a></p>
				<%}%>
				
				<nav>
					<a href="#menu">Menu</a>
				</nav>
			</header>
			
			<!--
			<login>
				<ul>
					<li>Login</li>
				</ul>
			</login>
			
			<nav id="menu2">
				<ul class="links">
					<li>Logout</li>
				</ul>
			</nav>
			-->
			
			<!-- Nav -->
			<nav id="menu">
				<ul class="links">
				<%if (request.getSession().getAttribute("x-access-token")==null){%>				
					<li><a href="index.jsp">Home</a></li>
				<%}else{%>
					<li><a href="manageCustomers.jsp">Home</a></li>
				<%}%>
					<!--
					<li><a href="survey.jsp" target=_blank>Assessment</a></li>
					-->
					<li><a href="manageCustomers.jsp">Customers</a></li>
					<li><a href="workflow.jsp">Workflow</a></li>
					<li><a href="credits.jsp">Credits</a></li>
				</ul>
			</nav>
			
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			
			<script>
			$(document).ready(function() {

				var	$window = $(window),
					$banner = $('#banner'),
					$body = $('body');

				//breakpoints({
				//	default:   ['1681px',   null       ],
				//	xlarge:    ['1281px',   '1680px'   ],
				//	large:     ['981px',    '1280px'   ],
				//	medium:    ['737px',    '980px'    ],
				//	small:     ['481px',    '736px'    ],
				//	xsmall:    ['361px',    '480px'    ],
				//	xxsmall:   [null,       '360px'    ]
				//});

				$window.on('load', function() {
					window.setTimeout(function() {
						$body.removeClass('is-preload');
					}, 100);
				});

				$('#menu')
					.append('<a href="#menu" class="close"></a>')
					.appendTo($body)
					.panel({
						target: $body,
						visibleClass: 'is-menu-visible',
						delay: 500,
						hideOnClick: true,
						hideOnSwipe: true,
						resetScroll: true,
						resetForms: true,
						side: 'right'
					});
		
				});
			</script>
			

			<!--
			<script src="assets/js/main.js"></script>
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
			-->
			
			
			
			