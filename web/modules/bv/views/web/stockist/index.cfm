<cfset getMyPlugin(plugin="jQuery").getDepends("cookie","secure/companies/detail","secure/companies/index")>
<div class="relative">
<cfoutput>
  <h3>#rc.stockist.getname()#</h3>

  <div id="tabs" class="stockist Aristo">
    <ul>
      <li><a class="overview" href="/bv/stockist/overview?nodeRef=#rc.nodeRef#"><span>Overview</span></a></li>
      <li><a class="contacts" href="/bv/stockist/contacts?nodeRef=#rc.nodeRef#"><span>Contacts</span></a></li>
      <li><a class="history" href="/bv/stockist/history?nodeRef=#rc.nodeRef#"><span>History</span></a></li>
      <li><a class="notes" href="/bv/comments/index?nodeRef=#rc.nodeRef#"><span>Notes</span></a></li>
      <cfif rc.stockist.getsiteID() neq "">
      <li><a class="blog" href="/bv/blog/index?siteID=#rc.stockist.getsiteID()#"><span>News</span></a></li>
      <li><a class="products" href="/bv/products/index?siteID=#rc.stockist.getsiteID()#"><span>Products</span></a></li>
      <li><a class="documents" href="/bv/documents/index?siteID=#rc.stockist.getsiteID()#"><span>Documents</span></a></li>
      </cfif>
    </ul>
  </div>
</cfoutput>
</div>