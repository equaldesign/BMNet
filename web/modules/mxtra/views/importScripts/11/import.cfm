  <cfset rc = rc>
  <cfquery name="r" datasource="mxtra_#rc.sess.siteID#">
   delete from eanTemp;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/CF_EBIZCODE.csv'
  INTO TABLE eanTemp FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  IGNORE 1 LINES
  (eancode,product_code)
  </cfquery>
  <cfquery name="dump" datasource="mxtra_#rc.sess.siteID#">
    delete from Products;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/CF_EBIZDATA.csv'
  INTO TABLE Products FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  IGNORE 1 LINES

  ( Product_Code,
    Full_Description,
    StatusCode,
    Status,
    @dummy,
    List_Price,
    @dummy, <!--- Unit of Price --->
    Retail_Price,
    Unit_of_Price,
    Trade,
    @dummy, <!--- Unit of Price --->
    Unit_of_Sale,
    Discount_Code,
    Description2,
    categoryID,
    @dummy,
    Replacemnt_Cost_Base,
    Discount_1,
    Discount_2,
    Discount_3,
    Nett_Cost,
    Unit_of_Buy,
    Unit_of_Cost,
    Supplier_Code,
    Weight,
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
    )
  </cfquery>
  <cfquery name="ean" datasource="mxtra_#rc.sess.siteID#">
   select * from eanTemp;
  </cfquery>
  <cfloop query="ean">
  <cfquery name="t" datasource="mxtra_#rc.sess.siteID#">
   update Products set EANCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eancode#">
   where Product_Code = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_code#">
   </cfquery>
  </cfloop>

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
  <cfset columnList = "account_number,company_contact,name,company_address_1,
    company_address_2,company_address_3,company_address_4,company_address_5,
      company_postcode,company_phone,
        company_fax,company_mobile,company_email,salesman_code,default_price_method,special_terms_class,contract_indicator,contract_indicator_2">
  <cfset bothFields = "">
  <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
  LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/CF_EBIZCUST.csv'
 INTO TABLE loaddata_temp
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
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
    discount_terms
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

<!---   <cfquery name="tmp" datasource="mxtra_#rc.sess.siteid#">
    select #columnList# INTO OUTFILE '/tmp/#fileName#' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    FROM loaddata_temp where account_number=0
  </cfquery> --->

  <cfexecute  timeout="30" name="/usr/bin/mysql" arguments="-u ebiz --host=ec2db.czy8v55h2q70.eu-west-1.rds.amazonaws.com --password=fl3x1bl3 -e ""select concat(#columnList#) FROM loaddata_temp where account_number=0"" --database=mxtra_11" outputfile="/tmp/#fileName#" />

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
    delete from ProductCategory;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/ProductCodeTree.csv' INTO TABLE ProductCategory FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  </cfquery>

  <cfquery name="dump" datasource="mxtra_#rc.sess.siteID#">
    delete from stock;
  </cfquery>
  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
    LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/BR_EBIZSTOC.csv' INTO TABLE stock FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' (branchID,Product_Code,@dummy,physical,reserved,@dummy,onOrder,@dummy)
  </cfquery>

  <cfquery name="test" datasource="mxtra_#rc.sess.siteID#">
  LOAD DATA LOCAL INFILE '/fs/homes/turnbull/turnbullftp/SO_EBIZSALE.csv'
  REPLACE INTO TABLE Invoice_Header
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
      IGNORE 1 LINES
  (
    branch_id,
    account_number,
    account_name,
    order_number,
    invoice_num,
    @inv_date,
    order_category,
    description,
    quantity,
    product_code,
    full_description,
    goods_total,
    line_total,
    line_vat,
    delivery_name,
    delivery_address_1,
    delivery_address_2,
    delivery_address_3,
    delivery_address_4,
    delivery_address_5,
    delivery_postcode,
    customer_order_no,
    categoryID,
    @dummy
    )
    set
    inv_date = str_to_date(@inv_date, '%d/%m/%Y')
  </cfquery>

  <cfquery name="topLevelCats" datasource="mxtra_#rc.sess.siteID#">
    select id from ProductCategory where CHAR_LENGTH(id) = 7;
  </cfquery>
  <!--- get the top level categories --->
  <cfloop query="topLevelCats">
    <cfquery name="Prods" datasource="mxtra_#rc.sess.siteID#">
      select count(*) as number from Products where categoryID = '#id#';
    </cfquery>
    <cfquery name="update" datasource="mxtra_#rc.sess.siteID#">
      update ProductCategory set productCount = #Prods.number# where id = '#id#';
    </cfquery>
  </cfloop>

  <cfquery name="topLevelCats" datasource="mxtra_#rc.sess.siteID#">
    select id from ProductCategory where CHAR_LENGTH(id) = 5;
  </cfquery>
  <!--- get the top level categories --->
  <cfloop query="topLevelCats">
    <cfquery name="Prods" datasource="mxtra_#rc.sess.siteID#">
      select count(*) as number from Products where left(categoryID,5) = '#id#';
    </cfquery>
    <cfquery name="update" datasource="mxtra_#rc.sess.siteID#">
      update ProductCategory set productCount = #Prods.number# where id = '#id#';
    </cfquery>
  </cfloop>

  <cfquery name="topLevelCats" datasource="mxtra_#rc.sess.siteID#">
    select id from ProductCategory where CHAR_LENGTH(id) = 3;
  </cfquery>
  <!--- get the top level categories --->
  <cfloop query="topLevelCats">
    <cfquery name="Prods" datasource="mxtra_#rc.sess.siteID#">
      select count(*) as number from Products where left(categoryID,3) = '#id#';
    </cfquery>
    <cfquery name="update" datasource="mxtra_#rc.sess.siteID#">
      update ProductCategory set productCount = #Prods.number# where id = '#id#';
    </cfquery>
  </cfloop>

  <cfquery name="topLevelCats" datasource="mxtra_#rc.sess.siteID#">
    select id from ProductCategory where CHAR_LENGTH(id) = 1;
  </cfquery>
  <!--- get the top level categories --->
  <cfloop query="topLevelCats">
    <cfquery name="Prods" datasource="mxtra_#rc.sess.siteID#">
      select count(*) as number from Products where left(categoryID,1) = '#id#';
    </cfquery>
    <cfquery name="update" datasource="mxtra_#rc.sess.siteID#">
      update ProductCategory set productCount = #Prods.number# where id = '#id#';
    </cfquery>
  </cfloop>

  <cfsetting requesttimeout="99900">
   <cfindex language="english" collection="turnbullpod" recurse="true" action="update" key="/fs/homes/turnbull/turnbullftp/PODs" extensions=".pdf" type="path" />
    <cfquery name="invoices" datasource="mxtra_#rc.sess.siteID#">
      select id, order_number, product_code from Invoice_Header where PODFile is null AND inv_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,now())#"> group by order_number;
    </cfquery>
    <cfloop query="invoices">
      <cfsearch name="PODs" type="simple" collection="turnbullpod" criteria='"#order_number#" AND "#product_code#"' />
      <cfset rc.PODs = PODs>
      <cfif PODs.recordCount neq 0>
        <cfquery name="updateHeader" datasource="mxtra_#rc.sess.siteID#">
          update Invoice_Header set PODFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PODs.url#"> where order_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#order_number#">
        </cfquery>
      </cfif>
    </cfloop>
<!---   <cffile action="read" file="/usr/share/dict/words" variable="dict">
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
