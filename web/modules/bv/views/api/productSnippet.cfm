<cfset getMyPlugin(plugin="jQuery").getDepends("","api/productSnippet","")>
<a href="#productSnippet" role="button" class="btn btn-mini pull-right showModal" data-toggle="modal" data-nodeRef="<cfoutput>#args.nodeRef#</cfoutput>">Add this product data to your website</a>
<div id="productSnippet" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="productSnippet" aria-hidden="true" data-show="hide">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Product Snippet</h3>
  </div>
  <div class="modal-body">
    <form class="form form-horizontal">
      <ul class="nav nav-tabs" id="myTab">
        <li class="active"><a data-target="#home" href="#" data-toggle="tab">Code</a></li>
        <li><a data-target="#options" href="#" data-toggle="tab">Options</a></li>      
        <li><a data-target="#expertoptions" href="#" data-toggle="tab">Expert Options</a></li>      
      </ul>  
      <div class="tab-content">
        <div class="tab-pane active row-fluid" id="home">
          <p class="help-block">
            Copy and paste the code below into your page
          </p>
          <textarea id="snippetCode" class="span12"  rows="10">
          </textarea>
        </div>
        <div class="tab-pane" id="options">
          <fieldset>            
            <div class="control-group">
              <label class="control-label">Show Documents</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-showdocuments" class="enableOption" value="true" checked="checked">
                  Tick this box to show the product's related documents
                </label>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Show Videos</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-show-video" value="true" class="enableOption" checked="checked">
                  Tick this box to show the product's related youtube videos
                </label>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Social Reactions</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-icons" value="true" class="enableOption" checked="checked">
                  Tick this box to enable social media reactions
                </label>
              </div>

            </div>
            <div class="control-group">
              <label class="control-label">Social Networks</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="googlePlus" class="enableOption" checked="checked">
                  Google Plus
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="facebook" class="enableOption" checked="checked">
                  Facebook
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="twitter" class="enableOption" checked="checked">
                  Twitter
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="delicious" class="enableOption" checked="checked">
                  Delicious
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="stumbleupon" class="enableOption" checked="checked">
                  Stumbleupon
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="linkedIn" class="enableOption" checked="checked">
                  LinkedIn
                </label>
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-social-networks" value="pinterest" class="enableOption" checked="checked">
                  Pinterest
                </label>
              </div>

            </div>            
          </fieldset>
        </div>
        <div class="tab-pane" id="expertoptions">
          <fieldset>
            <legend>Data Targets</legend>
            <div class="control-group">
              <label class="control-label">Accordion</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" data-reference="data-use-accordion" class="enableOption" value="true">
                  Use Accordion (data items will be appended to an existing accordion)
                </label>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Accordion Type</label>
              <div class="controls">                
                <select class="enableOption" data-reference="data-accordion-type">
                  <option value="jQueryUI">jQuery UI</option>
                  <option value="bootstrap">BootStrap</option>
                </select>
                <p class="help-block">Please choose the framework used for the accordion</p>                
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Accordion ID</label>
              <div class="controls">                
                <input type="text" class="enableOption" data-reference="data-accordion-target" value="accordion" placeholder="DOM ID of Accordion">
                <p class="help-block">The DOM ID of the accordion target (do not include the hash)</p>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Accordion Options</label>
              <div class="controls">                
                <label class="checkbox">
                  <input type="checkbox"  data-reference="data-accordion-collapse" class="enableOption" value="true">
                  Enable accordion to collapse
                </label>                
              </div>
            </div>
          </fieldset>
        </div>        
      </div>
    </form>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>