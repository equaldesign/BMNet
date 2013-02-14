<cfset getMyPlugin(plugin="jQuery").getDepends("","company/overview")>
<cfoutput>
<cfset addressString = "#rc.company.company_address_1#">
<cfif rc.company.company_address_2 neq ""><cfset addressString = "#addressString#,#rc.company.company_address_2#"></cfif>
<cfif rc.company.company_address_3 neq ""><cfset addressString = "#addressString#,#rc.company.company_address_3#"></cfif>
<cfif rc.company.company_address_4 neq ""><cfset addressString = "#addressString#,#rc.company.company_address_4#"></cfif>
<cfif rc.company.company_address_5 neq ""><cfset addressString = "#addressString#,#rc.company.company_address_5#"></cfif>
<cfif rc.company.company_postcode neq ""><cfset addressString = "#addressString#,#rc.company.company_postcode#"></cfif>
<div class="row-fluid">
  <div class="span4">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-marker"></i></a></span>
        <h5>Location Map</h5>
      </div>
      <div class="widget-content">
        <div id="mapOverview" data-destination="#addressString#" data-origin="#request.bmnet.company.company_address_1#,#request.bmnet.company.company_address_4#,#request.bmnet.company.company_postcode#" style="height:400px; width:100%"></div>
      </div>
    </div>
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-direction"></i></a></span>
        <h5>Directions from #request.bmnet.company.company_postcode#</h5>
        <div class="buttons"><a href="##" class="showRoute btn btn-mini"><i class="icon-marker"></i> Show on Map</a></div>
      </div>
      <div class="widget-content">
        <div id="overview"></div>
        <ol id="instructions" class="hide">
        </ol>
        <div class="form">
          <div class="input-prepend input-append row-fluid">
            <span class="add-on span3">Origin</span>
            <input type="text" id="u_address" class="span6" size="20" value="#request.bmnet.company.company_postcode#" />
            <input id="recalc" type="button" class="btn span3" value="update &raquo;" />
          </div>
        </div>
      </div>
    </div>
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-map"></i></span>
        <h5>Address</h5>
      </div>
      <div class="widget-content">
        <address>
          #Replace(addressString,",","<br />","all")#
        </address><br />
        <tel><a href="tel:#rc.company.company_phone#">#rc.company.company_phone#</a></tel>
      </div>
    </div>
  </div>
  <div class="span4">
      #renderView("viewlets/panels/emails")#
      #renderView("viewlets/panels/tasks")#
  </div>
  <div class="span4">
      #renderView("viewlets/panels/recentDocuments")#
      #renderView("viewlets/panels/emailCampaignResponses")#
  </div>
</div>
</cfoutput>


