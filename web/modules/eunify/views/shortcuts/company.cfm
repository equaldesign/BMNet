<cfswitch expression="#rc.type_id#">
  <cfcase value="1"><cfset cType="Customer"></cfcase>
  <cfcase value="2"><cfset cType="Supplier"></cfcase>
</cfswitch>
<cfoutput>#renderView("shortcuts/company/#cType#")#</cfoutput>