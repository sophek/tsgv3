<cfset zipRadiusObj = CreateObject("component","Zipcoderadiussearch") />


<!--- Set default form parameters to pass into the search filter. --->
<cfset zip = "" />

<cfif isdefined("url.zip") AND url.zip NEQ "">
    <cfset zip="#url.zip#" />
    
    <cfquery name="zipCount" datasource="tsgMysql" maxrows="1">
        SELECT zip_code from schools where zip_code = <cfqueryparam value = "#zip#" cfsqltype = "cf_sql_char"> 
    </cfquery>
        
    <cfif zipCount.recordcount EQ 0>
        <cfset zip="" />
    <cfelse>
        <cfset cookie.person.zip="#zip#">
        <cfset cookie.person.ip="#CGI.REMOTE_ADDR#">
    </cfif>  
</cfif>
        
<cfif isdefined("cookie.person.zip")>
    <cfset zip = cookie.person.zip />
</cfif>

    
<!--- Set default form parameters to pass into the search filter. --->
<cfparam name="form.zip_code" default="#zip#">
<cfparam name="form.radius" default="5">
<cfparam name="form.campus" default="">
<cfparam name="form.address" default="">
<cfparam name="form.city" default="">
<cfparam name="form.district" default="">
<cfparam name="form.school_level" default="">
<cfparam name="form.school_type" default="">
<cfparam name="form.school_programs" default="">
<cfparam name="form.letter_grade" default="">

<!--- Create a function to convert E,H,M to Elementary, Middle and High  --->
    
<cffunction name="convertLetterToSchoolLevel">
    <cfargument name="letter" required="yes" type="string" default="E">
        <cfif #arguments.letter# eq "M">
            <cfreturn "Middle" />
        <cfelseif #arguments.letter# eq "H">
            <cfreturn "High" />    
        <cfelse>
            <cfreturn "Elementary" />
        </cfif>
</cffunction>  
            
            
            
<cffunction name="convertSchoolType">
    <cfargument name="letter" required="yes" type="string" default="E">
        <cfif #arguments.letter# eq "No">
            <cfreturn "Traditonal Public School" />
        <cfelseif #arguments.letter# eq "Yes">
            <cfreturn "Charter School" />    
        <cfelseif #arguments.letter# eq "Peg">
            <cfreturn "Peg" />
        <cfelse>
            <cfreturn "" />
        </cfif>
</cffunction>            
      
<!--- Get School Type --->    
<cfscript>
    qrySchoolsType = queryNew(
                    'school_type',
                    'varChar',
                    [
                        {
                            school_type     :     'All'
                        },
                        {
                            school_type     :     'Charter School'
                        },
                        {
                            school_type     :     'Traditional Public School'
                        }
                    ]
                );
</cfscript>    
    
    
<!--- Set the two districts on page load in this case Dallas and Fort Worth ISD--->    
<cfparam name="variables.defaultDistrict1" default="Fort Worth ISD">
<cfparam name="variables.defaultDistrict2" default="Dalls ISD">

<!--- Set the initial search to false and qZipcode object to nothing--->
<cfset isSearch = false />
<cfset isDistrictAllSelected = false />
<cfset searchCounter = 0 />    
<cfset qZipCode = "" />
<cfset querySearchSQL = "" />     

<!--- Campus --->
<cfif structKeyExists(form,"campus") AND form.campus NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>
    
<!---Address --->
<cfif structKeyExists(form,"address") AND form.address NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>  

<!--- City --->
<cfif structKeyExists(form,"city") AND form.city NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>    

<!--- Radius --->    
<cfif structKeyExists(form,"radius") AND form.radius NEQ "" AND structKeyExists(form,"zip_code") AND form.zip_code NEQ "">
    <cfset radius = form.radius>
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />    
</cfif>

<!--- District --->    
<cfif structKeyExists(form,"district") AND form.district NEQ "">
    <cfset isSearch = true />
</cfif>

<!--- School Level --->    
<cfif structKeyExists(form,"school_level") AND form.school_level NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>

<!--- School Type --->    
<cfif structKeyExists(form,"charter_yes_and_no") AND form.charter_yes_and_no NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>

<!--- Grade --->    
<cfif structKeyExists(form,"letter_grade") AND form.letter_grade NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>
    
<!---If everything is checked and no search fields are filled in, display the message --->
<cfif isSearch>
    <cfif searchCounter eq 0>
    <cfif structKeyExists(form,"district") AND form.district EQ "All">
        <cfset isSearch = false />
        <cfset isDistrictAllSelected = true />
    </cfif>
    </cfif>    
