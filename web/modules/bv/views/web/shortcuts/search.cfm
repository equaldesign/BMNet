<h2>Shortcuts</h2>
<cfoutput>
<ul id="dashboardShortcuts">
  <li><a class="shortcut ajax searchproducts" href="/bv/search?query=#rc.query#">Product Search</a><cfif request.buildingVine.defaultSearch eq "products"><span class="optionSelected"></span></cfif></li>
  <li><a class="shortcut ajax searchdocuments" href="/bv/search/documents?query=#rc.query#"><cfif request.buildingVine.defaultSearch eq "documents"><span class="optionSelected"></span></cfif>Document Search</a></li>
  <li><a class="shortcut ajax searchcompany" href="/bv/search/company?query=#rc.query#"><cfif request.buildingVine.defaultSearch eq "company"><span class="optionSelected"></span></cfif>Site/Company Search</a></li>
  <li><a class="shortcut ajax searchpeople" href="/bv/search/people?query=#rc.query#"><cfif request.buildingVine.defaultSearch eq "people"><span class="optionSelected"></span></cfif>Contact/Person Search</a></li>
  <li><a class="shortcut ajax searchblog" href="/bv/search/blog?query=#rc.query#">Blog Search</a></li>
</ul>
</cfoutput>