<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/promotions/edit","")>
<cfoutput>
<form class="form-horizontal" id="editPromotion" action="/alfresco/service/bv/promotion?alf_ticket=#request.user_ticket#" method="post">
  <input type="hidden" name="nodeRef"  id="nodeRef" value="#rc.nodeRef#" />
  <input type="hidden" name="siteID" id="siteID" value="#rc.siteID#" />
  <fieldset>
    <legend>Promotion Information</legend>
    <div class="control-group">
      <label class="control-label" for="title">Name</label>
      <div class="controls">
        <input size="50" type="text" name="title" id="title" value="#paramValue('rc.promotion.name','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="description">Description</label>
      <div class="controls">
        <textarea class="simpleeditor input-large" rows="6" name="description" id="description">#paramValue('rc.promotion.description','')#</textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="code">Code</label>
      <div class="controls">
        <input size="15" type="text" name="code" id="code" value="#paramValue('rc.promotion.code','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="validFrom">Valid From</label>
      <div class="controls">
        <input class="date input-mini" size="10" type="text" name="validFrom" id="validFrom" value="#paramValue('rc.promotion.validFrom','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="validTo">Valid To</label>
      <div class="controls">
        <input class="date input-mini" size="10" type="text" name="validTo" id="validTo" value="#paramValue('rc.promotion.validTo','')#" />
      </div>
    </div>
  </fieldset>
</form>

</cfoutput>