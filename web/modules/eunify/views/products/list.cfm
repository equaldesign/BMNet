<cfset getMyPlugin(plugin="jQuery").getDepends("","products/table","")>
<div class="widget-box">
  <div class="widget-title">
    <h5>Product List</h5>
  </div>
  <div class="widget-content nopadding">
    <cfoutput>
    <input type="hidden" id="categoryID" value="#rc.categoryID#">
    </cfoutput>
    <table class="table table-condensed table-hover table-striped dataTable" id="productList">
      <thead>
        <tr>

          <th rowspan="2" width="1%"></th>
          <th rowspan="2" width="3%"></th>
          <th rowspan="2" nowrap="true">Product Code</th>
          <th rowspan="2" width="40%">Description</th>
          <th rowspan="2">Retail Price</th>
          <th rowspan="2">Trade Price</th>
          <th colspan="2" style="border-right: 1px solid #CCC;">Building Vine</th>
          <th rowspan="2">Web</th>
          <th rowspan="2">Public</th>
        </tr>
        <tr>
          <th>BV</th>
          <th>approved</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>
</div>
