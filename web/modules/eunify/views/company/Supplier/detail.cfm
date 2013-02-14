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
    <li><a class="overview" href="#bl('company.overview','id=#rc.company.id#')#"><i class="icon-building"></i><span>Overview</span></a></li>
    <li><a class="branch" href="#bl('branch.getAll','id=#rc.company.id#')#"><i class="icon-store"></i><span>Branches</span></a></li>
    <li><a class="invoices" href="#bl('purchases.list','filter=account_number&filterid=#rc.company.account_number#')#"><i class="icon-basket"></i><span>Purchases</span></a></li>
    <li><a class="sales" href="#bl('purchases.index','filterColumn=account_number&filterValue=#rc.company.account_number#')#"><i class="icon-chart-pie"></i><span>Purchase Analysis</span></a></li>
    <cfif isDefined("rc.psas")>
      <cfloop query="rc.psas">
        <li><a class="psa" href="#bl('psa.index','psaID=#ID#')#"><span>PSA: #id#</span></a></li>
      </cfloop>
    </cfif>
    <cfif isDefined("rc.eGroup.psas")>
      <cfloop query="rc.eGroup.psas">
        <li><a class="psa" href="#bl('eGroup.psa.index','psaID=#ID#')#"><span>PSA: CEMCO #id#</span></a></li>
      </cfloop>
    </cfif>
    <li><a class="documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#&folder=documentLibrary/companys/#rc.company.name#&c=true"><i class="icon-document"></i><span>Documents</span></a></li>
    <li><a class="email" href="/eunify/email/history/companyID/#rc.company.id#"><i class="icon-mail"></i><span>Emails</span></a></li>
    <li><a class="notes" href="/eunify/comment/list/relatedID/#rc.company.id#/relatedType/company"><i class="icon-comment"></i><span>Comments</span></a></li>
    <li><a class="feed" href="/eunify/feed/index?searchOn=company&searchID=#rc.company.id#"><i class="icon-rss"></i><span>Feed</span></a></li>
    <cfif rc.company.buildingVine>
      <li><a class="buildingvine noAjax" href="/bv/site/overview?siteID=#rc.company.bvsiteID#&showBVMenu=Site"><i class="icon-bv"></i><span>BV</span></a></li>
    </cfif>
    <cfif rc.company.eGroup_id neq 0>
      <li><a class="eGroup noAjax" href="/eGroup/company/index/id/#rc.company.eGroup_id#"><span>eGroup</span></a></li>
    </cfif>
  </ul>
</cfoutput>
</div>