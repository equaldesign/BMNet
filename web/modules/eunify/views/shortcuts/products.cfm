<cfset getMyPlugin(plugin="jQuery").getDepends("jstree","products/tree","themes/classic/style")>
<div class="leftAccordion">
  <h4><a class="product_panel_tree" href="#">Products</a></h4>
  <div>
    <ul id="productTree" class="jstree-products"></ul>
  </div>
  <h4><a class="product_panel_buildingVine">Building Vine</a></h4>
  <div>
    <ul>
      <li><a class="sync" href="/sync">Sync unmatched products</a></li>
      <li><a class="bv" href="/products/">Show BV Linked Products</a></li>
      <li><a class="update" href="/products/updatefromBV">Update from BV</a></li>
    </ul>
  </div>
</div>
