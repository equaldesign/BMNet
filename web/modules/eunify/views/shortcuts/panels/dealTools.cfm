<cfif isNumeric(rc.psaID)>
	<cfset psa = PopulateModel("psa")>
	<cfset figures = PopulateModel("figures")>
	<cfset rc.psaData = psa.getArrangement(rc.psaID)>
	<cfoutput>
    <ul>
      <cfif IsUSerInRole("Categories") OR IsUSerInRole("edit")>
        <li class="clonePSA"><a title="Create a clone from this PSA" href="#bl('psa.cloneDeal','PSAID=#rc.psaID#')#">clone agreement &raquo;</a></li>
      </cfif>
      <cfif IsUserInRole("edit") AND psa.canEditPSA(rc.psaData) AND rc.psaData.PSA_status neq "confirmed">
        <li class="deletePSA"><a title="delete this PSA" href="#bl('psa.delete','psaID=#rc.psaID#')#">delete agreement &raquo;</a></li>
      </cfif>
      <cfif isUserInARole("Categories,edit,figures,rebates")>
        <li class="viewPDF"><a target="_blank" href="#bl('psa.view','panel=psa&psaID=#rc.psaID#&layout=PDF')#">view agreement as pdf &raquo;</a></li>
      </cfif>
      <cfif isUserInARole("Categories,edit")>
        <li><a href="#bl('psa.emailDeal','psaID=#rc.psaID#')#" class="emailSupplier">email agreement to Supplier &raquo;</a></li>
        <li><a href="/blog/edit?blogDate=#DateFormat(now(),'DD/MM/YYYY')#&blogCategory=8&blogRelatedTo=arrangement&blogRelatedID=#rc.psaID#" class="emailMember">notifiy members &raquo;</a></li>
      </cfif>
      <cfif isUserInARole("figuresEntry,edit,Categories,admin")>
        <li class="editFigures"><a href="#bl('figures.returns','psaID=#rc.psaID#')#">edit figures &raquo;</a></li>
      </cfif>
    </ul>
 	</cfoutput>
</cfif>