<cfoutput>
  <cfset bug = getModel("bugs.BugService").getBug(args.id)>
  <tr>
    <td><i class="icon-bug"></i></td>
    <td><a class="clearfix" href="/bugs/bugs/detail?id=#args.id#">#bug.gettitle()#</a></p></td>
    <td></td>
  </tr>
</cfoutput>
 