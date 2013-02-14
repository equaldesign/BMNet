<cfoutput>
  <ul class="nav nav-tabs" id="myTab" xmlns="http://www.w3.org/1999/html">
    <li class="active"><a class="activateTab" data-reference="mt_delivery-info" data-toggle="tab" href="##delivery_#rc.product.id#"><i class="icon-truck-empty"></i>Home Delivery</a></li>
    <li><a class="activateTab" data-reference="mt_click-and-collect" data-toggle="tab" href="##collection_#rc.product.id#"><i class="icon-cart_add"></i>Click and collect</a></li>
  </ul>
  <div class="tab-content">
    <div class="tab-pane active" id="delivery_#rc.product.id#">
      <cfoutput>#renderView("shop/basket/add/#rc.product.delivery_locations##IIf(isUserInRole('trade'),"'_trade'","''")#")#</cfoutput>

    </div>
    <div class="tab-pane" id="collection_#rc.product.id#">
      <cfif isBoolean(rc.product.collectable) AND rc.product.collectable>
      <h4>Choose a branch to collect from</h4>
       <form class="form-horizontal doBasket" action="/mxtra/shop/basket/add" method="post">
        <cfset branches = getModel("eunify.BranchService").getAll()>
        <cfif rc.stockAvailable.recordCount neq 0>
          <select name="collectionBranch">
            <cfloop query="rc.stockAvailable">

               <cfset branch = getModel("eunify.BranchService").getBranch(realBranchID)>
               <option value="#branchID#">
                 #branch.name# (#physical# in stock)
               </option>

            </cfloop>
          </select>

        <cfelse>
          <select name="collectionBranch">

          <cfloop query="branches">
            <option value="#branch_ref#">
                 #name#
            </option>
          </cfloop>
          </select>
        </cfif>

        <input type="hidden" name="productID" value="#rc.productID#" />
        <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
        <div class="input-prepend input-append">
          <span class="add-on">QTY.</span>
          <input type="text" class="input-micro" maxlength="3" name="quantity" value="1">
          <input class="btn btn-info" type="submit" value="Click and collect &raquo;">
        </div>
				<br /><br />

      </form>
      <cfelse>
	  	  <p>Collection is not available for this product</p>
	    </cfif>
    </div>
  </div>
  <div class="clear"></div>
</cfoutput>

