
<div class="row-fluid">
  <cfif rc.showExtra>
  <div class="span5 controlTarget" link-target="emailDetail">
    <cfset rc.contactID = rc.contact.id>
    <cfset rc.companyID = 0>
    <cfoutput>#renderView("contact/panels/emailHistory")#</cfoutput>
  </div>

  <div class="span7" id="emailDetail">
  </cfif>
    <cfoutput>
    <h2>#rc.node.subject#</h2>
    <a href="/flo/callback/new?system=BMNet&contactID=#rc.contact.id#" class="btn btn-mini pull-right modaldialog noAjax"><i class="icon-flo-callback"></i>Create callback</a>
    <h3>
      <a href="/eunify/contact/index/id/#rc.contact.id#">
        <img width="40" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.email)))#?size=40&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
        #rc.contact.first_name# #rc.contact.surname# &lt;#rc.contact.email#&gt;
      </a>
    </h3>
    <dl class="dl-horizontal">
      <dt>Sent</dt>
      <dd>#DateFormat(rc.message.sentDate,"DDD DD/MM/YYYY")# #TimeFormat(rc.message.sentDate,"HH:MM")#</dd>
      <dt>To</dt>
      <dd>
        <cfloop array="#rc.toContacts#" index="c">
        <a href="/eunify/contact/index/id/#c.id#">
          #c.first_name# #c.surname# &lt;#c.email#&gt;
        </a>
        </cfloop>
      </dd>
      <cfif arrayLen(rc.ccContacts) gte 1>
        <dt>CC</dt>
        <dd>
          <cfloop array="#rc.ccContacts#" index="c">
          <a href="/eunify/contact/index/id/#c.id#">
            #c.first_name# #c.surname# &lt;#c.email#&gt;
          </a>
          </cfloop>
        </dd>
      </cfif>
    </dl>
    <cfloop array="#rc.node.attachments#" index="attachment">
      <span class="email_#ListLast(attachment.mimetype,'/')#">#attachment.name# (#fncFileSize(replace(attachment.size,",",""))#)</span>
    </cfloop>
      <iframe frameborder="0" border="0" width="100%" height="400" src="/eunify/email/body?downloadURL=#rc.node.downloadURL#"></iframe>
      <cfset rc.showEmailHistory = false>
    #renderView('contact/view')#
    </cfoutput>
  <cfif rc.showExtra>
  </div>
  </cfif>
</div>
