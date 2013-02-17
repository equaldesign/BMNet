<cfset getMyPlugin(plugin="jQuery").getDepends("","","intranet/unicorn.main",false)>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-calendar-task"></i></span>
    <cfoutput>
    <h5>#rc.item.task.name#</h5>

    <div class="buttons btn-group pull-right" style="padding-right: 15px">
      <a href="#bl('item.delete','id=#rc.item.task.id#')#" class="btn btn-mini"><i class="icon-delete"></i>delete item</a>
      <a href="#bl('item.edit','id=#rc.item.task.id#')#" class="btn btn-mini"><i class="icon-pencil"></i>edit item</a>
    </div>
    </cfoutput>
  </div>
  <div class="widget-content">
    <cfoutput>
      <p>
      #rc.item.task.description#
      </p>
    </cfoutput>
    <div class="row-fluid">
      <div class="span6">
        <h3>Related to</h3>
        <!--- dependencies --->
        <cfloop array="#rc.item.relatedObject#" index="q">
          <cfoutput>#renderView(view="task/relationships/list/#q.system#/#q.type#",args=q.object)#</cfoutput>
        </cfloop>
      </div>
      <div class="span6">
        <h3>Participants</h3>
        <!---- participants --->
        <table class="table table-bordered table-striped table-rounded">
          <thead>
            <tr>
              <td>Name</td>
              <td>Email</td>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="rc.item.dependencies">
            <tr>
              <td><img width="16" class="img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(emailaddress)))#?size=16&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" /><a href="/#system#/contact/index?id=#contactID#">#first_name# #surname#</td>
              <td>#emailaddress#</td>
            </tr>
            </cfoutput>
          </thead>
        </table>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <cfoutput>#renderView(view="activity/list/embed",args={showDates=false})#</cfoutput>
      </div>
      <div class="span12">
        <h4>New Task</h4>
        <cfoutput>#renderView(view="activity/new",args={hasItem=true})#</cfoutput>
        <cfset rc.relationshipURL = "/flo/item/detail?id=#rc.item.task.id#">
        <cfoutput>#renderView(view="comment/list",module="eunify")#</cfoutput>
      </div>
    </div>
  </div>
</div>
