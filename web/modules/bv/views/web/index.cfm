<cfset getMyPlugin(plugin="jQuery").getDepends("scroll,localScroll,","home/panels","public/home/homepage")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/feed/list")>
<cfset rc.feed = getModel("feedService").getFeed("","org.alfresco.blog.post-created")>
<cfset rc.siteService = getModel("SiteService")>

<cfoutput>
<cfset x = 1>

<cfloop array="#rc.feed#" index="item">
   <cfset rc.feedItem = item>
   <cfset rc.feedItem.detail = DeSerializeJSON(rc.feedItem.activitySummary)>
   <cftry>
   <cfif x eq 1>
    #renderView("public/feed/full/#ListLast(rc.feedItem.activityType,".")#")#
   <cfelse>
    #renderView("public/feed/type/#ListLast(rc.feedItem.activityType,".")#")#
   </cfif>
   <cfcatch type="any">
  </cfcatch>
   </cftry>
 <cfset x++>
 </cfloop>
</cfoutput>

<!---
<cfset getMyPlugin(plugin="jQuery").getDepends("scroll,localScroll,","home/panels","public/home/homepage")>
<div id="homeQuickNav">
  <ul>
    <li><a class="navit active" href="#suppliers">Suppliers &amp; Manufacturers</a></li>
    <li><a class="navit" href="#merchants">Merchants &amp; Retailers</a></li>
    <li class="last"><a class="navit" href="#builders">Builders &amp; Contractors</a></li>
  </ul>
</div>
<div id="homePages">
  <div id="suppliers" class="page">
    <cfoutput>#renderView("public/home/suppliers")#</cfoutput>
    <div class="clear"></div>
  </div>

  <div id="merchants" class="page">
    <cfoutput>#renderView("public/home/merchants")#</cfoutput>
    <div class="clear"></div>
  </div>

  <div id="builders" class="page">
    <cfoutput>#renderView("public/home/builders")#</cfoutput>
    <div class="clear"></div>
  </div>
</div>
--->