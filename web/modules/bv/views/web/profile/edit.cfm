<cfset getMyPlugin(plugin="jQuery").getDepends("validate","secure/profile/details","")>
<div class="page-header">
	<h1>Edit your details</h1>
</div>
<cfoutput>
<form id="changeDetails" class="form-horizontal">
	<fieldset>
		<legend>Settings</legend>
		<div class="control-group">
      <label class="control-label">Default Site</label>
      <div class="controls">
      	<select id="defaultSite" class="json">
      		<cfset currentUserSite = paramValue("rc.userPreferences.defaultSite","buildingVine")>
					<cfloop array="#rc.userSites#" index="s">
						<option value="#s.shortName#" #vm(s.shortName,currentUserSite)#>#s.title#</option>
			    </cfloop>
			  </select>        
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Your contact details</legend>
		<div class="control-group">
      <label class="control-label">Company Name</label>
      <div class="controls">
        <input type="text" name="organisation" id="organisation" class="input-large json" value="#paramValue("rc.user.organisation","")#" />
      </div>
    </div>
	  <div class="control-group">
      <label class="control-label">Job Title</label>
			<div class="controls">
				<input type="text" name="jobtitle" id="jobtitle" class="input-large json" value="#paramValue("rc.user.jobtitle","")#" />
			</div>
	  </div>		
		<div class="control-group">
      <label class="control-label">Work Address 1</label>
      <div class="controls">
        <input type="text" name="companyaddress1" id="companyaddress1" class="input-large json" value="#paramValue("rc.user.companyaddress1","")#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Work Address 2</label>
      <div class="controls">
        <input type="text" name="companyaddress2" id="companyaddress2" class="input-large json" value="#paramValue("rc.user.companyaddress2","")#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Work Address 3</label>
      <div class="controls">
        <input type="text" name="companyaddress3" id="companyaddress3" class="input-large json" value="#paramValue("rc.user.companyaddress3","")#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Direct Line</label>
      <div class="controls">
        <input type="text" name="telephone" id="telephone" class="span2 json" value="#paramValue("rc.user.telephone","")#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Mobile</label>
      <div class="controls">
        <input type="text" name="mobile" id="mobile" class="span2 json" value="#paramValue("rc.user.mobile","")#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Switchboard</label>
      <div class="controls">
        <input type="text" name="companytelephone" id="companytelephone" class="span2 json" value="#paramValue("rc.user.companytelephone","")#" />
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Social Connections</legend>		
    <div class="control-group">
      <label class="control-label">Google&reg;+ Profile</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-google_16"></i></span><input class="json" name="googlePlusProfile" type="text" value="#paramValue("rc.user.googleplusProfile","")#">
        </div>                  
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Facebook Profile</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-facebook_16"></i></span><input class="json" name="facebookProfile" type="text" value="#paramValue("rc.user.facebookProfile","")#">
        </div>                  
      </div>
    </div>    
    <div class="control-group">
      <label class="control-label">Twitter Username</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-twitter_16"></i></span><input class="json" name="twitterUsername" type="text" value="#paramValue("rc.user.twitterUsername","")#">
        </div>                  
      </div>
    </div> 
    <div class="control-group">
      <label class="control-label">LinkedIn Profile Page</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-linkedin_16"></i></span><input class="json" name="linkedInProfile" type="text" value="#paramValue("rc.user.linkedInProfile","")#">
        </div>                  
      </div>
		</div> 
    <div class="control-group">
			<label class="control-label">Skype Username</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-skype_16"></i></span><input class="json" name="skype" type="text" value="#paramValue("rc.user.skype","")#">
        </div>                  
      </div>
    </div>  
  </fieldset>
		<div class="form-actions">        
      <input class="btn btn-success" id="changePassword" type="submit" value="Update my details &raquo;">
    </div>
    <cfoutput>
    <input type="hidden" id="userName" value="#request.buildingVine.username#" /> 
    </cfoutput> 
	</fieldset>
</form>
</cfoutput>
