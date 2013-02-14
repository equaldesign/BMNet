<cfcomponent name="import">
  <cfproperty name="Import" inject="model:bmnet.custom.krmbuildersmerchantnet.model.importRoutines">
  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfdirectory action="list" type="file" directory="/fs/sites/ebiz/buildersMerchant.net/data/#request.siteID#" sort="desc" name="files">
    <cfloop query="files">
      <cfswitch expression="#name#">
        <cfcase value="Customers.txt">
          <cfset Import.Customers("#directory#/#name#",dateLastModified)>
        </cfcase>
      </cfswitch>
    </cfloop> 
    <cfset event.noRender()>
  </cffunction>
 
</cfcomponent>