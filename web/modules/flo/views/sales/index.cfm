<cfset getMyPlugin(plugin="jQuery").getDepends("","arrangeTasks","stages")>
<div class="row-fluid">
<cftry>
  <cfset spanSize = int(12/rc.stages.recordCount)>  
  <cfcatch type="any">
  <cfset spanSize = 4>
  </cfcatch>
</cftry>


<cfoutput query="rc.stages">
  <cfif rc.myTasks>
    <cfset rc.taskList = rc.tasks.getMyTasks(type="#rc.listType#",modle="#rc.system#",stage=id)>
  <cfelse>
    <cfset rc.taskList = rc.tasks.getTasks(type="#rc.listType#",modle="#rc.system#",stage=id)>
  </cfif>
  <!--- stage total --->
  <cfquery name="t" dbtype="query">
    select SUM(amount) as stageTotal from rc.taskList;
  </cfquery>
  <div class="span#spanSize#">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-target"></i></span>
        <h5>#name#</h5>
        <cfif rc.type eq "Sale">
          <span class="label label-#IIf(rc.taskList.recordCount eq 0,'""','"info"')# pull-right stageTotals">#rc.taskList.recordCount#</span>
          <span class="label label-success stageTotals">&pound;#decimalFormat(t.stageTotal)#</span>
        <cfelse>
          <span class="label label-#IIf(rc.taskList.recordCount eq 0,'""','"info"')# pull-right stageTotals">#rc.taskList.recordCount#</span>
        </cfif>
      </div>
      <div class="widget-content">
        <div class="sortthem" style="min-height: 100px" id="stage_#id#">
        <cfloop query="rc.taskList">
          <div id="item_#id#" class="item widget-box">
            <div class="widget-title">
              <span class="icon"><i class="icon-clipboard-list"></i></span>
              <h5><a href="/flo/item/detail/id/#id#">#name#</a></h5>
              <cfset activities = rc.tasks.getActivities(id)>
              #renderView(view="activity/list/highlight",args=activities)#
            </div>
            <div class="widget-content">
              <ul class="thumbnails">
                <cfset relationships = rc.tasks.getRelationships(id)>
                <cfloop query="relationships">
                  <cfset relatedObject = rc.relationship.getRelatedObject(relatedSystem,relatedType,relatedID)>
                  #renderView(view="sales/relationships/list/#relatedSystem#/#relatedType#",args=relatedObject)#
                </cfloop>
              </ul>
            </div>
          </div>
        </cfloop>
        </div>
      </div>
    </div>
  </div>
</cfoutput>
</div>


