<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","secure/tables,secure/promotions/associations","secure/promotions/associations")>
<div class="alert alert-info">
	<a href="#" class="close" data-dismiss="alert">&times;</a>
	<h3 class="alert-heading">About this section</h3>  
  <P>If your promotion is related to specific products, we highly recommend to select them below.</P>
  <p>You can either search for products individually, or you can select entire product categories.</p>	
</div>
<cfoutput>
<form action="/documents/index?dir=workspace://SpacesStore/#rc.nodeRef#" id="editProductAssociations" class="form form-horizontal">
  <input type="hidden" id="promoNodeRef" value="#rc.nodeRef#" />
  <div class="control-group"> 
    <label class="control-label">Search</label>
    <div class="controls">            
      <input rev="/alfresco/service/bvine/search/products?maxrows=50&siteid=#rc.siteID#&alf_ticket=#request.user_ticket#" id="findProductForAssociation"  />      
    </div>      
  </div>	
	<div class="span3 pull-left">		
    <div>
    	<table id="categoryList" class="dataTable table table-striped table-bordered">
    		<caption>Your Categories</caption>
				<thead>
    			<tr>    				
						<th>Name</th>
						<th width="1%"></th>
    			</tr>
    		</thead>
				<tbody>
					<cfloop array="#rc.productCategories#" index="cat">
				    <tr>						  
							<td>#cat.title#</td>
				      <td><a rel="#cat.nodeRef#" href="##" class="noAjax category select"><i class="icon-addtoList"></i></a></td>
						</tr>
					</cfloop>
				</tbody>
    	</table>      
    </div>
  </div>
  <div class="span3 pull-right">  	
    <table id="existingProducts" class="table table-striped table-bordered">
    	<caption>Applicable Products</caption>
			<thead>
    		<tr>
    			<th width="1%"></th>
					<th>Name</th>
    		</tr>
    	</thead>
			<tbody>
		    <cfloop array="#rc.promotions.products#" index="prod">
				  <tr>
				  	 <td><a rel="#prod.nodeRef#" href="##" class="noAjax deselect"><i class="icon-removeFromList"></i></a></td>
						 <td>#prod.title#</td>
				  </tr>		
				</cfloop>
			</tbody>
    </table>		
  </div>
</form>
</cfoutput>