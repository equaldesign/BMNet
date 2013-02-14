<cfset getMyPLugin("jQuery").getDepends("","tag/search","")> 
<fieldset>
  <legend>Tags</legend>
  <div class="control-group">
    <label class="control-label">Add a tag</label>
    <div class="controls">
      <div class="input-append">             
        <input class="tagSearch" />
				<span class="add-on"><i class="icon-search"></i></span>
        <input type="hidden" name="newTags" id="newTags" value="" />
      </div>
      <p class="help-block">Type a tag and press return, or select an existing tag when search results appear</p>
    </div>
  </div>
  <div class="control-group">
    <div class="controls" id="tags">
      <cfoutput>#renderView(view="tags/list",args=args)#</cfoutput>
    </div> 
  </div>
</fieldset> 