<cfset getMyPlugin(plugin="jQuery").getDepends("","insertImage","")>
<cfoutput>
    <div>
      <label for="name">Top Image</label>
      <input class="pageMeta" type="text" name="top_image" id="top_image" value="#paramValue('rc.requestData.page.attributes.customProperties.top_image','')#" />
      <button class="insert_image" type="button">Insert Image</button>
    </div>
    <div>
      <textarea class="editor" id="content" name="content">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.content',''))#</textarea>
    </div>
</cfoutput>
