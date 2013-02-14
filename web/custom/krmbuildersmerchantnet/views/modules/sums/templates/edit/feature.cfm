<cfset getMyPlugin(plugin="jQuery").getDepends("","insertImage","")>
<cfoutput>
    <div class="control-group">
      <label for="name" class="control-label">Feature name</label>
      <div class="controls">
        <input class="pageMeta" type="text" name="feature_name" id="feature_name" value="#paramValue('rc.requestData.page.attributes.customProperties.feature_name','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Feature Link</label>
      <div class="controls">
        <input class="pageMeta" type="text" name="feature_link" id="feature_link" value="#paramValue('rc.requestData.page.attributes.customProperties.feature_link','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="name">Feature Image</label>
      <div class="controls">
        <div class="input-append">
        <input class="pageMeta" type="text" name="feature_image" id="feature_image" value="#paramValue('rc.requestData.page.attributes.customProperties.feature_image','')#" />
        <button class="insert_image btn" type="button">Insert Image</button>
        </div>
      </div>
    </div>
</cfoutput>
