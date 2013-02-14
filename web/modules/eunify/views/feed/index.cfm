<cfset getMyPlugin(plugin="jQuery").getDepends("scroll","feed/feed","")>
<cfif NOT rc.isAjax>
  <cfoutput>#renderView("contact/homepagecontrols")#</cfoutput>
</cfif>
<div id="homepage">
  <cfoutput>
  <div id="newspagesheader" class="clearfix">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.feedCount>#rc.feedCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.feedCount# items
  <div class="pull-right" id="pageCount">
  #getMyPlugin(plugin="Paging").renderit(rc.feedCount,"/eunify/feed/index/page/@page@?searchOn=#rc.searchOn#&searchID=#rc.searchID#","btn-mini")#
  </div>
  </div>
  </cfoutput>
  <div class="feed">
  <cfloop query="rc.feed" startrow="#rc.boundaries.startRow#" endrow="#rc.boundaries.maxrow#">

  <cfoutput>
       <cftry>
       #renderView(view="feed/types/#actionID#",args={data=rc.feed,currentRow=currentRow,itemCount=itemCount},cache=true,cacheTimeOut=0,cacheSuffix="feed_#fID#")#
       <cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
	     </cftry>
  </cfoutput>

  </cfloop>
  </div>

  <cfoutput>
  <div id="newspagesheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.feedCount>#rc.feedCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.feedCount# items
  <div id="pageCount">
  #getMyPlugin(plugin="Paging").renderit(rc.feedCount,"/eunify/feed/index/page/@page@?searchOn=#rc.searchOn#&searchID=#rc.searchID#","btn-mini")#
  </div>
  </div>
  </cfoutput>
</div>
