<cfset paymentInfo = getModel("eunify.FiguresService").getPaymentDetail(args.data.targetID[currentRow])>
<cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(args.data.relatedID[currentRow],request.siteID)>
<cfoutput>
<a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  from
  (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>)
acknowledged they received a payment from
<a href="#bl('company.index','id=#paymentInfo.company_id#')#">#paymentInfo.supplierName#</a> for <strong>&pound;#DecimalFormat(paymentInfo.paidAmount)#</strong> against <strong>#paymentInfo.XMLRef#</strong>
for the agreement <a href="#bl('psa.index','psaID=#paymentInfo.psaID#')#">#paymentInfo.dealName#</a>
</cfoutput>
