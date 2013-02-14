<cfset siteTypes = {}>
<cfset siteTypes["Manufacturer"] = 0>
<cfset siteTypes["Distributor"] = 0>
<cfset siteTypes["Merchant"] = 0>
<cfset siteTypes["Group"] = 0>
<cfset siteTypes["Other"] = 0>
<cfset siteTypes["IT"] = 0>
<cftry>
  <cfloop array="#rc.sites#" index="site">
    <cfswitch expression="#paramValue("site.customProperties.companyType.value","")#">
      <cfcase value="Manufacturer,Merchant,Distributor,Group,IT,Other">
        <cfset siteTypes["#site.customProperties.companyType.value#"]++>
      </cfcase>
    </cfswitch>    
  </cfloop>  
  <cfcatch type="any">
    <cfdump var="#rc.sites#"><cfabort>
  </cfcatch>
</cftry>

<cfoutput>
  <ul class="nav nav-list" id="mainLinks">
    <li class="nav-header">Company Types</li>  
    <cfloop collection="#siteTypes#" item="t">
      <cfswitch expression="#t#">
        <cfcase value="Merchant">
          <cfset icon = "store">
          <cfset c = "warning">
        </cfcase>
        <cfcase value="Manufacturer">
          <cfset icon = "truck">
          <cfset c = "important">
        </cfcase>
        <cfcase value="Distributor">
          <cfset icon = "truck-empty">
          <cfset c = "info">
        </cfcase>
        <cfcase value="Group">
          <cfset icon = "users">
          <cfset c = "inverse">
        </cfcase>
        <cfcase value="IT">
          <cfset icon = "computer">
          <cfset c = "success">
        </cfcase>
        <cfcase value="Other">
          <cfset icon = "question">
          <cfset c = "">
        </cfcase>
      </cfswitch>
      <li><a rel="siteList" class="shortcut createblog" href="/bv/site/list?type=#t#"><i class="icon-#icon#"></i> #t# <span class="badge badge-#c# pull-right">#siteTypes['#t#']#</span></a></li>  
    </cfloop>
    <!--- TODO! 
    <li class="nav-header">Filter Types</li>  
    <li><a rel="siteList" class="shortcut" href="/bv/site/list?type=#rc.type#&ut=Products"><i class="icon-drill"></i> Recently Updated Products</a></li>  
    <li><a rel="siteList" class="shortcut" href="/bv/site/list?type=#rc.type#&ut=Blog"><i class="icon-newspaper"></i> Recently Updated News Items</a></li>  
    <li><a rel="siteList" class="shortcut" href="/bv/site/list?type=#rc.type#&ut=Promotions"><i class="icon-store"></i> Recently Updated Promotions</a></li>  
    --->
  </ul>
</cfoutput>
