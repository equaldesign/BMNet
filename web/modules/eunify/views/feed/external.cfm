<cfoutput>#renderView("contact/homepagecontrols")#</cfoutput>
<cfoutput>
<div id="homepage">
<div id="newspagesheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.feed.count>#rc.feed.count#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.feed.count# items
  <div id="pageCount">
#getMyPlugin(plugin="Paging").renderit(rc.feed.count,"/feed/external/page/@page@")#</div>
</div>
</cfoutput>
<cfoutput Startrow="#rc.boundaries.startRow#" maxrows="#rc.boundaries.maxrow-rc.boundaries.startRow#" query="rc.feed.feed">
   <cfif source eq "bvine">
      <div class="extfeeditem">
       <cftry>
       <cfoutput>#renderView(view="feed/type/#ListLast(category,".")#",module="buildingVine")#</cfoutput>
       <cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
       </cftry>
      </div>
    <cfelse>
      <div class="extfeeditem">
		    <div class="feedlogo"><img src="/includes/images/feed/#source#.jpg" /></div>
		    <h2><a target="_blank" href="#link#">#title#</a></h2>
		    <div class="meta">
		      <span class="feedDate">
		        #dateFormatOrdinal(pdate,"DDDD D MMM YYYY")#
		      </span>
		    </div>
		    <br class="clear" />

		      <div class="feedsummary">
		        #stripHTML(description)#
		      </div>
		  </div>
  </cfif>
</div>
</cfoutput>