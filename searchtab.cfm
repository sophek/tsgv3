<div class="container">
<p><h1 style="padding-left:20px;">Search Schools Below:</h1></p>
	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">School</li>
		<li class="tab-link" data-tab="tab-2">District</li>
		<li class="tab-link" data-tab="tab-3">Grade</li>
		<li class="tab-link" data-tab="tab-4">School Level</li>
        <li class="tab-link" data-tab="tab-5">School Type</li>
        <li class="tab-link" data-tab="tab-6">Address</li>
        <li class="tab-link" data-tab="tab-7">City</li>
        <li class="tab-link" data-tab="tab-8">Zip code</li>
	</ul>
<form action="index2.cfm" method="post">
    <!-- Tab 1 -->
	<div id="tab-1" class="tab-content current">
		<div class="subscribe">
            <div class="subscribe-inner">
			     <input type="text" id="campus" name="campus" value="<cfoutput>#form.campus#</cfoutput>" placeholder="Enter School Name" class="subscribe-field">
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 2 -->
	<div id="tab-2" class="tab-content">
        <div class="subscribe">
            <div class="subscribe-inner">
                <cfinclude template="selectDistrict.cfm">
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 3 -->
	<div id="tab-3" class="tab-content">
		 <div class="subscribe">
             <div class="subscribe-inner">
                 
                  <cfoutput>
                                    <select multiple name="letter_grade" style="" class="name_search form-control custom-dropdown">
                                        <option value=''>Please select a grade. Hold the shift key to select more than 1 grade.</option>
                                        <option value="All" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "All">selected</cfif>>All</option>
                                        <option value="A+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A+">selected</cfif>>A+</option>
                                        <option value="A" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A">selected</cfif>>A</option>
                                        <option value="A-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "A-">selected</cfif>>A-</option>
                                        <option value="B+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B+">selected</cfif>>B+</option>
                                        <option value="B" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B">selected</cfif>>B</option>
                                        <option value="B-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "B-">selected</cfif>>B-</option>
                                        <option value="C+" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C+">selected</cfif>>C+</option>
                                        <option value="C" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C">selected</cfif>>C</option>
                                        <option value="C-" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "C-">selected</cfif>>C-</option>
                                        <option value="D" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "D">selected</cfif>>D</option>
                                        <option value="F" <cfif isdefined("form.letter_grade") AND form.letter_grade EQ "F">selected</cfif>>F</option>
                                        <option value="Not Available">Not Available</option>
                                        </select>
                                    </cfoutput>
                 
                 
			     
             </div><!-- /.subscribe-inner -->
        </div>
	</div>
    <!-- Tab 4 -->    
	<div id="tab-4" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
                <select name="school_level" class="name_search form-control custom-dropdown">
                <option value=''>Select Elementary, Middle or High School</option>
                <option value='All'>All</option>
		        <option value="E" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "E">selected</cfif></cfoutput>>Elementary School</option>
		        <option value="M" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "M">selected</cfif></cfoutput>>Middle School</option>
		        <option value="H" <cfoutput><cfif isdefined("form.school_level") AND form.school_level EQ "H">selected</cfif></cfoutput>>High School</option>
		      </select>
            </div>			
        </div>
	</div>
    <!-- Tab 5 -->
    <div id="tab-5" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
            <select name="charter_yes_and_no" class="name_search form-control custom-dropdown">
            <option value=''>Select Magnet, Charter or Public School</option>
            <option value="All" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "All">selected</cfif></cfoutput>>All</option>
		    <option value="Peg" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Peg">selected</cfif></cfoutput>>Magnet School</option>
		    <option value="Yes" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "Yes">selected</cfif></cfoutput>>Charter School</option>
		    <option value="No" <cfoutput><cfif isdefined("form.charter_yes_and_no") AND form.charter_yes_and_no EQ "No">selected</cfif></cfoutput>>Traditional Public School</option>
		    </select>
        </div><!-- /.subscribe-inner -->
        </div>
	</div>
        
    <!-- Tab 6 -->    
    <div id="tab-6" class="tab-content">
		<div class="subscribe">
            <div class="subscribe-inner">
                <input type="text" id="address" name="address" value="<cfoutput>#form.address#</cfoutput>" placeholder="Address" class="subscribe-field">
            </div>
        </div>
	</div>
    <!-- Tab 7 -->
    <div id="tab-7" class="tab-content">
        <div class="subscribe">
		      <div class="subscribe-inner">
			         <input type="text" id="city" name="city" value="<cfoutput>#form.city#</cfoutput>" placeholder="City" class="subscribe-field">
              </div>
        </div>
	</div>
    <!-- Tab 8 -->
    <div id="tab-8" class="tab-content">
		<div class="subscribe">
			<div class="subscribe-inner">
			     <input type="text" id="zip_code" name="zip_code" value="<cfoutput>#form.zip_code#</cfoutput>" placeholder="Zip code" class="subscribe-field">
                <div class="form-group">
							<label class="control-label">Within - by Miles:</label>
							<select name="radius" class="name_search form-control custom-dropdown">
                                <option value=''>- Select Miles - </option>
                                <option value="2" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "2">selected</cfif></cfoutput>>2 Miles</option>
                                <option value="5" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "5">selected</cfif></cfoutput>>5 Miles</option>
                                <option value="10" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "10">selected</cfif></cfoutput>>10 Miles</option>
                                <option value="20" <cfoutput><cfif isdefined("form.radius") AND form.radius EQ "20">selected</cfif></cfoutput>>20 Miles</option>
                            </select>
						      </div>
            </div><!-- /.subscribe-inner -->
        </div>
	</div>
<div class="subscribe" style="float:left;position:relative;left:25px">
    <input type="submit" value="Search" class="subscribe-btn" style="font-size:1.5em;width:200px">  
</div>    
    </form>
</div>