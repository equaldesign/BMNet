<cfoutput>
 <cfset user = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset contact = getModel("eunify.ContactService").getContact(args.data.targetID[currentRow])>
 <cfset floItem = getModel("flo.TaskService").getTask(args.data.relatedID[currentRow])>
  <div class="media">
    <a class="pull-left" href="flo/item/detail/id/#floItem.task.id#">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(user.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-clipboard-task"></i><a href="/flo/item/detail/id/#floItem.task.id#">#floItem.task.name#</a></h4>
         <a href="#bl('contact.index','id=#user.id#')#">#user.first_name# #user.surname#</a> edited the workflow item which now has #floItem.activities.recordCount# activit<cfif floItem.activities.recordCount neq 1>ies<cfelse>y</cfif> and the following actor<cfif floItem.dependencies.recordCount neq 1>s</cfif>:
         <cfloop query="floItem.dependencies">
          <a href="#bl('contact.index','id=#contactID#')#">#first_name# #surname#</a>
         </cfloop>
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
</cfoutput>
