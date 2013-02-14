<cfoutput>
 <cfset flo = getModel("flo.TaskService")>
 <cfset co = getModel("eunify.ContactService")>
 <cfset user = co.getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset floTask = flo.getActivity(args.data.relatedID[currentRow])>
 <cfset floItem = flo.getTask(floTask.itemID)>
 <cfset contact = co.getContact(floTask.contactID)>
  <div class="media">
    <a class="pull-left" href="flo/item/detail/id/#floItem.task.id#">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(user.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-clipboard-task"></i><a href="/flo/item/detail/id/#floItem.task.id#">#floTask.name#</a></h4>
         <a href="#bl('contact.index','id=#user.id#')#">#user.first_name# #user.surname#</a>
         <cfif contact.id neq user.id>
         assigned this task to <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
         <cfelse>
         took ownership of this task
          </cfif>
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
</cfoutput>
