<cfcomponent>
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="BranchService" inject="id:eunify.BranchService">
  <cfproperty name="RecommendationService" inject="id:eunify.RecommendationService">

  <cffunction name="init">
    <cfset variables.canLog = true>
  </cffunction>

  <cffunction name="SalesOrders" returntype="boolean">
    <cfargument name="fileName">
    <cfset doCheckTable("Invoice")>
    <cfsetting requesttimeout="600">
    <!--- we will put these in a temp table, just to work out the headers --->
    <cfquery name="t" datasource="#dsn.getName()#">
    DROP TABLE IF EXISTS `Invoice_tmp`;
    </cfquery>
    <cfquery name="t" datasource="#dsn.getName()#">
    CREATE TABLE IF NOT EXISTS `Invoice_tmp` (
      `id` int(50) NOT NULL,
      `invoice_number` varchar(50) NOT NULL DEFAULT '0',
      `branch_id` varchar(20) NOT NULL DEFAULT '0',
      `account_number` varchar(50) NOT NULL DEFAULT '0',
      `account_name` varchar(100) NOT NULL DEFAULT '0',
      `order_number` varchar(50) NOT NULL DEFAULT '0',
      `invoice_date` date NOT NULL,
      `order_category` varchar(50) NOT NULL DEFAULT '0',
      `product_code` varchar(50) NOT NULL DEFAULT '0',
      `full_description` varchar(255) NOT NULL DEFAULT '0',
      `description` varchar(50) NOT NULL DEFAULT '0',
      `quantity` decimal(10,2) NOT NULL DEFAULT '0.00',
      `invoice_total` decimal(10,2) NOT NULL DEFAULT '0.00',
      `goods_total` decimal(10,2) NOT NULL DEFAULT '0.00',
      `line_total` decimal(10,2) NOT NULL DEFAULT '0.00',
      `vat_total` decimal(10,2) NOT NULL DEFAULT '0.00',
      `delivery_name` varchar(255) NOT NULL DEFAULT '0',
      `delivery_address_1` varchar(255) NOT NULL DEFAULT '0',
      `delivery_address_2` varchar(255) NOT NULL DEFAULT '0',
      `delivery_address_3` varchar(255) NOT NULL DEFAULT '0',
      `delivery_address_4` varchar(255) NOT NULL DEFAULT '0',
      `delivery_address_5` varchar(255) NOT NULL DEFAULT '0',
      `delivery_postcode` varchar(15) NOT NULL DEFAULT '0',
      `customer_order_number` varchar(255) NOT NULL DEFAULT '0',
      `categoryID` varchar(255) NOT NULL DEFAULT '0',
      `salesman` varchar(20) NOT NULL DEFAULT '0',
      `siteID` int(20) NOT NULL DEFAULT '0',
      `discounts` varchar(50) DEFAULT '0'
    )
    </cfquery>
    <cfquery name="tmp" datasource="#dsn.getName()#" result="imp">
      LOAD DATA INFILE '#arguments.fileName#'
        INTO TABLE Invoice_tmp
          FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
          LINES TERMINATED BY '\n'
            IGNORE 1 LINES
        (
          branch_id,
          account_number,
          account_name,
          order_number,
          invoice_number,
          @invoice_date,
          order_category,
          description,
          quantity,
          product_code,
          full_description,
          goods_total,
          line_total,
          vat_total,
          delivery_name,
          delivery_address_1,
          delivery_address_2,
          delivery_address_3,
          delivery_address_4,
          delivery_address_5,
          delivery_postcode,
          customer_order_number,
          categoryID,
          salesman,
          discounts
        )
        set
        invoice_date = str_to_date(@invoice_date, '%d/%m/%Y')
    </cfquery>
    <cfset d("Imported #imp.recordcount# records into tmp table")>
    <!--- set the siteID --->
    <cfquery name="uy" datasource="#dsn.getName()#">
      update Invoice_tmp set siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <!--- inject the lines straight away --->
    <cfquery name="d" datasource="#dsn.getName()#" result="invh">
      insert into Invoice_Header
        (invoice_num,quantity,product_code,full_description,goods_total,line_total,line_vat,categoryID,siteID)
        select
          invoice_number,
          quantity,
          product_code,
          full_description,
          goods_total,
          line_total,
          vat_total,
          categoryID,
          siteID
        FROM
          Invoice_tmp
    </cfquery>
    <cfset d("Imported #invh.recordcount# lines")>
    <!--- now insert the header --->
    <cfquery name="d" datasource="#dsn.getName()#" result="invhead">
      insert into Invoice
        (branch_id,
          account_number,
          account_name,
          order_number,
          invoice_number,
          invoice_date,
          order_category,
          description,
          quantity,
          invoice_total,
          line_total,
          vat_total,
          delivery_name,
          delivery_address_1,
          delivery_address_2,
          delivery_address_3,
          delivery_address_4,
          delivery_address_5,
          delivery_postcode,
          customer_order_number,
          salesman,
          discounts,
          siteID)
        SELECT
          branch_id,
          account_number,
          account_name,
          order_number,
          invoice_number,
          invoice_date,
          order_category,
          description,
          SUM(quantity),
          SUM(goods_total),
          SUM(line_total),
          SUM(vat_total),
          delivery_name,
          delivery_address_1,
          delivery_address_2,
          delivery_address_3,
          delivery_address_4,
          delivery_address_5,
          delivery_postcode,
          customer_order_number,
          salesman,
          discounts,
          siteID
        FROM
          Invoice_tmp
        GROUP BY invoice_number
    </cfquery>
    <cfset d("Imported #invhead.recordcount# Header records")>
    <cfquery name="headerTotals" datasource="#dsn.getName()#" result="del">
      SELECT
          branch_id,
          account_number,
          account_name,
          order_number,
          invoice_number,
          invoice_date,
          order_category,
          description,
          SUM(quantity),
          product_code,
          full_description,
          SUM(invoice_total),
          SUM(goods_total),
          SUM(line_total),
          SUM(vat_total),
          delivery_name,
          delivery_address_1,
          delivery_address_2,
          delivery_address_3,
          delivery_address_4,
          delivery_address_5,
          delivery_postcode,
          customer_order_number,
          categoryID,
          salesman,
          discounts
        FROM
          Invoice_tmp
        WHERE
          order_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="D">
        GROUP BY invoice_number
    </cfquery>
    <cfset d("#del.recordcount# records for delivery information")>
    <cfloop query="headerTotals">
      <cfset branch = BranchService.getBranchByRef(branch_id)>
      <cfset deliveryInfo = BranchService.getGenericCoOrdinates("#delivery_postcode#, UK")>
      <cfif deliveryInfo[1] neq 0>
        <cfset directions = BranchService.getDirections("#branch.maplat#,#branch.maplong#","#deliveryInfo[1]#,#deliveryInfo[2]#")>

        <cfquery name="up" datasource="#dsn.getName()#">
          update
            Invoice
          set
          <cfif isDefined("directions.routes[1].legs[1].distance.value")>
              delivery_distance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#directions.routes[1].legs[1].distance.value#">,
          </cfif>
            delivery_latitude = <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryInfo[1]#">,
            delivery_longitude = <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryInfo[2]#">
          WHERE
            invoice_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_number#">
            AND
            invoice_date = <cfqueryparam cfsqltype="cf_sql_date" value="#invoice_date#">
            AND
            siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        </cfquery>
      </cfif>
    </cfloop>
    <cfquery name="inv_lines" datasource="#dsn.getName()#">
      select * from Invoice_tmp
    </cfquery>
    <cfloop query="inv_lines">
      <cfset d("Doing recommendations")>
      <!--- insert "sales" into easy_rec --->
      <cfset RecommendationService.sendBuyAction(
        invoice_number="#invoice_number#",
        product_code="#Product_Code#",
        full_description="#full_description#",
        itemurl="http://#cgi.http_host#/mxtra/product/detail?productID=#product_code#",
        account_number="#account_number#"

      )>
    </cfloop>

    <!--- now update remote database timestamp --->
    <cfquery name="u" datasource="BMNet">
      update
        table_updates
      set
        last_updated = now()
      where
        tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="Invoice">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <!--- delete the tmp table --->
    <cfquery name="d" datasource="#dsn.getName()#">
      DROP TABLE Invoice_tmp;
    </cfquery>

  </cffunction>

  <cffunction name="BarCodes" returntype="void">
    <cfargument name="fileName">
    <!--- create tmp table --->
    <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        DROP TABLE IF EXISTS `barcodes`
      </cfquery>
    <cfquery name="ct" datasource="#dsn.getName()#">
      CREATE TABLE `barcodes` (
        `product_code` VARCHAR(50) NULL,
        `barcode` VARCHAR(50) NULL
      )
    </cfquery>
    <cfquery name="tmp" datasource="#dsn.getName()#" result="imp">
      LOAD DATA INFILE '#arguments.fileName#'
        INTO TABLE barcodes
          FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
          LINES TERMINATED BY '\n'
            IGNORE 1 LINES
        (barcode,product_code)
    </cfquery>
    <cfset d("Imported #imp.recordcount# records into temp table for Bar codes")>
    <cfquery name="updateProducts" datasource="#dsn.getName()#" result="bc">
      update
        Products, barcodes
      set
        Products.EANCode = barcodes.barcode
      WHERE
        Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
        Products.Product_Code = barcodes.product_code
    </cfquery>
    <cfset d("#bc.recordcount# Products updated with bar codes")>
    <!--- delete the temp table --->
    <cfquery name="dc" datasource="#dsn.getName()#">
      DROP TABLE barcodes;
    </cfquery>
  </cffunction>

  <cffunction name="Products" returntype="boolean">
    <cfargument name="fileName">
    <cfargument name="dateLastModified">
    <cfsetting requesttimeout="600">
    <!--- first check if we need to run the update --->
    <cfset doCheckTable("Products")>
    <cfif doRunUpdate("Products","#arguments.fileName#")>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        DROP TABLE IF EXISTS `products_temp`
      </cfquery>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        CREATE TABLE products_temp LIKE Products;
      </cfquery>
      <!--- add a new column to the temporary table --->
      <cfquery name="ttc" datasource="#dsn.getName()#">
        ALTER TABLE products_temp
        ADD COLUMN `external_id` INT NOT NULL DEFAULT '0';
      </cfquery>
      <!--- grab the column list --->
      <cfquery name="existingColumnNames" datasource="#dsn.getName()#">
        select * from Products limit 0,1;
      </cfquery>
      <!--- lame - gay to recreate the array? --->
      <cfset thisColumnList = []>
      <cfset qColumnList = existingColumnNames.getColumns()>
      <cfloop array="#qColumnList#" index="c">
        <cfset Arrayappend(thisColumnList,c)>
      </cfloop>
      <cfset ArrayDeleteAt(thisColumnList,1)>

      <cfset compareList = "Full_Description,List_Price,Unit_of_Sale,Retail_Price,Unit_of_Price,Trade,Discount_Code,StatusCode,Status,Description2,Replacemnt_Cost_Base,Discount_1,Discount_2,Discount_3,Cost_Price,Unit_of_Buy,Unit_of_Cost,Supplier_Code,Weight,Purchase_Text,Manufacturers_Product_Code,Key_Word_Search">
      <cfset bothFields = "">

      <!--- load the CSV into the temp table --->
      <cfquery name="tmp" datasource="#dsn.getName()#" result="imp">
        LOAD DATA INFILE '#arguments.fileName#'
        INTO TABLE products_temp
          FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
          LINES TERMINATED BY '\n'
            IGNORE 1 LINES
        (
          Product_Code,
          Full_Description,
          StatusCode,
          Description2,
          List_Price,
          Unit_of_Sale,
          Retail_Price,
          Unit_of_Price,
          Trade,
          @dummy,
          @dummy,
          Discount_Code,
          @dummy,
          categoryID,
          @dummy,
          Replacemnt_Cost_Base,
          Discount_1,
          Discount_2,
          Discount_3,
          Cost_Price,
          Unit_of_Buy,
          Unit_of_Cost,
          Supplier_Code,
          Weight,
          Purchase_Text,
          Manufacturers_Product_Code,
          Key_Word_Search
          )
      </cfquery>
      <cfset d("Products file has #imp.recordcount# records")>
      <!--- add the company type --->
      <cfquery name="tmp" datasource="#dsn.getName()#">
        UPDATE
          products_temp set siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <cfquery name="tmp" datasource="#dsn.getName()#" result="up">
        UPDATE
          products_temp,
          Products
        SET
          products_temp.external_id = Products.id
        where
          products_temp.Product_Code = Products.Product_Code
        AND
          Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <!--- any records with a zero external ID are new records --->
      <cfquery name="insertNewRecords" datasource="#dsn.getName()#" result="in">
        insert into Products (#ArrayToList(thisColumnList)#)
          select #ArrayToList(thisColumnList)#
          from
          products_temp
          where products_temp.external_id = 0
      </cfquery>
      <cfset d("Inserted #in.recordcount# Product records")>
      <cfquery name="tmp"  datasource="#dsn.getName()#" result="upd">
          UPDATE Products, products_temp SET
          <cfloop list="#compareList#" index="f">
          Products.#f# = products_temp.#f# <cfif f neq ListLast(compareList)>,</cfif>
          </cfloop>
            where
            Products.id = products_temp.external_id
          AND
          (<cfloop list="#compareList#" index="f">
          Products.#f# != products_temp.#f# <cfif f neq ListLast(compareList)>OR</cfif>
          </cfloop>
          )

      </cfquery>
      <cfset d("Updated #upd.recordcount# Product records")>
      <!--- now update remote database timestamp --->
      <cfquery name="u" datasource="BMNet">
        update
          table_updates
        set
          last_updated = now()
        where
          tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="Products">
        AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <!--- delete the temp table --->
      <cfquery name="dc" datasource="#dsn.getName()#">
        DROP TABLE products_temp;
      </cfquery>
    </cfif>
    <cfreturn true>
  </cffunction>

  <cffunction name="Customers" returntype="boolean">
    <cfargument name="fileName">
    <cfargument name="dateLastModified">
    <cfsetting requesttimeout="600">
    <!--- first check if we need to run the update --->
    <cfset doCheckTable("company_customers")>
    <cflog file="mywatcher" text="Updating Customers">
    <cfif doRunUpdate("company_customers","#arguments.fileName#")>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        DROP TABLE IF EXISTS `company_temp`
      </cfquery>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        CREATE TABLE company_temp LIKE company;
      </cfquery>
      <!--- add a new column to the temporary table --->
      <cfquery name="ttc" datasource="#dsn.getName()#">
        ALTER TABLE company_temp
        ADD COLUMN `external_id` INT NOT NULL DEFAULT '0';
      </cfquery>
      <!--- grab the column list --->
      <cfquery name="existingColumnNames" datasource="#dsn.getName()#">
        select * from company limit 0,1;
      </cfquery>
      <!--- lame - gay to recreate the array? --->
      <cfset thisColumnList = []>
      <cfset qColumnList = existingColumnNames.getColumns()>
      <cfloop array="#qColumnList#" index="c">
        <cfset Arrayappend(thisColumnList,c)>
      </cfloop>
      <cfset ArrayDeleteAt(thisColumnList,1)>

      <cfset compareList = "company_contact,name,company_address_1,company_address_2,company_address_3,company_address_4,company_address_5,company_postcode,company_phone,company_fax,company_mobile,company_email,salesman_code">
      <cfset bothFields = "">

      <!--- load the CSV into the temp table --->
      <cfquery name="tmp" datasource="#dsn.getName()#" result="imp">
        LOAD DATA INFILE '#arguments.fileName#'
        INTO TABLE company_temp
          FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
          LINES TERMINATED BY '\n'
            IGNORE 1 LINES
        (
          account_number,
          company_contact,
          name,
          company_address_1,
          company_address_2,
          company_address_3,
          company_address_4,
          company_address_5,
          company_postcode,
          company_phone,
          company_fax,
          company_email,
          salesman_code,
          default_price_method,
          special_terms_class,
          contract_indicator,
          contract_indicator_2,
          @dummy,
          discount_terms,
          creditLimit
          )
      </cfquery>
      <cfset d("Company file has #imp.recordcount# records")>
      <!--- add the company type --->
      <cfquery name="tmp" datasource="#dsn.getName()#">
        UPDATE
          company_temp set
          account_number = TRIM(LEADING '0' FROM account_number),
          type_id = 1, siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <cfquery name="tmp" datasource="#dsn.getName()#" result="up">
        UPDATE
          company_temp,
          company
        SET
          company_temp.external_id = company.id
        where
          company_temp.account_number = company.account_number
        AND
          company.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <!--- any records with a zero external ID are new records --->
      <cfquery name="insertNewRecords" datasource="#dsn.getName()#" result="in">
        insert into company (#ArrayToList(thisColumnList)#)
          select #ArrayToList(thisColumnList)#
          from
          company_temp
          where company_temp.external_id = 0
          AND
          company_temp.type_id = 1
      </cfquery>
      <cfset d("Inserted #in.recordcount# Customer records")>
      <cfquery name="tmp"  datasource="#dsn.getName()#" result="upd">
          UPDATE company, company_temp SET
          <cfloop list="#compareList#" index="f">
          company.#f# = company_temp.#f# <cfif f neq ListLast(compareList)>,</cfif>
          </cfloop>
            where
            company.id = company_temp.external_id
          AND
          (<cfloop list="#compareList#" index="f">
          company.#f# != company_temp.#f# <cfif f neq ListLast(compareList)>OR</cfif>
          </cfloop>
          )

      </cfquery>
      <cfset d("Updated #upd.recordcount# Customer records")>
      <!--- now update remote database timestamp --->
      <cfquery name="u" datasource="BMNet">
        update
          table_updates
        set
          last_updated = now()
        where
          tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="company_customers">
        AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <!--- delete the temp table --->
      <cfquery name="dc" datasource="#dsn.getName()#">
        DROP TABLE company_temp;
      </cfquery>
      <!--- try updating co-ordinates for all compaines --->
      <cfquery name="unknownLocations" datasource="#dsn.getName()#">
        select id, company_postcode from company where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        company_postcode != '' AND company_postcode is not null
        AND
        latitude = ''
        OR
        latitude is null
      </cfquery>

      <cfloop query="unknownLocations">
        <cfset tryCoOrdinates = BranchService.getGenericCoOrdinates("#company_postcode#, UK")>
        <cfif tryCoOrdinates[1] neq 0>
          <cfquery name="updateCompany" datasource="#dsn.getName()#">
            update
              company
            set
              latitude = <cfqueryparam cfsqltype="cf_sql_float" value="#tryCoOrdinates[1]#">,
              longitude = <cfqueryparam cfsqltype="cf_sql_float" value="#tryCoOrdinates[2]#">
            where
              id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">

          </cfquery>
          <cfset d("Got co-ordinates for #company_postcode#")>
        </cfif>
      </cfloop>
    </cfif>
    <cfreturn true>
  </cffunction>

  <cffunction name="Suppliers" returntype="boolean">
    <cfargument name="fileName">
    <cfargument name="dateLastModified">
    <cfsetting requesttimeout="600">
    <!--- first check if we need to run the update --->
    <cfset doCheckTable("company_suppliers")>
    <cflog file="mywatcher" text="Updating Customers">
    <cfif doRunUpdate("company_suppliers","#arguments.fileName#")>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        DROP TABLE IF EXISTS `company_temp`
      </cfquery>
      <cfquery name="doTempTableDrop" datasource="#dsn.getName()#">
        CREATE TABLE company_temp LIKE company;
      </cfquery>
      <!--- add a new column to the temporary table --->
      <cfquery name="ttc" datasource="#dsn.getName()#">
        ALTER TABLE company_temp
        ADD COLUMN `external_id` INT NOT NULL DEFAULT '0';
      </cfquery>
      <!--- grab the column list --->
      <cfquery name="existingColumnNames" datasource="#dsn.getName()#">
        select * from company limit 0,1;
      </cfquery>
      <!--- lame - gay to recreate the array? --->
      <cfset thisColumnList = []>
      <cfset qColumnList = existingColumnNames.getColumns()>
      <cfloop array="#qColumnList#" index="c">
        <cfset Arrayappend(thisColumnList,c)>
      </cfloop>
      <cfset ArrayDeleteAt(thisColumnList,1)>

      <cfset compareList = "company_contact,name,company_address_1,company_address_2,company_address_3,company_address_4,company_address_5,company_postcode,company_phone,company_fax,company_mobile,company_email,salesman_code">
      <cfset bothFields = "">

      <!--- load the CSV into the temp table --->
      <cfquery name="tmp" datasource="#dsn.getName()#" result="imp">
        LOAD DATA INFILE '#arguments.fileName#'
        INTO TABLE company_temp
          FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
          LINES TERMINATED BY '\n'
            IGNORE 1 LINES
        (
          account_number,
          name,
          company_address_1,
          company_address_2,
          company_address_3,
          company_address_4,
          company_address_5,
          company_postcode,
          company_phone,
          @dummy,
          company_fax,
          @dummy,
          company_email,
          salesman_code
          )
      </cfquery>
      <cfset d("Supplier file has #imp.recordcount# records")>
      <!--- add the company type --->
      <cfquery name="tmp" datasource="#dsn.getName()#">
        UPDATE
          company_temp set
          account_number = TRIM(LEADING '0' FROM account_number),
          type_id = 2, siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <cfquery name="tmp" datasource="#dsn.getName()#" result="up">
        UPDATE
          company_temp,
          company
        SET
          company_temp.external_id = company.id
        where
          company_temp.account_number = company.account_number
        AND
          company.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <!--- any records with a zero external ID are new records --->
      <cfquery name="insertNewRecords" datasource="#dsn.getName()#" result="in">
        insert into company (#ArrayToList(thisColumnList)#)
          select #ArrayToList(thisColumnList)#
          from
          company_temp
          where company_temp.external_id = 0
          AND
          company_temp.type_id = 2
      </cfquery>
      <cfset d("Inserted #in.recordcount# Supplier records")>
      <cfquery name="tmp"  datasource="#dsn.getName()#" result="upd">
          UPDATE company, company_temp SET
          <cfloop list="#compareList#" index="f">
          company.#f# = company_temp.#f# <cfif f neq ListLast(compareList)>,</cfif>
          </cfloop>
            where
            company.id = company_temp.external_id
          AND
          (<cfloop list="#compareList#" index="f">
          company.#f# != company_temp.#f# <cfif f neq ListLast(compareList)>OR</cfif>
          </cfloop>
          )

      </cfquery>
      <cfset d("Updated #upd.recordcount# Supplier records")>
      <!--- now update remote database timestamp --->
      <cfquery name="u" datasource="BMNet">
        update
          table_updates
        set
          last_updated = now()
        where
          tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="company_suppliers">
        AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>

      <!--- delete the temp table --->
      <cfquery name="dc" datasource="#dsn.getName()#">
        DROP TABLE company_temp;
      </cfquery>
    </cfif>
    <cfreturn true>
  </cffunction>

  <!--- PRIVATE METHODS --->

  <cffunction name="doRunUpdate" returntype="boolean" access="private">
    <cfargument name="tableName" required="true">
    <cfargument name="fileName" required="true">
    <cfquery name="tableLastUpdated" datasource="#dsn.getName()#">
      SELECT
        last_updated
      FROM
        table_updates
      WHERE
        tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfset fileInfo = getFileInfo(arguments.fileName)>
    <cfif DateCompare(fileInfo.lastmodified,tableLastUpdated.last_updated) gte 1>
      <cfreturn true>
    <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="doCheckTable" access="private">
    <cfargument name="tableName" required="true">
    <cfquery name="tableExists" datasource="#dsn.getName()#">
      select tablename from table_updates where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      AND
      tablename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#">
    </cfquery>
    <cfif tableExists.recordCount eq 0>
      <!--- there isn't a table record create - must be a new table. Create it then --->
      <cfquery name="v" datasource="#dsn.getName()#">
        insert into table_updates
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("d",-1,now())#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">

        )
      </cfquery>
    </cfif>
  </cffunction>

  <cffunction name="d" returntype="any">
    <cfargument name="mess">
    <cfif variables.canLog>
     <cfset logger.debug("#arguments.mess#")>
    </cfif>
  </cffunction>

</cfcomponent>