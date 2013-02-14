<cfif isDefined("rc.jsoncallback") AND rc.jsoncallback neq "">
  <cfcontent type="application/javascript">
<cfsavecontent variable="test">
  <cfoutput>
  <iframe src="https://www.buildingvine.com/products/writeReview?productID=#rc.productID#" scrolling="no" border="0" frameborder="0" width="525" height="400"></iframe>
 </cfoutput>
</cfsavecontent>
<cfset rc.retVar["html"] = test>
<cfoutput>#rc.jsoncallback#(#SerializeJSON(rc.retVar)#)</cfoutput>
<cfelse>

<cfoutput>#renderView("products/writeReview")#</cfoutput>
</cfif>