<cfoutput>
<div class="row-fluid">
  <div class="span3">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-picture"></i></a></span>
        <h5>Contact Details</h5>
      </div>
      <div class="widget-content">
        <img width="200" class="thumbnail img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.email)))#?size=200&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
        <cfif rc.contact.company_id neq "">
          <h3>Works for: <a href="#bl('company.detail','id=#rc.contact.company_id#')#">#rc.company.name#</a></h3>
        </cfif>
        <h4>#rc.contact.jobTitle#</h4>
        <p>Email: <cfif isEmail(rc.contact.email)><a href="mailto:#lcase(rc.contact.email)#">#lCase(rc.contact.email)#</a><cfelse>#lcase(rc.contact.email)#</cfif><br />
          Tel: #rc.contact.tel#<br />
          Mobile: #rc.contact.mobile#
        </p>
        #renderView(view="tags/list",args={relationship="contact",id="#rc.id#",delete=true})#
      </div>
    </div>
  </div>
    <div class="span5">
       #renderView("viewlets/panels/emails")#
       #renderView("viewlets/panels/tasks")#
    </div>
    <div class="span4">
      #renderView("viewlets/panels/emailCampaignResponses")#
    </div>
  </div>
</cfoutput>