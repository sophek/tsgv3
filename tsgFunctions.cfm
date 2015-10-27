




<cffunction name="schoolBg" returnType="String" hint="Get the grade color">
    <cfargument name="schoolOne" Type="string" required="true" default="">
    <cfargument name="schoolTwo" Type="string" required="true" default="">    
    <!--- Function body code goes here. --->
	<cfset local.bgImage = "profileCompareBg" & "#arguments.schoolOne#" & "#arguments.schoolTwo#" & ".jpg" />
    <cfreturn replace(bgImage," ","")>
</cffunction>
        
<cffunction name="gradeColor" returnType="String" hint="Get the grade color">
    <cfargument name="grade" Type="string" required="true" default="">
    <!--- Function body code goes here. --->
	<cfset local.color ="" />

        
<cfswitch expression="#arguments.grade#">

   <cfcase value="A,A-,A+">
     <cfset color = "##5fa176" />
   </cfcase>
    <cfcase value="B,B-,B+">
     <cfset color = "##6074a2" />
   </cfcase> 
    <cfcase value="C,C-,C+">
     <cfset color = "##968758" />
   </cfcase> 
    <cfcase value="D,D-,D+">
     <cfset color = "##cf3237" />
   </cfcase>
    <cfcase value="F">
     <cfset color = "##9e0100" />
   </cfcase>
   <cfdefaultcase>
     <cfset color = "##000000" />
   </cfdefaultcase>
</cfswitch>
        
    <cfreturn color>
</cffunction>

<cffunction name="avgColor" returnType="String" hint="Get the average color">
    <cfargument name="score" Type="string" required="true" default="">
    <!--- Function body code goes here. --->
	<cfset colorAvg = "">
	<cfif score LTE 25>
		<cfset colorAvg = "red" />
	<cfelseif score GTE 25 AND score LTE 75>
		<cfset colorAvg = "blue" />
	<cfelseif score GT 75>
		<cfset colorAvg = "green" />
	</cfif>
    <cfreturn colorAvg>
</cffunction>
        
<cffunction name="schoolTypeCharter" returnType="String" hint="">
    <cfargument name="school" Type="string" required="true" default="">
    <!--- Function body code goes here. --->
	<cfif #arguments.school# eq "Yes">
        <cfreturn "Charter School">
    </cfif>
    <cfif #arguments.school# eq "No" or arguments.school eq "NA">
        <cfreturn "Traditional Public School">
    </cfif>
        
</cffunction>
        
        

<cffunction name="displaySchoolProgram" returnType="String" hint="Display School Program">
    <cfargument name="program" Type="string" required="true" default="">
    <!--- Function body code goes here. --->
	<cfset result = "">
	<cfif arguments.program EQ "Data Not Available">
		<cfset result = "">
		<cfelse>
		<cfset result = arguments.program>	
	</cfif>
	<cfreturn result>
</cffunction>
		
<cffunction name="DisplayNA" returnType="String" hint="Display NA result">
	<cfargument name="TextToDisplay" Type="string" required="true" default="">
	<cfif arguments.TextToDisplay EQ "Not Available" or arguments.TextToDisplay eq "" or isnull(arguments.TextToDisplay)>
		<cfset display = "NA">
	<cfelse>
		<cfset display = arguments.TextToDisplay>
	</cfif>
	<cfreturn display>
</cffunction>

<cffunction name="cleanResult" returnType="String">
	<cfargument name="myString" Type="string" required="true" default="">
	<cfargument name="percent" Type="string" required="false" default="">

	<cfset localresult = "">
	<cfif arguments.myString eq "" or arguments.myString eq "Not Available" or isnull(arguments.myString) or arguments.myString eq "NA">
		<cfset localresult = "NA">
	<cfelse>
		<cfif findnocase(".",arguments.myString) eq 0>
				<cfset localresult = arguments.myString>
		<cfelseif findnocase(".",arguments.myString) eq 2>
				<cfif arguments.percent neq "">
					<cfset localresult = arguments.myString * 100>
					<cfset localresult = localresult>
					<cfset localresult = Left(localresult,4) & "%">
				<cfelse>
					<cfset localresult = arguments.myString>
					<cfset localresult = Left(localresult,3)>
				</cfif>
		<cfelseif findnocase(".",arguments.myString) eq 3>
				<cfif arguments.percent neq "">
					<cfset localresult = arguments.myString>
					<cfset localresult = localresult>
					<cfset localresult = Left(localresult,4) & "%">
				<cfelse>
					<cfset localresult = arguments.myString>
					<cfset localresult = Left(localresult,4)>
				</cfif>
		
		</cfif>
	</cfif>
	<cfreturn localresult>
