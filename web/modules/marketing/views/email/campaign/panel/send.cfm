<cfoutput>
<h2>Are you ready?!</h2>
<h4>Then let's send this thing!</h4>
<div class="row-fluid">
  <div class="span6 alert alert-info">
    <button class="close" href="##" data-dismiss="alert">&times;</button>
    <h3 class="alert-heading">I'm nervous!</h3>
    <p>Don't worry, we can send you a test email to your own account to see how it looks!</p>
    <a href="/marketing/email/campaign/dryrun?campaignID=#rc.campaign.id#" class="btn btn-large btn-warning"><i class="icon-send"></i>Send Test</a>
  </div>
  <div class="span6 alert alert-success">
    <h3>Send for real</h3>
    <a href="/marketing/email/campaign/send?campaignID=#rc.campaign.id#" class="btn btn-large btn-danger"><i class="icon-send"></i>Send For real!</a>
  </div>
</div>
</cfoutput>