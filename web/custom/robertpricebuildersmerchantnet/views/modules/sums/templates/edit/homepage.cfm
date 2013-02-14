<cfoutput>
  <textarea class="editorAdvanced editor" id="content" name="content">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.content',''))#</textarea>
  <textarea class="editorAdvanced" id="leftContent" name="leftContent">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.leftContent',''))#</textarea>
  <textarea class="editorAdvanced" id="rightContent" name="rightContent">#HtmlUnEditFormat(paramValue('rc.requestData.page.attributes.customProperties.rightContent',''))#</textarea>
</cfoutput>
