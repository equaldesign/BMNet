<h1>Pages</h1>
<cfoutput>
<cfloop array="#rc.wikipage.pages#" index="page">
  <div class="wikiPage">
    <a href="/wiki/index/name/#page.name#"><h2>#page.title#</h2></a>
    <div class="extraInfo">
      <span class="created">#page.createdOn#</span>
      <span class="createdBy">#page.createdBy#</span>
      <span class="modified">#page.modifiedOn#</span>
      <span class="modifiedBy">#page.modifiedBy#</span>
    </div>
    <div class="tags">
      <ul>
        <cfloop array="#page.tags#" index="tag">
          <li>#tag#</li>
        </cfloop>
      </ul>
    </div>
    <div class="page">
      <p>#createIntro(page.text)#</p>
    </div>

  </div>
</cfloop>
</cfoutput>