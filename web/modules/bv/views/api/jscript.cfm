<cfif rc.error>
  <cfdump var="#rc#">
<cfelse>
<cfcontent type="application/javascript">
<cfoutput>#rc.json#</cfoutput>
</cfif>