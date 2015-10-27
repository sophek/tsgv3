<!--- 
<cfif isdefined("cookie.person.zip")>
    <cfset link = "sample.cfm?zip=" & cookie.person.zip />
    <cflocation url="#link#" addToken="No">
</cfif>
--->

<!DOCTYPE HTML>
<html lang="en-GB">
    
    
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Texas School Guide</title>
    <script type="application/javascript">
    function getgeoip(json){
    	document.write("Geolocation information for IP address : ", json.ip);
    	document.write("Country : ", json.country);
    	document.write("Latitude : ", json.latitude);
    	document.write("Longitude : ", json.longitude);
         var fullLink = "index2.cfm?zip=" + json.zipcode + "&lat=" + json.latitude + "&lng=" + json.longitude;
        document.write(fullLink);
        location.href = fullLink;
    }
        
</script>

<script type="application/javascript" src="http://www.telize.com/geoip?callback=getgeoip"></script>

</head>

<body>

</body>
</html>