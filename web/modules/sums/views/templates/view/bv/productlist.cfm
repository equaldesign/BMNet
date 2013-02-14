<cfset categoryArray = createObject("java", "java.util.Collections").reverse(rc.products.parentStruct)>
<cfoutput>

  <ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <cfif rc.bvnodeRef neq 0>
  <li><a href="/html/#rc.requestData.page.name#">#rc.requestData.page.title#</a> <span class="divider">/</span></li>
  <cfelse>
  <li class="active">#rc.requestData.page.title#</li>
  </cfif>
   <cfset m = ArrayLen(rc.products.parentStruct)>

    <cfloop array="#rc.products.parentStruct#" index="cat">
      <li><a href="/html/#rc.requestData.page.name#?bvnodeRef=#cat.nodeRef#">#cat.name#</a><span class="divider">/</span></li>
    </cfloop>
    <cfif rc.bvnodeRef neq 0>
    <li class="active">#rc.products.category.name#</li>
    </cfif>

  </ul>
<cfif ArrayLen(rc.products.categories) gte 1>
<div class="row-fluid">
  <div class="span12">
  <cfloop array="#rc.products.categories#" index="item">
    <div class="row-fluid">
      <div class="span1 productImage">
        <img class="catImage thumbmnail" src="https://www.buildingvine.com/api/productImage?categoryNodeRef=#item.NodeRef#&size=70" />
      </div>
      <div class="span11">
        <h2>
            <a href="/html/#rc.requestData.page.name#?bvnodeRef=#item.nodeRef#">
              #item.name#
            </a>
          </h2>
      </div>
    </div>
  </cfloop>
  </div>
</div>
</cfif>
<cfset x = 1>
<cfif rc.bvnodeRef eq 0>
  <cfif ArrayLen(rc.products.results) gte 1>
    <div class="page-header">
      <h1>Featured Products</h1>
    </div>
  </cfif>
<cfelse>
  <cfif ArrayLen(rc.products.results) gte 1>
    <div class="page-header">
      <h1>Products in this category</h1>
    </div>
  </cfif>
</cfif>
<cfif ArrayLen(rc.products.results) gte 1>
<div class="row-fluid">
  <div class="span12">
    <cfloop array="#rc.products.results#" index="product">
      <div class="jstree-draggable">
        <div rel="#product.nodeRef#" class="row-fluid">
          <div class="span1 productImage">
            <cfif ArrayLen(product.productImage) gte 1>
              <img class="thumbnail" src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=70" />
            <cfelse>
              <img class="thumbnail" src="https://www.buildingvine.com/api/productImage?siteID=#rc.bvsiteID#&eancode=#product.eancode#&size=70&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#" />
            </cfif>
          </div>
          <div class="span11">
            <h2><a href="/html/#rc.requestData.page.name#?viewType=detail&bvnodeRef=#product.nodeRef#" class="ajax">#product.title#</a></h2>
            <cfif product.eanCode neq "">
              <h5><span class="EAN">EAN:</span> #product.eancode#</h5>
            </cfif>
          </div>
        </div>
      </div>
      <cfset x++>
    </cfloop>
  </div>
</div>
</cfif>
</cfoutput>