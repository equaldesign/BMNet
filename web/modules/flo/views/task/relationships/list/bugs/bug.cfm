<cfoutput>
<div class="clearfix" style="margin-bottom: 4px;">
  <cfset bug = getModel("bugs.BugService").getBug(args.id)>
  <a class="clearfix" href="/bugs/bugs/detail?id=#args.id#">#bug.gettitle()#</a></p>
</div>

</cfoutput>
 