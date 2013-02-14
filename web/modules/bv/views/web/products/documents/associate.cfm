<cfset getMyPlugin(plugin="jQuery").getDepends("UI.autocomplete","secure/documents/associations","secure/table")>
<cfoutput>
  <input type="hidden" id="rel_nodeRef" value="#rc.nodeRef#" />
    <input id="assoc_type" type="hidden" value="productDocuments">
</cfoutput>
<ul id="relationships">
  <cfoutput>
  <cfloop array="#rc.documentRelationships.associations.documentAssociations#" index="p">
    <li>
      <a class="del" href="/alfresco/service/bv/product/document/associations?nodeRef=#rc.nodeRef#&associationType=ProductImage&assocNode=#p.nodeRef#&alf_ticket=#request.user_ticket#"></a>
        <cfif p.eancode neq "">
          <cfset title ="#p.eancode#">
        <cfelseif p.supplierproductcode neq "">
          <cfset title ="#p.supplierproductcode#">
        <cfelse>
          <cfset title ="#p.manufacturerproductcode#">
        </cfif>
        <a href="/products/productDetail?noderef=#p.nodeRef#" class="ttip" title="#title#">#p.name#</a>
    </li>
  </cfloop>
  </cfoutput>
</ul>

<cfoutput>
<p>Search for other products to relate to this document</p>
<form id="findProducts" action="/alfresco/service/bvine/search/products?maxrows=50&siteid=#rc.siteID#&alf_ticket=#request.user_ticket#">
  <input id="q_auto" type="text" name="q" />
</form>
</cfoutput>