<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/products/editLink","")>
<form id="theLinkForm" class="form-horizontal" action="/alfresco/service/bvine/product/link?alf_ticket=<cfoutput>#request.user_ticket#</cfoutput>">
  <cfoutput><input type="hidden" id="productNode" value="#rc.productNode#" /></cfoutput>
  <fieldset id="current">
    <legend>Related Linked</legend>
    <cfoutput>
      <cfloop array="#rc.links#" index="l">
         <div class="control-group">
            <label class="control-label" for="title">#l.linkName#</label>
            <div class="controls">
              <div class="input-append">
                <input class="input-medium" type="text" name="name" value="#l.linkAddress#" />
                <select class="input-small" name="linkType">
                  <option value="youTube" #vm(l.linkType,"youTube")#>YouTube</option>
                  <option value="webpage" #vm(l.linkType,"webpage")#>WebPage</option>
                  <option value="tweet" #vm(l.linkType,"tweet")#>Tweet</option>
                </select>
                <span class="add-on">
                  <a href="##" class="deleteLink" data-id="#l.id#"><i class="icon-delete"></i></a>
                  <a href="##" class="saveLink" data-id="#l.id#"><i class="icon-save"></i></a>
                </span>
              </div>
            </div>
          </div>
      </cfloop>
    </cfoutput>
  </fieldset>
  <fieldset id="new">
    <legend>Add New Link</legend>
      <div class="control-group">
        <label class="control-label" for="title">Link Name</label>
        <div class="controls">
          <input id="newLinkName" class="input-small" type="text" name="name" value="" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="title">Link Ref</label>
        <div class="controls">
          <input id="newLinkRef" class="input-medium" type="text" name="name" value="" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="title">Link Type</label>
        <div class="controls">
          <select id="newLinkType" class="input-small" name="linkType">
            <option value="youTube">YouTube</option>
            <option value="webpage">WebPage</option>
            <option value="tweet">Tweet</option>
          </select>
        </div>
      </div>
      <div class="form-actions">
        <button id="addLink" type="button" class="btn btn-success">Add New Link</button>
      </div>
  </fieldset>
</form>