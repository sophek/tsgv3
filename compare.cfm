<!--- <cftry> --->
   
       
<cfinclude template="tsgFunctions.cfm">
<cfset lang = "EN">
<cfoutput>
<!-- If school 1 and school 2 where search against run this code below -->
<cfif isdefined("url.school1") AND url.school1 NEQ "" AND isdefined("url.school2") AND url.school2 NEQ "">
 <cfquery name="rResult" datasource="tsgMysql">
     select campus, id_number from schools where campus in ('#url.school1#','#url.school2#') LIMIT 2;
    </cfquery>
    <!-- Set the id_number off the campus name -->
    <cfset schoolOneQryString = #rResult.id_number[1]# />
    <cfset schoolTwoQryString = #rResult.id_number[2]# /> 
<cfelse>
    <cfset list = "#cgi.query_string#"> 
    <cfset arr = listToArray (list, "&")>
    <cfset schoolOneQryString = #replace(arr[4],'id%5B%5D=','')# />
    <cfset schoolTwoQryString = #replace(arr[5],'id%5B%5D=','')# />
</cfif>    

<cfif schoolOneQryString NEQ "" AND  schoolTwoQryString NEQ "">
<cfquery name="qrySchools" datasource="tsgMysql" maxrows="2">
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
    AND ID_NUMBER IN ('#schoolOneQryString#','#schoolTwoQryString#')
</cfquery>
    <!-- Set Pie Calculation 1 -->

    <cfscript>
    races = queryNew("race,raceColor,raceName");
    queryAddRow(races, 4);
 
    querySetCell(races, "race", qrySchools.white[1], 1);
    querySetCell(races, "raceColor", "blue", 1);
    querySetCell(races, "raceName", "White", 1);
    
    querySetCell(races, "race", qrySchools.black[1], 2);
    querySetCell(races, "raceColor", "orange", 2);
    querySetCell(races, "raceName", "Black", 2);
    
    querySetCell(races, "race", qrySchools.hispanic[1], 3);
    querySetCell(races, "raceColor", "green", 3);
    querySetCell(races, "raceName", "Hispanic", 3);
    
    querySetCell(races, "race", qrySchools.others[1], 4);
    querySetCell(races, "raceColor", "red", 4);
    querySetCell(races, "raceName", "Others", 4);
    </cfscript>
    
    <cfquery dbtype="query" name="race">
        select race,raceColor,raceName from races
    </cfquery>
    
    <!-- Set the Color Pattern for Pie Chart 1 -->
    <cfset colorPattern = "" />    
    <cfloop query="race">
        <cfif race neq "N/A">
            <cfset colorPattern = colorPattern & "'" & race.raceColor & "'" />
            <cfset colorPattern = colorPattern & "," />
        </cfif>
    </cfloop>
    <!-- End of Pie 1 Calculation -->
    
    <!-- Set Pie Chart 2 Calculation -->
    <cfscript>
    races2 = queryNew("race,raceColor,raceName");
    queryAddRow(races2, 4);
 
    querySetCell(races2, "race", qrySchools.white[2], 1);
    querySetCell(races2, "raceColor", "blue", 1);
    querySetCell(races2, "raceName", "White", 1);
    
    querySetCell(races2, "race", qrySchools.black[2], 2);
    querySetCell(races2, "raceColor", "orange", 2);
    querySetCell(races2, "raceName", "Black", 2);
    
    querySetCell(races2, "race", qrySchools.hispanic[2], 3);
    querySetCell(races2, "raceColor", "green", 3);
    querySetCell(races2, "raceName", "Hispanic", 3);
    
    querySetCell(races2, "race", qrySchools.others[2], 4);
    querySetCell(races2, "raceColor", "red", 4);
    querySetCell(races2, "raceName", "Others", 4);
    </cfscript> 

    <!-- Create a subquery from the races2 query object -->
    <cfquery dbtype="query" name="race2">
        select race,raceColor,raceName from races2
    </cfquery>
    
    <!-- Set the Color Pattern for Pie Chart 2 -->
    <cfset colorPattern2 = "" />    
    <cfloop query="race2">
        <cfif race neq "N/A">
            <cfset colorPattern2 = colorPattern2 & "'" & race2.raceColor & "'" />
            <cfset colorPattern2 = colorPattern2 & "," />
        </cfif>
    </cfloop>
    
    
