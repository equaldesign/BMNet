<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/psa","")>
<cfheader name="Expires" value="#GetHttpTimeString(Now())#" charset="utf-8">
<div id="fullagreement">
	<cfset arrangement = getModel("psa")>
	<cfoutput>
	<cfif NOT rc.printMode>
		<a target="_blank" class="noAjax printPSA" href="/psa/view/panel/psa?psaID=#rc.panelData.psa.id#&layout=PDF">Print</a>
	</cfif>
	<div class="clear">
		<img class="img" width="89" height="59" src="/includes/images/#request.siteID#/logo.jpg" align="left" /><h2> #request.BMNet.name# Purchase Agreement #year(rc.panelData.psa.period_from)#-#NumberFormat(rc.panelData.psa.id,"000")#</h2>
	</div>
	<br />
	<br />
	<table width="100%">
    <tr>
    	<td valign="top" class="TableField" width="40%"><strong>SUPPLIER</strong></td>
    	<td>
        <a href="/intranet/main/viewcompanydetail?id=#rc.panelData.company.id#"><strong>#rc.panelData.company.name#</strong></a><br />
	      <cfif rc.panelData.company.company_address_1 neq "">#rc.panelData.company.company_address_1#<br /></cfif>
        <cfif rc.panelData.company.company_address_2 neq "">#rc.panelData.company.company_address_2#<br /></cfif>
        <cfif rc.panelData.company.company_address_3 neq "">#rc.panelData.company.company_address_3#<br /></cfif>
        <cfif rc.panelData.company.company_address_4 neq "">#rc.panelData.company.company_address_4#<br /></cfif>
        <cfif rc.panelData.company.company_address_5 neq "">#rc.panelData.company.company_address_5#<br /></cfif>
        <cfif rc.panelData.company.company_postcode neq "">#rc.panelData.company.company_postcode#<br /></cfif>
        <cftry>
        <h4>#rc.panelData.supplierContact.first_name# #rc.panelData.supplierContact.surname#</h4>
        <p>Tel: #rc.panelData.supplierContact.tel#
        <cfif rc.panelData.supplierContact.mobile neq "">
        <p>Mob: #rc.panelData.supplierContact.mobile#</p>
        </cfif>
        <cfif rc.panelData.supplierContact.email neq "">
        <p>Email: #rc.panelData.supplierContact.email#</p>
        </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
      </td>
  	</tr>
  	<tr>
    	<td valign="top" class="TableField"><strong>NEGOTIATOR</strong></td>
    	<td><a href="/intranet/main/contactDetails?cid=#rc.panelData.contact.id#"><strong>#rc.panelData.contact.first_name# #rc.panelData.contact.surname#</strong></a><br />
				<p>#rc.panelData.contact.jobTitle# </p>
       <p>Tel: #rc.panelData.contact.tel#</p>
       <cfif rc.panelData.contact.mobile neq "">
        <p>Mob: #rc.panelData.contact.mobile#</p>
        </cfif>
        <cfif rc.panelData.contact.email neq "">
        <p>Email: #rc.panelData.contact.email#</p>
        </cfif>

			</td>
  	</tr>
  	<tr>
    	<td valign="top"><strong>PRODUCTS</strong></td>
    	<td>#rc.panelData.psa.name#</td>
  	</tr>
  	<tr>
    	<td><strong>AGREEMENT PERIOD</strong></td>
    	<td>#DateFormat(rc.panelData.psa.period_from,"MM/YYYY")# - #DateFormat(rc.panelData.psa.period_to,"MM/YYYY")#</td>
  	</tr>
	</table>
  <cfloop array="#rc.panelData.xml.arrangement.xmlChildren#" index="section">
    <h2>#section.xmlAttributes.title#</h2>
	  <div id="#section.xmlName#_list" class="comp">
	    <cfloop array="#section.component#" index="element">
	      <cfif canView(element,section.component.xmlName)>
	          <cfset rc.component = element>
	          <cfoutput>#renderView("psa/element/view/component")#</cfoutput>
	       </cfif>
	    </cfloop>
	  <div class="clearer"></div>
	  </div>
	  <br class="clear" />
  </cfloop>




<br class="clear" />

#renderView("psa/terms")#

</cfoutput>
	</div>