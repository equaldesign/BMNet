<cfset getMyPlugin(plugin="jQuery").getDepends("","products/category/edit")>

<cfoutput>
  <form id="editCategory" method="post" action="/eunify/category/doEdit" class="form-horizontal">
  <input type="hidden" id="buttonText" name="buttonText" value="#IIF(rc.categoryID eq "","'Create'","'Save'")#" />
  <cfif rc.categoryID neq "">
  <input type="hidden" id="oldID" name="oldID" value="#rc.categoryID#" />
  </cfif>
  <input type="hidden" id="parentID" name="parentID" value="#rc.parentID#">
    <fieldset>
      <legend><cfif rc.categoryID eq "">Create<cfelse>Edit</cfif>Category</legend>
      <div class="control-group">
        <label for="surname" class="control-label">ID<em>*</em></label>
        <div class="controls">
        	<input size="30" type="text" name="id" id="id" value="#IIF(rc.categoryID eq 0,"'#createUUID()#'","'#rc.categoryID#'")#" />
				</div>
      </div>
      <div class="control-group">
        <label for="surname" class="control-label">Name<em>*</em></label>
        <div class="controls">
        	<input size="30" type="text" name="name" id="name" value="#rc.category.name#" />
				</div>
      </div>
			<div class="control-group">
        <label for="surname" class="control-label">Web Page Slug<em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="pageslug" id="pageslug" value="#rc.category.pageslug#" />
        </div>
      </div>
			<div class="control-group">
        <label for="surname" class="control-label">Description<em>*</em></label>
        <div class="controls">
        	<textarea class="editor" rows="5" name="description" id="description" value="#rc.category.description#" />
				</div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Trade Enabled?</label>
        <div class="controls">
        	<input type="checkbox" id="webEnabled" name="webEnabled" value="true" #vm("true",rc.category.webEnabled,"checkbox")#>
        </div>
      </div>
			<!---<div class="control-group">
        <label for="tel" class="control-label">Building Vine Image</label>
        <div class="controls">
          <input size="30" type="text" name="BVNodeRef" id="BVNodeRef" value="#rc.category.BVNodeRef#" /><input type="button" id="findBVImage" class="btn" value="search ">
        </div>
      </div>--->
      <div class="control-group">
        <label for="tel" class="control-label">Public Enabled?</label>
				<div class="controls">
				  <input type="checkbox" id="publicWebEnabled" name="publicWebEnabled" value="true" #vm("true",rc.category.publicWebEnabled,"checkbox")#>
				</div>
      </div>
    </fieldset>
  </form>
</cfoutput>
