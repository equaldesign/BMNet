<cfset getMyPlugin(plugin="jQuery").getDepends("","email/templates","")>
<cfoutput>
<h2 class="page-header">Email template</h2>
<div class="row-fluid">
  <div class="span6">
    <form action="" class="form form-horizontal">
      <div class="control-group">
        <label class="control-label">Choose a template</label>
        <div class="controls">
          <select id="templateList" data-id="#rc.campaign.id#">
            <option value="">--choose--</option>
            <cfset templateList = getModel("marketing.CampaignService").getTemplates()>
            <cfloop query="templateList">
              <option value="#id#">#name#</option>
            </cfloop>
          </select>
        </div>
      </div>
    </form>
    <iframe id="emailTemplateiFrame" scrolling="false" src="/marketing/email/template/getTemplate?campaignID=#rc.campaign.id#&templateid=#rc.campaign.templateID#" width="100%" height="800" frameborder="0"></iframe>
  </div>
  <div class="span6">
    <h2>Email body</h2>
    <input type="hidden" id="bvsiteID" value="#request.bvsiteID#" />
    <form action="/marketing/email/template/setcontent?campaignID=#rc.campaign.id#" method="post">
    <textarea cols="80" id="emailBody" name="emailBody" rows="10">#HTMLEditFormat(rc.campaign.emailBody)#</textarea>
    <script>
      // Replace the <textarea id="editor1"> with an CKEditor instance.
      CKEDITOR.replace( 'emailBody', {
          on :
          {
            change: onChange
          }
        });
    </script>


    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-save"></i> save message</button>
    </div>
    </form>
    <h3 class="page-header">Customising your email content</h3>
    <p>You can use various "placeholders" in your email, which are detailed here:</p>
    <dl class="dl-horizontal">
      <dt>${firstname}</dt>
      <dd>User (recipient) first name</dd>
      <dt>${surname}</dt>
      <dd>User (recipient) surname (last) name</dd>
      <dt>${companyname}</dt>
      <dd>User (recipient's) company name</dd>
      <dt>${emailaddress}</dt>
      <dd>User (recipient's) email address</dd>
    </dl>
    <p><span class="label label-info">Also note this!</span></p>
    <p>You can add a default value to your placeholders, in case the value does not exist. So, for instance, add <code>${firstname,Customer}</code> - and if we don't have the users first name, we'll use the word "Customer" instead!</p>
  </div>
</div>
</cfoutput>