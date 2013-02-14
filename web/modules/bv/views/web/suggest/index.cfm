<cfset getMyPlugin(plugin="jQuery").getDepends("","","contact")>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>Not registered!</strong> You do not seem to have a Building Vine&trade; account - but don't worry, you could get one for free!</p>
  </div>
</div>

<br />

<div id="bvIntro">
  <cfquery name="p" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">select count(*) as productCount from alf_node where type_qname_id = 258
    AND store_id = 6 AND node_deleted = '';
  </cfquery>
  <cfoutput>
  <cfif isUserInRole("egroup_member")>
  <h2>About this service...</h2>
  <p>Building Vine&trade; is a third-party system that holds product information, technical specifications, press releases, promotions and product images - from leading suppliers within the Construction Industry.</p>
  <p>As a user of the #getSetting('siteTitle')# intranet, you can access the majority of Building Vine features and data for free.</p>
  <p>We can automatically create a new account for you, and link this to your #getSetting('siteTitle')# account so you can access all the data stored in Building Vine&trade; right here on the intranet - whenever you want.</p>
  <cfelse>
  <h2>About Building Vine&trade;</h2>
  <p>Building Vine&trade; is a third-party system that holds product information, technical specifications, press releases, promotions and product images - from leading suppliers within the Construction Industry.</p>
  <p>As a supplier you could store product information, images, brochures, promotions, company specific pricing - and much more.</p>
  <p>What's more, it's integrated directly into the #getSetting('siteTitle')# intranet - and 3 other buying group intranet systems - giving your data exposure to over 1000 merchant staff.</p>
  <p>To signup and add your company, visit <a target="_blank" href="http://www.buildingvine.com">www.buildingvine.com</a> for more information.</p>
  <p>Provided you use your #getSetting('siteTitle')# email address when registering, your site will instantly appear on the #getSetting('siteTitle')# intranet automatically!</p>
  </cfif>
  <h3>We currently store information on #NumberFormat(p.productCount+99854,"9,999,999")# products and counting...</h3>
  <cfif isUserInRole("egroup_member")>
  <a class="glow createBVAccount" href="/bv/admin/eGroupUserCreation/id/#rc.sess.eGroup.contactID#">Create your free Building Vine&trade; account &raquo;</a>
  </cfif>
  </cfoutput>
</div>

<div id="siteList">
  <h4>Supported by these suppliers and manufacturers...</h4>
  <cfset suppliers = getModel(name="SiteService",module="bv").listSuppliers()>
  <cfoutput query="suppliers">
  <a href="https://www.buildingvine.com/products?siteID=#shortName#" target="_blank"><img src="https://www.buildingvine.com/includes/images/companies/#lcase(shortName)#/small.jpg" class="tooltip glow" width="46" height="46" title="#title#"></a>
  </cfoutput>
</div>
