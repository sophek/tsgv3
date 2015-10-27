<!--- <cftry> --->
   
       
<cfinclude template="tsgFunctions.cfm">
<cfset lang = "EN">
<cfoutput>

<cfset list = "#cgi.query_string#"> 
<cfset arr = listToArray (list, "&")>
    
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
    <cfif isdefined("url.ID_NUMBER") AND url.ID_NUMBER NEQ "">
    	AND ID_NUMBER = <cfqueryparam value = "#replace(arr[4],'id%5B%5D=','')#" cfsqltype = "cf_sql_char" maxLength = "14">
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

    
<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link href="assets/plugins/c3-chart/c3.css" rel="stylesheet">
    <link href="style.css" rel="stylesheet">
    <cfinclude template="profileStyles.cfm">
    <style>
        .profileTable td {
            vertical-align: top;
            
        }    
        
        .nav img {
            padding-left: 50px;
            
        }
    </style>    
        
</head>
<body>
    
<!--- Query the school db and only display the profile if there is a record. --->    
<cfif qrySchools.recordcount GT 0>
<cfoutput query="qrySchools" maxrows="1">
<div id="profile" class="container">
    <table class="profileTable">
        <tr>
            <td colspan="3">
                  <!-- Start the campus title row -->
              <div class="row">
                    <div class="col-xs-9">
                        <table style="width:1050">
                            <tr>
                                <td align="center">
                                    <div class="nav">
                                    <img src="assets/images/campus_profile_icon.png">
                                    <img src="assets/images/report_card.png">
                                    <img src="assets/images/state_rank.png">
                                    </div>    
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="width:525"><div class="schoolName">#campus#</div></td>
                                <td>
                                    
                                        <div class="letterGrade">
                                            <span class="grade">#DisplayNA(LETTER_GRADE)#</span>
                                        </div>
                                   
                                </td>
                            </tr>
                        </table>
                        
                        
                  </div>
                    
                </div>
                <!-- End the campus title row -->
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <br><br><br>
                 <div class="row">
                    <div class="col-xs-9 schoolAddress" style="position:relative;left:42px;top:-55px">
                        <table class="schoolAddress">
                            <tr>
                                <td>
                                    <table class="schoolAddress">
                                        <tr>
                                            <td>#ADDRESS#</td>
                                            <td><div class="dot"></div></td>
                                            <td>#CITY#</td>
                                            <td><div class="dot"></div></td>
                                            <td>TX</td>
                                            <td><div class="dot"></div></td>
                                            <td>#ADDRESS#</td>
                                            <td><div class="dot"></div></td>
                                            <td>#zip_code#</td>
                                        </tr>
                                    </table>
                                    </td>
                            </tr>
                            <tr>
                                <td colspan="5">#PHONE# | #displayLang(schoolTypeCharter(school_type),"#lang#")# | #displayLang(school_level,"#lang#")# | #low_grade# - #high_grade# | #district#</td>
                                <td><cfif PEG eq "Yes"><div style="position:relative;top:-40px;left:100px"><img src="peg.png" alt="" class="peg" /></div><cfelse><div style="height:50px">&nbsp;</div></cfif></td>
                            </tr>
                        </table>
                     </div>
                </div>
            </td>
        </tr>
        
        <tr>
            <td>
                <!-- Start Campus Profile Column -->
                    <div class="col-xs-3" style="position:relative;top:-70px">
                        <span class="headerText" style="padding-left:40px">#displayLang("Campus Profile","#lang#")#</span>
                        <div style="padding-left:40px;padding-top:10px">
                            <table class="campusProfileTable" style="width:285px">
                                <tr>
                                    <td>#displayLang("Enrollment","#lang#")#</td>
                                    <td align="center"><b>#cleanResult(STUDENT_ENROLLMENT)#</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#displayLang("Economically Disadvantaged","#lang#")#</td>
                                    <td align="center"><b>#cleanResult(PERCENT_ECONOMICALLY_DISADVANTAGED,"percent")#</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#displayLang("Special Education","#lang#")#</td>
                                    <td align="center"><b>#cleanResult(SPECIAL_ED,"percent")#</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#displayLang("Student Teacher Ratio","#lang#")#</td>
                                    <td align="center" nowrap><b>#DisplayNA(STUDENT_RATIO)#</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#displayLang("Mobility Rate","#lang#")#</td>
                                    <td align="center"><b>#cleanResult(MOBILITY,"percent")#</b>
                                    </td>
                                </tr>
                                <cfif #school_level# eq "E">
                                    <tr>
                                        <td>#displayLang("3rd Grade Avg. Class Size","#lang#")#</td>
                                        <td align="center"><b>#cleanResult(THIRD_GRADE)#</b>
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </div>
                    </div>
        <!-- End Campus Profile Column -->
            </td>
            <td>
            <!-- Start Report Card Column -->
                <div class="col-xs-3" style="position:relative;top:-70px;left:10px"><span class="headerText">#displayLang("Report Card","#lang#")#</span>
                <div style="padding-left:2px">
                    <table class="reportCardTable" style="width:275px">
                        <thead>
                            <td></td>
                            <td>Score</td>
                        </thead>
                        <tr>
                            <td nowrap>#displayLang("STAAR Math - Adv","#lang#")#</td>
                            <td align="center"><b>#cleanResult(STAAR_MATH_ADVANCED,"percent")#</b>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap>#displayLang("STAAR Reading - Adv","#lang#")#</td>
                            <td align="center"><b>#cleanResult(STAAR_READING_ADVANCED,"percent")#</b>
                            </td>
                        </tr>
                        <tr>
                            <td>#displayLang("Reading Gain Score","#lang#")#</td>
                            <td align="center">
                                <b>#cleanResult(READING_GAIN_SCORE)#</b>
                            </td>
                        </tr>
                        <tr>
                            <td>#displayLang("Math Gain Score","#lang#")#</td>
                            <td align="center">
                                <b>#cleanResult(MATH_GAIN_SCORE)#<b> 
                            </td>
                        </tr>
                        <cfif #school_level# eq "H">
                        <tr>
                            <td nowrap>C@R Graduation Rate</td>
                            <td align="center"><b>#cleanResult(cr_graduation_rate,"percent")#</b>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap>Student Passing AP/IB</td>
                            <td align="center"><b>#cleanResult(ap_ib_participation_rate)#</b>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap>Average SAT Score</td>
                            <td align="center"><b>#average_sat_total_score#</b>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap>Average ACT Score</td>
                            <td align="center"><b>#cleanResult(average_act_composite_score)#</b>
                            </td>
                        </tr>
                         <!---    
                        <tr>
                            <td nowrap>Student Participation in AP/IB</td>
                            <td align="center"><b>#cleanResult(CR_GRADUATION_RATE)#</b>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap>Student Participation in SAT/ACT</td>
                            <td align="center"><b>#cleanResult(sat_act_participation_rate)#</b>
                            </td>
                        </tr> --->
                        </cfif>

                    </table>
                </div>
            </div>
            <!-- End Report Card Column --> 
            </td>
            <td>
                <!-- Start State Rank Column -->        
                <div class="col-xs-4" style="position:relative;top:-70px;left:40px"><span class="headerText">2015 #displayLang("State Rank","#lang#")# <span class="stateRank">#cleanResult(STATE_RANK_2015)# / <cfif school_level eq "H">1193<cfelse>4421</cfif></span></span>
                    <table class="rankTable">
                        <tr>
                            <td width="150" nowrap>#displayLang("Achievement Index","#lang#")#</td>
                            <td width="75" style="text-align:right">#cleanResult(ACHIEVEMENT_INDEX_PERCENTILE)#</td>
                            <td width="5">&nbsp;</td>
                            <td width="100%">
                                <cfset meterAchievementIndexHalf = cleanResult(ACHIEVEMENT_INDEX_PERCENTILE) / 2 />
                                <div style="padding-left:20px">
                                    <div class="#meterAchievementIndex#" style="width:#meterAchievementIndexHalf#">&nbsp;</div>
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td width="150" nowrap>#displayLang("Performance Index","#lang#")#</td>
                            <td width="75" style="text-align:right">
                                #cleanResult(CAMPUS_PERFORMANCE_INDEX_PERCENTILE)#
                            </td>
                            <td width="5">&nbsp;</td>
                            <td width="100%">
                                <cfset meterCampusPerformanceIndexHalf = cleanResult(CAMPUS_PERFORMANCE_INDEX_PERCENTILE) / 2 />
                                <div style="padding-left:20px">
                                    <div class="#meterCampusPerformanceIndex#" style="width:#meterCampusPerformanceIndexHalf#">&nbsp;</div>
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td width="150" nowrap>#displayLang("Growth Index","#lang#")#</td>
                            <td width="75" style="text-align:right">
                                #cleanResult(GROWTH_INDEX_PERCENTILE)#
                            </td>
                            <td width="5">&nbsp;</td>
                            <td width="100%">
                                <cfset meterGrowthIndexHalf = cleanResult(GROWTH_INDEX_PERCENTILE) / 2 />
                                <div style="padding-left:20px">
                                    <div class="#meterGrowthIndex#" style="width:#meterGrowthIndexHalf#">&nbsp;</div>
                                </div>    
                            </td>
                        </tr>
                        <tr>
                            <td width="150" nowrap>#displayLang("Composite Index","#lang#")#</td>
                            <td width="75" style="text-align:right">
                                #cleanResult(composite_index_percentile)#
                            </td>
                            <td width="5">&nbsp;</td>
                            <td width="100%">
                                <cfset meterCompositeIndexHalf = cleanResult(composite_index_percentile) / 2 />
                                <div style="padding-left:20px">
                                    <div class="#meterCompositeIndex#" style="width:#meterCompositeIndexHalf#">&nbsp;</div>
                                </div>    
                            </td>
                        </tr>
                    </table>
                    <div>
                                <ul class="averageLegend" style="position:relative;left:-50px;">
                                    <li><span class="redBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Below Average","#lang#")#</li>
                                    <li><span class="blueBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Average","#lang#")#</li>
                                    <li><span class="greenBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Above Average","#lang#")#</li>
                                </ul>
                    </div>
                </div>
                <!-- End Column State Rank -->        
            </td>
        </tr>
        <tr>
            <td align="top">
                 <div class="col-xs-3" style="position:relative;top:-40px">
                    <span class="headerText" style="padding-left:40px">#displayLang("Student Diversity","#lang#")#</span>
                    <div style="padding-left:20px;padding-top:15px">
                    <table>
                        <tr>
                            <td class="legendText">
                                <ul class="legend">
                                    
                                    
                                    <cfloop query="race">
                                        <cfif race neq "N/A">
                                        <li class="#raceColor#">
                                            <p>#displayLang("#raceName#","#lang#")# : #cleanResult((race * 100))#%</p>
                                        </li>
                                        </cfif>    
                                    </cfloop>    

                                   <!--- <cfif qrySchools.white neq "N/A">
                                        <li class="blue">
                                            <p>#displayLang("White","#lang#")# :
                                                <cfoutput>#cleanResult((white * 100))#%</p>
                                            </cfoutput>
                                        </li>
                                    </cfif>
                                    <cfif qrySchools.black neq "N/A">
                                        <li class="orange">
                                            <p>#displayLang("Black","#lang#")# :
                                                <cfoutput>#cleanResult(black * 100)#%</p>
                                            </cfoutput>
                                        </li>
                                    </cfif>
                                    <cfif qrySchools.hispanic neq "N/A">
                                        <li class="green">
                                            <p>#displayLang("Hispanic","#lang#")# :
                                                <cfoutput>#cleanResult(hispanic * 100)#%</p>
                                            </cfoutput>
                                        </li>
                                    </cfif>
                                    <cfif qrySchools.others neq "N/A">
                                        <li class="red">
                                            <p>#displayLang("Others","#lang#")# :
                                                <cfoutput>#cleanResult(others * 100)#%</p>
                                            </cfoutput>
                                        </li>
                                    </cfif> --->
                                </ul>

                                </td>
                                <td>
                                    <div id="c3-pie" style="height: 160px;width:200px;position:relative;left:25px;top:0px"></div>    
                                </td>
                        </tr>
                  </table>
                  </div>
                </div>
            </td>
            <td>
             <!-- Start School Programs-->
                <div class="col-xs-3" style="position:relative;top:-40px">
                    <span class="headerText" style="padding-left:10px;">#displayLang("School Programs","#lang#")#</span>
                    <div>
                        <table class="innovativeTable">
                            <tr>
                                <td style="padding-left: 10;">
                                <cfset programcounter = 0 />
                                <cfif displaySchoolProgram(ART_CLASSES) NEQ "" and displaySchoolProgram(ART_CLASSES) NEQ "Contact School">
                                    <cfset programcounter = programcounter + 1 />
                                </cfif>
                                <cfif displaySchoolProgram(MUSIC_CLASSES) NEQ "" and displaySchoolProgram(MUSIC_CLASSES) NEQ "Contact School">
                                    <cfset programcounter = programcounter + 1 />
                                </cfif>
                                <cfif programcounter eq 0>
                                        #displayLang("SchoolProgramNA","#lang#")#
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
                </div>    
            </td>
            <td>
                <!-- Start Innovation Resources Column -->
    <div class="col-xs-4" style="position:relative;top:-40px;left:40px">
         <span class="headerText">2014 #displayLang("State Rank","#lang#")# <span class="stateRank">#rank_2014#</span></span>   
        <div>
           <table class="rankTable">
            <tr>
                <td width="125" nowrap><b>#displayLang("2014 Grade","#lang#")#</b></td>
                <td width="75" style="text-align:right">
                    <b>#GRADE_2014#</b>
                </td>
                <td>

                </td>
            </tr>
        </table>
        </div>
        <br>
        
        <span class="headerText">#displayLang("Innovative Resources","#lang#")#</span>
        <div>
            <table class="innovativeTable">
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
               
    </div>
    <!-- End Innovation Resource Column -->  
            </td>
        </tr>
    </table>
  
<!-- End First 3 Sets of Columns Campus Prfile, Report Card, State Rank -->          

<!-- Start Row for Student Diversity, School Programs and Innovation Resources-->      
<div class="row">
   
    <div class="col-xs-1"></div>
   
    <div class="col-xs-1"></div>
          
</div>
<!-- End Row for Student Diversity, School Programs and Innovation Resources--> 
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
</body>
</html>
 <!--- <cfcatch type = "ANy"> 
 
            <h3>You've Thrown a An <b>Error</b></h3> 
            <cfoutput> 
           
                <p>#cfcatch.message#</p> 
                <p>Caught an exception, type = #CFCATCH.TYPE#</p> 
                <p>The contents of the tag stack are:</p> 
                <p>Please send this information to Sophek_Tounn@advancenetlabs.org</p>
            </cfoutput> 
        </cfcatch>

</cftry>     --->



