<cfoutput>
 <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(contact.company_id)>
  <cfset comment = getModel("eunify.CommentService").getComment(args.data.targetID[currentRow])>
 <cfswitch expression="#args.data.targetObject[currentRow]#">
 <cfcase value="rebatePayments">
  <cfquery name="p" datasource="#getDatasource('eGroup').getName()#">select psaID from rebatePayments where id = #args.data.targetID[currentRow]#</cfquery>
   <cfset psa = getModel("psa").getArrangement(p.psaID)>
   <cfset supplier = getModel("company").getCompany(psa.company_id)>
   <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  from
  (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) said:
  "#args.data.message[args.currentrow]#" relating to <a href="/psa/index/id/#psa.id#">#psa.name#</a>
 </cfcase>
 <cfcase value="blog">
   <cfset blog = getModel("blog").getBlogPost(args.data.targetID[currentRow])>
   <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  from
  (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) said:
  "#args.data.message[args.currentrow]#" relating to <a href="/blog/index/id/#blog.id#">#blog.title#</a>
 </cfcase>
 <cfcase value="comment">
   <cfset comment = getModel("eunify.CommentService").getComment(args.data.targetID[currentRow])>
   <cfswitch expression="#comment.relatedType#">
     <cfcase value="company">

     </cfcase>
   </cfswitch>
   <div class="media">
    <a class="pull-left" href="##">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(contact.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-comment"></i>#comment.title#</h4>
         <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a> said: #args.data.message[currentRow]#
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
 </cfcase>
 <cfdefaultcase>
   <div class="media">
    <a class="pull-left" href="##">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(contact.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-comment"></i>#comment.title#</h4>
         <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a> said: #args.data.message[currentRow]#
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
  </cfdefaultcase>
 </cfswitch>
</cfoutput>
