<style>
body{
			margin-top: 100px;
			font-family: 'Trebuchet MS', serif;
			line-height: 1.6
		}
		.container{
			width: 600px;
			margin: 0 auto;
		}



		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: #ededed;
			color: #222;
		}

		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
</style>

<div class="container">

	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">School</li>
		<li class="tab-link" data-tab="tab-2">District</li>
		<li class="tab-link" data-tab="tab-3">Grade</li>
		<li class="tab-link" data-tab="tab-4">School Level</li>
        <li class="tab-link" data-tab="tab-4">Address</li>
        <li class="tab-link" data-tab="tab-4">Zip code</li>
	</ul>

	<div id="tab-1" class="tab-content current">
		<div class="subscribe">
								<form action="?" method="post">
									<input type="submit" value="Go" class="subscribe-btn">
									
									<div class="subscribe-inner">
										<input type="email" id="mail" name="mail" value="" placeholder="Email Address" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-2" class="tab-content">
		 Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
	</div>
	<div id="tab-3" class="tab-content">
		Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
	</div>
	<div id="tab-4" class="tab-content">
		Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
	</div>
</div>
<div class="post-map" id="event-map" data-address="51 Sherbrooke W., Montreal, QC."></div><!-- /.post-map -->

<!-- container -->

<script>
$(document).ready(function(){
	
	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	});
    
    // Map
		if ($('#event-map').length) {
			google.maps.event.addDomListener(window, 'load', initialize);
		}
    
    	function initialize() {
		var address = $('#event-map').data('address');

		var geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(50, 50);
		var mapOptions = {
			zoom: 11,
			center: latlng,
			scrollwheel: false,
			disableDefaultUI: true
		};


		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				var marker = new MarkerWithLabel({
						map: map,
						position: results[0].geometry.location,
						icon: ' ',
						labelContent: '<i class="fa fa-map-marker"></i>',
						labelAnchor: new google.maps.Point(7, 28),
						labelClass: 'labels'
				});
				latlng = new google.maps.LatLng(results[0].geometry.location.k, results[0].geometry.location.D);
			}
		});

		var map = new google.maps.Map(document.getElementById('event-map'), mapOptions);
		
	}

})
</script>
<cfoutput>
    <script type="text/javascript">
 
	#location#
 	
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
	  //center: new google.maps.LatLng(32.800028, -96.781229),
      center: new google.maps.LatLng(#mapzoom#),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;
	
	var image = 'elementaryschool.png';
	var middleschool = 'middleschool.png';
	var highschool = 'highschool.png';

    for (i = 0; i < locations.length; i++) {
	
	if (locations[i][4] == 'E') {
    image = image;
	} else if(locations[i][4] == 'H') {
		image = highschool;
	} else if(locations[i][4] == 'M')  {
		image = middleschool;
	}
	
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map,
		icon: image
      });
	  
      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
        return function() {
		
          infowindow.setContent('<a class="iframe" target="_new" href=profile.cfm?id_number=' + locations[i][6] + '><b>' + locations[i][0] + '</b></a><br>' + locations[i][5]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
   </script> 
        
        
</cfoutput> 