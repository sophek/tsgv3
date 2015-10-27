<!--- The value of the variable Attributes.Name comes from the calling page. 
    If the calling page does not set it, make it "Who". ---> 
<cfparam name="Attributes.Name" default="Who"> 
<cfparam name="Attributes.Id_Number" default="Who"> 
 
<!--- Create a variable called Doctor, make its value "Doctor "  
    followed by the value of the variable Attributes.Name. 
    Make its scope Caller so it is passed back to the calling page. 
---> 
<cfset Caller.Doctor="Doctor " & Attributes.Name>
    
<!--- Query the school db and only display the profile if there is a record. --->  
    
<cfquery name="qrySchools" datasource="tsgMysql">
	SELECT schools.id_number, 
	schools.campus, 
	schools.district, 
	schools.county, 
	schools.address, 
	schools.city, 
	schools.state, 
	schools.zip_code, 
	schools.low_grade, 
	schools.high_grade, 
	schools.charter_yes_and_no as school_type, 
	schools.student_enrollment, 
	schools.percent_white_students as white, 
	schools.percent_african_american_students as black, 
	schools.percent_hispanic_students as hispanic, 
	schools.percent_other_students as others, 
	schools.percent_economically_disadvantaged, 
	schools.staar_reading_advanced, 
	schools.staar_math_advanced, 
	schools.achievement_index_percentile, 
	schools.demographically_adjusted_deviation_score, 
	schools.campus_performance_index_percentile, 
	schools.reading_gain_score, 
	schools.math_gain_score, 
	schools.growth_index_percentile, 
	schools.sat_act_participation_rate, 
	schools.ap_ib_participation_rate, 
	schools.percent_of_examinees_above_criterion_score, 
	schools.average_act_composite_score, 
	schools.average_sat_total_score, 
	schools.cr_graduation_rate, 
	schools.college_readiness_index_percentile, 
	schools.composite_index_percentile, 
	schools.state_rank_2015, 
	schools.letter_grade, 
	schools.latitude, 
	schools.longitude, 
	schools.special_ed, 
	schools.student_ratio, 
	schools.mobility, 
	schools.rank_2014, 
	schools.grade_2014, 
	schools.phone, 
	schools.peg, 
	schools.innovative_resources, 
	schools.art_classes, 
	schools.music_classes, 
	schools.ap_ib_college_dual_credit_options, 
	schools.college_counseling, 
	schools.athletics_sports_programs, 
	schools.other_programs, 
	schools.school_level, 
	schools.datecreated, 
	schools.dateupdated, 
	schools.`status`, 
	schools.third_grade
FROM schools
    Where 1=1
    <cfif isdefined("Attributes.ID_NUMBER") AND Attributes.ID_NUMBER NEQ "">
    	AND ID_NUMBER = <cfqueryparam value = "#Attributes.ID_NUMBER#" cfsqltype = "cf_sql_char" maxLength = "14">
    </cfif>
</cfquery>
    
<!---Start Pie Calcuation --->     
<cfscript>
    races = queryNew("race,raceColor,raceName");
    queryAddRow(races, 4);
 
    querySetCell(races, "race", qrySchools.white, 1);
    querySetCell(races, "raceColor", "blue", 1);
    querySetCell(races, "raceName", "White", 1);
    
    querySetCell(races, "race", qrySchools.black, 2);
    querySetCell(races, "raceColor", "orange", 2);
    querySetCell(races, "raceName", "Black", 2);
    
    querySetCell(races, "race", qrySchools.hispanic, 3);
    querySetCell(races, "raceColor", "green", 3);
    querySetCell(races, "raceName", "Hispanic", 3);
    
    querySetCell(races, "race", qrySchools.others, 4);
     querySetCell(races, "raceColor", "red", 4);
    querySetCell(races, "raceName", "Others", 4);
</cfscript>
    
<cfquery dbtype="query" name="race">
    select race,raceColor,raceName from races
</cfquery>
    
<cfset colorPattern = "" />    

