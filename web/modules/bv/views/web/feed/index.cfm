<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/feed/list")>
<cfoutput>
  <div id="pagingheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt arrayLen(rc.feed)>#ArrayLen(rc.feed)#<cfelse>#rc.boundaries.maxrow#</cfif> of #ArrayLen(rc.feed)# items
  <div id="pageCount">
  #rc.paging.renderit(arrayLen(rc.feed),"/feed?siteFilter=#rc.siteFilter#&typeFilter=#rc.typeFilter#&page=@page@","ajax")#
  </div>
  </div>
  <cfif rc.boundaries.maxRow GT ArrayLen(rc.feed)>
  	<cfset f2 = ArrayLen(rc.feed)>
	<cfelse>
	 <cfset f2 = rc.boundaries.maxRow>
  </cfif>
  <cfloop from="#rc.boundaries.startRow#" to="#f2#" index="i">
    <cfset rc.feedItem = rc.feed[i]>
	  <cfset rc.feedItem.detail = DeSerializeJSON(rc.feedItem.activitySummary)>
    #renderView("web/feed/type/#ListLast(rc.feedItem.activityType,".")#")#

  </cfloop>
  <div id="pagingheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt arrayLen(rc.feed)>#ArrayLen(rc.feed)#<cfelse>#rc.boundaries.maxrow#</cfif> of #ArrayLen(rc.feed)# items
  <div id="pageCount">
  #rc.paging.renderit(arrayLen(rc.feed),"/feed?siteFilter=#rc.siteFilter#&typeFilter=#rc.typeFilter#&page=@page@","ajax")#
  </div>
  </div>
  </cfoutput>