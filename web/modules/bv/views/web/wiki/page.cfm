<cfset getMyPlugin(plugin="jQuery").getDepends("block,form","secure/wiki/search","wiki")>
<form class="form-search" id="wikisearch" action="/search/wiki" method="post">
  <input placeholder="Search within these pages..." class="input-xlarge" id="wikiQ" type="text" name="query" >
  <input class="btn btn-primary" type="submit" value="Search &raquo;">
</form>
<div class="wikipage">
	<div class="page-header">
    <h1><cfoutput>#replace(rc.name,"_"," ","ALL")#</cfoutput></h1>
  </div>  
  <cfoutput>#rc.wikipage#</cfoutput>
</div>