<!-- Start bar chart 1 for State Rank table -->    
    
<cfset meterAchievementIndex = "meter-" & "#avgColor(qrySchools.ACHIEVEMENT_INDEX_PERCENTILE[1])#" />
<cfset meterCampusPerformanceIndex = "meter-" & "#avgColor(qrySchools.CAMPUS_PERFORMANCE_INDEX_PERCENTILE[1])#" />
<cfset meterGrowthIndex = "meter-" & "#avgColor(qrySchools.GROWTH_INDEX_PERCENTILE[1])#" />
<cfset meterCompositeIndex = "meter-" & "#avgColor(qrySchools.COMPOSITE_INDEX_PERCENTILE[1])#" />
    
<!-- Start bar chart 1 for State Rank table -->
    
<!-- Set the bg image dynamically by using the school level -->    
    <cfif qrySchools.recordcount GT 0>
        <cfset schoolbg = "assets/images/profileCompareBg" & "#qrySchools.school_level[1]#" & "#qrySchools.school_level[2]#" & ".jpg">
    </cfif>
<cfelse>
   Please go back.
</cfif>   

    
</cfoutput>
    
<!--- Set teh State Rank color bars --->

    
<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
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
        
     
        .link-black{
            color: black;
        }
    
        .bigger{
            font-size: 2em;
        }
        
         h1, .campus {
           
            font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
            margin-top: 0px;
            margin-bottom: 0px;
            
        }
        
        .campus{
            
            font-size:20px;
        }
        
        section h1 {
           
            font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            
        }
        
        section {
            padding-top: 20px;
            
        }
        
        section table {
          width: 475;
          padding-left: 5px;    
        }
        
        section div > p {
          padding-left: 20px;
          line-height: 15px;    
        }
        
        section table td {
            font-family: "proxima-nova",sans-serif;
            font-style: normal;
            font-weight: 400;
            line-height: 30px;
            
        }
        
        
         section p {
            font-family: "proxima-nova",sans-serif;
            font-style: normal;
            font-weight: 400;
            line-height: 25px;
            
        }
        
        .address{
            font-family: "arial",sans-serif;
            font-style: bold;
            font-weight: 700;
            font-size: 16px;
            line-height: 15px;
            color: #ff3333;
        }
        
        
        #grade{
            width: 75px;
            height: 75px;
            background-image: url(assets/images/gradePlaceholder.png);
            text-align: center;
            display: block;
           
        }
        
        #schools, #rank{
                <cfoutput>
                    background-image: url('#schoolbg#');
                </cfoutput>    
             
            height: 1200px;
            width: 1000px;
            padding: 0px;
        }
        
         #ReportCard {
            background-image: url('assets/images/reportCard.jpg');
            height: 1200px;
            width: 1000px;
            padding: 0px;
        }
        
        .myReportCard{
            position: relative;
            left: 90px;
            top:125px;
            
        }
        
        .myReportCard table td{
           
            line-height: 30px;
        }
        
        #grade p{
            
             font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 800;
            font-variant: small-caps;
            font-size: 48px;
            position: relative;
            top:25px;
            color: red;
        }
        
        body{
            background-color: #7ecebc;
            padding: 0;
            margin: 0;
            
        }
        
        .navTable td a {
            text-align: center;
            align-content: center;
        }
        
        .form-control{
            background-color: #e8e2db;
            font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
            color: black;
            text-transform: uppercase;
        }
        
        input::-webkit-input-placeholder {
            color: black !important;
            font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
}
 
input:-moz-placeholder { /* Firefox 18- */
color: black!important;  
    font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
}
 
input::-moz-placeholder {  /* Firefox 19+ */
color: black !important;  
    font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
}
 
input:-ms-input-placeholder {  
color: black !important;  
    font-family: "futura-pt",sans-serif;
            font-style: normal;
            font-weight: 700;
            font-variant: small-caps;
            font-size: 16px;
}
        
    </style>  
        
        
        
