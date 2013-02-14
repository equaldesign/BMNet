<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<cfset getMyPlugin(plugin="jQuery").getDepends("","products/detail","")>
<cfoutput>

<input type="hidden" id="product_code" value="#rc.product.product_code#">
<form id="liveUpdate"  class="form form-horizontal">
  <div class="row-fluid">
    <div class="span3">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-bv"></i></span>
          <h5>Building Vine</h5>
        </div>
        <div class="widget-content">
          <img src="https://www.buildingvine.com/api/productImage?&eancode=#rc.product.EANCode#&size=medium&manufacturerproductcode=#rc.product.Manufacturers_Product_Code#&supplierproductcode=#rc.product.product_code#&productName=#rc.product.full_description#" class="img"></a>

          <div id="productAccordion"></div>
          <div
            style="padding:10px;"
            data-show-video="true"
            id="bvinfo"
            data-use-accordion="true"
            data-accordion-target="productAccordion"
            data-accordion-collapse="false"
            data-accordion-start="false"
            data-use-tabs="false"
            data-tab-target="bv_detailTabsContainer"
            data-tab-type="bootstrap"
            data-social-networks="googlePlus,facebook,twitter,linkedIn"
            data-showdocuments="true"
            data-showdata="true"
            data-src="eancode=#rc.product.eancode#&manufacturerproductcode=#rc.product.manufacturers_product_code#&supplierproductcode=#rc.product.manufacturers_product_code#&productName=#rc.product.full_description#"></div>
        </div>
      </div>
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-chart-pie"></i></span>
          <h5>Sales Information</h5>
        </div>
        <div class="widget-content">

        </div>
      </div>
    </div>
    <div class="span4">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-money"></i></span>
          <h5>Pricing Information</h5>
        </div>
        <div class="widget-content">
          #renderView("products/details/pricing")#
        </div>
      </div>
    </div>
    <div class="span5">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-truck"></i></span>
          <h5>Delivery Information</h5>
        </div>
        <div class="widget-content">
          #renderView("products/details/delivery")#
        </div>
      </div>
    </div>
  </div>
  <div class="row-fluid">
    <div class="span4">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-drill"></i></span>
          <h5>Product Information</h5>
        </div>
        <div class="widget-content">
          #renderView("products/details/attributes")#
        </div>
      </div>
    </div>
    <div class="span4">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-store"></i></span>
          <h5>Stock Information</h5>
        </div>
        <div class="widget-content">

        </div>
      </div>
    </div>
    <div class="span4">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><i class="icon-globe"></i></span>
          <h5>Web Information</h5>
        </div>
        <div class="widget-content">
          #renderView("products/details/web")#
        </div>
      </div>
    </div>
  </div>
</form>
</cfoutput>
<!---
<h2><cfoutput>#rc.product.full_description#</cfoutput></h2>
<div id="tabs" class="Aristo">
<cfoutput>
<ul>
  <li><a class="detail" href="#bl('products.detail','id=#rc.product_code#')#"><span>Product Detail</span></a></li>
  <cfif isDefined("rc.eGroup.PSAs")>
  <cfloop query="rc.eGroup.PSAs">
    <li><a class="invoices" href="#bl('eGroup.psa.index','psaid=#id#')#"><span>CEMCO #id#</span></a></li>
  </cfloop>
  </cfif>
</ul>
</cfoutput>
</div>
--->