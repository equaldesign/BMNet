<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/market/home","")>
<form class="form">
      <h3>Sites</h3>
      <cfoutput>
      <cfloop array="#rc.filterOptions.sites#" index="site">
        <a href="##" class="btn btn-mini" data-brandID="#site#">#site#</a>
      </cfloop>     
      <hr />
      
      <div id="amount">&pound;#rc.minPrice# - &pound;#rc.maxPrice#</div><br />
      <div id="pricerange" data-min="#rc.filterOptions.priceLow#" data-max="#rc.filterOptions.priceHigh#"></div>
      <input type="hidden" id="price_from" value="#rc.minPrice#" />
      <input type="hidden" id="price_to" value="#rc.maxPrice#" />
      </cfoutput>
      <hr />
      
        <fieldset>          
          <div class="control-group">           
            <div class="controls">
              <div class="input-append">
                <input type="text" name="keyword" class="input-medium" value="" placeholder="search for an item" />
                <span class="add-on"><i class="icon-search"></i></span>                             
              </div>
            </div>
          </div>
          <div class="control-group">
            <div class="controls">
              <label class="checkbox">
                <input type="checkbox" name="public" value="true" checked="checked" />
                Show public items?
              </label>
            </div>
          </div>
        </fieldset>
      </form>