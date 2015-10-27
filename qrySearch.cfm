

<cfif isdefined("form.district") AND form.district NEQ "">
<cfif form.district NEQ "All">
	AND district = <cfqueryparam value = "#form.district#" cfsqltype = "cf_sql_char">
</cfif>
</cfif>

<cfif isdefined("form.campus") AND form.campus NEQ "">
	AND campus Like <cfqueryparam value = "%#form.campus#%" cfsqltype = "cf_sql_char"> 
</cfif>
    
<cfif isdefined("form.address") AND form.address NEQ "">
	AND address Like <cfqueryparam value = "%#form.address#%" cfsqltype = "cf_sql_char"> 
</cfif>    
    
<cfif isdefined("form.city") AND form.city NEQ "">
	AND city Like <cfqueryparam value = "%#form.city#%" cfsqltype = "cf_sql_char"> 
</cfif>    
    
<cfif isdefined("form.school_level") AND form.school_level NEQ "" AND form.school_level NEQ "All">
	AND school_level = <cfqueryparam value = "#form.school_level#" cfsqltype = "cf_sql_char"> 
</cfif>   
        
<cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no NEQ "" AND form.charter_yes_and_no NEQ "All">
    <cfif form.charter_yes_and_no eq "Peg">
    AND peg = <cfqueryparam value = "yes" cfsqltype = "cf_sql_char"> 
        <cfelse>
    AND charter_yes_and_no = <cfqueryparam value = "#form.charter_yes_and_no#" cfsqltype = "cf_sql_char">         
    </cfif>
	
</cfif>
        
<cfif isdefined("form.letter_grade") AND form.letter_grade NEQ "ALL" AND form.letter_grade NEQ "">
    <cfset lettergrades = ListQualify(form.letter_grade,"'",",","ALL")> 
	AND letter_grade in (<cfoutput>#lettergrades#</cfoutput>)
</cfif>

<cfif isdefined("form.art_classes") AND form.art_classes EQ "Yes">
	AND art_classes = 'Yes'
</cfif>
<cfif isdefined("form.music_classes") AND form.music_classes EQ "Yes">
	AND music_classes = 'Yes'
</cfif>
<cfif isdefined("form.sports_athletics") AND form.Sports EQ "Yes">
	AND sports_athletics = 'Yes'
</cfif>
<cfif isdefined("form.college_counseling") AND form.college_counseling EQ "Yes">
	AND college_counseling = 'Yes'
</cfif>
<cfif isdefined("form.ap_ib") AND form.AP EQ "Yes">
	AND ap_ib_college_dual_credit_options = 'Yes'
</cfif>    

