<cfoutput>
  <cfset rc.contact = getModel("eunify.ContactService")>
  <cfset rc.company = getModel("eunify.CompanyService")>
  <cfset contact = rc.contact.getContact(args.data.sourceID[currentRow])>
  <cfset company = rc.company.getCompany(contact.company_id)>
  <cfset rcontact = rc.contact.getContact(args.data.targetID[currentRow])>
  <cfset rcompany = rc.company.getCompany(rcontact.company_Id)>
  <div class="media">
    <a class="pull-left" href="#bl('contact.index','id=#contact.id#')#">
      <img class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(contact.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-user--pencil"></i><a href="#bl('contact.index','id=#rcontact.id#')#">#rcontact.first_name# #rcontact.surname#</a> was updated</h4>
         <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a> edited contact <a href="#bl('contact.index','id=#rcontact.id#')#">#rcontact.first_name# #rcontact.surname#</a> of
          <a href="#bl('company.index','id=#rcompany.id#')#">#rcompany.name#</a>
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
</cfoutput>