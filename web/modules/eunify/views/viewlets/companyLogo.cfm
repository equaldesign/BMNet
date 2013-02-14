<cfset company = getModel("modules.eunify.model.CompanyService").getCompany(args.companyID,request.siteID)>
<cfoutput>
<cfset imageSrc = "">
<cfset buildingVine = false>

<cfif args.width lte 50 AND args.width neq 0>
    <!--- no logo exists --->
    <cfif isBoolean(company.buildingVine) AND company.buildingVine>
      <cfset buildingVine = true>
      <!--- they have a building Vine account - so lets try and use their logo --->
      <cfhttp url="http://www.buildingvine.com/includes/images/companies/#company.bvsiteID#/small.jpg" result="bvImage"></cfhttp>
      <cfif bvImage.StatusCode neq 404>
        <cfset imageSrc = "https://www.buildingvine.com/includes/images/companies/#company.bvsiteID#/small.jpg">

      <cfelse>
       <cfset imageSrc = "/includes/images/website/unknown.jpg" />
      </cfif>
    <cfelse>
      <cfset imageSrc = "/includes/images/website/unknown.jpg" />
    </cfif>
<cfelse>
  <!--- they want the big image --->
    <cfif company.buildingVine>
      <!--- they have a building Vine account - so lets try and use their logo --->
      <cfhttp url="http://www.buildingvine.com/includes/images/companies/#company.bvsiteID#.png" result="bvImage"></cfhttp>
      <cfif bvImage.StatusCode neq 404>
        <cfset imageSrc = "https://www.buildingvine.com/includes/images/companies/#company.bvsiteID#.png" />
      <cfelse>
        <cfset imageSrc = "/includes/images/default.png" />
      </cfif>
    <cfelse>
      <cfset imageSrc = "/includes/images/default.png" />
    </cfif>
</cfif>
<cfif args.imageURL neq "">
  <cfif buildingVine>
    <cfset imageSrc="#args.imageURL#?size=#args.width#&d=#imageSrc#">
  <cfelse>
    <cfset imageSrc="#args.imageURL#?size=#args.width#&d=http://#cgi.HTTP_HOST##imageSrc#">
  </cfif>
</cfif>
<img <cfif args.width neq 0>width="#args.width#"</cfif> <cfif isDefined("args.align")>align="#args.align#"</cfif> <cfif isDefined("args.border")>border="#args.border#"<cfelse>border="0"</cfif> class="#args.class#" src="#imageSrc#" alt="#company.name#" />
</cfoutput>