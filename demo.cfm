
<cfset zipRadiusObj = CreateObject("component","Zipcoderadiussearch") />
    
<!--- Set default form parameters to pass into the search filter. --->
<cfparam name="form.zip_code" default="">
<cfparam name="form.radius" default="">
<cfparam name="form.campus" default="">
<cfparam name="form.address" default="">
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

<cfif structKeyExists(form,"campus") AND form.campus NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>
    
<cfif structKeyExists(form,"radius") AND form.radius NEQ "" AND structKeyExists(form,"zip_code") AND form.zip_code NEQ "">
    <cfset radius = form.radius>
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />    
</cfif>
    
<cfif structKeyExists(form,"district") AND form.district NEQ "">
    <cfset isSearch = true />
</cfif>

<cfif structKeyExists(form,"school_level") AND form.school_level NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>

<cfif structKeyExists(form,"charter_yes_and_no") AND form.charter_yes_and_no NEQ "">
    <cfset isSearch = true />
    <cfset searchCounter = searchCounter + 1 />
</cfif>
    
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
        <cfset qZipCode = zipRadiusObj.getZips(form.zip_code,form.radius)>
    </cfif>    
</cfif> 

<!--- Select the school data to poplulate the map location variable --->
<cfquery name="qZipCode" datasource="tsgMysql"  CACHEDWITHIN="#CreateTimeSpan(0, 1, 0, 0)#">
    SELECT district, school_level, campus, id_number, zip_code, address, city, phone, letter_grade,
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
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Charity Foundation - Premium HTML Template</title>
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.ico" />
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic">
	<link rel="stylesheet" href="assets/css/style.css" />
     <script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
     <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  
</head>
<body>
    <div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.4";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
