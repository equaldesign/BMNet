<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-document-pdf"></i></span>
    <h5>Recent Documents</h5>
  </div>
  <div class="widget-content">
    <cfloop array="#rc.recentDocuments.items#" index="d">
    <div class="media">
      <a class="pull-left" href="/bv/documents/detail?file=#d.nodeRef#&siteID=#d.location.site#">
        <img width="64" height="64" class="media-object" src="http://www.buildingvine.com/api/i?nodeRef=#d.id#&crop=true&aspect=1:1&size=64">
      </a>
      <div class="media-body">
        <h4 class="media-heading"><a href="/bv/documents/detail?file=#d.nodeRef#&siteID=#d.location.site#">#d.filename#</a></h4>
        <span class="modifiedBy">Modified By #d.author#</span><br /><span class="when">#Duration(cdt3(d.modifiedOn),now())#</span>
      </div>
    </div>
    </cfloop>
  </div>
</div>
</cfoutput>