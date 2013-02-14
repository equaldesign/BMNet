<cfset getMyPlugin(plugin="jQuery").getDepends("","products/import/import","")>
<div class="row-fluid">
  <div class="span4">

  </div>
  <div id="ajaxMain" class="span8">
    <form id="ssUpload" class="form form-horizontal" action="/eunify/products/doImport" method="post">
      <fieldset>
        <legend>Import Products</legend>
        <div class="control-group">
          <label class="control-label">
            Pick your file
          </label>
          <div class="controls">
            <input name="file" id="file" value="Browse and find your file..." type="file">
            <p class="help-block">Browser your computer to find your product file</p>
            <p class="help-block" id="beforeUpload"></p>
          </div>
        </div>
      </fieldset>
      <fieldset id="afterUpload" class="hidden">


      </fieldset>
    </form>
  </div>
</div>
