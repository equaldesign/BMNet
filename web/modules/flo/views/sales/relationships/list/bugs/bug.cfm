<cfoutput>
<div class="span3">  
  <cfset bug = getModel("bugs.BugService").getBug(args.id)>
  <a class="clearfix" href="/bugs/bugs/detail?id=#args.id#">#bug.gettitle()#</a></p>
</div>
</cfoutput>