</head>
<body>
    
    
   
    
    
<!--- Query the school db and only display the profile if there is a record. --->    
<cfif qrySchools.recordcount GT 0>

<div id="profile" class="container">
        
<!-- Start Campus Profile Section --> 
 <form action="compare.cfm" method="get">    
<div id="schools">
    <div class="row">
<cfoutput query="qrySchools" maxrows="2">
<div id="school" class="col-xs-6">
    <section>
    <div class="nav">
        <table class="navTable">
            <tr>
                <td><a href="##schools"><img src="assets/images/campus_profile_icon.png"></a></td>
                <td><a href="##ReportCard"><img src="assets/images/report_card.png"></a></td>
                <td><a href="##Rank"><img src="assets/images/state_rank.png"></a></td>
            </tr>
            <tr>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Campus Profile</td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Card</td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;State Rank</td>
            </tr>
        </table>
    </div>
</section>
<section>
   
    <div class="input-group">
      <input type="text" name="school#currentrow#" class="form-control" placeholder="#campus[currentrow]#">
      <input type="hidden" name="schooloneHidden" value="#id_number[1]#" /> 
      <input type="hidden" name="schooltwoHidden" value="#id_number[2]#" /> 
      <span class="input-group-btn">
        <input type="submit" class="btn btn-default" value="Search" />
      </span>
    </div><!-- /input-group -->
  
    <h1 class="campus"></h1><br>
    <div>
        <table>
            <tr>
                <td>
                    <p class="address">#displayLang(schoolTypeCharter(school_type),"#lang#")# | #displayLang(school_level,"#lang#")# | #low_grade# - #high_grade#</p>
                    <p class="address">#district#</p>
                    <p class="address">#address#, #city#, TX, #zip_code#</p>
                </td>
            </tr>
        </table>
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
            <td><h1>#displayLang("CURRENT GRADE","#lang#")# : </h1></td>
            <td style="position:relative;left:-150px;"><span id="grade"><p style="color:#gradeColor(letter_grade)#">#letter_grade#</p></td>
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
                
             <cfif qrySchools.currentrow EQ 1>
            <cfloop query="race">
                    <cfif race neq "N/A">
                        <li class="#raceColor#">
                            <p>#displayLang("#raceName#","#lang#")# : #cleanResult((race * 100))#%</p>
                        </li>
                    </cfif>
                </cfloop>    
            <cfelse>
                <cfloop query="race2">
                    <cfif race neq "N/A">
                        <li class="#raceColor#">
                            <p>#displayLang("#raceName#","#lang#")# : #cleanResult((race * 100))#%</p>
                        </li>
                    </cfif>
                </cfloop>     
            </cfif>     
            </td>
            <td><cfif qrySchools.currentrow EQ 1>
                <div id="c3-pie" style="height: 160px;width:200px;position:relative;left:150px;top:-50px"></div>
                <cfelse>
                <div id="c3-pie2" style="height: 160px;width:200px;position:relative;left:150px;top:-50px"></div>    
                </cfif>
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
                                                <tr><td>Art Classes</td></tr>
                                            </cfif>
                                            <cfif displaySchoolProgram(MUSIC_CLASSES) EQ "YES">
                                                <tr><td>Music Classes</td></tr>
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
                                    <tr><td>#i#</td></tr>
                                </cfloop>
                            </table>
                        </cfif>
                    </td>
                    </cfif>
                </tr>
            </table>
        </div>
</section>
</div>           
</cfoutput>
    </div>
</div>
    </form>    
<!-- End Campus Profile Section -->

<!-- Start Rank Section -->
<div id="Rank">
    <div class="row">
