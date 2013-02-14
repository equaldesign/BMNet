<cfcomponent displayname="Home page Template" hint="A template for the homepage">
 <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
 <cfproperty name="ProductService" inject="id:eunify.ProductService" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getFeatures" returntype="any">
    <cfreturn ProductService.getProducts(featured=true)>
  </cffunction>
</cfcomponent>