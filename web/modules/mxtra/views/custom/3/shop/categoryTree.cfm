<cfif NOT isDefined('rc.category')>
  <cfset rc.category = getModel("modules.mxtra.model.category")>
</cfif>
<cfset rc.baseCats = rc.category.getSubs(0,request.siteID)>
<cfoutput query="rc.baseCats">
  <h3><a href="##">#capFirstTitle(name)#</a></h3>
 
</cfoutput>