</script>
<div class="wrapper">
	<div class="bar">
		<div class="row">
			<div class="columns small-12">
				<p class="bar-phone">
					 <strong>English / Espanol</strong>
				</p><!-- /.bar-phone -->
				
				<div class="bar-socials">
					<ul>
						
						<li>
							<a href="#">
								<i class="fa fa-facebook"></i>
							</a>
						</li>
						
						<li>
							<a href="#">
								<i class="fa fa-twitter"></i>
							</a>
						</li>
						
						<li>
							<a href="#">
								<i class="fa fa-google-plus"></i>
							</a>
						</li>
						
						<li>
							<a href="#">
								<i class="fa fa-linkedin"></i>
							</a>
						</li>
                        <li>
                        <div class="fb-like" data-href="http://www.texasschoolguide.org/" data-layout="button_count" data-action="like" data-show-faces="true" data-share="true"></div>
                        </li>
					</ul>
				</div><!-- /.bar-socials -->
			</div><!-- /.columns small-12 -->
		</div><!-- /.row -->
	</div><!-- /.bar -->

	<header class="header">
		<div class="row">
			<div class="columns small-12"><a href="#" class="header-logo">
					<img src="http://www.texasschoolguide.org/images/tsg-logo.jpg" alt="Charity | Foundation">
    			</a>
				<div class="header-inner">
					<a href="#" class="button-burger">
						<span></span>
					</a>
				
					<nav class="nav">
						<ul>
							<li>
								<a href="demo.html">About the Project</a>
							</li>

							<li>
								<a href="page.html">Parent Action Guides</a>
								<ul>
									<li>
										<a href="page-elements.html">HTML Elements</a>
									</li>

									<li>
										<a href="page-404.html">404 Error Page</a>
									</li>
								</ul>
							</li>

							<li>
								<a href="causes.html">Schedule a Workshop</a>
								<ul>
									<li><a href="causes-detail.html">Single Cause</a></li>
								</ul>
							</li>
							
							<li>
								<a href="event.html">FAQ </a>
								<ul>
									<li><a href="event-detail.html">Single Event</a></li>
								</ul>
							</li>
							
							<li>
								<a href="blog.html">Testimonials </a>
								<ul>
									<li>
										<a href="blog-detail.html">Single Post</a>
									</li>
								</ul>
							</li>
							
							<li>
								<a href="staff.html">Contact Us</a>
							</li>
						</ul>
					</nav><!-- /.nav -->
				
					<div class="header-actions">
						<a href="page-donate.html" class="button">Donate</a>
					</div><!-- /.header-actions -->
				</div><!-- /.header-inner --></div><!-- /.columns small-12 -->
		</div><!-- /.row -->
	</header><!-- /.header -->


    <style>
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
		<li class="tab-link" data-tab="tab-4">School Level & Type</li>
        <li class="tab-link" data-tab="tab-5">Address & City</li>
        <li class="tab-link" data-tab="tab-6">Zip code</li>
	</ul>

	<div id="tab-1" class="tab-content current">
		<div class="subscribe">
								<form action="demo.cfm" method="post">
									<input type="submit" value="Go" class="subscribe-btn">
									
									<div class="subscribe-inner">
										<input type="text" id="campus" name="campus" value="<cfoutput>#form.campus#</cfoutput>" placeholder="Enter School Name" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-2" class="tab-content">
		 <div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
										<input type="text" id="district" name="district" value="<cfoutput>#form.district#</cfoutput>" placeholder="District" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-3" class="tab-content">
		 <div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
										<input type="text" id="letter_grade" name="letter_grade" value="<cfoutput>#form.letter_grade#</cfoutput>" placeholder="Grade" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-4" class="tab-content">
		<div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
                                        
                           
                                        
                                        
                                        <select name="school_level" class="name_search form-control">
                                <option value=''></option>
                                <option value='All'>All</option>
		                          <option value="E" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "E">selected</cfif></cfoutput>>Elementary School</option>
		                          <option value="M" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "M">selected</cfif></cfoutput>>Middle School</option>
		                          <option value="H" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "H">selected</cfif></cfoutput>>High School</option>
		                      </select>
        <select name="charter_yes_and_no" class="name_search form-control">
                                <option value=''></option>
                                <option value="All" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "All">selected</cfif></cfoutput>>All</option>
		                          <option value="Peg" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Peg">selected</cfif></cfoutput>>Magnet School</option>
		                          <option value="Yes" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Yes">selected</cfif></cfoutput>>Charter School</option>
		                          <option value="No" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "No">selected</cfif></cfoutput>>Traditional Public School</option>
		                      </select>
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
    <div id="tab-5" class="tab-content">
		<div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
										<input type="text" id="address" name="address" value="<cfoutput>#form.address#</cfoutput>" placeholder="Address" class="subscribe-field">
                                        <input type="text" id="city" name="city" value="<cfoutput>#form.zip_code#</cfoutput>" placeholder="City" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
    <div id="tab-6" class="tab-content">
		<div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
										<input type="text" id="zip_code" name="zip_code" value="<cfoutput>#form.zip_code#</cfoutput>" placeholder="Zip code" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
    <div>
    <!-- Start Map display -->                
    <div id="map" style="width: 600px; height: 400px;" class="post-map"></div>
    <!-- End Map display -->
   <iframe src="sample.cfm" width="600px" height="600px"></iframe>      
    
    </div>
</div>
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
})
</script>

