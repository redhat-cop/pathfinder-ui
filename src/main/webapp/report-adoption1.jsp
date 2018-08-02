<script src="http://www.chartjs.org/samples/latest/utils.js"></script>
						<script>
							
							var barChartData = {
								labels: ['',''],
								datasets: [{
									label: 'App 1',
									backgroundColor: Utils.chartColors.RED,
									data: [10,20]
								}, {
									label: 'App 2',
									backgroundColor: Utils.chartColors.GREEN,
									data: [30,0]
								}, {
									label: 'App 3',
									backgroundColor: Utils.chartColors.AMBER,
									data: [20,0]
								}]
					
							};
							window.onload = function() {
								var ctx = document.getElementById('adoption').getContext('2d');
								window.myBar = new Chart(ctx, {
									type: 'horizontalBar',
									data: barChartData,
									options: {
										title: {
											display: false,
											text: 'Stacked Bar Dependency Graph'
										},
										tooltips: {
											mode: 'index',
											intersect: false
										},
										responsive: true,
										scales: {
											xAxes: [{
												stacked: true,
											}],
											yAxes: [{
												stacked: true
											}]
										}
									}
								});
							};
						</script>