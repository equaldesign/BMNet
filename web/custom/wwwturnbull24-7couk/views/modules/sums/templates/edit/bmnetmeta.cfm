<cfset getMyPlugin(plugin="jQuery").getDepends("","insertImage","")>
<cfoutput>
    <div class="control-group">
      <label class="control-label" for="name">Reference ID</label>
      <div class="controls">
        <input class="pageMeta" type="text" name="ReferenceID" id="ReferenceID" value="#paramValue('rc.requestData.page.attributes.customProperties.ReferenceID','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Meta Type</label>
      <div class="controls">
        <select class="pageMeta" name="metaType" id="metaType">
          <option #vm(paramValue('rc.requestData.page.attributes.customProperties.metaType','tabData'),"tabData")# value="tabData">Tab</option>
          <option #vm(paramValue('rc.requestData.page.attributes.customProperties.metaType','tabData'),"landing")# value="landing">Landing Page</option>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Meta Title</label>
      <div class="controls">
        <input class="pageMeta" type="text" name="metaTitle" id="metaTitle" value="#paramValue('rc.requestData.page.attributes.customProperties.metaTitle','')#" />
      </div>
    </div>
    <div class="control-group">
      <textarea class="editor" id="content" name="content">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.content',''))#</textarea>
    </div>
</cfoutput>
