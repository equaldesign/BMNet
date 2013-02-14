<cfset getMyPlugin(plugin="jQuery").getDepends("","insertImage","")>
<cfoutput>
    <div>
      <label for="name">Reference ID</label>
      <input class="pageMeta" type="text" name="ReferenceID" id="ReferenceID" value="#paramValue('rc.requestData.page.attributes.customProperties.ReferenceID','')#" />
    </div>
    <div>
      <label for="name">Meta Type</label>
      <select class="pageMeta" name="metaType" id="metaType">
        <option value="tabData">Tab</option>
        <option value="landing">Landing Page</option>
      </select>
    </div>
    <div>
      <label for="name">Meta Title</label>
      <input class="pageMeta" type="text" name="metaTitle" id="metaTitle" value="#paramValue('rc.requestData.page.attributes.customProperties.metaTitle','')#" />
    </div>
    <div>
      <textarea class="editor" id="content" name="content">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.content',''))#</textarea>
    </div>
</cfoutput>
