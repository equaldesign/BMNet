<cfset getMyPlugin(plugin="jQuery").getDepends("","tags","")>

<cfset tags = getModel("bv.TagService").getTags(args.nodeRef)>
<cfoutput>
  <ul class="tags">
  <cfloop array="#tags#" index="tag">  
    <li><a class="tag" data-name="#tag#" data-node="#args.nodeRef#"  title="delete tag" href="/bv/tags?type=#args.type#&tag=#tag#">#tag#</a> 
      <cfif isUserInRole("admin_#args.siteID#")>
        <a class="noAjax deleteTag" data-name="#tag#" data-node="#args.nodeRef#" href="/alfresco/service/bv/tag?nodeRef=#args.nodeRef#&tag=#tag#&alf_ticket=#request.buildingVine.user_ticket#"><i class="icon-cross-circle-frame"></i></a>
    </cfif></li>
  </cfloop>
</ul>  
</cfoutput>