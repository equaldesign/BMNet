<cfset getMyPlugin(plugin="jQuery").getDepends("maps.infobubble","email/responsedetail","recipients")>
<cfoutput>
<div style="display:none; position: absolute;" id="map-tooltip"></div>
<div id="gMap" class="googleMap" campaign-id="#rc.campaign.id#"></div>
</cfoutput>