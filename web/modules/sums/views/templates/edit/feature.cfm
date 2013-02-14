<cfset getMyPlugin(plugin="jQuery").getDepends("","insertImage","")>
<cfoutput>
    <div>
      <label for="name">Feature name</label>
      <input class="pageMeta" type="text" name="feature_name" id="feature_name" value="#paramValue('rc.requestData.page.feature_name','')#" />
    </div>
    <div>
      <label for="name">Feature Image</label>
      <input class="pageMeta" type="text" name="feature_image" id="feature_image" value="#paramValue('rc.requestData.page.feature_image','')#" />
      <button class="insert_image" type="button">Insert Image</button>
    </div>
</cfoutput>
