<cfoutput>
  <form class="form-horizontal" action="/mxtra/shop/basket/add" method="post">
    <cfif (isUserInRole("trade") AND rc.product.delivery_locations_trade neq "collectonly") OR (rc.product.delivery_locations neq "collectonly")>
		<fieldset>
    	<legend>Home Delivery</legend>		  
			<div class="control-group">
		  
        <label class="control-label">Delivery</label>
				<div class="controls">
					<label class="radio">
						<input checked="checked" type="radio" name="collectionBranch" value="0">Deliver to me for &pound;#DecimalFormat(rc.deliveryCost)#
					</label>
				</div>          
      </div>
		</fieldset>
		</cfif>
    <cfif rc.product.collectable>
		<fieldset>
			<legend>Click and Collect</legend>
      <div class="control-group">
      	<label class="control-label">Collect from</label>
				<div class="controls">                  
				<cfset branches = getModel("modules.eunify.model.BranchService").getAll(request.siteID)>                 
          <cfif rc.stockAvailable.recordCount neq 0>
            <cfloop query="rc.stockAvailable">
              <cfif physical gte 1>
			  	     <cfset branch = getModel("modules.eunify.model.BranchService").getBranch(realBranchID)>  					     
			  	     <div>
			  	     <label class="radio">
			  	       <input  type="radio" name="collectionBranch" value="#branchID#">								 
								 <div class="thumbnails row">
									 <div class="span2">								 	
										<img class="thumbnail" src="http://maps.googleapis.com/maps/api/staticmap?center=<cfif branch.address1 neq "">#branch.address1#,</cfif><cfif branch.address2 neq "">#branch.address2#,</cfif><cfif branch.address3 neq "">#branch.address3#,</cfif><cfif branch.town neq "">#branch.town#,</cfif><cfif branch.county neq "">#branch.county#,</cfif><cfif branch.postcode neq "">#branch.postcode#,</cfif>&zoom=13&size=150x150&markers=color:green%7C<cfif branch.address1 neq "">#branch.address1#,</cfif><cfif branch.address2 neq "">#branch.address2#,</cfif><cfif branch.address3 neq "">#branch.address3#,</cfif><cfif branch.town neq "">#branch.town#,</cfif><cfif branch.county neq "">#branch.county#,</cfif><cfif branch.postcode neq "">#branch.postcode#,</cfif>&sensor=false" />
									 </div>
									 <div class="span2">
									 	<!--- branch details --->
										<h3>#branch.name#</h3>
										<address>
											#branch.address1#
											<cfif branch.address2 neq ""><br />#branch.address2#</cfif>
											<cfif branch.address2 neq ""><br />#branch.address2#</cfif>
											<cfif branch.town neq ""><br />#branch.town#</cfif>
											<cfif branch.county neq ""><br />#branch.county#</cfif>
											<cfif branch.postcode neq ""><br />#branch.postcode#</cfif>
										</address>
									 </div>
								 </div>
			  	     </label>
							 </div>               
              </cfif>
            </cfloop>            
          <cfelse>            
            <cfloop query="branches">
				      <div>
				      <label class="radio">
                 <input type="radio" name="collectionBranch" value="#branch_ref#">
                 <div class="row thumbnails">
									 <div class="span2">
	                  <img class="thumbnail" src="http://maps.googleapis.com/maps/api/staticmap?center=<cfif address1 neq "">#address1#,</cfif><cfif address2 neq "">#address2#,</cfif><cfif address3 neq "">#address3#,</cfif><cfif town neq "">#town#,</cfif><cfif county neq "">#county#,</cfif><cfif postcode neq "">#postcode#,</cfif>&zoom=13&size=150x150&markers=color:green%7C<cfif address1 neq "">#address1#,</cfif><cfif address2 neq "">#address2#,</cfif><cfif address3 neq "">#address3#,</cfif><cfif town neq "">#town#,</cfif><cfif county neq "">#county#,</cfif><cfif postcode neq "">#postcode#,</cfif>&sensor=false" />
	                 </div>
	                 <div class="span2">
	                  <h3>#name#</h3>
	                  <address>
	                    #address1#
	                    <cfif address2 neq ""><br />#address2#</cfif>
	                    <cfif address2 neq ""><br />#address2#</cfif>
	                    <cfif town neq ""><br />#town#</cfif>
	                    <cfif county neq ""><br />#county#</cfif>
	                    <cfif postcode neq ""><br />#postcode#</cfif>
	                  </address>
	                 </div>
								 </div>
               </label>
							 </div>              
            </cfloop>
          </cfif>
         </div>
      </div>
	    </cfif>  
    </fieldset>    
		<input type="hidden" name="productID" value="#rc.productID#" />
    <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
  </form>  
</cfoutput>