<cfoutput query="qrySchools" maxrows="2">    
    <div id="stateRank" class="col-xs-6">
        <section>
            <div class="nav">
                <table class="navTable">
                    <tr>
                        <td><a href="##schools"><img src="assets/images/campus_profile_icon.png"></a></td>
                        <td><a href="##ReportCard"><img src="assets/images/report_card.png"></a></td>
                        <td><a href="##Rank"><img src="assets/images/state_rank.png"></a></td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Campus Profile</td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Card</td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;State Rank</td>
                    </tr>
                </table>
            </div>
        </section>
        <section>
          <div class="input-group">
      <input type="text" name="school#currentrow#" class="form-control" placeholder="#campus[currentrow]#">
      <input type="hidden" name="schooloneHidden" value="#id_number[1]#" /> 
      <input type="hidden" name="schooltwoHidden" value="#id_number[2]#" /> 
      <span class="input-group-btn">
        <input type="submit" class="btn btn-default" value="Search" />
      </span>
    </div><!-- /input-group -->
      
            
        <h1 class="campus"></h1><br>
        <div>
            <table>
                <tr>
                    <td>
                    <p class="address">#displayLang(schoolTypeCharter(school_type),"#lang#")# | #displayLang(school_level,"#lang#")# | #low_grade# - #high_grade#</p>
                    <p class="address">#district#</p>
                    <p class="address">#address#, #city#, TX, #zip_code#</p>
                    </td>
                </tr>
            </table>
        </div>    
    </section>
        
        <section><h1>2015 #displayLang("State Rank","#lang#")# <span class="stateRank">#cleanResult(STATE_RANK_2015)# / <cfif school_level eq "H">1193<cfelse>4421</span></cfif></h1><span id="grade" style="position:relative;top:-25px;left:250px"><p style="color:#gradeColor(letter_grade)#">#letter_grade#</p></section>
        <section>
            <div>
                    <table cellpadding="2" cellspacing="2">
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
                </div>
                    <div>
                                <ul class="averageLegend" style="position:relative;left:-50px;">
                                    <li><span class="redBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Below Average","#lang#")#</li>
                                    <li><span class="blueBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Average","#lang#")#</li>
                                    <li><span class="greenBlock">&nbsp;&nbsp;&nbsp;</span>&nbsp;#displayLang("Above Average","#lang#")#</li>
                                </ul>
                    </div>
                
        </section>
        <section>
            <h1>#displayLang("2014 STATE RANK","#lang#")# <span class="stateRank">#rank_2014#</h1><span id="grade" style="position:relative;top:-25px;left:250px"><p style="color:#gradeColor(letter_grade)#">#GRADE_2014#</p>
        </section>    
    </div>
    </cfoutput>
    </div>    
</div>    
<!-- End Rank Section -->        

<!-- Start Report Card Section -->
<div id="ReportCard">
    <div class="row">
