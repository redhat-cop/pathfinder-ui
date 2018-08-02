<script>


    window.onload = function() {
			var ctx = document.getElementById('adoption').getContext('2d');
			var chart = new Chart(ctx, {
		    type: 'horizontalBar',
		    data: {
		        labels: ["Stream 1", "Stream 2", "Stream 3", "Stream 4"],
		        datasets: [
		        {
		        		label:"hidden",
		            data: [0, 100, 300, 100, 400],  // indent
		            backgroundColor: "rgba(0,0,0,0)",
		            hoverBackgroundColor: "rgba(0,0,0,0)"
		        },{
		            data: [100, 200, 100, 100],
		            backgroundColor: ['rgb(146,212,0)', 'rgb(240,171,0)', 'rgb(204, 0, 0)', 'rgb(0, 65, 83)'],
		        }]
		    },
				options:{
					    hover :{
					        animationDuration:10
					    },
					    scales: {
					        xAxes: [{
					            label:"Duration",
					            ticks: {
					                beginAtZero:true,
					                fontFamily: "'Open Sans Bold', sans-serif",
					                fontSize:11
					            },
					            scaleLabel:{
					                display:false
					            },
					            gridLines: {
					            }, 
					            stacked: true
					        }],
					        yAxes: [{
					            gridLines: {
					                display:false,
					                color: "#fff",
					                zeroLineColor: "#fff",
					                zeroLineWidth: 0
					            },
					            ticks: {
					                fontFamily: "'Open Sans Bold', sans-serif",
					                fontSize:11
					            },
					            stacked: true
					        }]
					    },
					    legend:{
					        display:false
					    },
							//tooltips: {
					    //    callbacks: {
					    //       label: function(tooltipItem,data) {
					    //       				var label = data.datasets[tooltipItem.datasetIndex].label || '';
					    //              return label;
					    //       }
					    //    }
					    //}
					}
			});
	
			//window.myBar=chart;
			//// this part to make the tooltip only active on your real dataset
			//var originalGetElementAtEvent = chart.getElementAtEvent;
			//chart.getElementAtEvent = function (e) {
			//		console.log(e);
			//    return originalGetElementAtEvent.apply(this, arguments).filter(function (e) {
			//        return e._datasetIndex === 1;
			//    });
			//}
	
		};

</script>