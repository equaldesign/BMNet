<cfoutput>
<div id="bc">
<ul>
  <li><a class="ajax createcompany" href="/bv/company/edit?type=#rc.type#">Create new #rc.type#</a></li>
  <li><a class="ajax createcontact" href="/bv/contacts/create?type=#rc.type#">Create new #rc.type# contact</a></li>
  <li><a class="ajax importcompany" href="/bv/company/import?type=#rc.type#">Import #rc.type#</a></li>
</ul>
</div>
<div id="searchandhelp">
  <div>
    <form action="/bv/company/search" method="post" id="customerSearch">
      <input type="hidden" name="siteID" value="#rc.siteID#" />
      <input type="hidden" name="type" value="#rc.type#" />
      <label  for="customerSearchI" class="over">Search #rc.type# </label>
      <input class="bvinesBox" name="query"  type="text" id="customerSearchI" value="" />
      <input class="glow greyStraight" type="submit" value="search" id="docSearchButton">
    </form>
  </div>
</div>
</cfoutput>