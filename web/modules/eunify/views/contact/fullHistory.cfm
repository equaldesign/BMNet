<cfoutput>
<h1>
  <img width="35" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.getemail())))#?size=35&d=http://#cgi.HTTP_HOST#/#paramImage('company/#rc.company.getid()#_square.jpg','website/unknown.jpg')#" />
  History for <a href="#bl('contact.index','id=#rc.contactID#')#">#rc.contact.getfirst_name()# #rc.contact.getsurname()#</a></h1>
  <h2>#rc.contact.getjobTitle()# at <a href="#bl('company.index','id=#rc.company.getid()#')#">#rc.company.getName()#</a></h2>

</cfoutput>
<cfoutput>
  <div id="newspagesheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.count>#rc.historyQ.recordCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.count# items
  <div id="pageCount">
  #getMyPlugin(plugin="Paging").renderit(rc.count,"/contact/fullHistory/id/#rc.contactID#/page/@page@?date_to=#rc.date_to#&date_from=#rc.date_from#&logFilter=#rc.logFilter#")#
  </div>
  </div>
</cfoutput>
<table class="v">
  <thead>
	  <tr>
	    <th>Address</th>
      <th>Date</th>
      <th>IP</th>
	  </tr>
  </thead>
  <tbody>
    <cfoutput query="rc.historyQ">
    <tr>
      <td><a href="#address#" class="tooltip" title="#address#">#left(address,50)#</td>
      <td>#DateFormat(stamp,"short")# #TimeFormat(stamp,"short")#</td>
      <td>#ipaddress#</td>
    </tr>
    </cfoutput>
  </tbody>
</table>
