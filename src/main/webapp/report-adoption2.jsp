


<script>


    window.onload = function() {
			var ctx = document.getElementById('adoption').getContext('2d');
			window.myBar = new Chart(ctx, {
	        type: 'line',
	        data: {
	            datasets: [
	            {
	
	                label: 'Scatter Dataset',
	                backgroundColor: "rgba(246,156,85,1)",
	                borderColor: "rgb(146,212,0)",
	                fill: false,
	                borderWidth : 15,
	                pointRadius : 0,
	                data: [
	                    {
	                        x: 0,
	                        y: 9
	                    }, {
	                        x: 3,
	                        y: 9
	                    }
	                ]
	            },
	            {
	                backgroundColor: "rgba(208,255,154,1)",
	                borderColor: "rgb(240,171,0)",
	                fill: false,
	                borderWidth : 15,
	                pointRadius : 0,
	                data: [
	                    {
	                        x: 3,
	                        y: 7
	                    }, {
	                        x: 5,
	                        y: 7
	                    }
	                ]
	            },
	            {
	
	                label: 'Scatter Dataset',
	                backgroundColor: "rgba(246,156,85,1)",
	                borderColor: "rgb(204, 0, 0)",
	                fill: false,
	                borderWidth : 15,
	                pointRadius : 0,
	                data: [
	                    {
	                        x: 5,
	                        y: 5
	                    }, {
	                        x: 10,
	                        y: 5
	                    }
	                ]
	            },
	            {
	                backgroundColor: "rgb(0, 65, 83)",
	                borderColor: "rgba(0,0,0,1)",
	                fill: false,
	                width : 10,
	                pointRadius : 1,
	                data: [
	                    {
	                        x: 10,
	                        y: 3
	                    }, {
	                        x: 13,
	                        y: 3
	                    }
	                ]
	            }
	            ]
	        },
	        options: {
	            legend : {
	                display : true
	            },
	            scales: {
	                xAxes: [{
	                    type: 'linear',
	                    position: 'bottom',
	                    ticks : {
	                        beginAtzero :true,
	                        stepSize : 1
	                    }
	                }],
	                yAxes : [{
	                    scaleLabel : {
	                        display : false
	                    },
	                    ticks : {
	                        beginAtZero :true,
	                        max : 10
	                    }
	                }]
	            }
	        }
	    });
		
		};
		
    
    
</script>