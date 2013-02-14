<h3>Current Active Users</h3>
  <cfoutput query="rc.currentUsers">
  <div class="currentUser">

    <img width="20" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=20&d=#paramImage('company/#companyID#_square.jpg','website/unknown.jpg')#" />
    <a href="#bl('contact.index','id=#contactID#')#" class="ajax tooltip" title="#name#">#first_name# #surname#
	   <!--- <cfif getModel("contact").isIdle(contactID)><!-- idle --><cfelse><!-- active --></cfif> --->
	</a>
    <p>#known_as#</p>
  </div>
  </cfoutput>