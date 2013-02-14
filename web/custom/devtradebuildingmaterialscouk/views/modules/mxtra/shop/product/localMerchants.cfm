<cfset rc.branches = getModel('modules.mxtra.model.eGroupLookup').getBranches(rc.product.buildingVineID,request.fullBasket.deliveryCoOrdinates)>
<cfif rc.branches.recordCount neq 0>      	 
  <cfoutput>
  #getMyPlugin(plugin="jQuery").getDepends("","postCodeLookup","",true,"mxtra")#
		<div class="alert alert-info">
	    <a class="close" data-dismiss="alert">&times;</a>
	    <h2 class="alert-heading">Stocking Branches</h2>
			<div id="locationsFound">
		    <p>We've found <strong style="color:red">#rc.branches.recordCount#</strong> UK Merchant branches that stock or sell this item<cfif request.fullBasket.deliverypostCode neq ""> close your location.<cfelse>.</cfif>
		    <cfif request.fullBasket.deliverypostCode eq "">
		    <h4>Find your nearest...</h4>
		    <form action="/mxtra/shop/basket/setpostcode" id="setpostcode" class="form form-horizontal">
		      <div class="input-prepend input-append">
		        <span class="add-on"><i class="icon-postcode"></i></span>
		        <input type="text" style="width:125px" class="input" id="postcode" name="postcode" placeholder="Enter your postcode..." />
		        <button class="btn btn-success">update</button>
		      </div><br />
					<input type="hidden" name="bvsiteid" value="#rc.product.buildingVineID#">                	      
		    </form>
				<h3>Find me automatically</h3>
				<p>We can find your location automatically. Oooh, spooky!</p>
				<a href="##" id="locateLocation" class="btn btn-info">Find my current location! <i class="icon-pushpin"></i></a>
		    </cfif>
	    </div>
	  </div>  
  </cfoutput>      
</cfif>