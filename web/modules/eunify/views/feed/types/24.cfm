<cfoutput>
 <cfset user = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset contact = getModel("eunify.ContactService").getContact(args.data.targetID[currentRow])>
 <cfset emailOb = getModel("eunify.EmailService").getEmail(args.data.relatedID[currentRow])>
 <cfset emailNode = getModel("bv.EmailService").getMessage(emailOb.nodeRef)>

 <cfset emailMessage = getModel("bv.EmailService").parseRaw(emailNode.downloadUrl)>
  <div class="media">
    <a class="pull-left" href="#bl('email.detail','id=#emailOb.id#')#">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(user.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-mail"></i><a href="#bl('email.detail','id=#emailOb.id#')#">#emailMessage.subject#</a></h4>
         <a href="#bl('contact.index','id=#user.id#')#">#user.first_name# #user.surname#</a> archived the email
         <a href="#bl('email.detail','id=#emailOb.id#')#">#emailMessage.subject#</a> from <a href="mailto:#emailMessage.from[1]#">#emailMessage.from[1]#</a>
         <i>#Duration(emailOb.messageDate,now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
</cfoutput>
