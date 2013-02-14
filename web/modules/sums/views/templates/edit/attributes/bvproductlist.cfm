<cfoutput>
    <div class="control-group">
      <label class="control-label" for="BVSiteID">BV SiteID</label>
      <div class="controls">
          <input class="pageMeta" type="text" name="BVSiteID" id="BVSiteID" value="#paramValue('rc.requestData.page.attributes.customProperties.BVSiteID','buildingVine')#" />
      </div>
    </div>
</cfoutput>
