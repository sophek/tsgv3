<cftry>
<!-- If the svg, campus name and id_number were passed -->
<cfif isdefined("form.svg") And form.svg NEQ "">
<!-- Campus name passed ? -->    
<cfif isdefined("form.campus") And form.campus NEQ "">
<!-- If id_number was passed -->
    <cfif isdefined("form.id_number") And form.id_number NEQ "">
        <!-- Set the current directory -->
        <cfset strPath = ExpandPath( "./" ) />
        <!-- Get the campus name so when can append the svg file name -->
        <cfset campus = trim(form.campus) />
        <!-- Same with the id_number -->    
        <cfset id_number = trim(form.id_number) />
        <!-- Write svg file to the directory -->
        <cffile action="write" file="#strPath##id_number#_#campus#.svg" output="#form.svg#">
        <!-- Display a success message -->
        <p>The pie chart was generated successfully.</p>    
        </cfif>
</cfif>    
<cfelse>
          Please click the generate pie chart button.
</cfif>
<!-- If any thing goes wrong, display an error message -->
<cfcatch type="any">
<cfoutput> 
            <!--- The diagnostic message from ColdFusion. ---> 
            <p>#cfcatch.message#</p> 
            <p>Caught an exception, type = #CFCATCH.TYPE#</p> 
            <p>The contents of the tag stack are:</p> 
            <cfdump var="#cfcatch.tagcontext#"> 
        </cfoutput>     
</cfcatch>    
</cftry>    
                
                