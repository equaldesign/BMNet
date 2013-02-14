<cfif NOT isDefined('rc.category')>
  <cfset rc.category = getModel("modules.eunify.model.ProductService")>
</cfif>
<cfset rc.baseCats = rc.category.categoryList(0,"","","")>
<cfoutput query="rc.baseCats">
  <h3><a href="##">#capFirstTitle(name)#</a></h3>
  <div>
    <ul>
      <cfset childCats = rc.category.categoryList(id,"","","")>
      <cfloop query="childCats">
        <cfset cCats = rc.category.categoryList(id,"","","")>
        <cfif cCats.recordCount neq 0>
        <li class="heading">#capFirstTitle(name)#&nbsp;</li>

        <ul>
        <cfloop query="cCats">
          <li><a href="/mxtra/shop/category/#pageslug#?categoryID=#id#">#capFirstTitle(name)#</a></li>
        </cfloop>
        </ul>
        <cfelse>
        <li><a href="/mxtra/shop/category/#pageslug#?categoryID=#id#">#capFirstTitle(name)#</a></li>
        </cfif>
      </cfloop>
    </ul>
  </div>
</cfoutput>