</cffunction>

<cffunction name="displayLang" returnType="String">
	<cfargument name="TextToDisplay" Type="string" required="true" default="">
	<cfargument name="lang" Type="string" required="false" default="EN">
	
	<cfswitch expression="#Ucase(Trim(arguments.TextToDisplay))#"> 
    <cfcase value="CAMPUS PROFILE"> <cfif arguments.lang eq "EN"> CAMPUS PROFILE <cfelse> PERFIL DE ESCUELA </cfif> </cfcase>

<cfcase value="Enrollment"> <cfif arguments.lang eq "EN"> Enrollment <cfelse> Inscripci&oacute;n </cfif> </cfcase>

<cfcase value="Economically Disadvantaged"> <cfif arguments.lang eq "EN"> Economically Disadvantaged <cfelse> En desventaja econ&oacute;mica </cfif> </cfcase>

<cfcase value="Special Education"> <cfif arguments.lang eq "EN"> Special Education * <cfelse> Educaci&oacute;n especial * </cfif> </cfcase>

<cfcase value="Student Teacher Ratio"> <cfif arguments.lang eq "EN"> Student Teacher Ratio * <cfelse> N&uacute;mero de alumnos por profesor * </cfif> </cfcase>

<cfcase value="Mobility Rate"> <cfif arguments.lang eq "EN"> Mobility Rate * <cfelse> Movilidad * </cfif> </cfcase>

<cfcase value="3rd Grade Avg. Class Size"> <cfif arguments.lang eq "EN"> 3rd Grade Avg. Class Size* <cfelse> Tama&ntilde;o promedio de clase de 3er Grado* </cfif> </cfcase>

<cfcase value="STUDENT DIVERSITY"> <cfif arguments.lang eq "EN"> STUDENT DIVERSITY <cfelse> Diversidad de Estudiantes </cfif> </cfcase>

<cfcase value="White"> <cfif arguments.lang eq "EN"> White <cfelse> Raza blanca </cfif> </cfcase>

<cfcase value="Black"> <cfif arguments.lang eq "EN"> Black <cfelse> Afro Americano </cfif> </cfcase>

<cfcase value="Hispanic"> <cfif arguments.lang eq "EN"> Hispanic <cfelse> Hispano </cfif> </cfcase>

<cfcase value="Others"> <cfif arguments.lang eq "EN"> Other <cfelse> Otra raza </cfif> </cfcase>

<cfcase value="REPORT CARD"> <cfif arguments.lang eq "EN"> REPORT CARD <cfelse> Boleta de Calificaciones </cfif> </cfcase>

<cfcase value="STAAR Math - Adv"> <cfif arguments.lang eq "EN"> STAAR Math - Advanced <cfelse> STAAR Matem&aacute;ticas - Avanzado </cfif> </cfcase>

<cfcase value="STAAR Reading - Adv"> <cfif arguments.lang eq "EN"> STAAR Reading - Advanced <cfelse> STAAR Lectura - Avanzado </cfif> </cfcase>

<cfcase value="Reading Gain Score"> <cfif arguments.lang eq "EN"> Reading Gain Score <cfelse> Puntaje de Ganancia en Lectura </cfif> </cfcase>

<cfcase value="Math Gain Score"> <cfif arguments.lang eq "EN"> Math Gain Score <cfelse> Puntaje de Ganancia en Matem&aacute;ticas </cfif> </cfcase>

<cfcase value="Below Average"> <cfif arguments.lang eq "EN"> Below Average <cfelse> Debajo del promedio </cfif> </cfcase>

<cfcase value="Average"> <cfif arguments.lang eq "EN"> Average <cfelse> Promedio </cfif> </cfcase>

<cfcase value="Above Average"> <cfif arguments.lang eq "EN"> Above Average <cfelse> Arriba del promedio </cfif> </cfcase>

<cfcase value="STATE RANK"> <cfif arguments.lang eq "EN"> STATE RANK <cfelse> Posici&oacute;n </cfif> </cfcase>

<cfcase value="Achievement Index"> <cfif arguments.lang eq "EN"> Achievement Index <cfelse> &Iacute;ndice de logros acad&eacute;micos </cfif> </cfcase>

<cfcase value="Performance Index"> <cfif arguments.lang eq "EN"> Performance Index <cfelse> &Iacute;ndice de Desempe&ntilde;o </cfif> </cfcase>

