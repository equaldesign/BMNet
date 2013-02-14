<cfset getMyPlugin(plugin="jQuery").getDepends("form","secure/products/upload","")>
<cfif rc.importStatus.productImportStatus neq "" AND rc.importStatus.productImportStatus neq 0>
<div class="alert alert-success">
	<a class="close" data-dismiss="alert">&times;</a>    
  <cfoutput><br />
  <strong>Import in progress! progress is at <span id="timeUpdated">#DateDiff("s",rc.importStatus.importStatusLastTime,now())#</span> %.</strong>
  <cfset getMyPlugin(plugin="jQuery").getDepends("","secure/products/importStatus","")>
  <div class="progress progress-success progress-striped active">
	  <div class="bar" id="progressBar" style="width: #DateDiff("s",rc.importStatus.importStatusLastTime,now())#%;" rel="#rc.siteID#"></div>
	</div>      
  </cfoutput>
</div>
</cfif>
<cfif rc.importStatus.productImportStatus eq "" OR rc.importStatus.productImportStatus eq 0>
  <form class="form-horizontal" id="ssUpload" encoding="multipart/form-data"  enctype="multipart/form-data" action="/products/uploadSpreadsheet" method="post">
    <fieldset>
      <legend>Upload your product database</legend>
      <div class="control-group">
        <label class="control-label" for="File">Spreadsheet file<em>*</em></label>
        <div class="controls">
				  <input type="file" name="file" id="file">
				</div>
      </div>			
      <div class="controls" id="beforeUpload"></div>

    </fieldset>
    <div id="afterUpload" class="hidden">

    </div>
  </form>
</cfif>