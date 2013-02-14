<!--- just a nice tabbed panel --->
<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-building"></i></span>
    <h5>#rc.company.name#</h5>
    <cfif canEditCompany(rc.company.id,rc.company.type_id)>
    <div class="btn-group buttons">
      <a class="btn btn-mini" href="##"><i class="icon-wrench"></i> Manage this company</a>
      <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##"><span class="caret"></span></a>
      <ul class="dropdown-menu">
        <cfif isUserInRole("admin")><li><a href="#bl('company.delete','id=#rc.company.id#')#"><i class="icon-trash"></i> Delete this company</a></li></cfif>
        <li><a href="#bl('company.edit','id=#rc.company.id#')#"><i class="icon-pencil"></i>Edit this company</a></li>
      </ul>
    </div>
    </cfif>
  </div>
</div>
  <div class="tabs-vertical row-fluid tabs-left">
    <ul class="nav nav-tabs">
      <li><a class="overview noAjax" href="#bl('company.overview','id=#rc.company.id#')#"><i class="icon-building"></i><span>Overview</span></a></li>
      <li><a class="contacts noAjax" href="#bl('company.contacts','id=#rc.company.id#')#"><i class="icon-users"></i><span>Contacts</span></a></li>
      <li><a class="branch noAjax" href="#bl('branch.getAll','id=#rc.company.id#')#"><i class="icon-store"></i><span>Branches</span></a></li>
      <li><a class="invoices noAjax" href="#bl('sales.list','filter=account_number&filterid=#rc.company.account_number#')#"><i class="icon-table"></i><span>Invoices</span></a></li>
      <li><a class="sales noAjax" href="#bl('sales.index','filterColumn=account_number&filterValue=#rc.company.account_number#')#"><i class="icon-chart-pie"></i><span>Sales</span></a></li>
      <li><a class="upsell noAjax" href="#bl('sales.upsell','id=#rc.company.account_number#')#"><i class="icon-building"></i><span>Upselling</span></a></li>
      <li><a class="ecommerce noAjax" href="#bl('ecommerce.list','filterColumn=account_number&filterValue=#rc.company.account_number#')#"><i class="icon-basket"></i><span>Online</span></a></li>
      <li><a class="documents noAjax" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#&folder=documentLibrary/companys/#rc.company.name#&c=true"><i class="icon-document-pdf"></i><span>Documents</span></a></li>
      <li><a class="email noAjax" href="/eunify/email/history/companyID/#rc.company.id#"><i class="icon-mail"></i><span>Email</span></a></li>
      <li><a class="notes noAjax" href="/eunify/comment/list/relatedID/#rc.company.id#/relatedType/company"><i class="icon-comment"></i><span>Comments</span></a></li>
      <li><a class="feed noAjax" href="/eunify/feed/index?searchOn=company&searchID=#rc.company.id#"><i class="icon-rss"></i><span>Feed</span></a></li>
      <cfif rc.company.buildingVine>
        <li><a class="buildingvine noAjax" href="/bv/site/overview?siteID=#rc.company.bvsiteID#&showBVMenu=Site"><i class="icon-bv"></i><span>BV</span></a></li>
      </cfif>
      <cfif rc.company.eGroup_id neq 0>
        <li><a class="eGroup noAjax" href="/eGroup/company/index/id/#rc.company.eGroup_id#"><span>eGroup</span></a></li>
      </cfif>
    </ul>
  </div>
</cfoutput>