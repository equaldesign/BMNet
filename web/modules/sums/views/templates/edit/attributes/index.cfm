  <cfoutput>
    <form class="form form-horizontal" action="/page" method="post" id="editPage">
      <ul class="nav nav-tabs">
        <li class="active"><a href="##pageproperties" data-toggle="tab">Page Properties</a></li>
        <li><a href="##additional" data-toggle="tab">Additional Properties</a></li>
      </ul>
      <div class="tab-content">
        <div class="tab-pane active" id="pageproperties">
          <fieldset>
            <legend>Page Details</legend>
            <div class="control-group">
              <label for="title" class="control-label">Title</label>
              <div class="controls">
                <input class="pageMeta" type="text" name="title" id="title" value="#paramValue('rc.requestData.page.title','')#" />
              </div>
            </div>
            <div class="control-group">
              <label for="name" class="control-label">Page Slug</label>
              <div class="controls">
                <input class="pageMeta" type="text" name="name" id="name" value="#paramValue('rc.requestData.page.name','')#" />
              </div>
            </div>
            <div class="control-group">
              <label for="pagetitle" class="control-label">Page Title</label>
              <div class="controls">
                <input class="pageMeta" type="text" name="pagetitle" id="pagetitle" value="#paramValue('rc.requestData.page.attributes.customproperties.pagetitle','')#" />
              </div>
            </div>

            <div class="control-group">
              <label for="keywords" class="control-label">Keywords</label>
              <div class="controls">
                <input class="pageMeta" type="text" name="keywords" id="keywords" value="#paramValue('rc.requestData.page.attributes.customproperties.keywords','')#" />
              </div>
            </div>
            <div class="">
              <label for="description" class="control-label">Description</label>
              <div class="controls">
                <textarea name="description" id="description" class="pageMeta">#paramValue('rc.requestData.page.attributes.customproperties.description','')#
                </textarea>
              </div>
            </div>
          </fieldset>
        </div>
        <div class="tab-pane" id="additional">
        <cfif paramValue("rc.requestData.page.template","") neq "">
          <fieldset>
            <legend>Template Information</legend>
            <cfset templateList = runEvent(event="sums:admin.newPage",eventArguments={returnTemplates=true})>
            <div class="control-group">
              <label class="control-label">Template</label>
              <div class="controls">
                <select class="pageMeta" name="template">
                  <cfset currentTemplate = paramValue('rc.requestdata.page.template','#paramValue("rc.template","blank")#')>
                  <cfloop query="templateList">
                    <cfset templateName = ListFirst(name,'.')>
                    <cfset templateInfo = GetComponentMetaData("#path#.#templateName#")>
                    <option #vm(currentTemplate,templateName)# value="#templateName#">#templateInfo.displayName#</option>
                  </cfloop>
                </select>
                <p class="help-block"><span class="label label-warning">Warning !</span> Altering the template could have unintended consequences!</p>
              </div>
            </div>
          </fieldset>
          <fieldset>
            <legend>Additional Attributes</legend>
            #renderView("templates/edit/attributes/#rc.requestData.page.template#")#
          </fieldset>
        </cfif>
        </div>
      </div>
      <input type="hidden" id="siteID" value="#request.bvsiteID#">
      <input type="hidden" id="nodeRef" value="#paramValue('rc.requestData.page.nodeRef',paramValue('rc.nodeRef',''))#">
      <input type="hidden" id="parentNodeRef" value="#paramValue('rc.requestData.page.parentNodeRef',paramValue('rc.parentNodeRef',''))#">
  </form>
  </cfoutput>