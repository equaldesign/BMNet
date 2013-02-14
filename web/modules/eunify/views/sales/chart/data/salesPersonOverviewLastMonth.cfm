<cfset rc.json = SerializeJSON(rc.data)>
<cfcontent type="application/json">
<cfoutput>#rc.json#</cfoutput>


