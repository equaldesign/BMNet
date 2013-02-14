  <cfset rc = rc>
  <cfquery name="del" datasource="mxtra_#rc.sess.siteID#">
    delete from Products;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/tuckerfrench/ecommerce_Products.txt'
  INTO TABLE Products FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  IGNORE 1 LINES
  ( @dummy, <!--- cono --->
    Product_Code,
    Key_Word_Search,
    categoryID,
    @dummy, <!--- transdt --->
    @dummy, <!--- transtm --->
    @dummy, <!--- operinit --->
    @dummy, <!--- unitsell --->
    @dummy, <!--- unitcnt --->
    Unit_of_Sale,
    Weight,
    @dummy, <!--- cubes --->
    @dummy, <!--- corecharge --->
    @dummy, <!--- msdsfl --->
    @dummy, <!--- msdschgdt --->
    @dummy, <!--- webpageext --->
    @dummy, <!--- xxde2 --->
    @dummy, <!--- webpage --->
    @dummy, <!--- warrlength --->
    @dummy, <!--- warrtype --->
    @dummy, <!--- unitconvfl --->
    Full_Description,
    @dummy, <!--- enterdt --->
    @dummy, <!--- statustype --->
    @dummy, <!--- notesfl --->
    @dummy, <!--- kittype --->
    @dummy, <!--- kitrollty --->
    @dummy, <!--- exponinvfl --->
    @dummy, <!--- nospecrecno --->
    @dummy, <!--- lifocat --->
    @dummy, <!--- msdssheetno --->
    @dummy, <!--- pbseqno --->
    @dummy, <!--- sellmult --->
    @dummy, <!--- xxde1 --->
    @dummy, <!--- seqno --->
    @dummy, <!--- length --->
    @dummy, <!--- termsdiscfl --->
    @dummy, <!--- xxc1 --->
    @dummy, <!--- termspct --->
    @dummy, <!--- xxc2 --->
    Supplier_Code,
    @dummy, <!--- xxc3 --->
    StatusCode,
    @dummy, <!--- tiedcompprt --->
    @dummy, <!--- bolclass --->
    @dummy, <!--- edicd --->
    @dummy, <!--- slgroup --->
    @dummy, <!--- priceonty --->
    @dummy, <!--- icspecrecno --->
    @dummy, <!--- width --->
    @dummy, <!--- oespecrecno --->
    @dummy, <!--- height --->
    @dummy, <!--- xxda1 --->
    @dummy, <!--- xxda2 --->
    @dummy, <!--- xxda3 --->
    @dummy, <!--- xxl1 --->
    @dummy, <!--- kitnsreqfl --->
    Bullet_1,
    Web_Description,
    @dummy, <!--- user5 --->
    Retail_Price,
    @dummy, <!--- user7 --->
    @dummy, <!--- user8 --->
    @dummy, <!--- user9 --->
    @dummy, <!--- autoupcd --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    Manufacturers_Product_Code,
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy, <!--- keyindex --->
    @dummy <!--- keyindex --->
    )
  </cfquery>
    <cfset fileName = "#CreateUUID()#.tmp">
  <cfset cnt_records = 0>
  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
    DROP TABLE if exists loaddata_temp;
  </cfquery>
  <cftry>
    <cfif fileExists("/tmp/#fileName#")>
  <cffile action="delete" file="/tmp/#fileName#">
    </cfif>
  <cfcatch type="any"></cfcatch></cftry>
  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
    CREATE TABLE loaddata_temp LIKE Customer;
  </cfquery>
  <cfquery name="existingColumnNames" datasource="mxtra_#rc.sess.siteid#">
    show columns from Customer;
  </cfquery>
  <cfset columnList = "account_number,name,special_terms_class,contract_indicator,company_fax,company_phone,salesman_code,company_address_1,company_address_2,company_address_4,company_address_5,company_postcode,contract_indicator_2">
  <cfset bothFields = "">
  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
  LOAD DATA LOCAL INFILE '/fs/homes/tuckerfrench/ecommerce_Customers.txt'
 INTO TABLE loaddata_temp
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
      IGNORE 1 LINES
  (
    account_number,
    name,
    special_terms_class,
    contract_indicator,
    company_fax,
    company_phone,
    salesman_code,
    company_address_1,
    company_address_2,
    company_address_4,
    company_address_5,
    company_postcode,
    contract_indicator_2
    )
  </cfquery>
  <cfquery name="result" datasource="mxtra_#rc.sess.siteid#">
  SELECT count(*) as records FROM loaddata_temp
  </cfquery>
  <cfset cnt_records = result.records>
  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
    UPDATE loaddata_temp,Customer SET loaddata_temp.account_number= Customer.account_number
      where Customer.account_number = loaddata_temp.account_number
  </cfquery>

  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
    select #columnList# INTO OUTFILE '/tmp/#fileName#' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    FROM loaddata_temp where account_number!=0
  </cfquery>
  <cfquery name="tmp"  datasource="mxtra_#rc.sess.siteid#">
    LOAD DATA LOCAL INFILE '/tmp/#fileName#' ignore INTO TABLE Customer FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY '\"' (#columnList#)
  </cfquery>
  <cfquery name="tmp"  datasource="mxtra_#rc.sess.siteid#">
      UPDATE Customer,loaddata_temp SET
      <cfloop list="#columnList#" index="f">
      Customer.#f# = loaddata_temp.#f# <cfif f neq ListLast(columnList)>,</cfif>
      </cfloop>
        where
        Customer.account_number = loaddata_temp.account_number and loaddata_temp.account_number!=0
  </cfquery>
  <cfquery name="del" datasource="mxtra_#rc.sess.siteID#">
    delete from Products where Product_Code = 0;
  </cfquery>
  <cfquery name="dump" datasource="mxtra_#rc.sess.siteID#">
    select count(*) as records from Products;
  </cfquery>


  <cfquery name="dump" datasource="mxtra_#rc.sess.siteID#">
    delete from stock;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
    LOAD DATA LOCAL INFILE '/fs/homes/tuckerfrench/ecommerce_Stock.txt' INTO TABLE stock FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    (
      branchID,
      Product_Code,
      physical,
      reserved,
      @dummy,
      onOrder,
      @dummy)
  </cfquery>

  <cfquery name="dump" datasource="mxtra_#rc.sess.siteID#">
    delete from ProductCategory;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/tuckerfrench/ProductCodeTree.csv' INTO TABLE ProductCategory FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  </cfquery>
  <cfquery name="del" datasource="mxtra_#rc.sess.siteID#">
    delete from Invoice_Header;
  </cfquery>
   <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/tuckerfrench/ecommerce_transactions.txt'
  REPLACE INTO TABLE Invoice_Header
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
      IGNORE 1 LINES
  (
    invoice_num,
    account_number,
    product_code,
    @dummy,
    branch_id,
    @dummy,
    quantity,
    line_total,
    goods_total,
    @inv_date
    )
    set
    inv_date = str_to_date(@inv_date, '%d/%m/%Y')
  </cfquery>
  <cfquery name="categories" datasource="mxtra_#rc.sess.siteID#">
    select id from ProductCategory;
  </cfquery>
  <cfloop query="categories">
    <cfquery name="prods" datasource="mxtra_#rc.sess.siteID#">
      select count(*) as num from Products where categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
    </cfquery>
    <cfif prods.num neq 0>
    <cfquery name="udcat" datasource="mxtra_#rc.sess.siteID#">
      update ProductCategory set productCount = <cfqueryparam cfsqltype="cf_sql_integer" value="#prods.num#">
      where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
    </cfquery>
    </cfif>
  </cfloop>

  <!--- bodge to remove non web products (for now) --->
  <cfquery name="p" datasource="mxtra_#rc.sess.siteID#">
    select distinct(categoryID) as catID from Products where statusCode != 'W'
  </cfquery>
  <cfloop query="p">
    <cfquery name="u" datasource="mxtra_#rc.sess.siteID#">
    update ProductCategory set productCount = 0
      where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#catID#">
   </cfquery>
  </cfloop>
  <!--- <cffile action="read" file="/usr/share/dict/words" variable="dict">
  <cfset wordArray = ListToArray(dict,chr(10))>
  <cfquery name="Customers" datasource="mxtra_#rc.sess.siteID#">
   select * from Customer
  </cfquery>
  <cfoutput query="Customers">
   <cfset rc.tes = MakeNicePassword(wordArray)>
   <cfquery name="u" datasource="mxtra_#rc.sess.siteID#">
     update Customer set pass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.tes#">
     WHERE account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_number#">
   </cfquery>
  </cfoutput> --->
