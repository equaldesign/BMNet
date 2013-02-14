<cfoutput>
  <ul>
    <li><a class="bvine" href="/bv" title="">Building Vine</a></li>
    <li><a class="bvine_createblog" href="#bl('bv.blog.edit','siteID=#rc.sess.buildingVine.siteID#')#" title="Create News Item">Create News Item</a></li>
    <li><a class="bvine_uploadproducts" href="#bl('bv.products.importProducts','siteID=#rc.sess.buildingVine.siteID#')#" title="Upload Product File">Upload Product File</a></li>
    <cfif rc.sess.eGroup.isMemberContact>
    <li><a class="bvine_uploadprices" href="#bl('bv.products.importPrices')#" title="Upload Price List">Upload Price List</a></li>
    <li><a class="bvine_sync" href="#bl('bv.tools.syncProductFile','siteID=#rc.sess.buildingVine.siteID#')#" title="Syncronise Data">Syncronise your ERM System</a></li>
    </cfif>
  </ul>
</cfoutput>