<cfoutput>
	<h2 class="cufon">Contacts</h2>
  <ul>
    <li class="editContactDetails"><a class="ajax" href="#bl('contact.edit','id=#rc.sess.BMNet.contactID#')#">Edit your contact details</a></li>
    <cfif rc.sess.eGroup.isMemberContact><li class="supplierContacts"><a class="ajax" href="#bl('contact.allContacts','id=2')#">Show all Supplier Contacts</a></li></cfif>
    <li class="memberContacts"><a class="ajax" href="#bl('contact.allContacts','id=1')#">Show all Member Contacts</a></li>
  </ul>
  <h2>Companies</h2>
  <ul>
    <li class="listCompanys"><a class="ajax" href="#bl('company.list','filter=1')#">Members A-Z (full list)</a></li>
    <cfif rc.sess.eGroup.isMemberContact><li class="listCompanys"><a class="ajax" href="#bl('company.list','filter=2')#">Suppliers A-Z (full list)</a></li></cfif>
		<cfif isUserInARole("admin,edit,memberadmin")><li class="createCompany"><a class="ajax" href="#bl('company.edit')#" title="Create a new company, you can create a new supplier or a new member company">Create a new company</a></li></cfif>
    <cfif isUserInARole("admin,Categories,memberadmin,edit,supplieradmin")><li class="createContact"><a class="ajax" href="#bl('contact.edit')#">create a new contact</a></li></cfif>
  </ul>
</cfoutput>