<cfsetting requesttimeout="90000">
<cffunction name="doFurtherCats" output="true">
  <cfargument name="children">
  <cfargument name="level">
  <cfif ArrayLen(arguments.children) neq 0>
    <cfset doFutherCats(arguments.children,level++)>
  <cfelse>
    <cfloop array="#arguments.children#" index="c">
      <cfoutput><h#arguments.level#>#c.title#</h#arguments.level#></cfoutput>
      <cfset doProductList(c.nodeRef)>
    </cfloop>
  </cfif>
</cffunction>
<cffunction name="doProductList" output="true">
  <cfargument name="categoryID">
  <cfset var productList = rc.products.listProducts(rc.siteID,0,100000,ListLast(arguments.categoryID,"/"))>
  <div class="productList">
    <cfloop array="#productList.results#" index="product">
      <cfset rc.product.detail = product>
      <cfif rc.style eq "standard">
        <p style="page-break-after:always;">&nbsp;</p>
        <div class="product">
          <cfoutput>#renderView("web/products/brochure/prod")#</cfoutput>
        </div>
      </cfif>
    </cfloop>
  </div>
</cffunction>
<cfset level = 1>
<cfdocument format="PDF" fontembed="true" bookmark="true" localurl="false" pagetype="A4">
  <cfdocumentsection name="Cover">
    <html>
      <head>
        <style>
          html, body {
            width:100%
            height: 100%
            background-color:#00CC99;
            color:#FFF;
          }
        </style>
      </head>
      <body>
        <cfoutput><img src="/includes/images/companies/#rc.siteID#.png"></cfoutput>
      </body>
    </html>
  </cfdocumentsection>
  <cfdocumentsection name="Catalog">
    <html>
      <head>
        <style>
          html, body {
            width:100%
            height: 100%
            color:#000;
            font-family: "Droid Sans";
            font-size: 90%;
          }
        </style>
      </head>
      <body>

    <cfloop array="#rc.categoryList.items#" index="cat">
      <cfdocumentitem type="pagebreak"></cfdocumentitem>
      <cfif ArrayLen(cat.children) neq 0>
        <cfset doFurtherCats(cat.children,level++)>
      <cfelse>
        <cfset doProductList(cat.nodeRef)>
      </cfif>
    </cfloop>
      </body>
    </html>
  </cfdocumentsection>
</cfdocument>