<div class="callout">
		<div class="row">
			<div class="columns large-6">
				<h2 class="callout-title">Change Their World. Change Yours. This changes everything.</h2><!-- /.callout-title -->
			</div><!-- /.columns large-6 -->
			
			<div class="columns large-6">
				<div class="callout-actions">
					<a href="#" class="button">Advocate </a>

					<span class="callout-separator">
						<span>Or</span>
					</span>

					<a href="#" class="button">Donate </a>
				</div><!-- /.callout-actions -->
			</div><!-- /.columns large-6 -->
		</div><!-- /.row -->
	</div><!-- /.callout -->

	<footer class="footer">
		<div class="footer-body">
			<div class="row">
				<div class="columns large-3 medium-12">
					<div class="footer-section">
						<h4 class="footer-section-title">About Us</h4><!-- /.footer-section-title -->
						
						<div class="footer-section-body">
							<p>CHILDREN AT RISK is a nonprofit organization that drives change for children through research, education and influencing public policy.</p>
						</div><!-- /.footer-section-body -->
					</div><!-- /.footer-section -->
				</div><!-- /.columns large-3 medium-12 -->
				
				<div class="columns large-3 medium-12">
					<div class="footer-section">
						<h4 class="footer-section-title">Quick Links</h4><!-- /.footer-section-title -->
						
						<div class="footer-section-body">
							<ul class="list-links">
								<li>
									About the Project
								</li>
								
								<li>
									Parent Action Guides
								</li>
								
								<li>
									Schedule a Workshop
								</li>
								
								<li>
									Faq
								</li>
								
								<li>
									Testimonials
								</li>
								
								<li>
									Contact Us
								</li>
							</ul><!-- /.list-links -->
						</div><!-- /.footer-section-body -->
					</div><!-- /.footer-section -->
				</div><!-- /.columns large-3 medium-12 -->
				
				<div class="columns large-3 medium-12">
					<div class="footer-section">
						<h4 class="footer-section-title">Newsletter Signup</h4><!-- /.footer-section-title -->
						
						<div class="footer-section-body">
							<p>Select your newsletters, enter your email address, and click "Subscribe"</p>

							<div class="subscribe">
								<form action="?" method="post">
									<input type="submit" value="Go" class="subscribe-btn">
									
									<div class="subscribe-inner">
										<input type="email" id="mail" name="mail" value="" placeholder="Email Address" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div><!-- /.subscribe -->
						</div><!-- /.footer-section-body -->
					</div><!-- /.footer-section -->
				</div><!-- /.columns large-3 medium-12 -->
				
				<div class="columns large-3 medium-12">
					<div class="footer-section">
						<h4 class="footer-section-title">Contact Us</h4><!-- /.footer-section-title -->
						
						<div class="footer-section-body">
							<p><b>CHILDREN AT RISK:</b> North Texas Office 2900 Live Oak St. Dallas, TX 75204</p>

							<div class="footer-contacts">
								<p>
									<span>
										<i class="fa fa-phone"></i> Phone:
									</span>
                                        214-599-0072
								</p>
								
								<p>
									<span>
										<i class="fa fa-envelope-o"></i> Email:
									</span>

									<a href="#">TexasSchoolGuide@childrenatrisk.org</a>
								</p>
							</div><!-- /.footer-contacts -->
                            
                            <h4 class="footer-section-title">&nbsp;&nbsp;&nbsp;&nbsp;</h4><!-- /.footer-section-title -->
                            
                            <p><b>CHILDREN AT RISK:</b> Houston Office 2900 Weslayan Suite 400 Houston, Texas 77027</p>

							<div class="footer-contacts">
								<p>
									<span>
										<i class="fa fa-phone"></i> Phone:
									</span>
                                        713-869-7740 
								</p>
								<p>
									<span>
										<i class="fa fa-fax"></i> Fax:
									</span>
                                        713-869-3409 
								</p>
								<p>
									<span>
										<i class="fa fa-envelope-o"></i> Email:
									</span>

									<a href="#">TexasSchoolGuide@childrenatrisk.org</a>
								</p>
							</div>
                            
						</div><!-- /.footer-section-body -->
					</div><!-- /.footer-section -->
				</div><!-- /.columns large-3 medium-12 -->
			</div><!-- /.row -->
		</div><!-- /.footer-body -->

		<div class="footer-bar">
			<div class="row">
				<div class="columns small-12">
					<div class="footer-credits">
						<p>
							Copyright 2015. All Rights Reserved by Charity Theme. Designed by <a href="https://wplook.com">WPlook Studio</a>
						</p>
					</div><!-- /.footer-credits -->
					
					<div class="footer-socials">
						<ul>					
							<li>
								<a href="#">
									<i class="fa fa-facebook"></i>
								</a>
							</li>
							
							<li>
								<a href="#">
									<i class="fa fa-twitter"></i>
								</a>
							</li>
							
							<li>
								<a href="#">
									<i class="fa fa-google-plus"></i>
								</a>
							</li>
							
							<li>
								<a href="#">
									<i class="fa fa-linkedin"></i>
								</a>
							</li>
						</ul>
					</div><!-- /.footer-socials -->
				</div><!-- /.columns small-12 -->
			</div><!-- /.row -->
		</div><!-- /.footer-bar -->
	</footer><!-- /.footer -->
</div><!-- /.wrapper -->
  
    
<script src="assets/javascripts/vendor.js"></script>
<script src="assets/javascripts/app.js"></script>
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
    
    
</body>
</html>