<cfloop query="race">
    <cfif race neq "N/A">
        <cfset colorPattern = colorPattern & "'" & race.raceColor & "'" />
        <cfset colorPattern = colorPattern & "," />
    </cfif>
</cfloop>

<!--- End Pie Calculation --->    

<cfset meterAchievementIndex = "meter-" & "#avgColor(qrySchools.ACHIEVEMENT_INDEX_PERCENTILE)#" />
<cfset meterCampusPerformanceIndex = "meter-" & "#avgColor(qrySchools.CAMPUS_PERFORMANCE_INDEX_PERCENTILE)#" />
<cfset meterGrowthIndex = "meter-" & "#avgColor(qrySchools.GROWTH_INDEX_PERCENTILE)#" />
<cfset meterCompositeIndex = "meter-" & "#avgColor(qrySchools.COMPOSITE_INDEX_PERCENTILE)#" />
    
</cfoutput>
    
<!--- Set teh State Rank color bars --->    
    
    
    
<cfif qrySchools.recordcount GT 0>
<cfoutput query="qrySchools" maxrows="1">
<div id="profile" class="container">
    <section>
      <table style="width:1050">
                            <tr>
                                <td align="center">
                                    <div class="nav">
                                    <img src="assets/images/campus_profile_icon.png">
                                    <img src="assets/images/report_card.png">
                                    <img src="assets/images/state_rank.png">
                                    </div>    
                                </td>
                                <td align="center">
                                    <div class="nav">
                                    <img src="assets/images/campus_profile_icon.png">
                                    <img src="assets/images/report_card.png">
                                    <img src="assets/images/state_rank.png">
                                    </div>    
                                </td>
                            </tr>
                        </table>
    </section>



        
<section>
    <h1>#campus#</h1>
    <div>
        <p class="address">#displayLang(schoolTypeCharter(school_type),"#lang#")# | #displayLang(school_level,"#lang#")# | #low_grade# - #high_grade# | #district#</p>
        <p class="address">#address#, #city#, TX, #zip_code#</p>
    </div>    
</section>
<!-- Current Rank -->    
<section>
    <h1>2015 #displayLang("State Rank","#lang#")# <span class="stateRank">#cleanResult(STATE_RANK_2015)# / <cfif school_level eq "H">1193<cfelse>4421</cfif></h1>    
</section>
<!-- Current Grade -->        
<section>
    <table>
        <tr>
            <td style="position:relative;left:-20px;"><h1>#displayLang("CURRENT GRADE","#lang#")# : </h1></td>
            <td style="position:relative;left:-100px;"><span id="grade"><img src="assets/images/f.png"> </td>
        </tr>
    </table>
</section>
<!-- end Current Grade -->        
<section>
    <h1>#displayLang("Campus Profile","#lang#")#</h1>
    <div>
    <table>
        <tr>
            <td>#displayLang("Enrollment","#lang#")#</td>
            <td align="left"><b>#cleanResult(STUDENT_ENROLLMENT)#</b>
            </td>
        </tr>
        <tr>
            <td>#displayLang("Economically Disadvantaged","#lang#")#</td>
            <td align="left"><b>#cleanResult(PERCENT_ECONOMICALLY_DISADVANTAGED,"percent")#</b>
            </td>
        </tr>
        <tr>
            <td>#displayLang("Special Education","#lang#")#</td>
            <td align="left"><b>#cleanResult(SPECIAL_ED,"percent")#</b>
            </td>
        </tr>
        <tr>
            <td>#displayLang("Student Teacher Ratio","#lang#")#</td>
            <td align="left" nowrap><b>#DisplayNA(STUDENT_RATIO)#</b>
            </td>
        </tr>
        <tr>
            <td>#displayLang("Mobility Rate","#lang#")#</td>
            <td align="left"><b>#cleanResult(MOBILITY,"percent")#</b>
            </td>
        </tr>
        <cfif #school_level# eq "E">
            <tr>
                <td>#displayLang("3rd Grade Avg. Class Size","#lang#")#</td>
                <td align="left"><b>#cleanResult(THIRD_GRADE)#</b>
                </td>
            </tr>
        </cfif>
    </table>
    </div>    
