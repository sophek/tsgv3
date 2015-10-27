<cfquery name="qrySchools" datasource="tsgMysql">
	select schools.id_number, 
	schools.campus, 
	schools.district,schools.percent_white_students as white, 
	schools.percent_african_american_students as black, 
	schools.percent_hispanic_students as hispanic, 
	schools.percent_other_students as others
    FROM schools
    Where 1=1
    <cfif isdefined("url.district")>
        AND district = <cfqueryparam value="#url.district#" CFSQLType="CF_SQL_VARCHAR">
        <cfelse>
        AND district = 'KOUNTZE ISD'
    </cfif>
    
</cfquery>
    
<!---Start Pie Calcuation --->     
<cfscript>
    races = queryNew("race,raceColor,raceName");
    queryAddRow(races, 4);
 
    querySetCell(races, "race", qrySchools.white[1], 1);
    querySetCell(races, "raceColor", "a6ce39", 1);
    querySetCell(races, "raceName", "White", 1);
    
    querySetCell(races, "race", qrySchools.black[1], 2);
    querySetCell(races, "raceColor", "825396", 2);
    querySetCell(races, "raceName", "Black", 2);
    
    querySetCell(races, "race", qrySchools.hispanic[1], 3);
    querySetCell(races, "raceColor", "ffcb05", 3);
    querySetCell(races, "raceName", "Hispanic", 3);
    
    querySetCell(races, "race", qrySchools.others[1], 4);
     querySetCell(races, "raceColor", "f15f43", 4);
    querySetCell(races, "raceName", "Others", 4);
</cfscript>
    
<cfquery dbtype="query" name="race">
    select race,raceColor,raceName from races
</cfquery>
    
<cfset colorPattern = "" />    

<cfloop query="race">
    <cfif race neq "N/A">
        <cfset colorPattern = colorPattern & "'##" & race.raceColor & "'" />
        <cfset colorPattern = colorPattern & "," />
    </cfif>
</cfloop>
    
<cfset pieColors = "#Left(colorPattern,len(colorPattern) - 1)#" />    

<html>
<head>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    
    
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {

        <cfoutput query="qrySchools">  
         var data#currentrow# = google.visualization.arrayToDataTable([
           ['', ''],
                    <cfif white NEQ "N/A">
                    ['white', #white#],
                    </cfif>
                    
                     <cfif black NEQ "N/A">
                    ['black', #black#],
                    </cfif>
                
                     <cfif hispanic NEQ "N/A">
                    ['hispanic', #hispanic#],
                    </cfif>
                     
                     <cfif hispanic NEQ "N/A">
                    ['others', #others#],
                     </cfif>
                
        ]);  
        </cfoutput>
          
        // var data = google.visualization.arrayToDataTable([
        //  ['Task', 'Hours per Day'],
        //  ['White',     50],
        //  ['Black',      30],
        //  ['Hispanic',  10],
        //  ['Other', 10]
        //]);

        //var options = {
          //legend: 'none',
          //pieSliceText : 'none',
          //pieSliceBorderColor : 'none',     
          //colors: ['#a6ce39', '#825396', '#ffcb05', '#f15f43']
        //}; 
          
        var options = {
          backgroundColor: 'transparent',
          legend: 'none',
          pieSliceText : 'none',
          pieSliceBorderColor : 'none', 
        <cfoutput>colors: [#pieColors#]</cfoutput>    
        };

            <cfoutput>
                <cfloop index="i" from="1" to="#qrySchools.recordcount#">
                    var chart#i# = new google.visualization.PieChart(document.getElementById('piechart#i#'));
                    var pie_div#i# = document.getElementById('piechart#i#');
                    google.visualization.events.addListener(chart#i#, 'ready', allready#i#);   
                    
                    
          function allready#i#(){
              var e = document.getElementById('piechart#i#');
              var svg = e.getElementsByTagName('svg')[0].parentNode.innerHTML;
              var c = document.getElementById('svg-value#i#');
              c.value = svg;

      }
        
    
                    chart#i#.draw(data#i#, options);
                </cfloop>    
            </cfoutput>
            
      }
        
        
        
    </script>
    
    </head>
    <body>
        
        
        <cfoutput>
            <cfloop index="i" from="1" to="#qrySchools.recordcount#">
                <form action="generateSvg.cfm" method="post" target="mytarget">
                <input type="hidden" id="svg-value#i#" name="svg">
                <input type="hidden" name="campus" value="#qrySchools.campus[i]#">
                <input type="hidden" name="id_number" value="#qrySchools.id_number[i]#">
                <div id="piechart#i#" style="width: 80px; height: 80px;"></div><input type="submit" class="button#i#" value="Generate Pie Chart"> <br>#qrySchools.campus[i]# <br /> School ID Number = #qrySchools.id_number[i]#
               </form>
            
            </cfloop>
        </cfoutput>
    
        <iframe name="mytarget" href="generateSvg.cfm" height="100" width="100" border="0" frameborder="0"></iframe>
    
    </body>
</html>    