<cfif event.getCurrentModule() eq "sums">
  <cfoutput>#renderView()#</cfoutput>
<cfelse>
  <cfif event.getCurrentModule() eq "bv">
    <cfset getMyPlugin(plugin="jQuery").getDepends("","bvine,tags","tags")>
  </cfif>
  <cftry>
    <cfif event.getCurrentModule() neq "">
      <cfoutput>#renderView("subLayouts/#event.getCurrentModule()#")#</cfoutput>
    <cfelse>
      <div class="container">
        <cfoutput>#renderView()#</cfoutput>
      </div>
    </cfif>
    <cfcatch type="any">
      <div class="container">
        <div class="row">
          <div class="span4 hidden-phone">
            <cfif event.getCurrentModule() eq "bv">
              <cfoutput>#renderView("web/shortcuts/#ListLast(event.getCurrentHandler(),":")#")#</cfoutput>
            </cfif>
          </div>
          <div class="span8">
            <cfoutput>#renderView()#</cfoutput>
          </div>
        </div> 
      </div>     
      <cfdump var="#cfcatch#">
    </cfcatch>
  </cftry>

</cfif>