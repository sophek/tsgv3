<cfcomponent displayname="Zipcodes Component">
<cffunction
	name="GetLatitudeLongitudeProximity"
	access="public"
	returntype="numeric"
	output="false"
	hint="I find the approximate distance in miles between the given pair of latititude and longitude values. The closer you get to the North or South Pole, the less accurate this becomes due to changes in distance between degrees. Math borrowed from http://zips.sourceforge.net.">

	<!--- Define arguments. --->
	<cfargument
		name="FromLatitude"
		type="numeric"
		required="true"
		hint="I am the starting latitude value."
		/>

	<cfargument
		name="FromLongitude"
		type="numeric"
		required="true"
		hint="I am the starting longitude value."
		/>

	<cfargument
		name="ToLatitude"
		type="numeric"
		required="true"
		hint="I am the target latitude value."
		/>

	<cfargument
		name="ToLongitude"
		type="numeric"
		required="true"
		hint="I am the target longitude value."
		/>

	<!--- Define the local scope. --->
	<cfset var LOCAL = {} />

	<!---
		The approximate number of miles per degree of latitude.
		Once we have the difference in degrees, we will use this
		to find an approximate horizontal distance.
	--->
	<cfset LOCAL.MilesPerLatitude = 69.09 />

	<!---
		Calculate the distance in degrees between the two
		different latitude / longitude locations.
	--->
	<cfset LOCAL.DegreeDistance = RadiansToDegrees(
		ACos(
				(
					Sin( DegreesToRadians( ARGUMENTS.FromLatitude ) ) *
					Sin( DegreesToRadians( ARGUMENTS.ToLatitude ) )
				)
			+
				(
					Cos( DegreesToRadians( ARGUMENTS.FromLatitude ) ) *
					Cos( DegreesToRadians( ARGUMENTS.ToLatitude ) ) *
					Cos( DegreesToRadians( ARGUMENTS.ToLongitude - ARGUMENTS.FromLongitude ) )
				)
			)
		) />


	<!---
		Given the difference in degrees, return the approximate
		distance in miles.
	--->
	<cfreturn Round( LOCAL.DegreeDistance * LOCAL.MilesPerLatitude ) />
</cffunction>


<cffunction
	name="DegreesToRadians"
	access="public"
	returntype="numeric"
	output="false"
	hint="I convert degrees to radians.">

	<!--- Define arguments. --->
	<cfargument
		name="Degrees"
		type="numeric"
		required="true"
		hint="I am the degree value to be converted to radians."
		/>

	<!--- Return converted value. --->
	<cfreturn (ARGUMENTS.Degrees * Pi() / 180) />
</cffunction>


<cffunction
	name="RadiansToDegrees"
	access="public"
	returntype="numeric"
	output="false"
	hint="I convert radians to degrees.">

	<!--- Define arguments. --->
	<cfargument
		name="Radians"
		type="numeric"
		required="true"
		hint="I am the radian value to be converted to degrees."
		/>

	<!--- Return converted value. --->
	<cfreturn (ARGUMENTS.Radians * 180 / Pi()) />
</cffunction>
    
    
    
<cffunction name="getZips"
	access="public"
	returntype="query"
	output="true"
	hint="I output the zip codes">
    
    <!--- Define arguments. --->
	
    <cfargument
		name="zip"
		type="numeric"
		required="true"
		hint="I am the zipcode to search aganist"
		/>
    
    <cfargument
		name="miles"
		type="numeric"
		required="true"
		hint="I am the miles radius to search against"
		/>
    
    <!---
	Set the approximate miles per latitude. We will use this to
	create a rough box model used to find proximal zip codes.
--->
<cfset flMilesPerDegree = 69.09 />

<!---
	Now, let's determine what kind of mileage we want to use to
	gather near-by zip codes.
--->
<cfset intMileRadius = arguments.miles />
<cfset intZip = arguments.zip />
    

<!---
	We need to convert our mile-bases search to a degree-delta
	that can be used to find min and max latitude and longitude.
	To do so, we are going to find what percentage of the
	miles-per-degree equates to our mile radius.
--->
<cfset flDegreeRadius = (intMileRadius / flMilesPerDegree) />


<!---
	To calculate the rough box model, we need to get the
	latitude and longitude of our start zip code.
--->
<cfquery name="qOrigin" datasource="tsgMysql">
	SELECT
		z.id_number,
		z.city,
		z.state,
		z.zip_code,
		z.latitude,
		z.longitude,
		CAST( z.longitude AS DECIMAL(10,8) ) AS test
	FROM
		schools z

	<!--- Original location in NYC (my office!) --->
	WHERE
		z.zip_code = '#intZip#'
</cfquery>


    


<!---
	Now that we have our target zip code's latitude and
	longitude value, we can calculate the min and max
	longitude and latitude values of our rough box model.
	This will be the +/- degree radiues in each plane.
--->
<cfset flMinLatitude = (qOrigin.latitude - flDegreeRadius) />
<cfset flMaxLatitude = (qOrigin.latitude + flDegreeRadius) />
<cfset flMinLongitude = (qOrigin.longitude - flDegreeRadius) />
<cfset flMaxLongitude = (qOrigin.longitude + flDegreeRadius) />


<!---
	Using the rough box model, get all of the zip codes that
	fall within the box.
--->
<cfquery name="qZipCode" datasource="tsgMysql">
	SELECT
		z.id_number,
		z.city,
		z.state,
		z.zip_code,
		z.latitude,
		z.longitude,

		<!--- Set an empty value for distance. --->
		( 0 ) AS distance
	FROM
		schools z
	WHERE
		z.latitude >= <cfqueryparam value="#flMinLatitude#" cfsqltype="cf_sql_float" />
	AND
		z.latitude <= <cfqueryparam value="#flMaxLatitude#" cfsqltype="cf_sql_float" />
	AND
		z.longitude >= <cfqueryparam value="#flMinLongitude#" cfsqltype="cf_sql_float" />
	AND
		z.longitude <= <cfqueryparam value="#flMaxLongitude#" cfsqltype="cf_sql_float" />
</cfquery>



<!---
	Now that we have the estimated zip codes, let's loop over
	them and update the column for the more accurate (but still
	just an appoximation) distance. By doing this, we can compare
	the limitations of the rough box model to the somewhat more
	accurate mathematical calculation.
--->
<cfloop query="qZipCode">

	<!--- Store mathematical distnace. --->
	<cfset qZipCode[ "distance" ][ qZipCode.CurrentRow ] = JavaCast(
		"int",
		GetLatitudeLongitudeProximity(
			qOrigin.latitude,
			qOrigin.longitude,
			qZipCode.latitude,
			qZipCode.longitude
			)
		) />

</cfloop>
    
<cfreturn qZipCode />    
</cffunction>
    
</cfcomponent>



