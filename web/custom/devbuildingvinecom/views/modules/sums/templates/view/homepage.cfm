<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/14/homepage","jQuery/sr/settings",false)#</cfoutput>
<div class="hidden-phone" id="homepageBanner">
  <div class="container">

    <h1>There's a place for everything, <br />and everything in it's place.</h1>
    <h3>Product specifications, press releases, price books, <br />promotions, documentation, health &amp; safety sheets.</h3>
    <h4>Mobile, web, tablet, back-office, intranet, web integration.</h4>
    <p>For all products within the construction industry, Building Vine provides<br/> 
        a single point of storage with multiple routes to access.</p>
        <br /><br />
    <a href="/signup" class="btn btn-large btn-success">Sign up for free</a>&nbsp;<a href="/html/tour.html" class="btn btn-large btn-warning">More information</a>
  </div>
</div>
<div>
  <div class="homecounter hidden-phone">
    <div class="container">
      <cfquery name="p" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">select count(*) as productCount from alf_node where type_qname_id = 258
        AND store_id = 6;
      </cfquery>
      <div class="counter">
        <h3>
          Currently
          <div class="counter-analog">
          <cfoutput>#numFormatAdvanced(p.productCount+99854,"999,999","<span class='part'><span class='digit digit$num'>$num</span></span>","<span class='sep'>,</span>")#</cfoutput>
          </div>
          Products Stored
        </h3>
      </div>
    </div>
  </div>
  <div class="homeintro">
    <div class="container">
      <h2>Building Vine is a platform for Suppliers and Manufacturers to manage their products, press releases, documentation and product specifications. Merchants and Retailers can then use this information for free on their websites and intranets - helping them generate more sales and reducing their website management overheads.</h2>
    </div>
  </div>
  <div class="homedescription">
    <div class="container">
      <div class="row-fluid">
        <div class="span4">
          <div class="media">
            <a class="pull-left" href="##"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-64/help_and_support.png" class="media-object"></a>
            <div class="media-body">
              <h4 class="media-heading">How does it work?</h4>
              <p>Each supplier has a "site", where they manage their products, documents, press releases and promotions.</p>
              <p>Merchants and Retailers can then use this information directly on their website through our web API; product images display automatically (resized and cropped), specifications show alongside the products, and documention is loaded automatically (user guides, installation instructions).</p>
            </div>
          </div>
        </div>
        <div class="span8">
          <div class="span6">
            <div class="media">
              <a class="pull-left" href="##"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-64/secured.png" class="media-object"></a>
              <div class="media-body">
                <h4 class="media-heading">Benefits for Manufacturers and Distributors</h4>
                <ul>
                  <li><i class="icon-tick-circle-frame"></i>Control of your products in the marketplace</li>
                  <li><i class="icon-tick-circle-frame"></i>Help new online retailers get up-and-running quickly and easily</li>
                  <li><i class="icon-tick-circle-frame"></i>Targetting Marketing through opt-in mailing lists</li>
                  <li><i class="icon-tick-circle-frame"></i>Help retailers sell more products, by providing customers with more information</li>
                </ul>
              </div>
            </div>
          </div>
          <div class="span6">
            <div class="media">
              <a class="pull-left" href="##"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-64/shopping-bag.png" class="media-object"></a>
              <div class="media-body">
                <h4 class="media-heading">Benefits for Merchants and Retailers</h4>
                <ul>
                  <li><i class="icon-tick-circle-frame"></i>Reduce your ongoing website management costs</li>
                  <li><i class="icon-tick-circle-frame"></i>Sell more products by proving better images and specifications to visitors</li>
                  <li><i class="icon-tick-circle-frame"></i>Reduce server load and speed up your website's performance</li>
                  <li><i class="icon-tick-circle-frame"></i>Centralise social interactivity to boost your company's image</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="homeintro">
    <div class="container">
      <h2>Who's using it?</h2>
      <cfquery name="newSites" datasource="bvine">select * from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">;</cfquery>
      <cfoutput query="newSites">
        <cfset uImage = paramImage2("/modules/bv/includes/images/companies/#shortName#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>
        <a href="/site/#shortName#" class="ttip" title="#title#"><img class="img-polaroid" alt="#xmlFormat(title)#" src="#uImage#" /></a>
      </cfoutput>
    </div>
  </div>
</div>
