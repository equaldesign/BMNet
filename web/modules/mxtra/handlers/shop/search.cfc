<cfcomponent output="false"  cache="true">
  <cfproperty name="category" inject="id:mxtra.category" scope="instance" />
  <cfproperty name="product" inject="id:eunify.ProductService" scope="instance" />
<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->

<cffunction name="index" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.categoryID = event.getValue('categoryID',0)>
  <cfset rc.procuctID = event.getValue('procuctID',0)>
  <cfset rc.pageID = 0>
  <cfset rc.sPage = event.getValue('sPage',1)>
 <cfset rc.product = instance.product>
  <cfset rc.orderBy = event.getValue('orderBy',rc.sess.mxtra.prefs.orderBy)>
  <cfif rc.orderBy neq rc.sess.mxtra.prefs.orderBy>
   <cfset rc.sess.mxtra.prefs.orderBy = rc.orderBy>
  </cfif>
  <cfset rc.orderDir = event.getValue('orderDir',rc.sess.mxtra.prefs.orderDir)>
  <cfif rc.orderDir neq rc.sess.mxtra.prefs.orderDir>
   <cfset rc.sess.mxtra.prefs.orderDir = rc.orderDir>
  </cfif>
  <cfset rc.fPage = event.getValue('fPage',1)>
  <cfset rc.tree = event.getValue('tree','')>
  <cfset rc.query = event.getValue('query','')>
  <cfscript>
	  if (rc.sPage neq 1) {
	    rc.sRow = (rc.sPage-1)*10;
	  } else {
	    rc.sRow = 1;
	  }
  </cfscript>
  <cfif rc.categoryID neq 0>
    <cfquery name="results" datasource="mxtra_#rc.sess.siteID#">
      select
        Product_Code,
        Full_Description,
        Full_Description as name,
        MATCH (
          Full_Description,
          Description2,
          Status,
          Manufacturers_Product_Code,
          Key_Word_Search,
          Web_Description,
          Bullet_1,
	        Bullet_2,
	        Bullet_3,
	        Bullet_4,
	        Bullet_5,
	        Bullet_6,
	        Bullet_7,
	        Bullet_8,
	        Bullet_9,
	        Bullet_10
	      ) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">) as score,
        Weight,
        List_Price,
        List_Price as price,
        Retail_Price,
        Product_Code,
        Unit_of_Price,
        Trade,
        Discount_Code,
        StatusCode,
        Status,
        categoryID,
        Description2,
        Purchase_Text,
        Manufacturers_Product_Code,
        Key_Word_Search,
        Web_Description,
        Bullet_1,
        Bullet_2,
        Bullet_3,
        Bullet_4,
        Bullet_5,
        Bullet_6,
        Bullet_7,
        Bullet_8,
        Bullet_9,
        Bullet_10
        from
          Products
        where
          MATCH (
            Full_Description,
	          Description2,
	          Status,
	          Manufacturers_Product_Code,
	          Key_Word_Search,
	          Web_Description,
	          Bullet_1,
	          Bullet_2,
	          Bullet_3,
	          Bullet_4,
	          Bullet_5,
	          Bullet_6,
	          Bullet_7,
	          Bullet_8,
	          Bullet_9,
	          Bullet_10
          ) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">)
        AND
          left (categoryID,#len(rc.categoryID)#) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.categoryID#">
        order by #rc.orderBy# #rc.orderDir#
    </cfquery>
	<cfelse>
	  <cfquery name="results" datasource="mxtra_#rc.sess.siteID#">
      select
        Product_Code,
        Full_Description,
        Full_Description as name,
        MATCH (
          Full_Description,
          Description2,
          Status,
          Manufacturers_Product_Code,
          Key_Word_Search,
          Web_Description,
          Bullet_1,
          Bullet_2,
          Bullet_3,
          Bullet_4,
          Bullet_5,
          Bullet_6,
          Bullet_7,
          Bullet_8,
          Bullet_9,
          Bullet_10
        ) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">) as score,
        Weight,
        List_Price,
        List_Price as price,
        Retail_Price,
        Product_Code,
        Unit_of_Price,
        Trade,
        Discount_Code,
        StatusCode,
        Status,
        categoryID,
        Description2,
        Purchase_Text,
        Manufacturers_Product_Code,
        Key_Word_Search,
        Web_Description,
        Bullet_1,
        Bullet_2,
        Bullet_3,
        Bullet_4,
        Bullet_5,
        Bullet_6,
        Bullet_7,
        Bullet_8,
        Bullet_9,
        Bullet_10
        from
          Products
        where
          MATCH (
	          Full_Description,
	          Description2,
	          Status,
	          Manufacturers_Product_Code,
	          Key_Word_Search,
	          Web_Description,
	          Bullet_1,
	          Bullet_2,
	          Bullet_3,
	          Bullet_4,
	          Bullet_5,
	          Bullet_6,
	          Bullet_7,
	          Bullet_8,
	          Bullet_9,
	          Bullet_10
          ) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">)
        AND
          Retail_Price > <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        order by #rc.orderBy# #rc.orderDir#
    </cfquery>
	</cfif>
  <cfscript>
    rc.results = results;
    rc.productCount = rc.results.recordCount;
    rc.pages = ceiling(rc.productCount/10);
    rc.currentPage = rc.sPage;
  </cfscript>
  <cfset event.setLayout('sites/#rc.sess.siteID#/Layout.#rc.sess.pageFormat#')>
  <cfset event.setView("/shop/searchResults")>
</cffunction>


<cffunction name="jsonsearch" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.query = event.getValue('term','')>
  <cfset rc.orderBy = event.getValue('orderBy',"Full_Description")>  
    <cfquery name="results" datasource="BMNet">
      select
        Product_Code, 
        Full_Description,
        Full_Description as name,
        MATCH (Full_Description,Manufacturers_Product_Code,EANCode,Product_Code) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">) as score,
        Weight,
        List_Price,
        List_Price as price,
        Retail_Price, 
        Product_Code,
        Unit_of_Price,
        Trade,
        Discount_Code,
        StatusCode,
        Status,
        categoryID,
        Description2,
        Purchase_Text,
        Manufacturers_Product_Code,
        Key_Word_Search,
        Web_Description,
        Bullet_1,
        Bullet_2,
        Bullet_3,
        Bullet_4,
        Bullet_5,
        Bullet_6,
        Bullet_7,
        Bullet_8,
        Bullet_9,
        Bullet_10
        from 
          Products
        where
          MATCH (Full_Description,Manufacturers_Product_Code,EANCode,Product_Code) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.query#">)
        AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
		    AND
          Retail_Price > <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        order by score desc
    </cfquery>
  <cfset rc.json = ArrayNew(1)>
  <cfloop query="results">
    <cfset resultJ = StructNew()>
    <cfset resultJ["id"] = "#Product_Code#">
    <cfset resultJ["label"] = "#name#">
    <cfset ArrayAppend(rc.json,resultJ)>
  </cfloop>
  <cfset rc.json = Serializejson(rc.json)>
  <cfset event.setLayout('Layout.ajax')>
  <cfset event.setView("renderJSON")>
</cffunction>

	</cfcomponent>