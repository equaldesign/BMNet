<cfdump var="#rc.requestData#">
<cfoutput>
<h1>#rc.requestData.page.title#</h1>
#HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#
</cfoutput>