</section>

<!-- Chart -->
  <section>
    <h1>#displayLang("Student Diversity","#lang#")#</h1>
      <div>
     <table>
        <tr>
            <td>

                <cfloop query="race">
                    <cfif race neq "N/A">
                        <li class="#raceColor#">
                            <p>#displayLang("#raceName#","#lang#")# : #cleanResult((race * 100))#%</p>
                        </li>
                    </cfif>
                </cfloop>

            </td>
            <td>
                <div id="c3-pie" style="height: 160px;width:200px;position:relative;left:150px;top:-50px"></div>
            </td>
        </tr>
    </table>
    </div>  
</section>
    
 <section>
    <h1>#displayLang("SCHOOL PROGRAMS","#lang#")#</h1>
     <div>
                        <table>
                            <tr>
                                <td>
                                <cfset programcounter = 0 />
                                <cfif displaySchoolProgram(ART_CLASSES) NEQ "" and displaySchoolProgram(ART_CLASSES) NEQ "Contact School">
                                    <cfset programcounter = programcounter + 1 />
                                </cfif>
                                <cfif displaySchoolProgram(MUSIC_CLASSES) NEQ "" and displaySchoolProgram(MUSIC_CLASSES) NEQ "Contact School">
                                    <cfset programcounter = programcounter + 1 />
                                </cfif>
                                <cfif programcounter eq 0>
                                       <p>#displayLang("SchoolProgramNA","#lang#")#</p>
                                    <cfelse>
                                        <table>
                                            <cfif displaySchoolProgram(ART_CLASSES) EQ "YES">
                                            <tr><td><div class="dot"></div>&nbsp;&nbsp;&nbsp;</td><td>Art Classes</td></tr>
                                            </cfif>
                                            <cfif displaySchoolProgram(MUSIC_CLASSES) EQ "YES">
                                            <tr><td><div class="dot"></div>&nbsp;&nbsp;&nbsp;</td><td>Music Classes</td></tr>
                                            </cfif>

                                        </table>
                                    </cfif>
                                </td>
                            </tr>
                        </table>
                    </div>
        
</section>
    
<!-- Innovation -->    

<section>
    <h1>#displayLang("Innovative Resources","#lang#")#</h1>
       <div>
            <table>
                <tr>
                    <cfif len(innovative_resources) EQ 0>
                    <td>
                        #displayLang("InnovationNA","#lang#")#
                    </td>
                    <cfelseif innovative_resources EQ "" OR innovative_resources EQ "NA">
                    <td>
                        #displayLang("InnovationNA","#lang#")#
                    </td>
                    <cfelse>
                    <td>
                        <cfset thislistcounter = #listLen(innovative_resources)#>
                        <cfif thislistcounter eq 0>
                            #displayLang("InnovationNA","#lang#")#
                        <cfelse>
                            <table>
                                <cfloop index="i" list="#innovative_resources#" delimiters=",">
                                    <tr><td><div class="dot"></div>&nbsp;&nbsp;&nbsp;</td><td>#i#</td></tr>
                                </cfloop>
                            </table>
                        </cfif>
                    </td>
                    </cfif>
                </tr>
            </table>
        </div>
</section>    
    
  
<div class="row">
    <div class="col-xs-12">
         <span style="padding-left:30px;font-size:11px">* 2012-2013 School Year / 2014 School Rankings</span> 
    </div>
</div>        
</cfoutput>

<!-- C3 JS -->
<script src="assets/plugins/c3-chart/d3.v3.min.js" charset="utf-8"></script>
<script src="assets/plugins/c3-chart/c3.min.js"></script>
<script>	
var chart = c3.generate({
bindto: '#c3-pie',
data: {
	// iris data from R
	columns: [
        <cfloop query="race">
            <cfif race neq "N/A">
                <cfoutput>['#raceName#',#race# ],</cfoutput>
            </cfif>
        </cfloop>
       
         ],
	type : 'pie'
},
color: {
  pattern: [<cfoutput>#colorPattern#</cfoutput>]
},  
legend: {
show: false
},
});
</script>    
    
</cfif> 