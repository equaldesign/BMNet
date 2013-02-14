<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/companies/list","secure/companies/list")>
<cfoutput>
  <h2>Stockists</h2>
  <ul id="dashboardShortcuts">
    <li><a class="shortcut stockists" href="/stockist/">List Stockists</a></li>
    <li><a class="shortcut stockistMap" href="/stockist/map">Stockists Map</a></li>
    <cfif rc.siteManager><li><a class="shortcut ajax uploadproducts" href="/stockist/import">Upload Stockist database</a></li></cfif>
    <cfif rc.siteManager><li><a class="shortcut ajax importprices" href="/stockist/sync">Import from Buying Groups</a></li></cfif>
  </ul>
</cfoutput>