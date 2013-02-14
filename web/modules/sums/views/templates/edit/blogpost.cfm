<cfoutput>
      <div>
        <label for="name">Date</label>
        <input class="date pageMeta" type="text" name="date" id="date" value="#paramValue('rc.requestData.page.date','')#" />
      </div>
    <textarea class="editor" id="content" name="content">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.content',''))#</textarea>
</cfoutput>