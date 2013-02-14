<cfcomponent>
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cffunction name="getFields" returntype="query">
    <cfargument name="fieldName">
    <cfargument name="object" required="true" default="product">
    <cfquery name="fields" datasource="#dsn.getName()#">
       select * from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.siteID#">
      AND
      fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldName#">
      AND
      object = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
    </cfquery>
    <cfreturn fields>
  </cffunction>

  <cffunction name="doImport" returntype="void">
    <cfargument name="requestCollection" required="true">
    <cfargument name="siteID" required="true">
    <cfargument name="object" required="true" default="product">
    <cfargument name="tableName" required="true" default="Products">
    <cfargument name="tablesubKey" required="true" default="Product_Code">
    <cfargument name="runMappings" required="true" default="true" type="boolean">
    <cfset var rc = arguments.requestCollection>
    <cfsetting requesttimeout="9000">
    <!--- remove mappings --->
    <cftry>
      <cfif arguments.runMappings>
        <cfquery name="d" datasource="#dsn.getName()#">
          delete from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
          AND
          object = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
        </cfquery>
        <cfloop collection="#rc.object#" item="p">
          <cfif rc.object[p] neq "">
            <cfquery name="addThis" datasource="#dsn.getName()#">
              insert into fieldDefinitions (object,fieldName,siteID,mapsTo)
              VALUES
                (
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#p#">,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.object[p]#">
                )
            </cfquery>
          </cfif>
        </cfloop>
      </cfif>
      <!--- now get the field mappings --->
      <cfquery name="fmappings" datasource="#dsn.getName()#">
        select * from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        object = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
      </cfquery>
      <cfspreadsheet action="read" src="#rc.fileName#" headerrow="1" query="spreadsheet" sheet="1" />
      <cfif arguments.tablesubkey eq "">
        <!--- it's not an import/update job - it's just an import, so delete all existing stuff --->
        <cfquery name="a" datasource="#dsn.getName()#">
          delete from #arguments.tableName# where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        </cfquery>
      </cfif>
      <cfloop query="spreadsheet" startrow="2">
        <cfset pscurrentrow = currentRow>
        <!--- first, find an existing product, if it's an import/export job --->
        <cfif arguments.tablesubKey neq "">
          <cfquery name="pexists" datasource="#dsn.getName()#">
            select id from #arguments.tableName# where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
            AND
            #tablesubKey# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#rc.object['#tablesubKey#']#'][currentRow]#">
          </cfquery>
        </cfif>
        <cfif arguments.tablesubKey eq "" OR pexists.recordCount eq 0>
          <!--- insert the product --->
          <cfquery name="x" datasource="#dsn.getName()#">
          insert into #arguments.tableName#
            (#ValueList(fmappings.fieldname)#,siteID)
          VALUES
            (
              <cfloop query="fmappings">
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#mapsTo#'][pscurrentrow]#">,
              </cfloop>
              <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
            )
          </cfquery>
        <cfelse>
          <!--- update an existing record --->
          <cfquery name="x" datasource="#dsn.getName()#">
          update #arguments.tableName#
            set
              <cfloop query="fmappings">
                #fieldname# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#mapsTo#'][pscurrentrow]#">,
              </cfloop>
              siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
            where
              id = <cfqueryparam cfsqltype="cf_sql_integer" value="#pexists.id#">
          </cfquery>
        </cfif>
      </cfloop>
      <cfmail from="support@buildersmerchant.net" to="#rc.sess.BMNet.username#" subject="#arguments.tableName# Import">Your import was a success</cfmail>
      <cfcatch type="any">
        <cfset local.Email = MailService.newMail().config(from="support@buildersmerchant.net",to="#rc.sess.BMNet.name# <#rc.sess.BMNet.username#>",subject="#arguments.tableName# Import")>
        <cfsavecontent variable="q"><cfdump var="#cfcatch#"></cfsavecontent>
        <cfset local.Email.sethtml(q)>
        <cfset MailService.send(local.Email)>
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="doLedgerImport" returntype="void">
    <cfargument name="requestCollection" required="true">
    <cfargument name="siteID" required="true">
    <cfset var rc = arguments.requestCollection>
    <cfsetting requesttimeout="9000">
    <!--- remove mappings --->
    <cftry>
      <cfquery name="d" datasource="#dsn.getName()#">
        delete from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
        AND
        object = <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.line">
      </cfquery>
      <cfquery name="d" datasource="#dsn.getName()#">
        delete from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
        AND
        object = <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.header">
      </cfquery>
      <cfloop collection="#rc.invoice.header#" item="p">
        <cfif rc.invoice.header[p] neq "">
          <cfquery name="addThis" datasource="#dsn.getName()#">
            insert into fieldDefinitions (object,fieldName,siteID,mapsTo)
            VALUES
              (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.header">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#p#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.invoice.header[p]#">
              )
          </cfquery>
        </cfif>
      </cfloop>
      <cfloop collection="#rc.invoice.line#" item="p">
        <cfif rc.invoice.line[p] neq "">
          <cfquery name="addThis" datasource="#dsn.getName()#">
            insert into fieldDefinitions (object,fieldName,siteID,mapsTo)
            VALUES
              (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.line">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#p#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.invoice.line[p]#">
              )
          </cfquery>
        </cfif>
      </cfloop>
      <!--- now get the field mappings --->
      <cfquery name="lmappings" datasource="#dsn.getName()#">
        select * from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        object = <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.line">
      </cfquery>
      <cfquery name="hmappings" datasource="#dsn.getName()#">
        select * from fieldDefinitions where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        object = <cfqueryparam cfsqltype="cf_sql_varchar" value="invoice.header">
      </cfquery>
      <cfspreadsheet action="read" src="#rc.fileName#" headerrow="1" query="spreadsheet" sheet="1" />
      <cfloop query="spreadsheet" startrow="2">
        <cfset pscurrentrow = currentRow>
        <!--- insert the product --->

        <cfset goods_total = spreadsheet['#getFields("goods_total","invoice.line").mapsTo#'][pscurrentrow]>
        <cfset quantity = spreadsheet['#getFields("quantity","invoice.line").mapsTo#'][pscurrentrow]>
        <cfset line_total = goods_total*quantity>
        <cfquery name="x" datasource="#dsn.getName()#">
        insert into Invoice_Header
          (#ValueList(lmappings.fieldname)#,siteID,line_total)
        VALUES
          (
            <cfloop query="lmappings">
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#mapsTo#'][pscurrentrow]#">,
            </cfloop>
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#line_total#">

          )
        </cfquery>
      </cfloop>
      <!--- now grab the line data --->
     <cfset invoiceNumber = getFields('invoice_num','invoice.line').mapsTo>
      <cfoutput query="spreadsheet" group="#invoiceNumber#" startrow="2">
        <cfset pscurrentrow = currentRow>
          <cfquery name="agdata" datasource="#dsn.getName()#">
          select
            SUM(line_total) as lineTotal,
            SUM(goods_total) as goods_total,
            SUM(line_vat) as vatTotal
          from
            Invoice_Header
          where
            siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
            AND
            invoice_num = <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#invoiceNumber#'][pscurrentrow]#">
        </cfquery>
          <cfquery name="x" datasource="#dsn.getName()#">
        insert into Invoice
          (invoice_number,#ValueList(hmappings.fieldname)#,invoice_total,siteID)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#invoiceNumber#'][pscurrentrow]#">,
            <cfloop query="hmappings">
              <cfswitch expression="#fieldName#">
                <cfcase value="quantity">
                  <cfqueryparam cfsqltype="cf_sql_integer" value="#spreadsheet['#mapsTo#'][pscurrentrow]#">,
                </cfcase>
                <cfcase value="invoice_date">
                  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(spreadsheet['#mapsTo#'][pscurrentrow])#">,
                </cfcase>
                <cfcase value="goods_total">
                  <cfqueryparam cfsqltype="cf_sql_float" value="#agdata.goods_total#">,
                </cfcase>
                <cfcase value="vat_total">
                  <cfif agdata.vatTotal neq "">
                  <cfqueryparam cfsqltype="cf_sql_float" value="#agdata.vatTotal#">,
                  <cfelse>
                  <cfqueryparam cfsqltype="cf_sql_float" value="0">,
                  </cfif>
                </cfcase>
                <cfdefaultcase>
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#spreadsheet['#mapsTo#'][pscurrentrow]#">,
                </cfdefaultcase>
              </cfswitch>
            </cfloop>
            <cfif agdata.vatTotal neq "">
              <cfqueryparam cfsqltype="cf_sql_float" value="#agdata.lineTotal+agdata.vatTotal#">,
            <cfelse>
              <cfqueryparam cfsqltype="cf_sql_float" value="#agdata.lineTotal#">,
            </cfif>

            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
          )
        </cfquery>
      </cfoutput>
      <cfmail from="support@buildersmerchant.net" to="#rc.sess.BMNet.username#" subject="Ledger Import">Your import was a success</cfmail>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.message# #cfcatch.Detail# #cfcatch.ExtendedInfo#">
        <cfset local.Email = MailService.newMail().config(from="support@buildersmerchant.net",to="tom.miller@ebiz.co.uk",subject="Ledger Import")>
        <cfsavecontent variable="q"><cfdump var="#cfcatch#"></cfsavecontent>
        <cfset local.Email.sethtml(q)>
        <cfset MailService.send(local.Email)>
      </cfcatch>
    </cftry>
  </cffunction>

</cfcomponent>