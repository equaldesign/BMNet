<cfset getMyPlugin(plugin="jQuery").getDepends("","links","")>
<cfoutput>
  <ul id="linkList" class="nav nav-tabs nav-stacked">
  <cfloop array="#rc.links#" index="link">
    <li rel="#link.nodeRef#" rev="#link.linkOrder#">

        <i class="icon-arrow-move draghandler"></i>
        #link.name#
        <a href="##" class="delete_link pull-right"><i class="icon-chain--minus"></i></a>
        <a href="##" class="edit_link pull-right"><i class="icon-chain--pencil"></i></a>

    </li>
  </cfloop>
  </ul>
<form action="/alfresco/service/sums/link?alf_ticket=#request.user_ticket#" id="newLinkForm" method="post" class="form form-horizontal">
      <label class="checkbox">
        <input type="checkbox" id="inheritLinks" value="true" #vm(rc.page.inheritLinks,"true","checkbox")# />
        Inherit Links from parent page</label>
      </label>
      <label class="checkbox">
        <input type="checkbox" id="showLinks" value="true" #vm(rc.page.showLinks,"true","checkbox")# />
        Show Links
      </label>
  <fieldset>
    <legend>Add new link</legend>
    <div class="control-group">
      <label class="control-label" for="name">Link Name</label>
      <div class="controls">
        <input type="text" id="link_name" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Link URL</label>
      <div class="controls">
        <input type="text" id="link_url" value="" />
      </div>
    </div>
    <div class="or">OR</div>
    <div class="control-group">
      <label class="control-label" for="name">Link Page</label>
      <div class="controls">
        <select id="link_page" name="link_page">
          <option value="">--none--</option>
          <cfloop array="#rc.allPages#" index="page">
            <option value="/html/#page.data.name#">#trim(page.data.title)#</option>
          </cfloop>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Link Target</label>
      <div class="controls">
        <select id="link_target" name="link_target">
          <option value="_self">none</option>
          <option value="_blank">new window</option>
        </select>
      </div>
    </div>
    <div class="form-actions">
      <button class="btn btn-success" type="button" id="createLink">Add link</button>
    </div>
  </fieldset>
  <input type="hidden" id="linkNodeRef" value="" />
</form>
</cfoutput>