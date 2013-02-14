<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/products/price/import","")>
<cfoutput>
<form enctype="multipart/form-data" id="plUpload" class="form-horizontal" action="/bv/products/uploadPriceSpreadsheet" method="post">
    <fieldset>      
      <legend>Price File Import</legend> 
      <div class="control-group"">
        <label class="control-label" for="name">Name</label>
				<div class="controls">
				  <input type="text" id="name" name="name" />	
				</div>        
      </div>
      <div class="control-group">
        <label class="control-label" for="security_group">Security</label>
        <div class="controls">    
				  <div class="input-prepend input-prepend">
				  	<span class="add-on"><i class="icon-search"></i></span>
						<input id="securitySearch" />
						<select id="searchType">
							<option value="users">Search for Users</option>
							<option value="groups">Search for Groups</option>
							<option value="sites">Search for Other Sites</option>
						</select>
				  </div>    
					<br /><table id="currentUsers" class="hidden table table-bordered table-striped">
            <tbody></tbody>
          </table>
        </div>
				
      </div>      
      <div class="control-group">
        <label class="control-label" for="file">Choose File</label>
				<div class="controls">
          <input type="file" name="file" id="file" />
				</div>
				<div class="controls" id="beforeUpload"></div>
      </div>      
			
    </fieldset>
		<div id="mapFields" class="hidden">
				
	
		</div>   
    <input type="hidden" name="siteID" value="#request.bvsiteID#" />
  </form>
</cfoutput>