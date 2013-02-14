<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","secure/companies/contacts","secure/tables,secure/dashboard/main")>
<cfoutput>
 <div class="widget table">
  <table class="display" id="company_contacts">
    <thead>
      <tr>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Phone</th>
      </tr>
    </thead>
    <tbody>
      <cfloop array="#rc.contacts.results#" index="contact">
        <tr>
          <td><a href="/bv/contact?nodeRef=#contact.nodeRef#" class="ajax">#contact.firstName#</a></td>
          <td><a href="/bv/contact?nodeRef=#contact.nodeRef#" class="ajax">#contact.lastName#</a></td>
          <td>#contact.attributes.contactPhone#</td>
        </tr>
      </cfloop>
    </tbody>
  </table>
  </div>
</cfoutput>