				<script>
					function buildGuage(percentage,completeColorRGB,incompleteColorRGB,title){
					  var remaining=100-percentage;
						return {
							"type":"doughnut",
			        "data": {
//                "labels": [percentage,"",remaining],
		            "datasets": [
		                {
		                    "data": [
		                        percentage,
		                        1,
		                        remaining
		                    ],
		                    "backgroundColor": [
		                        completeColorRGB,
		                        "rgba(0, 0, 0, 0.6)",
		                        incompleteColorRGB,
		                    ],
		                    "borderWidth": 0,
//		                    "hoverBackgroundColor": [
//		                        completeColorRGB,
//		                        "rgba(0, 0, 0, 0.6)",
//		                        incompleteColorRGB,
//		                    ],
		                    "hoverBorderWidth": 0
		                },
		                {
		                    "data": [
		                        percentage,
		                        1,
		                        remaining
		                    ],
		                    "backgroundColor": [
		                        "rgba(0, 0, 0, 0)",
		                        "rgba(0, 0, 0, 0.6)",
		                        "rgba(0, 0, 0, 0)",
		                    ],
		                    "borderWidth": 0,
		                    "hoverBackgroundColor": [
		                        "rgba(0, 0, 0, 0)",
		                        "rgba(0, 0, 0, 0.6)",
		                        "rgba(0, 0, 0, 0)"
		                    ],
		                    "hoverBorderWidth": 0
		                }
		            	]
		        	},
							"options": {
    // String - Template string for single tooltips
    tooltipTemplate: "<\%if (label){\%><\%=label \%>: <\%}\%><\%= value + ' \%' \%>",
    // String - Template string for multiple tooltips
    multiTooltipTemplate: "<\%= value + ' \%' \%>",
		            "cutoutPercentage": 35,
		            "rotation": -3.1415926535898,
		            "circumference": 3.1415926535898,
		            "legend": {
		                "display": false
		            },
		            "tooltips": {
		                "enabled": true
		            },
		            "title": {
		                "display": true,
		                "text": title,
		                "position": "bottom"
		            }
		        	}
						};
					}
</script>