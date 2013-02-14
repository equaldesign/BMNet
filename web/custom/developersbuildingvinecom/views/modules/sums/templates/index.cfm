<cfhtmlhead text='<title>Tucker French Bathrooms - #paramValue("rc.requestData.page.title","Serving all around London")#</title>'></cfhtmlhead>
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

</cfoutput>
<div id="content">
  <cfoutput>#renderView(view="#rc.templatePath#")#</cfoutput>
</div>

