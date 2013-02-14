<cfoutput>
<div class="row">
  <div class="span4">
    <cfloop query="rc.templates">
      <cfset templateName = ListFirst(name,'.')>
      <cfset templateInfo = GetComponentMetaData("#path#.#templateName#")>
        <a class="templateDiv template_#templateName#" data-template="#templateName#" href="/sums/page/#createUUID()#?template=#templateName#&mode=edit&parentNodeRef=#rc.parentNodeRef#"><span class="title">#templateInfo.displayName#</span>
          <span class="summary">#templateInfo.hint#</span>
        </a>

    </cfloop>
  </div>
  <div class="span5 hidden" id="newpageproperties">
      <div class="alert alert-info hidden" id="tDetails">
        <h3 class="alert-heading"></h3>
        <p></p>
      </div>
      <form class="form form-horizontal" action="/sums/page" method="post" id="editPage">
      <fieldset>
        <legend>Page Details</legend>
        <div class="control-group">
          <label for="title" class="control-label">Title</label>
          <div class="controls">
            <input class="npageMeta" type="text" name="title" id="ntitle" value="#paramValue('rc.requestData.page.title','')#" />
          </div>
        </div>
        <div class="control-group">
          <label for="name" class="control-label">Page Slug</label>
          <div class="controls">
            <input class="npageMeta" type="text" name="name" id="name" value="#paramValue('rc.requestData.page.name','')#" />
          </div>
        </div>
        <div class="control-group">
          <label for="pagetitle" class="control-label">Page Title</label>
          <div class="controls">
            <input class="npageMeta" type="text" name="pagetitle" id="pagetitle" value="#paramValue('rc.requestData.page.attributes.customproperties.pagetitle','')#" />
          </div>
        </div>
        <cfif paramValue('rc.parentNodeRef','') neq "">
        <div class="control-group">
          <label for="pagetitle" class="control-label">Create Link</label>
          <div class="controls">
            <label class="checkbox">
              <input type="checkbox" name="createLink" id="createLink" value="true" />
              Create a link to this new page on the current page?
            </label>

          </div>
        </div>
        </cfif>
        <div class="control-group">
          <label for="keywords" class="control-label">Keywords</label>
          <div class="controls">
            <input class="npageMeta" type="text" name="keywords" id="keywords" value="#paramValue('rc.requestData.page.attributes.customproperties.keywords','')#" />
          </div>
        </div>
        <div class="">
          <label for="description" class="control-label">Description</label>
          <div class="controls">
            <textarea name="description" id="description" class="npageMeta">#paramValue('rc.requestData.page.attributes.customproperties.description','')#
            </textarea>
          </div>
        </div>
      </fieldset>
      <div class="form-actions">
        <button type="button" id="createPage" class="btn btn-success">Create Page &raquo;</button>
      </div>
      <input type="hidden" class="npageMeta" id="tmple" name="template" value="#paramValue('rc.requestdata.page.template','#paramValue("rc.template","blank")#')#">
      <input type="hidden" name="nodeRef" id="nodeRef" value="#paramValue('rc.nodeRef','')#">
      <input type="hidden" name="parentNodeRef" id="parentNodeRef" value="#paramValue('rc.parentNodeRef','')#">
    </form>
  </div>
</div>
</cfoutput>