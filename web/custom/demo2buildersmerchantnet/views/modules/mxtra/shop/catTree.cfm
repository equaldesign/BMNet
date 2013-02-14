<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/1/shop","",false)#</cfoutput>
<cfif NOT isDefined('rc.category')>
  <cfset rc.category = getModel("ProductService")>
</cfif>
<cfset rc.thisCategory = rc.category.getParentCategory(rc.categoryID,request.siteID)>
<cfif NOT isDefined("rc.filterOptions")>
  <cfset rc.filterOptions = rc.category.getProductRanges(ArrayToList(rc.category.categoryTraverse(rc.categoryID)))>
</cfif>
<cfif NOT isDefined("rc.leftCategories")>
<cfset rc.leftCategories = rc.category.categoryList(0)>
</cfif>
<div>
  <h4><cfif rc.categoryID neq 0>Further </cfif>Categories</h4>
  <ul id="mainLinks" class="nav nav-list">
    <cfif rc.productID neq 0>
      <cfoutput><li><a href="#bsl('/mxtra/shop/category/index?categoryID=#rc.categoryID#')#"><i class="icon-arrow-merge-090"></i> Up a level</a></li></cfoutput>
    <cfelseif rc.categoryID neq 0>
      <cfoutput><li><a href="#bsl('/mxtra/shop/category/index?categoryID=#rc.thisCategory.parentid#')#"><i class="icon-arrow-merge-090"></i> Up a level</a></li></cfoutput>
    </cfif>
    <cfif rc.leftCategories.recordCount neq 0>
      <cfoutput query="rc.leftCategories">
        <li class="#IIf(rc.categoryID eq id,'"active"','""')#"><a href="#bsl('/mxtra/shop/category/#pageSlug#?categoryID=#id#')#"><i class="icon-arrow-000-small"></i> #capFirstTitle(name)#</a></li>
      </cfoutput>

    </cfif>
  </ul>
  <cftry>
  <div class="accordion" id="shopFilter">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" data-parent="#shopFilter" href="#collapseOne">
           Filter Products <i class="icon-toolbox pull-right"></i>
        </a>
      </div>
      <div id="collapseOne" class="accordion-body collapse">
        <div class="accordion-inner">

            <cfoutput>
            <cfif rc.priceFrom eq "">
              <cfset startPrice = rc.filterOptions.min>
            <cfelse>
              <cfset startPrice = rc.priceFrom>
            </cfif>
            <cfif rc.priceTo eq "">
              <cfset endPrice = rc.filterOptions.max>
            <cfelse>
              <cfset endPrice = rc.priceTo>
            </cfif>
            <form class="form form-horizontal" id="filterForm">
              <h4>Price</h4>
              <div class="row-fluid">
                <label class="span4">Min Price</label>
                <div class="span8 input-prepend">
                  <span class="add-on">&pound;</span>
                  <input type="text" class="input-mini" id="price_from" value="#startPrice#" />
                </div>
              </div>
              <div class="row-fluid">
                <label class="span4">Max Price</label>
                <div class="span8 input-prepend">
                  <span class="add-on">&pound;</span>
                  <input type="text" class="input-mini" id="price_to" value="#endPrice#" />
                </div>
              </div>
              <br />
              <div data-min="#rc.filterOptions.min#" data-max="#rc.filterOptions.max#" id="pricerange"></div>
              <hr />

              <div class="row-fluid">
                <label class="span4">Delivery Area</label>
                <div class="span8">
                  <label class="checkbox">
                    <input class="filterCheck" data-relation="delivery_locations" #vml(request.mxtra.filter.delivery_locations,"nationwide","checkbox")# type="checkbox"  name="delivery_locations" value="nationwide" />
                    Nationwide
                  </label>
                  <label class="checkbox">
                    <input class="filterCheck" data-relation="delivery_locations" #vml(request.mxtra.filter.delivery_locations,"radius,postcode","checkbox")# type="checkbox" name="delivery_locations" value="radius,postcode" />
                    Local Delivery only
                  </label>
                </div>
              </div>
              <hr />
              <div class="row-fluid">
                <label class="span4">Collection</label>
                <div class="span8">
                  <label class="checkbox">
                    <input class="filterCheck" data-relation="collectable" #vml(request.mxtra.filter.collectable,"true","checkbox")# type="checkbox" name="collectable" value="true" />
                    Show collectable items?
                  </label>
                </div>
              </div>
              <hr />
              <div class="row-fluid">
                <label class="span4">Delivery Cost</label>
                <div class="span8">
                  <label class="checkbox">
                    <input class="filterCheck" data-relation="delivery_charge" #vml(request.mxtra.filter.delivery_charge,"none","checkbox")# type="checkbox" name="delivery_charge" value="none" />
                    Free Delivery
                  </label>
                  <label class="checkbox">
                    <input class="filterCheck" data-relation="delivery_charge" #vml(request.mxtra.filter.delivery_charge,"fixed","checkbox")# type="checkbox" name="delivery_charge" value="fixed" />
                    Fixed Cost
                  </label>
                </div>
              </div>
              <hr />
              <cfif isSimpleValue(request.geoInfo) OR request.geoInfo.zipcode eq "">
                <div class="alert"><button type="button" class="close" data-dismiss="alert">&times;</button>For accurate delivery information, please <a href="/mxtra/shop/basket/enterpostcode" class="dialog">provide your postcode</a></div>
              <cfelse>
                <div class="alert alert-info"><button type="button" class="close" data-dismiss="alert">&times;</button>We currently have your postcode as #request.geoinfo.zipcode#. If this is incorrect, please <a href="/mxtra/shop/basket/enterpostcode" class="dialog">update your postcode</a></div>
              </cfif>
            </form>
            </cfoutput>
        </div>
      </div>
    </div>
  </div>
  <cfcatch type="any">  <cfdump var="#rc.filterOptions#"></cfcatch>
  </cftry>
  <br />

</div>
