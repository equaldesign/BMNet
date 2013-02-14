<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("maps.infobubble","sites/1/branchLocator","sites/2/branchLocator",false)#</cfoutput>
<cfset branches = rc.templateModel.getBranches()>
  <div id="gMap"></div>
  <cfoutput>
  <cfloop array="#branches#" index="b">
    <div class="branch hidden">
      <div class="branchAttribute fileName">#HtmlUnEditFormat(b.page.attributes.name)#</div>
      <cfloop collection="#b.page.attributes.customProperties#" item="o">
        <div class="branchAttribute #o#" name="#o#">#HtmlUnEditFormat(b.page.attributes.customProperties[o])#</div>
      </cfloop>
      <div class="branchDetail">
        <address>
          #HtmlUnEditFormat(b.page.attributes.customProperties.branch_address)#
        </address>
        #HtmlUnEditFormat(b.page.attributes.customProperties.branch_opening_hours)#
        <a href="/html/#b.page.attributes.name#" class="btn btn-danger">Branch Details</a>
      </div>
    </div>
  </cfloop> 
  </cfoutput>
