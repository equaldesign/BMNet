<cfcomponent accessors="true" output="true" hint="The bvine module service layer" cache="false">
  <cfproperty name="file">
  <cfproperty name="name">
  <cfproperty name="authority">
  <cfproperty name="searchOn">  
  <cfproperty name="priceeffectivefromdate">
  <cfproperty name="priceeffectivetodate">
  <cfproperty name="discountgroup">
  <cfproperty name="rebategroup">
  <cfproperty name="supplierslistprice">
  <cfproperty name="merchantinvoiceprice">
  <cfproperty name="priceunitofmeasuredescription">
  <cfproperty name="priceunitofmeasurequantity">
  <cfproperty name="packquantity">
  <cfproperty name="vatcode"> 

	<!--- Dependencies --->

  <cfproperty name="userService" inject="model:UserService"  scope="instance" />

  <!---<cfproperty name="simpleDB" inject="model:aws.db"  scope="instance" /> --->
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="logger" inject="logbox:root">
  <cffunction name="importPrices" returntype="any">
    <cfargument name="ticket">
    <cfargument name="email">
    <cfquery name="d" datasource="bvine">
      delete from fieldDefinitions where site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#"> and object = <cfqueryparam cfsqltype="cf_sql_varchar" value="price">
    </cfquery>
    <cfif getsearchOn() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="searchOn">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getsearchOn()#">
        )
    </cfquery>
	  </cfif>  
    <cfif getpriceeffectivefromdate() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="priceeffectivefromdate">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpriceeffectivefromdate()#">
        )
    </cfquery>
    </cfif>
    <cfif getpriceeffectivetodate() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="priceeffectivetodate">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpriceeffectivetodate()#">
        )
    </cfquery>
    </cfif>
    <cfif getdiscountgroup() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="discountgroup">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdiscountgroup()#">
        )
    </cfquery>
    </cfif>
    <cfif getrebategroup() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="rebategroup">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getrebategroup()#">
        )
    </cfquery>
    </cfif>
    <cfif getsupplierslistprice() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="supplierslistprice">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getsupplierslistprice()#">
        )
    </cfquery>
    </cfif>
    <cfif getmerchantinvoiceprice() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="merchantinvoiceprice">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getmerchantinvoiceprice()#">
        )
    </cfquery>
    </cfif>
    <cfif getpriceunitofmeasuredescription() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="priceunitofmeasuredescription">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpriceunitofmeasuredescription()#">
        )
    </cfquery>
    </cfif>
    <cfif getpriceunitofmeasurequantity() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="priceunitofmeasurequantity">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpriceunitofmeasurequantity()#">
        )
    </cfquery>
    </cfif>
    <cfif getpackquantity() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="packquantity">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpackquantity()#">
        )
    </cfquery>
    </cfif>
    <cfif getvatcode() neq "">
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="price">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="vatcode">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.bvsiteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#getvatcode()#">
        )
    </cfquery>
    </cfif>
      <cfspreadsheet action="read" src="#getfile()#" headerrow="1" query="priceSpreadsheet" sheet="1" />
      <cfset priceFile = {}>
	    <cfset priceFile["security_groups"] = ListToArray(getauthority())>
      <cfset priceFile["prices"] = []>
      <cfloop query="priceSpreadsheet" startrow="2"> 
        <cfset price = {}>
        <cfset price["searchOn"] = priceSpreadsheet["#getsearchOn()#"][currentRow]>		    
			  <cfset price["title"] = getname()>
        <cfif getpriceeffectivefromdate() neq "">
          <cfset price["priceeffectivefromdate"] = priceSpreadsheet["#getpriceeffectivefromdate()#"][currentRow]>
        </cfif>
        <cfif getpriceeffectivetodate() neq "">
          <cfset price["priceeffectivetodate"] = priceSpreadsheet["#getpriceeffectivetodate()#"][currentRow]>
        </cfif>
        <cfif getdiscountgroup() neq "">
          <cfset price["discountgroup"] = priceSpreadsheet["#getdiscountgroup()#"][currentRow]>
        </cfif>
        <cfif getrebategroup() neq "">
          <cfset price["rebategroup"] = priceSpreadsheet["#getrebategroup()#"][currentRow]>
        </cfif>
        <cfif getsupplierslistprice() neq "">
          <cfset price["supplierslistprice"] = priceSpreadsheet["#getsupplierslistprice()#"][currentRow]>
        </cfif>
        <cfif getmerchantinvoiceprice() neq "">
          <cfset price["merchantinvoiceprice"] = priceSpreadsheet["#getmerchantinvoiceprice()#"][currentRow]>
        </cfif>
        <cfif getpriceunitofmeasuredescription() neq "">
          <cfset price["priceunitofmeasuredescription"] = priceSpreadsheet["#getpriceunitofmeasuredescription()#"][currentRow]>
        </cfif>
        <cfif getpriceunitofmeasurequantity() neq "">
          <cfset price["priceunitofmeasurequantity"] = priceSpreadsheet["#getpriceunitofmeasurequantity()#"][currentRow]>
        </cfif>
        <cfif getpackquantity() neq "">
          <cfset price["packquantity"] = priceSpreadsheet["#getpackquantity()#"][currentRow]>
        </cfif>
        <cfif getvatcode() neq "">
          <cfset price["vatcode"] = priceSpreadsheet["#getvatcode()#"]>
        </cfif>
        <cfset ArrayAppend(priceFile["prices"],price)>
      </cfloop>
      <cfhttp port="8080" timeout="90000" throwonerror="true" result="priceResults" method="post" url="http://46.51.188.170/alfresco/service/bv/price?siteID=#request.bvsiteID#&title=#getname()#&alf_ticket=#ticket#">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(priceFile)#">
      </cfhttp>
      <!--- then read in the second sheet - which are deletions --->
     
    <cfreturn priceResults>
  </cffunction>

  <cffunction name="importProducts" returntype="Any">
    <cfargument name="ticket">
    <cfargument name="siteID" required="true">
    <cfargument name="siteType" required="true">
    <cfargument name="localURL" required="true" default="">
    <cfargument name="targetSiteID" required="true" default="">
    <cfargument name="associateImages" required="true" default="false">
    <cfargument name="emailMe" required="true" default="false">
    <cfargument name="emailAddress" required="true" default="">
    <cfset var containsPrices = false>
    <cfset var containsProducts = true>
    <cfset var productFile = "">
    <cfset var productSS = "">
    <cfif targetSiteID eq "">
      <cfset targetSiteID = siteID>
    </cfif>
    <cfsetting requesttimeout="9000">
    <cfset productArray = []>
    <cfspreadsheet action="read" src="#localURL#" headerrow="1" query="productSpreadsheet" sheet="1" />
    <cfloop query="productSpreadsheet" startrow="2">
      <!--- we need to set a fileName --->
      <cfset product = {}>
      <cfset product["supplierproductcode"] = "">
      <cfset product["fileName"] = "">
      <cfset product["eancode"] = "">
      <cfset product["manufacturerproductcode"] = "">
      <cfset product["productcode"] = "">
      <cfset product["categoryID"] = "">
      <cfset product["category"] = "">
      <cfset product["productName"] = "">
      <cfif ListFindNoCase(productSpreadsheet.ColumnList,"productcode") AND productSpreadsheet.productcode neq "">
        <cfset product["productcode"] = productSpreadsheet.productcode>
      </cfif>
      <cfif ListFindNoCase(productSpreadsheet.ColumnList,"EAN Code") AND productSpreadsheet["EAN Code"][currentRow] neq "" AND productSpreadsheet["EAN Code"][currentRow] neq " ">
        <cfset product["fileName"] = productSpreadsheet["EAN Code"][currentRow]>
        <cfset product["eancode"] = productSpreadsheet["EAN Code"][currentRow]>
      <cfelseif ListFindNoCase(productSpreadsheet.ColumnList,"productcode") AND productSpreadsheet["productcode"][currentRow] neq "" AND productSpreadsheet["productcode"][currentRow] neq " ">
        <cfset product["fileName"] = productSpreadsheet["productcode"][currentRow]>
      <cfelseif ListFindNoCase(productSpreadsheet.ColumnList,"Manufacturer Product Code") AND  productSpreadsheet["Manufacturer Product Code"][currentRow] neq "">
        <cfset product["fileName"] = productSpreadsheet["Manufacturer Product Code"][currentRow]>
      <cfelseif ListFindNoCase(productSpreadsheet.ColumnList,"Supplier Product Code") AND productSpreadsheet["Supplier Product Code"][currentRow] neq "">
        <cfset product["fileName"] = productSpreadsheet["Supplier Product Code"][currentRow]>
      <cfelse>
        <cfset product["fileName"] = productSpreadsheet["Product Description 1"][currentRow]>
      </cfif>
      <cfif product.fileName neq "">
        <cfif ListFindNoCase(productSpreadsheet.ColumnList,"Manufacturer Product Code") AND  productSpreadsheet["Manufacturer Product Code"][currentRow] neq "">
          <cfset product["manufacturerproductcode"] = productSpreadsheet["Manufacturer Product Code"][currentRow]>
        </cfif>
        <cfif ListFindNoCase(productSpreadsheet.ColumnList,"Supplier Product Code") AND productSpreadsheet["Supplier Product Code"][currentRow] neq "">
          <cfset product["supplierproductcode"] = productSpreadsheet["Supplier Product Code"][currentRow]>
        </cfif>
        <cfif ListFindNoCase(productSpreadsheet.ColumnList,"categoryID") AND productSpreadsheet["categoryID"][currentRow] neq "">
          <cfset product["categoryID"] = productSpreadsheet["categoryID"][currentRow]>
        </cfif>
        <cfif ListFindNoCase(productSpreadsheet.ColumnList,"category") AND productSpreadsheet["category"][currentRow] neq "">
          <cfset product["category"] = trim(productSpreadsheet["category"][currentRow])>
        </cfif>
        <cfif ListFindNoCase(productSpreadsheet.ColumnList,"Product Description 1") AND  productSpreadsheet["Product Description 1"][currentRow] neq ""><cfset product["productName"] = "#productSpreadsheet['Product Description 1'][currentRow]#"> </cfif>
        <cfset product["customData"] = StructNew()>
        <cfset product["productData"] = StructNew()>
        <cfloop list="#productSpreadsheet.columnList#" index="col">
  	      <cfset colName = LCase(Replace(col," ","","ALL"))>
  	      <!--- add a new tag pair --->
  	      <cfswitch expression="#colName#">
            <cfcase value="eancode,productdescription1,productcode,manufacturerproductcode,supplierproductcode,nmbsproductgroup,weightperunitofmeasure,productdescription2,productdescription3,rrp,unitweight,manufacturerbandname,packagingpaper,nmbssuppliercode,packagingwood,packagingglass,packagingsteel,packagingplastic,manufacturerbrandname,packagingaluminium,imageurl,thumbnailurl,coshhurl,specificationurl">
              <!--- don't add this shit --->
              <cfset product["productData"]["#colName#"] = "#productSpreadsheet['#col#'][currentRow]#">
            </cfcase>
            <cfcase value="priceeffectivefromdate,discountgroup,rebategroup,category,categoryid">
              <!--- do nothing with these --->
            </cfcase>
            <cfdefaultcase>
                <!--- to the meta data description --->
                <cfset product["customData"]["#colName#"] = "#productSpreadsheet['#col#'][currentRow]#">
            </cfdefaultcase>
          </cfswitch>
        </cfloop>
        <cfset product["productName"] = trim(product.productName)>
        <cfset product["fileName"] = "#friendlyUrl(product.fileName)#.json">
        <cfset arrayAppend(productArray,product)>
      </cfif>
    </cfloop>
    <cfset jsonObject = {}>
    <cfset jsonObject["products"] = productArray>
    <!--- now serialize the json object and send it to alfresco --->
    <cfset js = SerializeJSON(jsonObject)>
    <cffile action="write" file="/tmp/test" output="#js#">

    <cfhttp port="8080" result="importImages" method="post" url="http://46.51.188.170/alfresco/service/bv/product?siteID=#siteID#&associateImages=#associateImages#&alf_ticket=#ticket#">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#js#">
    </cfhttp>
    <cfif emailMe>

        <cfmail server="46.51.188.170" from="no-reply@buildingvine.com" subject="Your product import" to="#emailAddress#">
        <cfif importImages.statusCode eq "200 OK">
          Your import was completed successfully
        <cfelse>
          There was a problem with your import.
        </cfif>
        </cfmail>

    </cfif>
    <!--- then read in the second sheet - which are deletions --->
    <cfreturn local>
  </cffunction>



	<cfscript>
	  function populate_fields(str,productStruct){
    l = Len(str);
    i = 1;
    output = '';

    while (i LT l){

        f = REFindNoCase("\{([a-z,0-9,_])+\}",str,i,"TRUE");
        if (f.pos[1] IS 0){
            output = output & Mid(str,i,l-i+1);
            i = l;
        } else {
            output = output & Mid(str,i,f.pos[1]-i);
            name = Mid(str,f.pos[1]+1,f.len[1] - 2);
            output = output & productStruct["#name#"];
            i = f.pos[1] + f.len[1];
        }

    }

    return output;

}
function friendlyUrl(title) {
    title = trim(title);
    title = replaceNoCase(title,"&amp;","and","all"); //replace &amp;
    title = replaceNoCase(title,"&","and","all"); //replace &
    title = replaceNoCase(title,"'","","all"); //remove apostrophe
    title = reReplaceNoCase(trim(title),"[^a-zA-Z0-9]","","ALL");
    return lcase(title);
}
</cfscript>
</cfcomponent>