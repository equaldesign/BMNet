<cfcomponent name="import">
  <cfproperty name="Import" inject="bmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.ImportRoutines">
  <cffunction name="index" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfdirectory action="list" type="file" directory="/fs/sites/ebiz/buildersMerchant.net/data/#request.siteID#" name="files">
    <cfloop query="files">
      <cfswitch expression="#name#">
        <cfcase value="CF_EBIZCUST.csv">
          <!--- Customer Import --->
          <cfset Import.Customers("#directory#/#name#",dateLastModified)>
        </cfcase>
        <cfcase value="CF_DTF-SUP.csv">
          <!--- Supplier Import --->
          <cfset Import.Suppliers("#directory#/#name#",dateLastModified)>
        </cfcase>
        <cfcase value="CF_EBIZCODE.csv">
          <!--- Bar Code Import --->
          <cfset Import.BarCodes("#directory#/#name#")>
        </cfcase>
        <cfcase value="CF_EBIZWPRO.csv">
          <!--- Product Import --->
          <cfset Import.Products("#directory#/#name#",dateLastModified)>
        </cfcase>
        <cfcase value="SL_MSPAYDAT.csv">
          <!--- Invoice Payments Import --->
          <!--- <cfset Import.InvoicePayments("#directory#/#name#",dateLastModified)> --->
        </cfcase>
        <cfcase value="SO_EBIZSALE.csv">
          <!--- Sales Orders --->
          <cfset Import.SalesOrders("#directory#/#name#")>
        </cfcase>

      </cfswitch>
    </cfloop>
    <cfset event.noRender()>
  </cffunction>
</cfcomponent>