<cfsavecontent variable="htmlData">
<cfoutput>#renderView("psa/element/edit/component")#</cfoutput>
</cfsavecontent>
<cfset returnData = structNew()>
<cfset returnData["funct"] = rc.funct>
<cfset returnData["htmlData"] = htmlData>
<cfset returnData["arrayIndex"] = fixdot(rc.componentIndex)>
<cfset returnData["cType"] = rc.componentType>
<cfset returnData["cGroup"] = rc.cGroup>
<cfset jsonPacket = SerializeJSON(returnData)>
<cfcontent type="application/json">
<cfoutput>#jsonPacket#</cfoutput>