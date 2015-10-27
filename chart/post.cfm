    <cfset strPath = ExpandPath( "./" ) /> 
    <cffile action="write" file="#strPath#temp.svg" output="#url.name#"  >
    

<cfabort>

<!--- Define page variables. --->
<cfparam
    name="FORM.action"
    type="string"
    default="" />
 
<cfparam
    name="FORM.value"
    type="string"
    default="hello" />
  
 
<cfset FORM.action = trim( FORM.action ) />
<cfset FORM.value = trim( FORM.value ) />
 
        <!--- BEGIN: Something was passed in as an email. --->
        <cfif len( FORM.value )>
            <cffile action="write" file="#strPath#temp.svg" output="hello world"  >
        </cfif>
