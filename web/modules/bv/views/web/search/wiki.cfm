<cfoutput>
<h1>Search results for #rc.query#</h1>
<hr />
<div id="wikipage">
<cfloop array="#rc.pages.pages#" index="page">
 <cfset wikiPage = StripHTML(page.text)>
 <div class="result">
  <h3><a href="/pages/#page.name#">#page.title#</a></h3>
  <p>
    <cfset wikiWords = ListToArray(wikiPage," ")>
    <cfif arrayLen(wikiWords) gte 50>
      <cfset aTo = 50>
    <cfelse>
      <cfset aTo = arrayLen(wikiWords)>
    </cfif>
    <cfloop from="1" to="#aTo#" index="i">#wikiWords[i]# </cfloop>...
  </p>
 </div>
</cfloop>
</cfoutput>
</div>