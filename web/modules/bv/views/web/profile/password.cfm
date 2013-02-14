<cfset getMyPlugin(plugin="jQuery").getDepends("validate","secure/profile/password","")>
  <form class="form-horizontal" id="changePassword" action="/">
  	<fieldset>
  	  <legend>Change your password</legend>	    		  
		  <div class="control-group"> 
		  	<label class="control-label">Existing Password<em>*</em></label>
				<div class="controls">
          <input type="password" name="currentPassword" id="currentPassword" />
				</div> 
		  </div>
		  <div class="control-group">
		  	<label class="control-label">New Password<em>*</em></label>
        <div class="controls">
				  <input type="password" name="newPassword1" id="newPassword1" />
				</div> 
		  </div>
		  <div class="control-group">
		  	<label class="control-label">Confirm Password<em>*</em></label>
        <div class="controls">
				  <input type="password" name="newPassword2" id="newPassword2" />
				</div> 
		  </div>
		  <div class="form-actions">		  	
	  		<input class="btn btn-success" id="changePassword" type="submit" value="Change my Password &raquo;">
			</div>
			<cfoutput>
      <input type="hidden" id="userName" value="#request.buildingVine.username#" /> 
      </cfoutput>			
  	</fieldset>
  </form>
