
<cfif isdefined("cookie.person.zip")>
    <cfset link = "sample.cfm?zip=" & cookie.person.zip & "cf" />
    <cflocation url="#link#" addToken="No">
</cfif>

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
        document.write("zip : ", json.postal_code);
        var fullLink = "sample.cfm?zip=" + json.postal_code + "&lat=" + json.latitude + "&lng=" + json.longitude;
        location.href= fullLink;
    }
</script>

<script type="application/javascript" src="http://www.telize.com/geoip?callback=getgeoip"></script>

</head>

<body>


</body>
</html>