<!--- do something different for Blog Posts --->
<cfif ListFirst(event.getCurrentEvent(),":") eq "bv">
  <cfoutput>
    <input type="hidden" id="alf_ticket" value="#request.buildingVine.user_ticket#" />
  </cfoutput>
</cfif>
<cfif event.getCurrentEvent() eq "bv:blog.item">
  <cfoutput>#renderView()#</cfoutput>
<cfelseif event.getCurrentEvent() eq "bv:site.detail">
  <cfoutput>#renderView("subLayouts/siteIntro")#</cfoutput>
<cfelseif event.getCurrentHandler() eq "bv:products">
  <cfoutput>#renderView("subLayouts/products")#</cfoutput>
<cfelseif event.getCurrentHandler() eq "bv:documents">
  <cfoutput>#renderView("subLayouts/documents")#</cfoutput>
<cfelse>
  <div class="container">
    <div class="row">
      <div class="span4">
        <cfif event.getCurrentModule() eq "bv">
          <cfoutput>#renderView("web/shortcuts/#ListLast(event.getCurrentHandler(),":")#")#</cfoutput>
        </cfif>
      </div>
      <div class="span8">
        <cfoutput>#renderView()#</cfoutput>
      </div>
    </div>
  </div>
</cfif>

