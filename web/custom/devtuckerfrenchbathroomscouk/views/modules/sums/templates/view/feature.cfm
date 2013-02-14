<cfif isUserInRole("staff")>
<cfoutput>
  <div #isE()# name="feature_image">
    #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.feature_image",""))#
  </div> 
</cfoutput>
</cfif>
<cfoutput>
  <div class="row">
    <div class="span8" name="pageContent" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.pageContent","Main Page"))#</div>
    <div class="span4" name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div>
  </div>
</cfoutput>
