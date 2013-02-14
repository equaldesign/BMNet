<cfset getMyPlugin(plugin="jQuery").getDepends("jCrop","secure/sites/editLogo","jQuery/jQuery.jCrop")>
<div class="page-header">
	<h1>Edit site Logos</h1>
</div>
<br />
<div id="inviteAlert" class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>About Site Logos</h3>
    <p>We use three logos in Building Vine - a small 46x46 pixel thumbnail, a medium 60px high (or 200px wide max) logo, and a transparent logo for your header.</p>
		<p>If you wish to change your header logo, we strongly recommend you use a PNG format image with alpha transparency.</p>
		<p>But don't worry about the size, we do all that for you!</p>
  </div>
</div>
<cfoutput>

<form class="form-horizontal" id="imageForm">
	<fieldset>
		<legend>Large Logo</legend>
		<div class="control-group">
			<label class="control-label"></label>
			<div class="controls">
				<div class="img"><img src="/includes/images/companies/#rc.siteID#/large.jpg" id="largeLogo" rel="#rc.siteID#" ></div><br />
				<button type="button" class="btn btn-info btn"><div id="largeUpload"></div></button>
			  <input type="hidden" id="large_x" value=""/>
				<input type="hidden" id="large_y" value=""/>
				<input type="hidden" id="large_w" value=""/>
				<input type="hidden" id="large_h" value=""/>
				<div id="largeQueue"></div>
			</div>
		</div>		
		<div class="form-actions">
      <a rel="#rc.siteID#" href="##" id="saveLarge" class="btn btn-primary">Save Large Image</a>      
    </div>
	</fieldset>
	<fieldset>
    <legend>Thumbnail</legend>
    <div class="control-group">
      <label class="control-label"></label>
      <div class="controls">
        <div class="img"><img src="/includes/images/companies/#rc.siteID#/small.jpg" id="thumbnail" rel="#rc.siteID#" ></div><br />
        <button type="button" class="btn btn-info btn"><div id="thumbnailUpload"></div></button>
				<input type="hidden" id="thumb_x" value=""/>
        <input type="hidden" id="thumb_y" value=""/>
        <input type="hidden" id="thumb_w" value=""/>
        <input type="hidden" id="thumb_h" value=""/>
				<div id="thumbQueue"></div>
      </div>
    </div>    
    <div class="form-actions">
      <a rel="#rc.siteID#" href="##" id="saveThumb" class="btn btn-primary">Save Thumbnail</a>      
    </div>
  </fieldset>
	<fieldset>
    <legend>Header Logo <small>This may appear with a black background, but don't worry!</small></legend>
    <div class="control-group">
      <label class="control-label"></label>
      <div class="controls">
        <div class="img"><img src="/includes/images/companies/#rc.siteID#.png" id="transparent" rel="#rc.siteID#" ></div><br />
        <button type="button" class="btn btn-info btn"><div id="transparentUpload"></div></button>
				<input type="hidden" id="transparent_x" value=""/>
        <input type="hidden" id="transparent_y" value=""/>
        <input type="hidden" id="transparent_w" value=""/>
        <input type="hidden" id="transparent_h" value=""/>
				<div id="transparentQueue"></div>
      </div>
    </div>    
    <div class="form-actions">
      <a rel="#rc.siteID#" href="##" id="saveTransparent" class="btn btn-primary">Save Transparent Logo</a>      
    </div>
  </fieldset>
</form>

</cfoutput>