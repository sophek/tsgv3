
<cfset zipRadiusObj = CreateObject("component","Zipcoderadiussearch") />
    
<!--- Set default form parameters to pass into the search filter. --->
<cfparam name="form.zip_code" default="">
<cfparam name="form.radius" default="">
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


<!DOCTYPE HTML>
<html lang="en-GB">
    
    
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Texas School Guide</title>
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.ico" />
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic">
	<link rel="stylesheet" href="assets/css/style.css" />
     <script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
     <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js" type="text/javascript"></script>
    <script src="jquery.cookie.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../examples-style.css">
    <style type="text/css" title="currentStyle"> 
	@import "demo_page.css";
	@import "demo_table.css";
</style>
    
    <style>
		.container{
			width: 100%;
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
</head>

<body>


  

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.js"></script>

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

	<cfinclude template="header.cfm">
	<cfinclude template="partial-home-section.cfm">
        
        




<div class="container">

	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">School</li>
		<li class="tab-link" data-tab="tab-2">District</li>
		<li class="tab-link" data-tab="tab-3">Grade</li>
		<li class="tab-link" data-tab="tab-4">School Level</li>
        <li class="tab-link" data-tab="tab-5">School Type</li>
        <li class="tab-link" data-tab="tab-6">Address</li>
        <li class="tab-link" data-tab="tab-7">City</li>
        <li class="tab-link" data-tab="tab-8">Zip code</li>
	</ul>
<form action="sample.cfm" method="post">
    <!-- Tab 1 -->
	<div id="tab-1" class="tab-content current">
		<div class="subscribe">
            <div class="subscribe-inner">
			     <input type="text" id="campus" name="campus" value="<cfoutput>#form.campus#</cfoutput>" placeholder="Enter School Name" class="subscribe-field">
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 2 -->
	<div id="tab-2" class="tab-content">
        <div class="subscribe">
            <div class="subscribe-inner">
                <cfinclude template="selectDistrict.cfm">
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 3 -->
	<div id="tab-3" class="tab-content">
		 <div class="subscribe">
             <div class="subscribe-inner">
                 
                  <cfoutput>
                                    <select multiple name="letter_grade" style="" class="name_search form-control">
                                        <option value=''>Please select a grade. Hold the shift key to select more than 1 grade.</option>
                                        <option value="All" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "All">selected</cfif>>All</option>
                                        <option value="A+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A+">selected</cfif>>A+</option>
                                        <option value="A" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A">selected</cfif>>A</option>
                                        <option value="A-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A-">selected</cfif>>A-</option>
                                        <option value="B+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B+">selected</cfif>>B+</option>
                                        <option value="B" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B">selected</cfif>>B</option>
                                        <option value="B-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B-">selected</cfif>>B-</option>
                                        <option value="C+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C+">selected</cfif>>C+</option>
                                        <option value="C" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C">selected</cfif>>C</option>
                                        <option value="C-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C-">selected</cfif>>C-</option>
                                        <option value="D" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "D">selected</cfif>>D</option>
                                        <option value="F" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "F">selected</cfif>>F</option>
                                        <option value="Not Available">Not Available</option>
                                        </select>
                                    </cfoutput>
                 
                 
			     
             </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 4 -->    
	<div id="tab-4" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
                <select name="school_level" class="name_search form-control">
                <option value=''>Select Elementary, Middle or High School</option>
                <option value='All'>All</option>
		        <option value="E" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "E">selected</cfif></cfoutput>>Elementary School</option>
		        <option value="M" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "M">selected</cfif></cfoutput>>Middle School</option>
		        <option value="H" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "H">selected</cfif></cfoutput>>High School</option>
		      </select>
            </div>			
        </div>
	</div>
    <!-- Tab 5 -->
    <div id="tab-5" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
            <select name="charter_yes_and_no" class="name_search form-control">
            <option value=''>Select Magnet, Charter or Public School</option>
            <option value="All" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "All">selected</cfif></cfoutput>>All</option>
		    <option value="Peg" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Peg">selected</cfif></cfoutput>>Magnet School</option>
		    <option value="Yes" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Yes">selected</cfif></cfoutput>>Charter School</option>
		    <option value="No" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "No">selected</cfif></cfoutput>>Traditional Public School</option>
		    </select>
        </div><!-- /.subscribe-inner -->
        </div>
	</div>
        
    <!-- Tab 6 -->    
    <div id="tab-6" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
                <input type="text" id="address" name="address" value="<cfoutput>#form.address#</cfoutput>" placeholder="Address" class="subscribe-field">
            </div>
        </div>
	</div>
    <!-- Tab 7 -->
    <div id="tab-7" class="tab-content">
        <div class="subscribe">
		      <div class="subscribe-inner">
			         <input type="text" id="city" name="city" value="<cfoutput>#form.city#</cfoutput>" placeholder="City" class="subscribe-field">
              </div>
        </div>
	</div>
    <!-- Tab 8 -->
    <div id="tab-8" class="tab-content">
		<div class="subscribe">
			<div class="subscribe-inner">
			     <input type="text" id="zip_code" name="zip_code" value="<cfoutput>#form.zip_code#</cfoutput>" placeholder="Zip code" class="subscribe-field">
                <div class="form-group">
							<label class="control-label">Within - by Miles:</label>
							<select name="radius" class="name_search form-control">
                                <option value=''>- Select Miles - </option>
                                <option value="2" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "2">selected</cfif></cfoutput>>2 Miles</option>
                                <option value="5" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "5">selected</cfif></cfoutput>>5 Miles</option>
                                <option value="10" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "10">selected</cfif></cfoutput>>10 Miles</option>
                                <option value="20" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "20">selected</cfif></cfoutput>>20 Miles</option>
                            </select>
						      </div>
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
<div class="subscribe" style="float:left;position:relative;left:25px">
    <input type="submit" value="Search" class="subscribe-btn">  
</div>    
    </form>
</div>


<div id="map" style="width: 100%; height: 450px;" class="post-map"></div>
     <table cellpadding="0" cellspacing="0" border="0" class="display" id="displayData" cellspacing="0" width="100%"> 
	<thead>
		<tr>
			<th align="left">Code</th>
			<th align="left">Location</th>
            <th align="left">Location</th>
            <th align="left">Location</th>
            <th align="left">Location</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="5" class="dataTables_empty">Loading data from server</td> 
		</tr>
	</tbody>
</table>
<!-- container -->

<section class="section-featured">
		<div class="row">
			<div class="columns small-12">
				<header class="section-head">
					<h2 class="section-title">Learn More</h2><!-- /.section-title -->	
			
					<div class="section-image">
						<img src="assets/images/temp/ico-droplet.png" height="22" width="14" alt="">
					</div><!-- /.section-image -->
			
				</header><!-- /.section-head -->
			
				<div class="section-body">
					<div class="slider-featured">
						<div class="slider-clip">
							<ul class="slides owl-carousel">
								<li class="slide">
									<div class="slide-image">
										<img src="assets/images/learn1.jpg" height="175" width="270" alt="">
			
										<div class="slide-overlay">
											<div class="slide-overlay-inner">
												<a href="#" class="button button-white">Donate Now</a>
											</div><!-- /.slide-overlay-inner -->
										</div><!-- /.slide-overlay -->
									</div><!-- /.slide-image -->
			
									<div class="slide-content">
										<h3>Who we are / What we do</h3>
										
										<p>CHILDREN AT RISK is a nonprofit organization that drives change for children through research, education and influencing public policy. Some of our causes includes: Public Education, Human Trafficking, Health and Nutrition and Parenting.  We believe that quality education is the pathway for children to pull themselves out of poverty and into the American middle class. CHILDREN AT RISK has researched and produced results and reports on several issues that affect the educational achievement and attainment of students in Texas, from the effects of statewide education budget cuts to the release of our annual school rankings.</p>
									</div><!-- /.slide-content -->
			
								</li><!-- /.slide -->
							
								<li class="slide">
									<div class="slide-image">
										<img src="assets/images/learn2.jpg" height="175" width="270" alt="">
			                             <div class="slide-overlay">
											<div class="slide-overlay-inner">
												<a href="mailto:TexasSchoolGuide@childrenatrisk.org" class="button button-white">Email Us</a>
											</div><!-- /.slide-overlay-inner -->
										</div><!-- /.slide-overlay -->
									</div><!-- /.slide-image -->
			
									<div class="slide-content">
										<h3>Feedback </h3>
                                        <p>We would love to hear from you! If you would like to update your school information, offer a testimonial on how the guide has helped you, provide information on how we can make this resource helpful to parents, or find a copy of the Texas School Guide, please send an email to: TexasSchoolGuide@childrenatrisk.org.</p>
									</div><!-- /.slide-content -->
			
								</li><!-- /.slide -->
							
								<li class="slide">
									<div class="slide-image">
										<img src="assets/images/learn3.jpg" height="175" width="269" alt="">
			
										<div class="slide-overlay">
											<div class="slide-overlay-inner">
												<a href="#" class="button button-white">Donate Now</a>
											</div><!-- /.slide-overlay-inner -->
										</div><!-- /.slide-overlay -->
									</div><!-- /.slide-image -->
			
									<div class="slide-content">
										<h3>Resources </h3>
                                        <p>The Texas School Guide also contains several resources that will provide you with information surrounding the education and well-being of children, from quality child care centers and indicators, to higher education resources, district websites, public libraries and other nonprofit agencies as well as journals (Journal of Applied Research on Children and Journal of Family Strengths).</p>
									</div><!-- /.slide-content -->
			
								</li><!-- /.slide -->
                                <li class="slide">
									<div class="slide-image">
										<img src="assets/images/learn4.jpg" height="175" width="269" alt="">
			
										<div class="slide-overlay">
											<div class="slide-overlay-inner">
												<a href="#" class="button button-white">Donate Now</a>
											</div><!-- /.slide-overlay-inner -->
										</div><!-- /.slide-overlay -->
									</div><!-- /.slide-image -->
			
									<div class="slide-content">
										<h3>Parent Action Guides </h3>
                                        <p>The Parent Action Guides provide detailed information to parents and guardians for every stage of the growing child: from early childhood, through the elementary and middle school years and then to higher and post-secondary education. Components of the Action Guides includes: Parent and Family Involvement, Early childhood education and Higher Education</p>
									</div><!-- /.slide-content -->
			
								</li><!-- /.slide -->
						
							</ul><!-- /.slides -->
						</div><!-- /.slider-clip -->
						
						<div class="slider-actions"></div><!-- /.slider-actions -->
					</div><!-- /.slider-featured -->
				</div><!-- /.section-body -->
			</div><!-- /.columns small-12 -->
		</div><!-- /.row -->
	</section><!-- /.section-featured -->
   <section class="section-updates">
		<div class="row">
		
			
			<div class="columns large-6">
				<section class="section-upcoming-event">
					<header class="section-head">
						<h3 class="section-title">Upcoming Event</h3><!-- /.section-title -->
		
						<div class="section-head-actions">
							<a href="#" class="button button-facebook">
								<i class="fa fa-facebook"></i> Facebook Page
							</a>
						</div><!-- /.section-head-actions -->
					</header><!-- /.section-head -->
		
					<div class="section-body">
						<div class="event-alt" itemscope itemtype="https://schema.org/Event">
							<div class="event-image">
								<a href="#">
									<img src="assets/images/calendar.jpg" height="293" width="528" alt="" itemprop="image">
								</a>
							</div><!-- /.event-image -->
		
							<h4 class="event-title">
								<a href="#" itemprop="name">Organizing Music Event To Get Good Donation</a>
							</h4><!-- /.event-title -->
		
							<div class="event-meta">
								<span>
									<i class="fa fa-user"></i> Admin
								</span>
								
								<span>
									<i class="fa fa-calendar"></i> May 7, 2015 at 2:00 PM
								</span>
								
								<span>
									<i class="fa fa-map-marker"></i> Montreal, QC.
								</span>
							</div><!-- /.event-meta -->
		
							<div class="event-entry" itemprop="description">
								<p>Donec varius ultrices purus. Nullam sit amet sapien tortor. Aenean tincidunt inte rdum felis, vel placerat purus porta nec.</p>
							</div><!-- /.event-entry -->
						</div><!-- /.event-alt -->
					</div><!-- /.section-body -->
				</section><!-- /.section-upcoming-event -->
			</div><!-- /.columns large-6 -->
		</div><!-- /.row -->
	</section><!-- /.section-updates -->

			</div><!-- /.columns large-6 -->
		</div><!-- /.row -->
	</section>
    	<section class="section-testimonials">
		<div class="section-body">
			<div class="slider-testimonials">
				<div class="row">
					<div class="slider-clip">
						<ul class="slides owl-carousel">
							<li class="slide">
								<div class="slide-entry">
									<p>
										Phasellus vitae diam pulvinar, tempus diam et, aliquam tellus. Quisque mattis odio eu placerat luctus. <br>
										Vivamus magna elit, ultrices non lacinia vel, tempor vitae tellus. Fusce sit amet sem sit <br>
										amet risus fringilla dapibus sed sit amet odio. 
									</p>
								</div><!-- /.slide-entry -->
					
								<div class="slide-foot">
									<p>Victor Tihai, WPlook Studio</p>
								</div><!-- /.slide-foot -->
							</li><!-- /.slide -->
						
							<li class="slide">
								<div class="slide-entry">
									<p>
										Phasellus vitae diam pulvinar, tempus diam et, aliquam tellus. Quisque mattis odio eu placerat luctus. <br>
										Vivamus magna elit, ultrices non lacinia vel, tempor vitae tellus. Fusce sit amet sem sit <br>
										amet risus fringilla dapibus sed sit amet odio. 
									</p>
								</div><!-- /.slide-entry -->
					
								<div class="slide-foot">
									<p>Diana Tihai, WPlook Studio</p>
								</div><!-- /.slide-foot -->
							</li><!-- /.slide -->
						
							<li class="slide">
								<div class="slide-entry">
									<p>
										Phasellus vitae diam pulvinar, tempus diam et, aliquam tellus. Quisque mattis odio eu placerat luctus. <br>
										Vivamus magna elit, ultrices non lacinia vel, tempor vitae tellus. Fusce sit amet sem sit <br>
										amet risus fringilla dapibus sed sit amet odio. 
									</p>
								</div><!-- /.slide-entry -->
					
								<div class="slide-foot">
									<p>Johnathan Doe, WPlook Studio</p>
								</div><!-- /.slide-foot -->
							</li><!-- /.slide -->
						</ul><!-- /.slides -->
					</div><!-- /.slider-clip -->
				</div><!-- /.row -->
			</div><!-- /.slider-testimonials -->
		</div><!-- /.section-body -->
	</section><!-- /.section-testimonials -->


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



	<cfinclude template="callout.cfm" />
    <cfinclude template="footer.cfm" />
</div><!-- /.wrapper -->
            
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
            
<script src="assets/javascripts/vendor.js"></script>
<script src="assets/javascripts/app.js"></script>
    
<script language="javascript" src="dataTables.js"></script>

<script type="text/javascript" charset="utf-8">
$(document).ready(function() {
				$('#displayData').dataTable( {
					"bProcessing": true,
					"bStateSave": true,
					"bServerSide": true,
					"sAjaxSource": "handler.cfm",
					"aoColumns": [ 
								{ "sName": "campus", "sTitle": "Campus", "sWidth": "30%", "bSortable": "true" },
								{ "sName": "district", "sTitle": "District", "sWidth": "20%", "bSortable": "true" },
                                { "sName": "city", "sTitle": "City", "sWidth": "20%", "bSortable": "true" },
                                { "sName": "school_level", "sTitle": "School Level", "sWidth": "20%", "bSortable": "true" },
                                { "sName": "letter_grade", "sTitle": "Grade", "sWidth": "10%", "bSortable": "true"}
                        

					],
                    
					"sPaginationType": "full_numbers",
					"aaSorting": [[1,'asc']],
					"oLanguage": {
						"sLengthMenu": "Page length: _MENU_",
						"sSearch": "Filter:",
						"sZeroRecords": "No matching records found"
								},

					"fnServerData": function ( sSource, aoData, fnCallback ) {

						aoData.push(
							{ "name": "table", "value": "schools" },
							{ "name": "sql", "value": "SELECT district, school_level, campus, id_number, zip_code, address, city, phone, letter_grade, latitude, longitude, charter_yes_and_no" },
                            { "name": "campus", "value": "<cfoutput>#form.campus#</cfoutput>" },
                            { "name": "district", "value": "<cfoutput>#form.district#</cfoutput>" },
                            { "name": "school_level", "value": "<cfoutput>#form.school_level#</cfoutput>" },
                            { "name": "letter_grade", "value": "<cfoutput>#form.letter_grade#</cfoutput>" },
                            { "name": "city", "value": "<cfoutput>#form.city#</cfoutput>" },
                            { "name": "address", "value": "<cfoutput>#form.address#</cfoutput>" }
						);

						$.ajax( {"dataType": 'json',
								 "type": "POST",
								 "url": sSource,
								 "data": aoData,
								 "success": fnCallback} );
						}
				} );
			} );
</script>
    
    
</body>
</html>