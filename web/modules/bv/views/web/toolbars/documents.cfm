<cfoutput>
<div id="bc"></div>
<div id="searchandhelp">
  <div>
	  <form action="/bv/documents/search" method="post" id="documentSearch">
	    <input type="hidden" name="siteID" value="#rc.siteID#" />
	    <label  for="documentSearchI" class="over">Search documents </label>
	    <input class="bvinesBox" name="query"  type="text" id="documentSearchI" value="" />
      <input class="glow greyStraight" type="submit" value="search" id="docSearchButton">
	  </form>
  </div>
</div>
</cfoutput>