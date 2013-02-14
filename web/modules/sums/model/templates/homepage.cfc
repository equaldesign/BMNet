<cfcomponent displayname="Home page Template" hint="A template for the homepage">
 <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getPopularProducts" returntype="any">   
    <cfhttp result="products" port="8080" url="http://46.51.188.170/easyrec-web/api/1.0/json/mostboughtitems?apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_3&numberOfResults=25&timeRange=MONTH&requesteditemtype=ITEM"></cfhttp>    
    <cfreturn DeSerializeJSON(products.fileContent)>
  </cffunction>
</cfcomponent>