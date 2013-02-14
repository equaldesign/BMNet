<cfoutput>
<div id="bc">
<ul>
  <li><a class="ajax createcompany" href="/bv/company/edit">Create new Company</a></li>
  <li><a class="ajax createcontact" href="/bv/contacts/create">Create new contact</a></li>
  <li><a class="ajax importcompany" href="/bv/company/import">Import companies</a></li>
  <li><a class="ajax importcompany" href="/bv/contact/import">Import Contacts</a></li>
</ul>
</div>
<div id="searchandhelp">
  <div>
    <form action="/bv/company/search" method="post" id="customerSearch">
      <input type="hidden" name="siteID" value="#rc.siteID#" />
      <label  for="customerSearchI" class="over">Search Companies </label>
      <input class="bvinesBox" name="query"  type="text" id="customerSearchI" value="" />
      <input class="glow greyStraight" type="submit" value="search" id="docSearchButton">
    </form>
  </div>
</div>
</cfoutput>