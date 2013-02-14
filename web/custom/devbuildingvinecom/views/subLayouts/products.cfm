<cfset bgImage = "/includes/images/sites/14/homebg.jpg">
<cfif event.getCurrentEvent() eq "bv:products.productDetail">
  <cfif arrayLen(rc.product.detail.productImage) gte 1>
    <cfset bgImage = "https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=1000&crop=true">
  </cfif>
<cfelse>
  <cfif ArrayLen(rc.products.results) gt 0>
    <cfloop array="#rc.products.results#" index="product">
      <cfif arrayLen(product.productImage) gte 1>
        <cfset bgImage = "https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=1000&crop=true">
        <cfbreak>
      </cfif>
    </cfloop>
  <cfelse>
    <cfif isDefined("rc.products.categories") AND ArrayLen(rc.products.categories) gte 1>
      <cfset bgImage = "https://www.buildingvine.com/api/productImage?categoryNodeRef=#rc.products.categories[1].nodeRef#&size=1000&crop=true">
    <cfelse>
      <cfset bgImage = "https://www.buildingvine.com/api/productImage?categoryNodeRef=0&size=1000&crop=true">
    </cfif>
  </cfif>
</cfif>
<cfoutput>

  <style>
    body {
      background: url('#bgImage#'); background-size:100%; background-attachment:fixed; height: 100%; background-repeat: no-repeat;
    }
  </style>
<div class="mainBG" style="background: url('/includes/images/sites/14/pattern.png'); height: 100%">

  <div class="products">

    <div class="breadcrumb">
      <div class="container">
        <cfoutput>
        <div>
          <form class="pull-right form-horizontal" method="get" action="/bv/search?siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#">
            <div class="input-append">
              <input class="input-xlarge" placeholder="Product Search..." type="text" name="query" id="furtherSearchBox">
              <input type="button" class="btn" value="Search" />
            </div>
          </form>
          <ul class="breadcrumb">
            <li><a href="#bl("products.index","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#")#" class="ajax">Products</a><span class="divider">/</span></li>
            <cfif event.getCurrentEvent() eq "bv:products.productDetail">
              <cfset m = ArrayLen(rc.product.detail.parentStruct)>
              <cfloop from="1" to="#m#" index="i">
                <cfset cat = rc.product.detail.parentStruct[m]>
                <li><a href="#bl("products.index","nodeRef=#cat.nodeRef#&siteID=#rc.product.detail.site#&layout=#rc.layout#&maxrows=#rc.maxrows#")#">#cat.name#</a><span class="divider">/</span></li>
                <cfset m-->
              </cfloop>
              <li class="active">#rc.product.detail.title#</li>
            <cfelse>
              <cfset m = ArrayLen(rc.products.parentStruct)>
              <cfloop array="#rc.products.parentStruct#" index="cat">
                <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#cat.nodeRef#")#">#cat.name#</a><span class="divider">/</span></li>
              </cfloop>
              <cfif rc.nodeRef neq 0>
                <li class="active">#rc.products.category.name#</li>
              </cfif>
            </cfif>
          </ul>
        </div>
        </cfoutput>
      </div>
    </div>
    <div class="container">
      <div class="row"> 
        <div class="span4 hidden-phone">
          <cfif event.getCurrentModule() eq "bv">  
             <cfoutput>#renderView(view="web/shortcuts/#ListLast(event.getCurrentHandler(),":")#",cache=true,cacheSuffix="shortcut_products_#request.bvsiteID#")# </cfoutput>
          </cfif>
        </div>
        <div class="span8">
          <div class="productMain">
          <cfoutput>#renderView()#</cfoutput>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>