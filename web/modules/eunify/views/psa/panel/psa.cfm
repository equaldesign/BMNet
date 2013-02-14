<cfif rc.panelData.canEditPSA AND rc.em AND  NOT rc.printMode>
	<cfoutput>
		#renderView("psa/panel/psa_edit")#
	</cfoutput>
<cfelseif rc.layout neq "PDF">
	<cfoutput>
		#renderView("psa/panel/psa_view")#
	</cfoutput>
<cfelse>
  <cfoutput>
    #renderView("psa/panel/psa_pdf")#
  </cfoutput>
</cfif>