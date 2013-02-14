<cfoutput>
<h1>#rc.requestData.page.title#</h1>
  <form class="form form-horizontal" action="/sums/contact" method="post">
    #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.formcontent)#
    <input type="hidden" name="recipient" id="recipient" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.recipient',''))#" />
    <input type="hidden" name="subject" id="subject" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.subject',''))#" />
    <input type="hidden" name="sendautoresponse" id="sendautoresponse" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.sendautoresponse',''))#" />
    <input type="hidden" name="autoresponsecontent" id="autoresponsecontent" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.autoresponsecontent',''))#" />
    <input type="hidden" name="formNodeRef" id="formNodeRef" value="#paramValue('rc.requestData.page.nodeRef','')#" />
  </form>
</cfoutput>


<fieldset>
  <legend>About You</legend>
  <div class="control-group">
    <label class="control-label">Your Name</label>
    <div class="controls">
      <input name="full_name" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Your Email</label>
    <div class="controls">
      <input name="emailaddress" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Company Name</label>
    <div class="controls">
      <input name="companyName" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Contact Number</label>
    <div class="controls">
      <input name="contact_number" />
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Your Free Trial Details</legend>
  <div class="control-group">
    <label class="control-label">Site Name</label>
    <div class="controls">
      <input name="siteName">
      <p class="help-block">Your site name will be your URL, so www.[sitename].buildersmerchant.net</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Company Logo</label>
    <div class="controls">
      <input name="siteLogo" type="file" />
    </div>
  </div>
</fieldset>
<div class="form-actions">
  <input type="submit" class="btn btn-success" value="Start your free trial!" />
</div>