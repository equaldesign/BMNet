<cfset getMyPlugin(plugin="jQuery").getDepends("","","basicMenu")>
<div id="basicMenu">
  <ul>
    <li><a class="ajax news" href="/blog">News</a></li>
    <cfset rootGroups = getModel("groups").getChildrenGroups(getSetting("rootGroupCategory"))>
    <cfoutput query="rootGroups">
    <li><a class="ajax heavyside" href="/psa/fullList?root=#oid#">#name# Agreements</a></li>
    </cfoutput>
    <li><a class="ajax promotions" href="/promotions/">Promotions</a></li>
    <cfoutput><li><a class="ajax pricelist" href="/documents/documentNameList?period=#DateFormat(dateAdd('d',-7,now()),'DD/MM/YY')#&name=Prices">Price updates this week</a></li></cfoutput>
  </ul>
</div>