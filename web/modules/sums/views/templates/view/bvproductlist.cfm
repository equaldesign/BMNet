<cfset rc.viewType = event.getValue("viewType","list")>
<cfset rc.bvsiteID = paramValue("rc.requestData.page.attributes.BVSiteID","buildingVine")>
<cfset bvProductService = getModel("bv.ProductService")>
<cfset rc.bvnodeRef = event.getValue("bvnodeRef","0")>
<div class="wht">
<cfif rc.viewType eq "list">
  <cfscript>

        rc.paging = getMyPlugin("Paging");
        rc.maxRows = event.getValue("maxrows","");
        rc.layout = event.getValue("layout","");
        rc.paging.setPagingMaxRows(rc.maxRows);
        rc.boundaries = rc.paging.getBoundaries();
        rc.products = bvProductService.listProducts(nodeRef=rc.bvnodeRef,siteID=rc.bvsiteID,startRow=rc.boundaries.startRow,maxrow=rc.boundaries.maxRow);
  </cfscript>
  <cfoutput>#renderView("templates/view/bv/productlist")#</cfoutput>
<cfelse>
  <cfscript>
      rc.product = bvProductService.productDetail(rc.bvnodeRef,rc.bvsiteID);

      rc.parents = [];
      index = ArrayLen(rc.product.detail.parents);
      while (index>0) {
        ArrayAppend(rc.parents,"###rc.product.detail.parents[index]#");
        index--;
      }
      rc.amazonExists = false;

  </cfscript>
  <cfoutput>#renderView("templates/view/bv/productdetail")#</cfoutput>
</cfif>
</div>