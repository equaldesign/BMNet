<cfhtmlhead text='<title>#paramValue("rc.requestData.page.attributes.customProperties.pagetitle","#paramValue("rc.requestData.page.title","BuildersMerchant.net")#")#</title>'>
<cfoutput>
  <cfscript>
  function isE() {
  if (isUserInAnyRole("staff,ebiz") AND isDefined("event") AND event.getCurrentModule() eq "sums" AND (NOT isDefined("rc.requestData.page.permissions") OR (isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit))) {
   return 'contenteditable="true"';
  } else {
   return '';
  }
}
  </cfscript>
<input type="hidden" id="bvsiteID" value="#request.bvsiteid#">
<cfif isDefined("rc.requestData.page.parents") AND paramValue("rc.requestData.page.name","") neq "homepage.html" AND NOT paramValue("rc.requestData.page.template","") eq "homepage" AND NOT paramValue("rc.requestData.page.template","") eq "bvproductlist">
<ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <li class="active">#rc.requestData.page.title#</li>
</ul>
</cfif>
</cfoutput>
<div id="content">
  <cfoutput>#renderView(view="#rc.templatePath#")#</cfoutput>
</div>

