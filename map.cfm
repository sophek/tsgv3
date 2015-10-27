<div id="map" style="width: 100%; height: 450px;" class="post-map"></div>
<!-- Start map legend section -->                
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>   
    
    
<cfoutput>
    <script type="text/javascript">
        
        
$(".fancybox")
    .attr('rel', 'gallery')
    .fancybox({
        type: 'iframe',
        autoSize : false,
        beforeLoad : function() {                    
            this.width = parseInt(this.href.match(/width=[0-9]+/i)[0].replace('width=',''));  
            this.height = parseInt(this.href.match(/height=[0-9]+/i)[0].replace('height=',''));
        }
    });
        
 
	#location#
 	
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
	  //center: new google.maps.LatLng(32.800028, -96.781229),
      center: new google.maps.LatLng(#mapzoom#),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;
	
	var Agrade = 'A.png';
	var Bgrade = 'B.png';
    var Cgrade = 'C.png';
    var Dgrade = 'D.png';
    var Fgrade = 'F.png';    

    for (i = 0; i < locations.length; i++) {
	
	if (locations[i][4] == 'A' || locations[i][4] == 'A+' || locations[i][4] == 'A-' ) {
    image = Agrade;
	} else if(locations[i][4] == 'B' || locations[i][4] == 'B+' || locations[i][4] == 'B-') {
		image = Bgrade;
	} else if(locations[i][4] == 'C' || locations[i][4] == 'C+' || locations[i][4] == 'C-' )  {
		image = Cgrade;
	} else if(locations[i][4] == 'D' || locations[i][4] == 'D+' || locations[i][4] == 'D-' ) {
        image = Dgrade;
    } else if(locations[i][4] == 'F' || locations[i][4] == 'F+' || locations[i][4] == 'F-' ) {    
        image = Fgrade;
     } else {
         
     }
    
    
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map,
		icon: image
      });
	  
      google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
        return function() {
		
          infowindow.setContent('<a class="fancybox" href=profile.cfm?id_number=' + locations[i][6] + '><b>' + locations[i][0] + '</b></a><br>' + locations[i][5]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
   </script> 
        
        
</cfoutput> 