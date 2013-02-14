<cfoutput>
<div>
  <label for="name">Send Results to:</label>
  <input class="pageMeta" type="text" name="recipient" id="recipient" value="#paramValue('rc.requestData.page.attributes.customProperties.recipient','')#" />
</div>
<div>
  <label for="name">Subject</label>
  <input class="pageMeta" type="text" name="subject" id="subject" value="#paramValue('rc.requestData.page.attributes.customProperties.subject','Feedback from the website!')#" />
</div>
<div>
  <label for="name">Send Auto response?</label>
  <input class="pageMeta" type="checkbox" name="sendautoresponse" id="sendautoresponse" value="true" #vm(paramValue("rc.requestData.page.attributes.customProperties.sendautoresponse","false"),"false")# />
</div>
</cfoutput>
