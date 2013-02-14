<cfsetting showdebugoutput="false">
<cfset event.showDebugPanel(false)>
<cfheader name="Expires" value="#Now()#">
  <cfheader name="Pragma" value="no-cache">
<cfoutput>#renderView()#</cfoutput>
