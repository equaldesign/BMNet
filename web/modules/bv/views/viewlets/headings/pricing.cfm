<cfset getMyPlugin(plugin="jQuery").getDepends("","","public/home/pricing",false)>
<div class="pricingHeader">
<h1>30-day Free Trial on All Building Vine accounts</h1>
<cfquery name="p" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">select count(*) as productCount from alf_node where type_qname_id = 258
    AND store_id = 6 AND node_deleted = '';
  </cfquery>
  <cfquery name="tm" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">
  select count(*) as productCount from alf_node where type_qname_id = 258
  AND store_id = 6 AND node_deleted = '' AND audit_created > DATE_ADD(now(), INTERVAL -1 MONTH)
  </cfquery>  
	<cfoutput><h2>We have over #NumberFormat(p.productCount+99854,"9,999,999")# products and counting...</h2></cfoutput>
	<div class="row">
		<div class="pricing container">
		
	    <div class="pricebox small left">	    	
        <div>    		
	    		<h2>Personal Account</h2>
					<h3>FREE</h3>
					<h4>For individuals</h4>
				</div>
				<div class="divider"></div>
				<div>
				 <p>Free access to basic information, remote access via Sharepoint or WebDav/FTP.</p>
				 <p>Great for individuals, architects, specifiers and installers. No contract, no commitment, no charge!</p>
          <a href="/signup?type=free" class="btn">Sign Up</a>
				</div>				
	    </div>
			<div class="pricebox large">			
				<div>
					<h2>Business</h2>
					<h3>&pound;990</h3>
					<h4>For Merchants, Suppliers, Manufacturers and Retailers</h4>
				</div>
				<div class="divider"></div>
				<div>
				  <br /><p>Store products, add promotions and press releases, access our API through your website, automate price changes on your back office system, and follow your suppliers and customers.</p>
				  <p>Integration into the 4 main UK Buying Groups</p>
					<a href="/signup?type=business" class="btn btn-large btn-success">Sign Up</a>
				</div>				
			</div>
			<div class="pricebox small right">
				<div>
				  <h2>Basic Account</h2> 
          <h3>&pound;299</h3>
          <h4>A simple listing for Suppliers and Manufacturers</h4>
				</div>
				<div class="divider"></div>
				<div>
				  <br /><p>List your site, add press releases and promotions - get better exposure for less</p>
					<p>Integration into the 4 main UK Buying Groups.</p>
          <a href="/signup?type=basic" class="btn btn-large btn-info">Sign Up</a>
				</div>
			</div>		
		</div>
	</div>
</div>