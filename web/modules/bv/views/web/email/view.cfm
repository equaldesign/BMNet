<cfoutput>
	<div class="page-header">
		<h2>#rc.campaign.name#</h2>
	</div>
	<dl class="dl-horizontal">
		<dt>Subject</dt>
		  <dd>#rc.campaign.subject#</dd>		
		<cfif rc.campaign.sent>
		  <dt>Sent to</dt>
			 <dd>#rc.campaign.sentto# users</dd>
		</cfif>
	</dl>
	<cfif NOT rc.campaign.sent>
		<a class="btn btn-warning" href="/email/send/id/#rc.id#"><i class="icon-sendEmail"></i>Send</a>
		<a class="btn btn-info" href="/email/preview/id/#rc.id#"><i class="icon-emailPreview"></i>Preview</a>		
	</cfif>
</cfoutput>