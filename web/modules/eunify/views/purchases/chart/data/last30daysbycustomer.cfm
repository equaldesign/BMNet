<cfset rc.json = {}>
<cfset rc.json["results"] = []>

<cfloop query="rc.data">
  <cfset s = {}>
  <cfset s["latitude"] = latitude>
  <cfset s["longitude"] = longitude>
  <cfset s["customerName"] = name>
  <cfset s["id"] = id>
  <cfset s["spend"] = spend>
  <cfset arrayAppend(rc.json["results"],s)>
</cfloop>
<cfset rc.json = SerializeJSON(rc.json)>
<cfcontent type="application/json">
<cfoutput>#rc.json#</cfoutput>