<cfoutput query="qrySchools" maxrows="2">    
    <div id="report" class="col-xs-6">
             <section>
                <div class="nav">
                    <table class="navTable">
                        <tr>
                            <td><a href="##schools"><img src="assets/images/campus_profile_icon.png"></a></td>
                            <td><a href="##ReportCard"><img src="assets/images/report_card.png"></a></td>
                            <td><a href="##Rank"><img src="assets/images/state_rank.png"></a></td>
                        </tr>
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Campus Profile</td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Card</td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;State Rank</td>
                        </tr>
                    </table>
                </div>
            </section>
        <section>
              <div class="input-group">
      <input type="text" name="school#currentrow#" class="form-control" placeholder="#campus[currentrow]#">
      <input type="hidden" name="schooloneHidden" value="#id_number[1]#" /> 
      <input type="hidden" name="schooltwoHidden" value="#id_number[2]#" /> 
      <span class="input-group-btn">
        <input type="submit" class="btn btn-default" value="Search" />
      </span>
    </div><!-- /input-group -->
  
            
            
        <h1 style="position:relative;left:50px;" class="campus"></h1><br>
            <div style="position:relative;left:50px;">
                <table>
                    <tr>
                        <td>
                            <p class="address">#displayLang(schoolTypeCharter(school_type),"#lang#")# | #displayLang(school_level,"#lang#")# | #low_grade# - #high_grade#</p>
                            <p class="address">#district#</p>
                            <p class="address">#address#, #city#, TX, #zip_code#</p>
                        </td>
                    </tr>
                </table>
            </div>    
        </section>
        <section class="myReportCard">
            <div>
                     <table style="width:300px">
                         
                         <tr>
                            <td align="right" colspan="2">
                             <h1 class="bigger">2015 Report Card </h1>
                             </td>
                         </tr> 
                         <tr>
                            <td align="right" colspan="2">
                             <span id="grade" style="position:relative;top:0px;left:0px"><p style="color:#gradeColor(letter_grade)#">#GRADE_2014#</p>
                             </td>
                         </tr>
                        <tr>
                            <td></td>
                            <td>Score</td>
                         </tr> 
                        <tr>
                            <td nowrap><a href="##" data-toggle="tooltip" title="STAAR is the State of Texas Assessments of Academic Readiness that measures student’s performance" class="link-black">#displayLang("STAAR Math - Adv","#lang#")#*</a></td>
                            <td><b>#cleanResult(STAAR_MATH_ADVANCED,"percent")#</b>
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"><hr></td>
                         </tr>
                        <tr>
                            <td nowrap><a href="##" data-toggle="tooltip" title="STAAR is the State of Texas Assessments of Academic Readiness that measures student’s performance" class="link-black">#displayLang("STAAR Reading - Adv","#lang#")#</a></td>
                            <td><b>#cleanResult(STAAR_READING_ADVANCED,"percent")#</b>
                            </td>
                        </tr>
                          <tr>
                            <td colspan="2"><hr></td>
                         </tr>
                        <tr>
                            <td><a href="##" data-toggle="tooltip" title="A measure of student-level performance relative to a student’s test-score peers." class="link-black">#displayLang("Reading Gain Score","#lang#")#*</a></td>
                            <td>
                                <b>#cleanResult(READING_GAIN_SCORE)#</b>
                            </td>
                        </tr>
                          <tr>
                            <td colspan="2"><hr></td>
                         </tr>
                        <tr>
                            <td><a href="##" data-toggle="tooltip" title="Gain scores in math and reading measure student-level performance relative to a student’s test-score peers. A student’s test score peers are all the students statewide who took the same subject-matter test last year and posted the same score (at the same grade level). Thus, the peer group for a 6th grade math student who scored a 20 on the 5th grade math test is everyone who also scored a 20 on the 5th grade math test, statewide." class="link-black">#displayLang("Math Gain Score","#lang#")#</a></td>
                            <td>
                                <b>#cleanResult(MATH_GAIN_SCORE)#<b> 
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"><hr></td>
                         </tr>        
                        <cfif #school_level# eq "H">
                        <tr>
                            <td nowrap>C@R Graduation Rate</td>
                            <td><b>#cleanResult(cr_graduation_rate,"percent")#</b>
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"><hr></td>
                         </tr>    
                        <tr>
                            <td nowrap>Student Passing AP/IB</td>
                            <td><b>#cleanResult(ap_ib_participation_rate)#</b>
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"><hr></td>
                         </tr>    
                        <tr>
                            <td nowrap>Average SAT Score</td>
                            <td><b>#average_sat_total_score#</b>
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"><hr></td>
                         </tr>    
                        <tr>
                            <td nowrap>Average ACT Score</td>
                            <td><b>#cleanResult(average_act_composite_score)#</b>
                            </td>
                        </tr>
                        </cfif>

                    </table>
                </div>
        </section>  
    </div>
    </cfoutput>
    </div>    
</div>    
<!-- End Rank Section --> 

    

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
                                    
                                    
                                    
<script>	
var chart = c3.generate({
bindto: '#c3-pie2',
data: {
	// iris data from R
	columns: [
        <cfloop query="race2">
            <cfif race neq "N/A">
                <cfoutput>['#raceName#',#race# ],</cfoutput>
            </cfif>
        </cfloop>
       
         ],
	type : 'pie'
},
color: {
  pattern: [<cfoutput>#colorPattern2#</cfoutput>]
},  
legend: {
show: false
},
});
</script>  
    
<script>
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip(); 
      $('a[href*=#]:not([href=#])').click(function() {
	    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

	      var target = $(this.hash);
	      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
	      if (target.length) {
	        $('html,body').animate({
	          scrollTop: target.offset().top
	        }, 1000);
	        return false;
	      }
	    }
	  });
	
    
    
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



