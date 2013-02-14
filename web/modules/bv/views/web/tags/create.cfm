<cfset getMyPLugin("jQuery").getDepends("","secure/tags/search")>
<fieldset>
  <legend>Tags</legend>
  <div class="control-group">
    <label class="control-label">Add a tag</label>
    <div class="controls">
      <div class="input-append">            
        <input class="tagSearch" type="text" />
        <span class="add-on"><i class="icon-magnifier"></i></span>
        
      </div>
      <input type="hidden" name="newTags" id="newTags" value="" />
      <p class="help-block">Type a tag and press return, or select an existing tag when search results appear</p>
    </div>
  </div>

  <div class="control-group"> 
    <div class="controls" id="tags">
    
      <cfoutput>#renderView(view="web/tags/list",args=args)#
      <input type="hidden" id="tagNode" value="#args.nodeRef#" /></cfoutput>
    </div>
  </div>
</fieldset>  