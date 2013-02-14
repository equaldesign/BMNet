<cfset getMyPlugin(plugin="jQuery").getDepends("scroll,colorpicker","secure/sites/settings","jQuery/jQuery.colorpicker")>
<div class="page-header">
	<h1>Edit Site Details</h1>
</div>
<div id="updateComplete" class="hidden controls alert alert-success">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <p>Your changes were saved</p>        
  </div>
</div> 
<cfoutput>
<form class="form-horizontal" id="settingsForm" action="/alfresco/service/bvapi/sites/#request.bvsiteID#?alf_ticket=#request.buildingVine.user_ticket#" method="post">
	<fieldset>
    <legend>Basic Information</legend>
    <div class="control-group">
      <label class="control-label" for="title">Site Shortname<em>*</em></label>
      <div class="controls">
        <input type="text" class="input disabled" name="title" id="title" value="#rc.site.shortName#" disabled="disabled" />
        <p class="help-block">This is the short name (or identifier) for your site. It cannot be changed.</p>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label" for="title">Site Title<em>*</em></label>
      <div class="controls">
        <input type="text" class="st input-xlarge" name="title" id="title" value="#rc.site.title#" />
        <p class="help-block">This is the title of your Company site (it appears in the listings and elsewhere).</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Description</label>
      <div class="controls">
        <textarea rows="8" class="st input-xlarge" name="description" id="description">#rc.site.description#</textarea>
        <p class="help-block">Enter a brief description for your company. Try to be short, and concise where possible.</p>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Company Type</label>
      <div class="controls">
        <select class="stcp" name="companyType">
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"Manufacturer")# value="Manufacturer">Manufacturer</option>
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"Distributor")# value="Distributor">Distributor</option>
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"Merchant")# value="Merchant">Merchant</option>
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"Group")# value="Group">Group or Association</option>
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"IT")# value="IT">IT &amp; Support</option>
          <option #vm(paramValue("rc.site.customProperties.companyType.value","Manufacturer"),"Other")# value="Other">Other / Misc</option>
        </select>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Visiblity</label>
      <div class="controls">
        <select class="st span4" name="visibility">
        	<option #vm(rc.site.visibility,"PUBLIC")# value="PUBLIC">Public (anyone can see and view public content)</option>
					<option #vm(rc.site.visibility,"MODERATED")# value="MODERATED">Moderated (anyone can see, but need to request access to content)</option>
					<option #vm(rc.site.visibility,"PRIVATE")# value="PRIVATE">Private (users get access by invitation only)</option>
        </select>
      </div>
    </div>  		
  </fieldset>
	<fieldset>
    <legend>Contact Information</legend>
    <div class="control-group">
      <label class="control-label">Address 1</label>
      <div class="controls">
        <input class="stcp" name="address1" type="text" value="#paramValue("rc.site.customProperties.address1.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Address 2</label>
      <div class="controls">
        <input class="stcp" name="address2" type="text" value="#paramValue("rc.site.customProperties.address2.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Address 3</label>
      <div class="controls">
        <input class="stcp" name="address3" type="text" value="#paramValue("rc.site.customProperties.address3.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Town</label>
      <div class="controls">
        <input class="stcp" name="town" type="text" value="#paramValue("rc.site.customProperties.town.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">County/State</label>
      <div class="controls">
        <input class="stcp" name="county" type="text" value="#paramValue("rc.site.customProperties.county.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Post Code / Zip</label>
      <div class="controls">
        <input class="stcp input-small" name="postcode" type="text" value="#paramValue("rc.site.customProperties.postcode.value","")#">                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Telephone</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/telephone.png"></span><input class="stcp" name="telephone" type="text" value="#paramValue("rc.site.customProperties.telephone.value","")#">
        </div>                         
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Website</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/globe.png"></span><input class="stcp" name="website" type="text" value="#paramValue("rc.site.customProperties.website.value","")#">
        </div>				                        
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Email</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/mail.png"></span><input class="stcp" name="email" type="text" value="#paramValue("rc.site.customProperties.email.value","")#">
        </div>                                
      </div>
    </div>
  </fieldset>	
	<fieldset> 
    <legend>Social Networking</legend>   
    <div class="control-group">
      <label class="control-label">Google&reg;+ Page</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/social/google_16.png"></span><input class="stcp" name="googlePlusPage" type="text" value="#paramValue("rc.site.customProperties.googlePlusPage.value","")#">
        </div>                  
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Facebook Page</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/social/facebook_16.png"></span><input class="stcp" name="facebookPage" type="text" value="#paramValue("rc.site.customProperties.facebookPage.value","")#">
        </div>                  
      </div>
    </div>    
    <div class="control-group">
      <label class="control-label">Twitter Username</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/social/twitter_16.png"></span><input class="stcp" name="twitterUsername" type="text" value="#paramValue("rc.site.customProperties.twitterUsername.value","")#">
        </div>                  
      </div>
    </div> 
		<div class="control-group">
      <label class="control-label">LinkedIn Company Page</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/social/linkedin_16.png"></span><input class="stcp" name="linkedInPage" type="text" value="#paramValue("rc.site.customProperties.linkedInPage.value","")#">
        </div>                  
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">YouTube Channel</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/social/youtube_16.png"></span><input class="stcp" name="youTube" type="text" value="#paramValue("rc.site.customProperties.youTube.value","")#">
        </div>                  
      </div>
    </div>  
  </fieldset>
	<fieldset>
		<legend>Email Marketing <small>Feature coming soon</small></legend>
		<div class="control-group">
      <label class="control-label">Campaign Monitor ID</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-campaignMonitor"></i></span><input class="stcp" name="campaignMonitorKey" type="text" value="#paramValue("rc.site.customProperties.campaignMonitorKey.value","")#">
        </div>
      </div>
    </div>
	</fieldset>
	<fieldset>
    <legend>Header</legend>
    <div class="control-group">
      <label class="control-label">Colour</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><img id="colorPickerButton" src="https://d25ke41d0c64z1.cloudfront.net/images/icons/color-swatch.png"></span><input class="stcp" name="headerColour" id="colorPicker" type="text" value="#paramValue("rc.site.customProperties.headerColour.value","inherit")#">
        </div>        
      </div>
    </div>
		
    <div id="inviteAlert" class="controls alert alert-info">
      <a class="close" data-dismiss="alert">&times;</a>
      <div id="inviteBody">
        <p>If you wish, you can specify a custom header colour - for the nav bar at the top of the Building Vine&trade; website whilst viewing your site.</p>
				<p>This is great if your company logo colour scheme doesn't really fit with our nice green theme. It can also help your site stand out against others in the repository</p>
      </div>
    </div>
  </fieldset>
  <fieldset> 
    <legend>Product Image Search</legend>   
    <div class="control-group">
      <label class="control-label">Auto Search</label>
      <div class="controls">
        <label class="checkbox">
          <input class="stcp" type="checkbox" name="imageSearch" value="true" #vm(paramValue("rc.site.customProperties.imageSearch.value","true"),true,"checkbox")#/>
          Automatically search for images when no official image exists?
        </label>                  
      </div>
    </div>
		<div id="inviteAlert" class="controls alert alert-info">
      <a class="close" data-dismiss="alert">&times;</a>
      <div id="inviteBody">
        <p>You can stop Building Vine&trade; from trying to find images in it's repository, when an offocial images does not exist for your product</p>
      </div>
    </div>    
    <div class="control-group">
      <label class="control-label">Auto Search Restrict</label>
      <div class="controls">
        <label class="checkbox">
          <input class="stcp"  type="checkbox" name="imageRestricted" value="true" #vm(paramValue("rc.site.customProperties.imageRestricted.value","true"),true,"checkbox")# />
          Restrict auto-searching to this site only?
        </label>                  
      </div>
    </div>   
		<div id="inviteAlert" class="controls alert alert-info">
      <a class="close" data-dismiss="alert">&times;</a>
      <div id="inviteBody">
        <p>If you find a lot of images are displaying incorrect images (and more importantly, not your images), you can choose to not search for "unnofficial" images in other sites.</p>        
      </div>
    </div> 
  </fieldset>
	<div class="form-actions">
    <input type="submit" class="btn btn-primary" value="Save Settings">      
  </div>
  <input id="shortName" type="hidden" name="shortName" value="#request.siteID#" />	
</form>

</cfoutput>