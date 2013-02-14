<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/stockists/map")>
<script src="/includes/javascript/api/stockists.js" language="javascript"></script>
<h2>Your Stockists Map</h2>
<cfoutput>
<div style="width: 650px; height: 800px" rel="#rc.siteID#" id="stockistMap"></div>
</cfoutput>