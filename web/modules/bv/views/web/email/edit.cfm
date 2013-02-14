<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
<cfset getMyPlugin(plugin="jQuery").getDepends("ckeditor,form","","")>
<cfoutput>
	
<form action="/email/save/id/#rc.id#" class="form form-horizontal">
	<fieldset>
		<legend>Email Details</legend>
		<div class="control-group">
			<label class="control-label">Name</label>
			<div class="controls">
				<input class="input" name="name" value="#rc.campaign.name#" />
			</div>
		</div>
		<div class="control-group">
      <label class="control-label">From Name</label>
      <div class="controls">
        <input class="input" name="fromName" value="#rc.campaign.fromName#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Subject</label>
      <div class="controls">
        <input class="input" name="subject" value="#rc.campaign.subject#" />
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Email Body</label>
      <div class="controls">
        <textarea class="editor" name="body">#rc.campaign.body#</textarea>        
      </div>
    </div>		
	</fieldset>
	<div class="form-actions">
		<button class="btn btn-success"><i class="icon-save"></i> Save</button>
	</div>
	<input type="hidden" name="siteID" value="#rc.siteID#">
</form>
</cfoutput>