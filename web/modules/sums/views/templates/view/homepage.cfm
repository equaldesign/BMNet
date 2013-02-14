<cfoutput>
<div class="wht">
  <h1>#rc.requestData.page.title#</h1>
  <div name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content",""))#</div>
</div>
</cfoutput>