</cfif>
    
    
<!--If form parameters were pass, invoke zipcode radius search-->
    
<cfif isSearch>
    <cfif IsNumeric(form.zip_code) AND form.radius NEQ "">
        <cfset qZipCode = zipRadiusObj.getZips(form.zip_code,form.radius) />
        <cfset listOfZipcodes = QuotedValueList(qZipCode.zip_code,",") />
    </cfif>    
</cfif> 
      

<!--- Select the school data to poplulate the map location variable --->
<cfquery name="qZipCode" datasource="tsgMysql"  CACHEDWITHIN="#CreateTimeSpan(0, 1, 0, 0)#" result="qrySchools">
    SELECT district, CASE WHEN school_level = 'E' THEN 'Elementary' WHEN school_level = 'H' THEN 'High' WHEN school_level = 'M' THEN 'Middle' ELSE '' END AS school_level, campus, id_number, zip_code, address, city, phone, letter_grade,
        latitude,
        longitude, charter_yes_and_no
        FROM schools
        WHERE 1=1
    <cfif isSearch>
        <!--- if zipcode radius was searched against --->
        <!--- If the zipcode is numeric, we then can filter by zipcodes--->
        <cfif IsNumeric(form.zip_code)>
            <cfif IsQuery(qZipCode)>
                AND zip_code in (#QuotedValueList(qZipCode.zip_code,",")#);
            </cfif>    
            <cfinclude template = "qrySearch.cfm">
        <cfelse>
            <!--- We can filter by all the other search critera--->
            <cfinclude template = "qrySearch.cfm">            
        </cfif>    
    <cfelse>
        AND district in ('Fort Worth ISD','Dallas ISD')
    </cfif>    
</cfquery>
            
    
<!--- Set the default zoom level of the map based on the first latitude and longtitude coordinates --->
<cfif qZipCode.recordcount GT 0>
        <cfoutput query="qZipCode" maxrows="1">
            <cfset mapzoom = "#latitude#,#longitude#" />
        </cfoutput>
    <cfelse>
        <cfset mapzoom = "32.73629703,-96.92390757" />
</cfif>       
    
<!--- Set the record counter to zero, this is make sure our location array does not crash with the extra comma, --->
<cfset recordcounter = 0 />
    
<!--- The maxcount is for the array loop for the location js variable --->
<cfset maxcount = qZipCode.recordcount />

<!--- Create an addressinfo variable to hold the address, city, state and zip to pass to the map popup--->
<cfset addressinfo = "" />

<!--- This code behind creates a javascript arry variable called location, which is essentialy the data pins for the mad to load--->
<cfsavecontent variable="location">
    var locations = [
    <cfoutput query="qZipCode">
	   <cfset addressinfo = #JSStringFormat(address)# & " " & #JSStringFormat(city)# & " " & #JSStringFormat(zip_code)# & "<br />" & #JSStringFormat(phone)# & "<br /><b>" & "(" & #convertSchoolType(charter_yes_and_no)# & ")" & " " & #JSStringFormat(convertLetterToSchoolLevel(school_level))# & "</b>" >
	   
	   <cfset recordcounter = recordcounter + 1>
        <cfif recordcounter NEQ maxcount>
	           ['#JSStringFormat(campus)# (#JSStringFormat(letter_grade)#)', #latitude#, #longitude#, #recordcounter#, '#JSStringFormat(letter_grade)#', '#JSStringFormat(addressinfo)#','#id_number#'],
	   <cfelse>
	           ['#JSStringFormat(campus)# (#JSStringFormat(letter_grade)#)', #latitude#, #longitude#, #recordcounter#, '#JSStringFormat(letter_grade)#', '#JSStringFormat(addressinfo)#','#id_number#'],
	   </cfif>
    </cfoutput>];
</cfsavecontent>

           
<!--- End CF code --->  
<!DOCTYPE html>
<html>
<!---     
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <title>jQuery DataTables – Row selection using checkboxes - jsFiddle demo by gyrocode</title>
  <script type='text/javascript' src='//code.jquery.com/jquery-1.11.0.js'></script>
  
 <link rel="stylesheet" href="assets/css/style.css" />
  <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.7/css/jquery.dataTables.min.css">
  <script type='text/javascript' src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
  <script type='text/javascript' src="https://cdnjs.cloudflare.com/ajax/libs/jquery-mockjax/1.6.2/jquery.mockjax.min.js"></script>
  <script type='text/javascript' src="assets/javascripts/jquery.fancybox.js"></script>
<link rel="stylesheet" href="assets/javascripts/jquery.fancybox.css" />    
    

    
  <style type='text/css'>
      table.dataTable.select tbody tr,
      table.dataTable thead th:first-child {
        cursor: pointer;
      }
      
      .dataTables_length{
          position: relative;
          left:100px;
          text-align: center;
      }
      
      .dataTables_filter{
          position: relative;
          right: 50px;
          
      }
      
      .dataTables_info{
          
          position: relative;
          left: 50px;
      }
  </style>
</head> --->
    
<head>
		<meta charset='utf-8'/>
		<title>Colorbox Examples</title>
<link rel="stylesheet" href="assets/css/style.css" />
<link rel="stylesheet" href="assets/css/colorbox.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.7/css/jquery.dataTables.min.css">
<script type='text/javascript' src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
<script type='text/javascript' src="https://cdnjs.cloudflare.com/ajax/libs/jquery-mockjax/1.6.2/jquery.mockjax.min.js"></script>
<script src="assets/javascripts/jquery.colorbox.js"></script>
    
<!-- Important Owl stylesheet -->
<link rel="stylesheet" href="assets/javascripts/owl-carousel/owl.carousel.css">
 
<!-- Default Theme -->
<link rel="stylesheet" href="assets/javascripts/owl-carousel/owl.theme.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

 
<!-- Include js plugin -->
<script src="assets/javascripts/owl-carousel/owl.carousel.js"></script>    
   
    <script>
			$(document).ready(function(){
				//Examples of how to assign the Colorbox event to elements
				$(".iframe").colorbox({iframe:true, width:"80%", height:"80%"});
                
                // Slider Intro
		// Foundation Init
		//$(document).foundation();
        
       

		// Fullscreener
		//$('.fullscreener img').fullscreener();

		// Progressbar
		$('.progressbar-inner').each(function() {
			var width = $(this).data('progress');

			$(this).width(width + '%');
		});

		// Slider Intro
		$('.slider-intro .slides').owlCarousel({
			loop: true,
			autoplay: 5000,
			autoplayHoverPause : true,
			autoplayTimeout: 5000,
			smartSpeed: 500,
			nav: true,
			navContainer: '.slider-intro .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1,
			margin: 0
		});

                
                
                //Tabs
                
        $('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	       });
        
       
                
			});
		</script>
   
	</head>    
<body>
    

<div class="wrapper">
        <cfinclude template="header.cfm">
        	<div class="slider-intro">
		<div class="slider-clip">
			<ul class="slides owl-carousel">
				<li class="slide">
					<div class="slide-image fullscreener">
						<img src="http://themes.wplook.com/html/charity/assets/images/temp/slider-intro-image2.jpg" height="890" width="1800" alt="">
					</div><!-- /.slide-image -->

					<div class="slide-content">
						<div class="row">
							<div class="columns large-7">
								<h2 class="slide-title">Send Childrens To School</h2><!-- /.slide-title -->

								<div class="slide-entry">
									<p>Integer sit amet augue iaculis, ultricies justo nec, commodo nisi. Class taciti sociosqu ad litora torquent per conubia nostra</p>
								</div><!-- /.slide-entry -->
							</div><!-- /.columns large-7 -->

							<div class="columns large-5">
								<div class="slide-aside">
									<div class="slide-tag">Urgent Cause</div><!-- /.slide-tag -->

									<div class="slide-progress">
										<div class="slide-raised">
											<span>Raised</span>

											<strong>$56,354</strong>
										</div><!-- /.slide-raised -->

										<div class="slide-to-go">
											<span>To Go</span>

											<strong>$1,15,699</strong>
										</div><!-- /.slide-to-go -->
									</div><!-- /.slide-progress -->

									<div class="slide-actions">
										<a href="#">Donate Now</a>
									</div><!-- /.slide-actions -->
								</div><!-- /.slide-aside -->
							</div><!-- /.columns large-5 -->
						</div><!-- /.row -->
					</div><!-- /.slide-content -->
				</li><!-- /.slide -->
                <li class="slide">
					<div class="slide-image fullscreener">
						<img src="http://themes.wplook.com/html/charity/assets/images/temp/slider-intro-image.jpg" height="890" width="1800" alt="">
					</div><!-- /.slide-image -->

					<div class="slide-content">
						<div class="row">
							<div class="columns large-7">
								<h2 class="slide-title">Send Childrens To School</h2><!-- /.slide-title -->

								<div class="slide-entry">
									<p>Integer sit amet augue iaculis, ultricies justo nec, commodo nisi. Class taciti sociosqu ad litora torquent per conubia nostra</p>
								</div><!-- /.slide-entry -->
							</div><!-- /.columns large-7 -->

							<div class="columns large-5">
								<div class="slide-aside">
									<div class="slide-tag">Urgent Cause</div><!-- /.slide-tag -->

									<div class="slide-progress">
										<div class="slide-raised">
											<span>Raised</span>

											<strong>$56,354</strong>
										</div><!-- /.slide-raised -->

										<div class="slide-to-go">
											<span>To Go</span>

											<strong>$1,15,699</strong>
										</div><!-- /.slide-to-go -->
									</div><!-- /.slide-progress -->

									<div class="slide-actions">
										<a href="#">Donate Now</a>
									</div><!-- /.slide-actions -->
								</div><!-- /.slide-aside -->
							</div><!-- /.columns large-5 -->
						</div><!-- /.row -->
					</div><!-- /.slide-content -->
				</li><!-- /.slide -->


			</ul><!-- /.slides -->
		</div><!-- /.slider-clip -->
		
		<div class="slider-actions"></div><!-- /.slider-actions -->
	</div><!-- /.slider-intro -->
        <cfinclude template="searchtab.cfm">
        <div id="map" style="width: 100%; height: 450px;" class="post-map"></div>
        <cfinclude template="schooltable.cfm">
        <cfinclude template="learnmoresection.cfm">
        <cfinclude template="eventssection.cfm">   
        <cfinclude template="testimonials.cfm">
        <cfinclude template="callout.cfm" />
        <cfinclude template="footer.cfm" />
        
</div>
      
    
<!-- Start map legend section -->                
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>   
    
    
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
		
          infowindow.setContent('<a class="iframe" target="_new" href=profile.cfm?id_number=' + locations[i][6] + '><b>' + locations[i][0] + '</b></a><br>' + locations[i][5]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
   </script> 
        
        
</cfoutput>   
<script>
        
    
   // Array holding selected row IDs
   var rows_selected = [];
   var table = $('#example').DataTable({
       "oLanguage": {
        "sInfoEmpty": 'No schools to show',
        "sEmptyTable": "No schools found currently, please add at least one.",
       },
        "pageLength": 25,
      'columnDefs': [{
         'targets': 0,
         'searchable':false,
         'orderable':false,
         'className': 'dt-body-center',
         'render': function (data, type, full, meta){
             return '<input type="checkbox">';
         }
      }],
      'order': [1, 'asc'],
      'rowCallback': function(row, data, dataIndex){
         // Get row ID
         var rowId = data[0];

         // If row ID is in the list of selected row IDs
         if($.inArray(rowId, rows_selected) !== -1){
            $(row).find('input[type="checkbox"]').prop('checked', true);
            $(row).addClass('selected');
         }
      }
   });   

    // Handle click on checkbox
   $('#example tbody').on('click', 'input[type="checkbox"]', function(e){
      var $row = $(this).closest('tr');

      // Get row data
      var data = table.row($row).data();

      // Get row ID
      var rowId = data[0];
       
      // Determine whether row ID is in the list of selected row IDs 
      var index = $.inArray(rowId, rows_selected);

      // If checkbox is checked and row ID is not in list of selected row IDs
      if(this.checked && index === -1){
         rows_selected.push(rowId);

      // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
      } else if (!this.checked && index !== -1){
         rows_selected.splice(index, 1);
      }


      // Prevent click event from propagating to parent
      e.stopPropagation();
   });
    
     // Handle form submission event 
   $('#frm-example').on('submit', function(e){
      var form = this;
       
       

      // Iterate over all selected checkboxes
      $.each(rows_selected, function(index, rowId){
          
         // Create a hidden element 
         $(form).append(
             $('<input>')
                .attr('type', 'hidden')
                .attr('name', 'id[]')
                .val(rowId)
         );
      });

      // FOR DEMONSTRATION ONLY     
      
      // Output form data to a console     
      $('#example-console').text($(form).serialize());
      console.log("Form submission", $(form).serialize());
       var myLink = "http://127.0.0.1:8500/tsgv3/compare.cfm?" + $(form).serialize();
       $("#w3s").attr("href", myLink);
       $("#w3s")[0].click();
       
      // Remove added elements
      $('input[name="id\[\]"]', form).remove();
       
      // Prevent actual form submission
      e.preventDefault();
   });
    
</script>
    
            
</body>
</html>