<cfcase value="Growth Index"> <cfif arguments.lang eq "EN"> Growth Index <cfelse> &Iacute;ndice de Crecimiento </cfif> </cfcase>
<cfcase value="Current Grade"> <cfif arguments.lang eq "EN"> CURRENT GRADE <cfelse> &Iacute;ndice de Crecimiento </cfif> </cfcase>

<cfcase value="Composite Index"> <cfif arguments.lang eq "EN"> Composite Index <cfelse> &Iacute;ndice de Crecimiento </cfif> </cfcase>
<cfcase value="2014 State Rank"> <cfif arguments.lang eq "EN"> 2014 STATE RANK <cfelse> &Iacute;ndice de Crecimiento </cfif> </cfcase>
<cfcase value="2014 Grade"> <cfif arguments.lang eq "EN"> 2014 Grade <cfelse> &Iacute;ndice de Crecimiento </cfif> </cfcase>
    
<cfcase value="School Programs"> <cfif arguments.lang eq "EN"> SCHOOL PROGRAMS * <cfelse> Activos de la Escuela * </cfif> </cfcase>

<cfcase value="INNOVATIVE RESOURCES"> <cfif arguments.lang eq "EN"> INNOVATIVE RESOURCES* <cfelse> Recursos Innovadores </cfif> </cfcase>
<cfcase value="SchoolProgramNA"> <cfif arguments.lang eq "EN">No school program data were available at the time of publication. Please contact the school directly for more information.<cfelse> Datos sobre Activos de la Escuela no estaban disponibles en el momento de publicaci&oacute;n.  Por favor, p&oacute;ngase en contacto con la escuela directamente para obtener mas informaci&oacute;n.</cfif> </cfcase>
<cfcase value="InnovationNA"> <cfif arguments.lang eq "EN">No additional resources data were available at the time of publication. Please contact the school directly for more information.<cfelse> Datos sobre los recursos innovadores de esta escuela no estaban disponibles en el momento de publicaci&oacute;n.  Por favor, p&oacute;ngase en contacto con la escuela directamente para obtener mas informaci&oacute;n.</cfif> </cfcase>
<cfcase value="Traditional public school"> <cfif arguments.lang eq "EN"> Traditional public school <cfelse> Escuela P&uacute;blica Tradicional </cfif> </cfcase>
<cfcase value="All"> <cfif arguments.lang eq "EN"> All <cfelse> Todo </cfif> </cfcase>
<cfcase value="Miles"> <cfif arguments.lang eq "EN"> Miles <cfelse> Kms </cfif> </cfcase>
<cfcase value="Search"> <cfif arguments.lang eq "EN"> Search <cfelse> Busque </cfif> </cfcase>
<cfcase value="Charter school"> <cfif arguments.lang eq "EN"> Charter school <cfelse> Escuela Charter (Aut&oacute;noma) </cfif> </cfcase>
<cfcase value="M"> <cfif arguments.lang eq "EN"> Middle <cfelse> Secundarias </cfif> </cfcase>
<cfcase value="H"> <cfif arguments.lang eq "EN"> High <cfelse> Preparatorias </cfif> </cfcase>
<cfcase value="E"> <cfif arguments.lang eq "EN"> Elementary <cfelse> Primarias </cfif> </cfcase>
	
    <cfdefaultcase> 
    </cfdefaultcase> 
</cfswitch> 

</cffunction>


<cffunction name="gradecss" returnType="String">
<cfargument name="grade" Type="string" required="true" default="">
<cfset gradecss = "">
<cfswitch expression="#Trim(arguments.grade)#"> 
    <cfcase value="A">
<cfset gradecss = "label-pass">	
    </cfcase> 
    <cfcase value="A+"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
	<cfcase value="A-"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
    
	<cfcase value="B"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
    <cfcase value="B+"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
	<cfcase value="B-"> 
	<cfset gradecss = "label-pass">
    </cfcase>

<cfcase value="C"> 
<cfset gradecss = "label-pass">
    </cfcase> 
    <cfcase value="C+"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
	<cfcase value="C-"> 
	<cfset gradecss = "label-pass">
    </cfcase> 
	<cfcase value="Not Available"> 
	<cfset gradecss = "label-Na">
    </cfcase>
	<cfdefaultcase>
		<cfset gradecss = "label-danger">
    </cfdefaultcase> 
</cfswitch>
	<cfreturn gradecss>
</cffunction>
