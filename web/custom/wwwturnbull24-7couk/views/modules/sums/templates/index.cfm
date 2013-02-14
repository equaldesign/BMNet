<cfhtmlhead Text = '<title>Turnbull 24-7 - #paramValue("rc.requestData.page.title","Serving all around Lincolnshire")#</title>'>

<cfoutput>
  <cfscript>
  function isE() {
  if (isUserInRole("staff") AND isDefined("event") AND event.getCurrentModule() eq "sums" AND (NOT isDefined("rc.requestData.page.permissions") OR (isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit))) {
   return 'contenteditable="true"';
  } else {
   return '';
  }
}
  </cfscript>

</cfoutput>
<div id="content">
  <cfoutput>#renderView("#rc.templatePath#")#</cfoutput>
</div>

