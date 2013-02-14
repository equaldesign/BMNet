<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#rc.sess.siteID#/turnbull,sites/#rc.sess.siteID#/checkout","sites/#rc.sess.siteID#/checkout,sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
<cfoutput><h2>#rc.title# </h2></cfoutput>
<table class="tableCloth">
  <thead>
    <tr>
      <th>Billing Contact</th>
      <th>Total</th>
      <th>Delivery Post Code</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    <cfoutput query="rc.orders">
      <cfif rc.sess.mxtra.account.isAdmin>
        <cfset qLink = "/mxtra/admin/orders/orderDetail/id/#id#">
      <cfelse>
        <cfset qLink = "/mxtra/account/orderDetail/id/#id#">
      </cfif>
      <tr>
        <td><a href="#qLink#">#billingcontact#</a></td>
        <td><a href="#qLink#">&pound;#(totalVATPrice)#</a></td>
        <td><a href="#qLink#">#deliverypostcode#</a></td>
        <td><a href="#qLink#">#status#</a></td>
      </tr>
    </cfoutput>
  </tbody>
</table>