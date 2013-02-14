<cfset getMyPlugin(plugin="jQuery").getDepends("","menus,contact/view")>
<cfif rc.contact.id eq "">
    <h2>No contact</h2>
    <p>The contact you requested no-longer exists</p>
    <cfabort>
</cfif>
<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-building"></i></span>
    <h5>#rc.contact.first_name# #rc.contact.surname#</h5>
    <cfif paramValue("rc.canEditContact","false")>
    <div class="btn-group buttons">
      <a class="btn btn-mini" href="##"><i class="icon-wrench"></i> Manage this contact</a>
      <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##"><span class="caret"></span></a>
      <ul class="dropdown-menu">
        <li><a class="noAjax" href="/flo/callback/new?system=BMNet&contactID=#rc.contact.id#"><i class="icon-telephone"></i> Create callback</a></li>
        <li><a href="#bl('contact.edit','id=#rc.contact.id#')#"><i class="icon-pencil"></i> Edit this contact</a></li>
        <li><a href="##" rel="#bl('contact.delete','id=#rc.contact.id#')#"><i class="icon-delete"></i>Delete this contact</a></li>
        <li><a href="#bl('contact.passwordReminder','email=#rc.contact.email#')#"><i class="icon-envelope"></i>Send password reminder</a></li>
      </ul>
    </div>
    </cfif>
  </div>
</div>

  <div class="tabs-vertical row-fluid tabs-left">
    <ul class="nav nav-tabs">
			<li><a class="overview noAjax" href="#bl('contact.view','id=#rc.contact.id#')#"><i class="icon-user"></i><span>Overview</span></a></li>
			<li><a class="company noAjax" href="#bl('company.overview','id=#rc.contact.company_id#')#"><i class="icon-building"></i><span>Company Info</span></a></li>
      <cfif NOT isDefined("rc.showEmailHistory") OR rc.showEmailHistory>
      <li><a class="email noAjax" href="#bl('email.history','contactID=#rc.contact.id#')#"><i class="icon-mail"></i><span>Email History</span></a></li>
      </cfif>
      <li><a class="notes noAjax" href="/eunify/comment/list/relatedID/#rc.contact.id#/relatedType/contact"><i class="icon-comment"></i><span>Comments</span></a></li>
      <li><a class="feed noAjax" href="/eunify/feed/index?searchOn=contact&searchID=#rc.contact.id#"><i class="icon-rss"></i><span>Feed</span></a></li>
      <li><a class="task noAjax" href="/flo/related/system/BMNet/relatedType/contact/relatedID/#rc.contact.id#"><i class="icon-clipboard-task"></i><span>Tasks</span></a></li>
		</ul>
	</div>
</cfoutput>
