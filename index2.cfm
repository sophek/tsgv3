
        

<cfset zipRadiusObj = CreateObject("component","Zipcoderadiussearch") />


<!--- Set default form parameters to pass into the search filter. --->
<cfset zip = "" />
<cfset radius = "5" />

<cfif isdefined("url.zip") AND url.zip NEQ "">
    <cfset zip="#url.zip#" />
    <cfset radius="20" />
<!-- Query for the zipcode -->    
    <cfquery name="zipCount" datasource="tsgMysql" maxrows="1">
        SELECT zip_code from schools where zip_code = <cfqueryparam value = "#zip#" cfsqltype = "cf_sql_char"> 
    </cfquery>
    <!-- If the 5 digit zipcode does not match rerunn the query with a 3 digit zip code -->    
    <cfif zipCount.recordcount EQ 0>
    <!-- Get the first 3 digits -->    
    <cfset zip=#Left(zip,3)# />  
        
    <cfquery name="zipCount3" datasource="tsgMysql" maxrows="1">
        SELECT zip_code from schools where zip_code = <cfqueryparam value = "#zip#" cfsqltype = "cf_sql_char"> 
    </cfquery>
    <!-- If the three digit zip does not match the database set zip to nothing -->    
    <cfif zipCount3.recordcount EQ 0>
        <cfset zip = "" />
    </cfif>    
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
<cfparam name="form.radius" default="#radius#">
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
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Texas School Guide</title>
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.ico" />
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic">
	<link rel="stylesheet" href="assets/css/style.css" />
     <script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.7/css/jquery.dataTables.min.css">
    <script type='text/javascript' src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
    <script type='text/javascript' src="https://cdnjs.cloudflare.com/ajax/libs/jquery-mockjax/1.6.2/jquery.mockjax.min.js"></script>
    <script type='text/javascript' src="assets/javascripts/jquery.fancybox.js"></script>
    <link rel="stylesheet" href="assets/javascripts/jquery.fancybox.css" />
</head>
<body>
    <div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.4";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<div class="wrapper">
	<cfinclude template="header.cfm">       
	<cfinclude template="partial-home-section.cfm">
    <cfinclude template="searchtab.cfm">
    <cfinclude template="map.cfm">
    <cfinclude template="schooltable.cfm">
    <cfinclude template="learnmoresection.cfm">
    <cfinclude template="eventssection.cfm">   
    <cfinclude template="testimonials.cfm">
    <cfinclude template="callout.cfm">
    <cfinclude template="footer.cfm">  
</div>
<!-- /.wrapper -->
  
<script src="assets/javascripts/vendor.js"></script>
<script src="assets/javascripts/app.js"></script>     
        
</body>
</html>

