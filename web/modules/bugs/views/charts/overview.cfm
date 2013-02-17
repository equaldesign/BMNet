
<cfoutput>
<input type="hidden" id="chartType" value="#rc.type#">
<input type="hidden" id="status" value="#rc.status#">

<div id="chartData-#rc.status#-#rc.type#"></div>
</cfoutput>
<cfset getMyPlugin(plugin="jQuery",module="bugs").getDepends("","chart","")>