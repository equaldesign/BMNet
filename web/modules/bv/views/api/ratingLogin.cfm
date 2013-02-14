<cfif rc.error>
  <cfdump var="#rc#">
<cfelse>
<cfcontent type="application/javascript">
<cfsavecontent variable="test">
  <cfoutput>
  <iframe src="https://www.buildingvine.com/login/external?target=#rc.target#" scrolling="no" border="0" frameborder="0" width="525" height="400"></iframe>
  </cfoutput>
</cfsavecontent>
<cfset rc.retVar["html"] = test>
<cfoutput>#rc.jsoncallback#(#SerializeJSON(rc.retVar)#)</cfoutput>
</cfif>