<cfoutput>
<cfif isDefined("rc.requestData.page.parents") AND paramValue("rc.requestData.page.name","") neq "homepage.html" AND NOT paramValue("rc.requestData.page.template","") eq "bvproductlist">
<ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <li class="active">#rc.requestData.page.title#</li>
</ul>
</cfif>
</cfoutput>
<cfoutput>
<h1>#rc.requestData.page.title#</h1>
  <form class="form form-horizontal" action="/sums/contact" method="post">
    <div name="formcontent" id="formcontent" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.formcontent",""))#</div> 
    <div class="form-actions">
      <input type="submit" class="btn btn-success" value="Send" />
    </div>
    <input type="hidden" name="recipient" id="recipient" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.recipient',''))#" />
    <input type="hidden" name="subject" id="subject" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.subject',''))#" />
    <input type="hidden" name="sendautoresponse" id="sendautoresponse" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.sendautoresponse',''))#" />
    <input type="hidden" name="autoresponsecontent" id="autoresponsecontent" value="#urlEncrypt(paramValue('rc.requestData.page.attributes.customProperties.autoresponsecontent',''))#" />
    <input type="hidden" name="formNodeRef" id="formNodeRef" value="#paramValue('rc.requestData.page.nodeRef','')#" />
  </form>
</cfoutput>


