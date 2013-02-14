<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="false">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />

  <!--- methods --->

  <cffunction name="salesChartData" returntype="Array">
    <cfargument name="siteID">
    <cfargument name="filterBy" required="true" default="">
    <cfargument name="filterValue" required="true" default="">
	  <cfquery name="allData" datasource="#dsn.getName()#">
	  	  select sum(invoice_total) as throughput,
			  UNIX_TIMESTAMP(invoice_date)*1000 as epochdate
			  from
			  Invoice
			  where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
			  <cfif arguments.filterBy neq "">
			  AND
			  #arguments.filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValue#">
			  </cfif>
			  group by epochdate
	  </cfquery>
	  <cfset returnArray = []>
	  <cfloop query="allData">
	    <cfset ArrayAppend(returnArray,[epochdate,throughput])>
	  </cfloop>
	  <cfreturn returnArray>
  </cffunction>

  <cffunction name="getSalesFilter" returntype="array">
  	<cfargument name="siteID" required="true">
	  <cfargument name="filter" required="true" default="salesman">
	  <cfquery name="f" datasource="#dsn.getName()#">
	    select
		    distinct(#arguments.filter#) as theFilter
		  from
		    Invoice where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
	  </cfquery>
	  <cfset var returnArray = []>
	  <cfloop query="f">
	  	<cfset ArrayAppend(returnArray,theFilter)>
	  </cfloop>
	  <cfreturn returnArray>
  </cffunction>

  <cffunction name="salesChartDataBy" returntype="Array">
    <cfargument name="siteID">
	  <cfargument name="filterBy" required="true" default="salesman">
	  <cfargument name="filterValue" required="true" default="">

    <cfquery name="allData" datasource="#dsn.getName()#">
        select sum(invoice_total) as throughput,
        UNIX_TIMESTAMP(invoice_date)*1000 as epochdate
        from
        Invoice
        where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
		    AND
			  #arguments.filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValue#">
        group by epochdate
    </cfquery>
    <cfset returnArray = []>
    <cfloop query="allData">
      <cfset ArrayAppend(returnArray,[epochdate,throughput])>
    </cfloop>
    <cfreturn returnArray>
  </cffunction>


  <cffunction name="chartData" returntype="query">
    <cfargument name="chartType" type="string" default="yearonyearcomparison">
    <cfargument name="filterColumns" type="Array" default="">
    <cfargument name="filterValues" type="Array" default="">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfset queryNow = CreateDate(year(now()),month(now()),day(now()))>
    <cfswitch expression="#arguments.chartType#">
      <cfcase value="yearonyearcomparison">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
          select sum(invoice_total) as throughput,
          invoice_date
          from
          Invoice
          where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy',-2,queryNow)#">
          <cfif arrayLen(arguments.filterColumns) gte 1>
          <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
          AND
          #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
          </cfloop>
          </cfif>
          Group by Date_Format(invoice_date,'%Y%m')
        </cfquery>
        <cfset returnQ = QueryNew("DateLast,DateThis,ValueLast,ValueThis")>
        <cfset startDate = DateAdd("yyyy",-2,queryNow)>
        <cfloop from="1" to="12" index="m">
          <cfquery name="lastM" dbtype="query">
            select
              throughput
            from
              comparisons
            WHERE
            invoice_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(YEAR(startDate),MONTH(startDate),1)#">
            AND <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(YEAR(startDate),MONTH(startDate),DaysInMonth(startDate))#">
          </cfquery>
          <cfset plusYear =DateAdd('yyyy',1,startDate) >
          <cfquery name="thisM" dbtype="query">
            select
              throughput
            from
              comparisons
            WHERE
            invoice_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(YEAR(plusYear),MONTH(plusYear),1)#">
            AND <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(YEAR(plusYear),MONTH(plusYear),DaysInMonth(plusYear))#">
          </cfquery>
          <cfset QueryAddRow(returnQ)>
          <cfset QuerySetCell(returnQ,"DateLast",DateFOrmat(startDate,"MMM YY"))>
          <cfset QuerySetCell(returnQ,"DateThis",DateFOrmat(plusYear,"MMM YY"))>
          <cfset QuerySetCell(returnQ,"ValueLast",lastM.throughput)>
          <cfset QuerySetCell(returnQ,"ValueThis",thisM.throughput)>
          <cfset startDate = DateAdd("m",1,startDate)>
        </cfloop>
      </cfcase>
      <cfcase value="monthonmonthcomparison">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
          select sum(invoice_total) as throughput,
          invoice_date
          from
          Invoice
          where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-2,queryNow)#">
          <cfif arrayLen(arguments.filterColumns) gte 1>
          <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
          AND
          #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
          </cfloop>
          </cfif>
          Group by Date_Format(invoice_date,'%Y%m%d')
        </cfquery>
        <cfset returnQ = QueryNew("DateLast,DateThis,ValueLast,ValueThis")>
        <cfset startDate = DateAdd("d",-60,queryNow)>
        <cfloop from="1" to="30" index="m">
          <cfquery name="lastM" dbtype="query" cachedwithin="#CreateTimespan(1,0,0,0)#">
            select
              throughput
            from
              comparisons
            WHERE
            invoice_date = <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
          </cfquery>
          <cfset plusYear =DateAdd('d',30,startDate) >
          <cfquery name="thisM" dbtype="query" cachedwithin="#CreateTimespan(1,0,0,0)#">
            select
              throughput
            from
              comparisons
            WHERE
            invoice_date = <cfqueryparam cfsqltype="cf_sql_date" value="#plusYear#">
          </cfquery>
          <cfset QueryAddRow(returnQ)>
          <cfset QuerySetCell(returnQ,"DateLast",startDate)>
          <cfset QuerySetCell(returnQ,"DateThis",plusYear)>
          <cfset QuerySetCell(returnQ,"ValueLast",lastM.throughput)>
          <cfset QuerySetCell(returnQ,"ValueThis",thisM.throughput)>
          <cfset startDate = DateAdd("d",1,startDate)>
        </cfloop>
      </cfcase>
      <cfcase value="last30daysbycustomer">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
         select
            sum(invoice_total) as spend,
            company.name,
            company.id as id,
            company.latitude,
            company.longitude
          from
            Invoice,
            company
          where
            Invoice.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
             AND
             invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,queryNow)#">
             AND
             company.account_number = Invoice.account_number
            <cfif arrayLen(arguments.filterColumns) gte 1>
               <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
                    AND
                    #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
                    </cfloop>
            </cfif>
            AND
            invoice_total > 0
            Group by name
        </cfquery>
        <cfset returnQ = comparisons>
      </cfcase>
      <cfcase value="customerdissapearance">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
         SELECT
              c.name,
              c.id as id,
              c.latitude,
              c.longitude,
              lsm.invoice_count as invoice_count,
              lsm.spend as spend
          FROM
              company AS c
              INNER JOIN (
                  SELECT account_number, count(*) AS invoice_count, sum(line_total) as spend
                  FROM Invoice
                  WHERE invoice_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-8,queryNow)#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,queryNow)#">
                  <cfif arrayLen(arguments.filterColumns) gte 1>
                    <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
                    AND
                    #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
                    </cfloop>
                  </cfif>
                  AND
                  siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
                  GROUP BY account_number
              ) AS lsm
                  ON c.account_number = lsm.account_number
              LEFT JOIN (
                  SELECT account_number, count(*) AS invoice_count
                  FROM Invoice
                  WHERE invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,queryNow)#">
                  AND
                  siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
                  GROUP BY account_number
              ) AS lm
                  ON c.account_number = lm.account_number
              WHERE
                  c.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
                  AND
                  c.type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                  AND
                  lsm.invoice_count >= 50
                  AND IFNULL(lm.invoice_count, 0) = 0

        </cfquery>
        <cfset returnQ = comparisons>
      </cfcase>
      <cfcase value="salesPersonOverview">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
        select
         salesman,
          FLOOR(sum(invoice_total)) as throughput
          from
          Invoice
          where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-12,queryNow)#">
          AND
          salesman is not null
          AND
          salesman != ''
          AND invoice_total > 0
          <cfif arrayLen(arguments.filterColumns) gte 1>
          <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
          AND
          #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
          </cfloop>
          </cfif>
          Group by salesman
        </cfquery>
        <cfset returnQ = comparisons>
      </cfcase>
      <cfcase value="salesPersonOverviewThisMonth">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
        select
         salesman,
          FLOOR(sum(invoice_total)) as throughput
          from
          Invoice
          where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          invoice_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,queryNow)#">
          AND
          salesman is not null
          AND
          salesman != ''
          AND invoice_total > 0
          <cfif arrayLen(arguments.filterColumns) gte 1>
          <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
          AND
          #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
          </cfloop>
          </cfif>
          Group by salesman
          Order by throughput desc
          LIMIT 0,10
        </cfquery>
        <cfset returnQ = comparisons>
      </cfcase>
      <cfcase value="salesPersonOverviewLastMonth">
        <cfquery name="comparisons" datasource="#dsn.getName()#" cachedwithin="#CreateTimespan(1,0,0,0)#">
        select
         salesman,
          FLOOR(sum(invoice_total)) as throughput
          from
          Invoice
          where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          invoice_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-2,queryNow)#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,queryNow)#">
          AND
          salesman is not null
          AND
          salesman != ''
          AND invoice_total > 0
          <cfif arrayLen(arguments.filterColumns) gte 1>
          <cfloop from="1" to="#ArrayLen(arguments.filterColumns)#" index="i">
          AND
          #arguments.filterColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterValues[i]#">
          </cfloop>
          </cfif>
          Group by salesman
          Order by throughput desc
          LIMIT 0,10
        </cfquery>
        <cfset returnQ = comparisons>
      </cfcase>
    </cfswitch>

    <cfreturn returnQ>
  </cffunction>

</cfcomponent>