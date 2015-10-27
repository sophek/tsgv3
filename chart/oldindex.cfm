<cfquery name="qrySchools" datasource="tsgMysql" cachedWithin="#CreateTimeSpan(3,0,0,0)#">
	select distinct(schools.district) as district from schools order by district ASC 
</cfquery>

<cfdump var="#qrySchools#" label="" />

<html>
<head>
    
    <script language="JAVASCRIPT">
<!--//
function goToPage763(mySelect)
{
PageIndex2=mySelect.selectedIndex;
{
if 
(
mySelect.options[PageIndex2].value != "none"
)
{
frames['iframe2'].location.href = mySelect.options[PageIndex2].value;
}

}
}
//-->
</script>

    
</head>
    <body>
        
        
        
        
        
<form name="form763">
    <select NAME="select763" SIZE="1" onChange="goToPage763(this.form.select763)">
    <option VALUE="frame.cfm" SELECTED>Select a page and go</option>
    <cfoutput>
        <cfloop query="qrySchools">  
            <option VALUE="chart.cfm?district=#URLEncodedFormat(district)#">#district#</option>
        </cfloop>
    </cfoutput>    
    </select> 
        
    <IFRAME NAME="iframe2" SRC="frame.cfm" ALIGN="top" HEIGHT="100%" WIDTH="95%" HSPACE="10" VSPACE="10" align="middle" frameborder="0"></IFRAME>                
</form>

        

      
    
    </body>
</html>    