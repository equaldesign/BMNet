<cfset groups = getModel("groups")>
<cfoutput>#getMyPLugin("jQuery").getDepends("","favourites/tree")#
    <ul id="favouritesTree"  rel="future" class="jstree-classic">
      <li>Tree</li>
    </ul>
</cfoutput>