<cfset getMyPlugin(plugin="jQuery").getDepends("","tableSearch","")>
<h2 class="page-header">Results for tag match <span class="red"><cfoutput>#rc.tag#</cfoutput></h2>
<table class="table table-striped table-bordered table-condensed dataTable" id="filtertable">
  <thead>
  <tr>
    <th>id</th>
    <th>First Name</th>
    <th>Surname</th>
  </tr>
  </thead>
  <tbody>
  <cfoutput query="rc.results">
    <tr>
    <td><a href="#bl('contact.index','id=#id#')#">#id#</a></td>
    <td><a href="#bl('contact.index','id=#id#')#">#first_name#</a></td>
    <td><a href="#bl('contact.index','id=#id#')#">#surname#</a></td>
  </tr>
  </cfoutput>
  </tbody>
</table>