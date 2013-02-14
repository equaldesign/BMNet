<cfset getMyPlugin(plugin="jQuery").getDepends("colorpicker","secure/sites/color","jQuery/jQuery.colorpicker")>
<div class="page-header">
	<h1>Edit Header Colour</h1>
</div>
<br />
<div id="inviteAlert" class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>About the header colour</h3>
    <p>We use three logos in Building Vine - a small 46x46 pixel thumbnail, a medium 60px high (or 200px wide max) logo, and a transparent logo for your header.</p>
		<p>If you wish to change your header logo, we strongly recommend you use a transparent PNG format image.</p>
		<p>But don't worry about the size, we do all that for you!</p>
  </div>
</div>
<cfoutput>

<form class="form-horizontal" id="imageForm" action="/site/headerDo/siteID/#request.siteID#" method="post">
	<fieldset> 
		<legend>Pick a header colour</legend>
		<div class="control-group">
			<label class="control-label">Colour</label>
			<div class="controls">
				<div class="input-prepend">
          <span class="add-on"><img id="colorPickerButton" src="https://d25ke41d0c64z1.cloudfront.net/images/icons/color-swatch.png"></span><input name="colour" id="colorPicker" type="text" value="#rc.buildingVine.siteDB.headerColour#">
        </div>
				
			</div>
		</div>		
		<div class="form-actions">
      <input type="submit" class="btn btn-primary" value="Save Header Colour">      
    </div>
	</fieldset>	
</form>

</cfoutput>