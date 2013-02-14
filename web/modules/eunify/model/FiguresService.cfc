<cfcomponent name="figuresService" output="true" cache="true" autowire="true">
	<!--- Dependencies --->
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="logger" inject="logbox:root" />
	<cfproperty name="company" inject="id:eunify.CompanyService" />
	<cfproperty name="psa" inject="id:eunify.PSAService" />

  <cfscript>
		function vNum(num) {
			if (IsNumeric(num)) {
				return num;
			}	else {
				return 0;
			}
		}

		function getPeriodFromString(str) {
			var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
			str = replace(str,"Turnover for ","");
			p = ListToArray(str," ");
			theyear = p[2];
			theMonth = arrayFind(months,p[1]);
			return CreateDate(theyear,theMonth,1);
		}



	</cfscript>

  <cffunction name="getNextInputDate" returntype="date">
  	<cfargument name="psaID">
  	<cfscript>
      var latestDate = "";
      var a = "";
    </cfscript>
    <cfquery name="latestDate" datasource="#dsnRead.getName()#">
    	select
      	period
      from
      	turnover as rt
      where
      	rt.psaID = '#arguments.psaID#'
      order by period desc;
		</cfquery>
	  <cfif latestDate.recordCount eq 0>
  		<cfquery name="a" datasource="#dsnRead.getName()#">
    		select period_from from arrangement where id = '#arguments.psaID#';
    	</cfquery>
    	<cfreturn a.period_from>
  	<cfelse>
  		<cfreturn DateAdd("m",1,latestDate.period)>
  	</cfif>
  </cffunction>

  <cffunction name="getLastInputDate" returntype="date">
    <cfargument name="psaID">
    <cfscript>
      var latestDate = "";
      var a = "";
    </cfscript>
    <cfquery name="latestDate" datasource="#dsnRead.getName()#">
      select
        period as maxDate
      from
        turnover as rt
      where
        rt.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
        order by maxDate desc;
    </cfquery>
    <cfif latestDate.recordCount eq 0>
      <cfquery name="a" datasource="#dsnRead.getName()#">
        select period_from from arrangement where id = '#arguments.psaID#';
      </cfquery>
      <cfreturn a.period_from>
    <cfelse>
      <cfreturn latestDate.maxDate>
    </cfif>
  </cffunction>

  <cffunction name="payable" returntype="query" output="false">
    <cfargument name="memberID" required="true" default="0">
    <cfargument name="paid" required="true" default="false">
    <cfargument name="period_from" required="true" default="#createDate(year(now()),month(now()),1)#">
    <cfargument name="period_to" required="true" default="#createDate(year(now()),month(now())-1,1)#">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfscript>
      var payments = "";
    </cfscript>
    <cfquery name="payments" datasource="#dsnRead.getName()#">
      select
        arrangement.name,
        arrangement.dealData,
        company.known_as,
		<cfif memberID eq 0>
	    SUM(rp.rebatePayable) as rebatePayable,
        <cfelse>
		rp.rebatePayable,
		</cfif>
        rp.id,
        rp.xmlID,
        rp.periodFrom,
        rp.periodTo,
        rp.psaID,
        rp.paid,
		rp.periodName,
        rebateElement(rp.psaID, rp.xmlID) as rebateName,
        getPayableTo(rp.psaID, rp.xmlID) as payableTo
      from
        rebatePayments as rp,
        arrangement,
        company
      where
        rp.rebatePayable != 0
        <cfif isUserInRole("member")>
        <cfif memberID neq 0>
		AND
        rp.memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
		<cfelse>
		and getPayableTo(rp.psaID, rp.xmlID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="group">
		</cfif>
        AND
        arrangement.id = rp.psaID
        AND
        company.id = arrangement.company_id
        AND
        <cfelse>
        AND
        arrangement.company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
        AND
        rp.psaID = arrangement.id
        AND
        company.id = rp.memberID
        AND
        </cfif>
        rp.periodTo BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#period_from#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#period_to#">

        AND
        <!--- we only want valid, tickable elements --->
        (
          YEAR(rp.periodTo) = YEAR(rp.figuresLastDate)
          AND
          MONTH(rp.periodTo) <= MONTH(rp.figuresLastDate)
        )
        AND
        rp.paid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paid#">
		<cfif memberID eq 0>
		group by company_id,xmlID,periodTo,psaID
		</cfif>
        order by rebatePayable desc;
    </cfquery>
    <cfreturn payments>
  </cffunction>

	<cffunction name="getEntryTurnover" returntype="query">
  	<cfargument name="psaID">
  	<cfargument name="date">
  	<cfscript>
      var latestDate = "";
    </cfscript>
    <cfquery name="latestDate" datasource="#dsnRead.getName()#">
    	select
      	figuresID, memberID, value as amount
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
      and
				period = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.date#">
      ;
		</cfquery>
	  <cfreturn latestDate>
  </cffunction>

  <cffunction name="getAllMemberTurnover" returntype="query">
    <cfargument name="dateFrom" required="true" type="date">
    <cfargument name="dateTo" required="true" type="date">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfscript>
      var turnover = "";
    </cfscript>
    <cfquery name="turnover" datasource="#dsnRead.getName()#">
      select
			  arrangement.name,
			  company.name as known_as,
			  arrangement.id,
			  company.id as companyID,
			  turnover.period,
			  turnover.figuresID,
        turnover.value as totalturnover,
			  figuresEntry.inputName
			from
			  turnover,
			  arrangement,
			  company,
			  figuresEntry
			where
			  turnover.memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">
			  AND
			  turnover.period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(dateFrom)#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(dateTo)#">
			  AND
			  arrangement.id = turnover.psaID
			  AND
			  figuresEntry.id = turnover.figuresID
        AND
        figuresEntry.inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			  AND
			  company.id = arrangement.company_id
    </cfquery>
    <cfreturn turnover>
  </cffunction>

  <cffunction name="getAllTurnover" returntype="query">
    <cfargument name="dateFrom" required="true" type="date">
    <cfargument name="dateTo" required="true" type="date">
    <cfscript>
      var turnover = "";
    </cfscript>
    <cfquery name="turnover" datasource="#dsnRead.getName()#">
      select
        arrangement.name,
        company.name as known_as,
        arrangement.id,
        company.id as companyID,
        member.name as memberName,
        turnover.period,
        turnover.figuresID,
        turnover.value as totalturnover,
        figuresEntry.inputName
      from
        turnover,
        arrangement,
        company,
        company as member,
        figuresEntry
      where
        turnover.period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(dateFrom)#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(dateTo)#">
        AND
        arrangement.id = turnover.psaID
        AND
        member.id = turnover.memberID
        AND
        figuresEntry.id = turnover.figuresID
        AND
        figuresEntry.inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
        company.id = arrangement.company_id
    </cfquery>
    <cfreturn turnover>
  </cffunction>

	<cffunction name="getFiguresEnteredRetrospective" returntype="struct">
		<cfargument name="psaID" type="numeric" required="yes">
  	<cfargument name="periodFrom" type="date" required="yes">
		<cfargument name="periodTo" type="date" required="yes">
		<cfargument name="figuresID" type="any" required="yes">
		<cfargument name="figuresIDRetroSpective" type="any" required="yes">
    <cfargument name="rebateRateQ" type="query" required="yes">
  	<cfargument name="minusQ" type="query" required="yes">
  	<cfargument name="inputType" type="numeric" required="yes">
  	<cfargument name="outputType" type="numeric" required="yes">
  	<cfscript>
      var perMemberDue = "";
      var figures = "";
      var figuresTotal = "";
      var figuresTotalRetrospective = "";
      var achieved = "";
      var achievedRetrospective = "";
      var rebateTotal = "";
      var rebateTotalRetrospective = "";
      var figuresPerMember = "";
      var figuresPerMemberRetrospective = "";
      var alreadyPaid = "";
    </cfscript>
    <cfquery name="figuresTotal" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period >= <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND period < <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <cfquery name="figuresTotalRetrospective" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresIDRetroSpective#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <cfquery name="achieved" dbtype="query" maxrows="1">
    	select * from rebateRateQ where figureFrom < #NumberFormat(figuresTotal.total,"999999999.00")# order by figureFrom desc;
    </cfquery>
    <cfquery name="achievedRetrospective" dbtype="query" maxrows="1">
    	select * from minusQ where figureFrom < #NumberFormat(figuresTotal.total,"999999999.00")# order by figureFrom desc;
    </cfquery>
    <Cfquery name="rebateTotal" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total,
        sum(value)/100*#NumberFormat(achieved.rebateValue,"0.00")# as rebatable
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <Cfquery name="rebateTotalRetrospective" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total,
        (#rebateTotal.rebatable# - sum(value)/100*#NumberFormat(achievedRetrospective.rebateValue,"0.00")#) as rebatable
      from
      	turnover
      where
        figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresIDRetroSpective#">
      and
      	rebateIndexID = '#rebateIndexRetroSpective#'
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <Cfquery name="figuresPerMember" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total,
        sum(value)/100*#NumberFormat(achieved.rebateValue,"0.00")# as rebatable,
        turnover.memberID,
        #NumberFormat(achieved.rebateValue,"0.00")# as outputType,
        #arguments.inputType# as inputTypeID,
        #arguments.outputType# as outputTypeID,
        known_as
      from
      	turnover,
        company
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      AND
      	company.id = turnover.memberID
      group by memberID;
    </Cfquery>
    <Cfquery name="figuresPerMemberRetrospective" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total,
        sum(value)/100*#NumberFormat(achievedRetrospective.rebateValue,"0.00")# as rebatable,
        turnover.memberID,
        #NumberFormat(achievedRetrospective.rebateValue,"0.00")# as outputType,
        #arguments.inputType# as inputTypeID,
        #arguments.outputType# as outputTypeID,
        known_as
      from
      	turnover,
        company
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      AND
      	company.id = turnover.memberID
      group by memberID;
    </Cfquery>
    <cfset perMemberDue = QueryNew("known_as,memberID,rebatable,total,outputType,inputTypeID,outputTypeID")>
    <cfloop query="figuresPerMember">
    	<cfset QueryAddRow(perMemberDue)>
      <cfset QuerySetCell(perMemberDue,"known_as","#known_as#")>
			<cfset QuerySetCell(perMemberDue,"memberID","#memberID#")>
      <cfset QuerySetCell(perMemberDue,"total","#total#")>
      <cfset QuerySetCell(perMemberDue,"outputType","#figuresPerMember.outputType#")>
      <cfset QuerySetCell(perMemberDue,"inputTypeID","#inputTypeID#")>
      <cfset QuerySetCell(perMemberDue,"outputTypeID","#outputTypeID#")>
			<cfquery name="alreadyPaid" dbtype="query">
      	select rebatable from figuresPerMemberRetrospective where memberID = #memberID#;
      </cfquery>
      <cfset QuerySetCell(perMemberDue,"rebatable","#rebatable-alreadyPaid.rebatable#")>
    </cfloop>
    <cfset figures = StructNew()>
    <cfset figures.total = rebateTotal>
    <cfset figures.perMember = perMemberDue>
    <cfset figures.achieved = achieved>
    <cfset figures.rebateRateQ = rebateRateQ>
    <cfreturn figures>

  </cffunction>
	<cffunction name="getFiguresEntered" returntype="struct">
		<cfargument name="psaID" type="numeric" required="yes">
  	<cfargument name="periodFrom" type="date" required="yes">
		<cfargument name="periodTo" type="date" required="yes">
		<cfargument name="figuresID" type="any" required="yes">
    <cfargument name="rebateRateQ" type="query" required="yes">
  	<cfargument name="inputType" type="numeric" required="yes">
  	<cfargument name="outputType" type="numeric" required="yes">
  	<cfscript>
      var figures = "";
      var figuresTotal = "";
      var achieved = "";
      var rebateTotal = "";
      var figuresPerMember = "";
    </cfscript>
    <cfquery name="figuresTotal" datasource="#dsn.getName()#">
    	select
      	sum(value) as total
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <cfquery name="achieved" dbtype="query" maxrows="1">
    	select * from rebateRateQ where figureFrom < #NumberFormat(figuresTotal.total,"999999999.00")# order by figureFrom desc;
    </cfquery>
    <Cfquery name="rebateTotal" datasource="#dsnRead.getName()#">
    	select
      	sum(value) as total,
        sum(value)/100*#NumberFormat(achieved.rebateValue,"0.00")# as rebatable
      from
      	turnover
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodTo#">
      group by rebateIndexID;
    </Cfquery>
    <Cfquery name="figuresPerMember" datasource="#dsnReadn.getName()#">
    	select
      	sum(value) as total,
        sum(value)/100*#NumberFormat(achieved.rebateValue,"0.00")# as rebatable,
        turnover.memberID,
        #NumberFormat(achieved.rebateValue,"0.00")# as outputType,
        #arguments.inputType# as inputTypeID,
        #arguments.outputType# as outputTypeID,
        known_as
      from
      	turnover,
        company
      where
      	psaID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#psaID#">
      and
      	figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">
      AND
      	period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodTo#">
      AND
      	company.id = turnover.memberID
      group by memberID;
    </Cfquery>
    <cfset figures = StructNew()>
    <cfset figures.total = rebateTotal>
    <cfset figures.perMember = figuresPerMember>
    <cfset figures.achieved = achieved>
    <cfset figures.rebateRateQ = rebateRateQ>
    <cfreturn figures>
  </cffunction>

 	<cffunction name="getTurnover" returntype="query">
 	 <cfargument name="account_number" required="true">
  	<cfargument name="periodFrom" required="false">
  	<cfargument name="periodTo" required="false">
  	<cfset var BMNet = UserStorage.getVar("BMNet")>
  	<cfscript>
      var throughput = "";
    </cfscript>
 	  <cfquery name="throughPut" datasource="#dsnRead.getName()#">
 	    select
			sum(price) as total
      from
				Purchase_Ledger
      WHERE
      account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.account_number#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
 	      <cfif isDefined('arguments.periodFrom')>
			AND
					inv_date BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
			</cfif>

 	    </cfquery>
 	    <cfreturn throughPut>
 	  </cffunction>

  <cffunction name="getTotalMemberThroughPut" returntype="query">
	  <cfargument name="psaID">
    <cfargument name="members">
    <cfscript>
      var throughput = "";
    </cfscript>
	  <cfquery name="throughPut" datasource="#dsnRead.getName()#">
	    select
	        sum(value) as total
	      from
	        turnover
	      where
	        psaID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#psaID#">)
	       AND
	      memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#members#">)
	  </cfquery>
    <cfreturn throughPut>
  </cffunction>

  <cffunction name="getTotalGroupThroughPut" returntype="query">
    <cfargument name="psaID">
    <cfscript>
      var throughput = "";
    </cfscript>
    <cfquery name="throughPut" datasource="#dsnRead.getName()#">
      select
          sum(value) as total
        from
          turnover
        where
          psaID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#psaID#">)
    </cfquery>
    <cfreturn throughPut>
  </cffunction>

 <cffunction name="getThroughPut" returntype="query">
  <cfargument name="dealID" required="true" default="0">
  <cfargument name="figuresID" required="true" default="0">
  <cfargument name="periodFrom">
  <cfargument name="periodTo">
  <cfargument name="members" required="true" default="0">
  <cfargument name="memberOnly" required="true" default="false">
  <cfargument name="strung" required="true" default="false">
  <cfargument name="strungTarget" required="true" default="false">
  <cfscript>
      var figuresPSA = "";
      var inputStreams = "";
      var thispsa = "";
      var fromDiff = "";
      var payments = "";
      var throughPut = "";
      var pt = "";
      var tp = "";
  </cfscript>
  <cfset inputStreams = psa.getFiguresEntryElementsFromList(figuresID)>
  <cfset thispsa = psa.getArrangement(dealID)>
  <cfif strung>
    <cfquery name="payments" datasource="#dsnRead.getName()#" result="pt">
       select sum(rebatePayable) as paymentTotal from rebatePayments
       where
       psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#dealID#">
       AND
       xmlID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#strungTarget#" list="true">)
       AND
       periodFrom >= <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#">
       AND
       periodTo <= <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
     </cfquery>
  </cfif>
  <cfquery name="throughPut" result="tp" datasource="#dsnRead.getName()#">
    select
        <cfif strung AND NOT memberOnly AND payments.paymentTotal neq "">sum(value)-#payments.paymentTotal# as total,
        <cfelse>
        sum(value)  as total,
        </cfif>
        psaID,
        period,
        memberID
      from
        turnover
      where
      <cfif members neq 0>
        memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#members#" list="true">)
      and
      </cfif>
      <cfif figuresID neq 0>
        <cfif inputStreams.recordCount gte 1>
        (
        </cfif>
        <cfloop query="inputStreams">

        <cfif inputStreams.psaID neq arguments.dealID>
          <cfset figuresPSA = psa.getArrangement(psaID)>
          <cfset fromDiff = DateDiff("yyyy",thispsa.period_from,figuresPSA.period_from)>

          <cfset periodFrom = CreateDate(Year(DateAdd("yyyy",fromDiff,thispsa.period_from)),month(arguments.periodFrom),day(arguments.periodFrom))>
          <cfset periodTo = CreateDate(Year(DateAdd("yyyy",fromDiff,thispsa.period_from)),month(arguments.periodTo),day(arguments.periodTo))>
          <cfset logger.debug("#periodFrom#,#periodTo#")>
        </cfif>
        <cfif currentRow neq 1>
        OR
        </cfif>
        (
          figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        AND
          (period >= <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND period <= <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">)
        )
        </cfloop>
        <cfif inputStreams.recordCount gte 1>
        )
        </cfif>
      <cfelse>
        period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
      </cfif>
      <cfif memberOnly> group by memberID</cfif>
    </cfquery>

    <cfset logger.debug("#throughPut.total#")>
    <cfreturn throughPut>
  </cffunction>

<cffunction name="getMemberTurnover" returntype="query">
 <cfargument name="psaID" required="true" default="0">
  <cfargument name="figuresID" required="true" default="0">
  <cfargument name="periodFrom">
  <cfargument name="periodTo">
  <cfargument name="members" required="true" default="0">
  <cfargument name="allbut" required="true" default="false" type="boolean">
  <cfscript>
      var throughput = "";
    </cfscript>
  <cfquery name="throughPut" datasource="#dsnRead.getName()#">
    select
       sum(value) as total,
        period,
        memberID
      from
        turnover
      where
      <cfif allbut>
        memberID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#members#" list="true">)
      <cfelse>
        memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#members#" list="true">)
      </cfif>
      and
        period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
        group by period;
    </cfquery>
    <cfreturn throughPut>
  </cffunction>

  <cffunction name="getTotalThroughPut" returntype="any">
    <cfargument name="psaID">
  <cfargument name="figuresID">
  <cfargument name="periodFrom">
  <cfargument name="periodTo">
    <cfargument name="members">
    <cfscript>
      var throughput = "";
    </cfscript>
  <cfquery name="throughPut" datasource="#dsnRead.getName()#">
    select
        sum(value) as total
      from
        turnover
      where
        psaID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#psaID#">
              <cfif members neq 0>
      and
        memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#members#" list="true">)
      </cfif>
      and
        figuresID IN (<cfqueryparam cfsqltype="cf_sql_integer"  value="#figuresID#" list="true">)
      AND
        period BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">;
    </cfquery>
    <cfreturn throughPut>
  </cffunction>

  <cffunction name="targetCalculations" returntype="query">
    <cfargument name="psaID">
    <cfargument name="xmlID">
    <cfscript>
      var getCalcs = "";
    </cfscript>
    <cfquery name="getCalcs" datasource="#dsnRead.getName()#">
            select sum(OTEThroughput) as OTEThroughput, sum(OTEPayable) as OTEPayable from rebatePayments
            where throughput != 0
            AND
            psaID = <cfqueryparam value="#psaID#" cfsqltype="cf_sql_integer">
            AND
            xmlID = <cfqueryparam value="#xmlID#" cfsqltype="cf_sql_varchar" >
          </cfquery>
          <cfreturn getCalcs>
  </cffunction>


  <cffunction name="getTurnoverIndex" returntype="query">
    <cfargument name="q" type="query" required="true">
    <cfargument name="memberID" required="true" type="numeric">
    <cfscript>
      var thisq = "";
    </cfscript>
    <cfquery name="thisq" dbtype="query">
      select
        total,
        psaID,
        period,
        memberID
      from
        q
      where
        memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
    </cfquery>
    <cfreturn thisq>
  </cffunction>

  <cffunction name="getAdjustedStringTurnver" returntype="query">
    <cfargument name="thisP" required="true">
    <cfargument name="rebateInf" required="true">
    <cfargument name="turnover">
    <cfscript>
      var payments = "";
      var pt = "";
    </cfscript>
		<cfquery name="payments" datasource="#dsnRead.getName()#" result="pt">
		  select
		    sum(rebatePayable) as paymentTotal
		  from
		    rebatePayments
		  where
		    psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisP.memberinputTurnover.psaID#">
		  AND
		    xmlID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rebateInf.strungTarget#" list="true">)
		  AND
		    memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisP.memberinputTurnover.memberID#">
		  AND
		    periodFrom >= <cfqueryparam cfsqltype="cf_sql_date" value="#thisP.periodFrom#">
		  AND
		    periodTo <= <cfqueryparam cfsqltype="cf_sql_date" value="#thisP.periodTo#">
		</cfquery>
    <cfset turnover.total = javaCast("float",(turnover.total - payments.paymentTotal))>
    <cfreturn turnover>
  </cffunction>







  <cffunction name="calculateRebate" returntype="any" output="yes">
  	<cfargument name="psaID" required="yes">
    <cfargument name="arrangementQ" required="yes">
    <cfargument name="debug" required="yes" default="false">
    <cfscript>
      var eGroup = UserStorage.getVar("eGroup");
      var figuresLastDate = getLastInputDate(psaID);
      var dealXML = "";
      var xpathExp = "";
      var rebateNodes = "";
      var psaFrom = "";
      var psaTo = "";
      var rebateInfo = "";
      var thisPeriod = "";
      var rebateElement = "";
      var c = "";
      var dealXML = "";
      var pp = "";
      var exists = "";
      var insertPayments = "";
    </cfscript>
    <!--- delete any old figures --->
    <cfset delRebatePayments(psaID)>
    <cfset dealXML = XmlParse(arrangementQ.dealData)>
		<cfset xpathExp = "//component[calculate='true']">
		<cfset rebateNodes = XMLSearch(dealXML,xpathExp)>
    <cfset psaFrom = arrangementQ.period_from>
		<cfset psaTo = DateAdd("d",40,arrangementQ.period_to)>

		<cfloop array="#rebateNodes#" index="rebateElement">
      <cfset rebateInfo = createRebateStruct(rebateElement,psaFrom,psaTo)>
      <cfloop from="1" to="#rebateInfo.periods#" step="#rebateInfo.months#" index="c"><!--- loop through as many months as there are in the period calculation period --->
        <cfset thisPeriod = createPeriodStruct(psaID,rebateInfo,c)>
        <cfloop query="thisPeriod.memberinputTurnover">
          <cfset thisPeriod.thisMember = {}>
          <cfset thisPeriod.thisMember.output = getTurnoverIndex(thisPeriod.memberoutputTurnover,memberID)>
          <cfset thisPeriod.thisMember.input = getTurnoverIndex(thisPeriod.memberinputTurnover,memberID)>
	        <cfif rebateInfo.strung>
            <cfset thisPeriod.thisMember.input = getAdjustedStringTurnver(thisPeriod,rebateInfo,thisPeriod.thisMember.input)>
	        </cfif>
          <cfif rebateInfo.rebateType eq "individual">
            <cfset thisPeriod.inputTurnover = thisPeriod.thisMember.input>
            <cfset thisPeriod.outputTurnover = thisPeriod.thisMember.output>
          <cfelseif rebateInfo.rebateType eq "individualgrowth">
	          <cfset thisPeriod.inputTurnover = thisPeriod.thisMember.input>
	          <cfset thisPeriod.outputTurnover = thisPeriod.thisMember.output>
            <cfquery name="pp" dbtype="query">
              select
                *
              from
                thisPeriod.targetTurnover
              where
                memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
            </cfquery>
            <cfset thisPeriod.targetTurnover = pp>
          </cfif>
          <cfset thisPeriod = doAverageCalcs(rebateInfo,thisPeriod,psaID)>
          <cfset thisPeriod = getRebateLevels(rebateInfo.thisPeriod,psaID)>
          <!--- check to see if a rebate payment already exists --->
          <cfquery name="exists" datasource="#dsnRead.getName()#">
            select id from rebatePayments
            WHERE
            psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
            AND
            memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
            AND
            periodFrom = <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodFrom#">
            AND
            periodTo = <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodTo#">
            AND
            xmlID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rebateInfo.xmlID#">
          </cfquery>
          <cfif exists.recordCount gte 1>
            <cfquery name="insertPayments" datasource="#dsn.getName()#">
            update rebatePayments
            set
              throughput = <cfqueryparam cfsqltype="cf_sql_decimal" value="#thisPeriod.thismember.input.total#">,
              rebateValue = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.rebateValue#">,
              rebateAmount = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.insert_rebatePayable#">,
              rebatePayable = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.x_rebatePayable#">,
              periodName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#thisPeriod.theElement.periodName#">,
              OTEValue = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.OTEValue#">,
              OTEThroughput = <cfqueryparam cfsqltype="cf_sql_float" value="#numberFormat(thisPeriod.OTETurnoverTotalMember,"9999999999.00")#">,
              OTEPayable = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.insert_rebatePayableOTE#">,
              figuresLastDate = <cfqueryparam cfsqltype="cf_sql_date" value="#figuresLastDate#">
            WHERE
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#exists.id#">
            </cfquery>
          <cfelse>
            <cfquery name="insertPayments" datasource="#dsn.getName()#">
            insert into rebatePayments
              (psaID, memberID,periodFrom,periodTo,throughput,rebateValue,rebateAmount,rebatePayable,xmlID,periodName,OTEValue,OTEThroughput,OTEPayable,figuresDate)
            VALUES
              (
              <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,
              <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodFrom#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodTo#">,
              <cfqueryparam cfsqltype="cf_sql_decimal" value="#total#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.rebateValue#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.insert_rebatePayable#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.x_rebatePayable#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#rebateInfo.xmlID#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#thisPeriod.periodName#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.OTEValue#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#numberFormat(thisPeriod.OTETurnoverTotalMember,"9999999999.00")#">,
              <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.insert_rebatePayableOTE#">,
              <cfqueryparam cfsqltype="cf_sql_date" value="#figuresLastDate#">
              )
            </cfquery>
          </cfif>

		    </cfloop>
	    </cfloop>
  	</cfloop>

  </cffunction>

  <cffunction name="getCalculations" returntype="query">
  	<cfargument name="psaID" required="yes">
    <cfargument name="memberID" required="yes" default="0">
    <cfset var getCalQ = "">
    <cfquery name="getCalQ" datasource="#dsnRead.getName()#">
    	select * from rebatePayments, company
      where throughput != 0
      AND
      company.id = rebatePayments.memberID
      AND
      psaID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#psaID#">)
      <cfif memberID neq 0>
      AND
      rebatePayments.memberID = '#memberID#'
    	</cfif>
      order by xmlID, periodfrom, known_as, periodName;
    </cfquery>
    <cfreturn getCalQ>
  </cffunction>

  <cffunction name="getCalculationsBySupplier" returntype="query">
    <cfargument name="psaID" required="yes">
    <cfargument name="memberID" required="yes" default="0">
    <cfset var getCalcDB = "">
    <cfquery name="getCalcDB" datasource="#dsnRead.getName()#">
      select * from rebatePayments, company
      where throughput != 0
      AND
      company.id = rebatePayments.memberID
      AND
      psaID = '#psaID#'
      <cfif memberID neq 0>
      AND
      rebatePayments.memberID = '#memberID#'
      </cfif>
      order by xmlID, periodfrom, known_as, periodName;
    </cfquery>
    <cfreturn getCalcDB>
  </cffunction>

  <cffunction name="getCalculationPeriod" returntype="query">
    <cfargument name="paymentID" required="true" default="0">
    <cfargument name="psaID" required="true">
    <cfargument name="xmlID" required="true">
    <cfargument name="periodName" required="true">
    <cfscript>
      var calcInfo = "";
      var getCalcDB = "";
    </cfscript>
    <cfif paymentID neq 0>
      <!--- we need the extra info from the payment ID --->
      <cfquery name="calcInfo" datasource="#dsnRead.getName()#">
        select xmlID, psaID, periodName from rebatePayments where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentID#">
      </cfquery>
      <cfset psaID = calcInfo.psaID>
      <cfset xmlID = calcInfo.xmlID>
      <cfset periodName = calcInfo.periodName>
    </cfif>
    <cfquery name="getCalcDB" datasource="#dsnRead.getName()#">
      select * from rebatePayments, company
      where throughput != 0
      AND
      company.id = rebatePayments.memberID
      AND

      psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
      AND
      xmlID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlID#">
      AND
      periodName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#periodName#">
      order by known_as;
    </cfquery>
    <cfreturn getCalcDB>
  </cffunction>



  <cffunction name="wipeFigures" returntype="any">
    <cfargument name="psaID">
    <cfargument name="period">
    <cfset var remove = "">
    <cfquery name="remove" datasource="#dsn.getName()#">
      delete from turnover
      where
      psaID = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
      AND
      period = <cfqueryparam cfsqltype="cf_sql_date" value="#period#">
    </cfquery>
  </cffunction>

  <cffunction name="upDateFiguresStatus" returntype="any">
  	<cfargument name="psaID">
    <cfargument name="status">
    <cfset var updateDeal = "">
    <cfquery name="updateDeal" datasource="#dsn.getName()#">
    	update arrangement set figures = '#status#', lastModified = lastModified where id = '#psaID#';
    </cfquery>
  </cffunction>

<cffunction name="getJob" returntype="boolean">
  <cfargument name="psaID">
  <cfset var getjob = "">
  <cfquery name="getjob" datasource="#dsnRead.getName()#">
    select * from calculationJob where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
  </cfquery>
  <cfif getjob.recordCount eq 0>
    <cfreturn false>
  <cfelse>
    <cfreturn true>
  </cfif>
</cffunction>

  <cffunction name="setPaid" returntype="Any">
    <cfargument name="paymentID" required="true" default="0">
    <cfargument name="paid" required="true">
    <cfargument name="psaID" required="true">
    <cfargument name="xmlID" required="true">
    <cfargument name="periodName" required="true">
    <cfargument name="datasource" default="">
    <cfset var setit = "">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="setit" datasource="#arguments.datasource#">
      update rebatePayments set paid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paid#">
      where
      <cfif paymentID neq 0>
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentID#">
      <cfelse>
        psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
        AND
        xmlID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlID#">
        AND
        periodName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#periodName#">
      </cfif>
    </cfquery>
  </cffunction>

  <cffunction name="figuresStatus" returntype="string">
  	<cfargument name="psaID" required="yes">
  	<cfset var getS = "">
    <cfquery name="getS" datasource="#dsnRead.getName()#">
    	select figures from arrangement where id = '#psaID#';
    </cfquery>
    <cfreturn getS.figures>
  </cffunction>

  <cffunction name="figuresExist" returntype="boolean">
  	<cfargument name="psaID" required="yes">
  	<cfset var figures = "">
    <cfquery name="figures" datasource="#dsnRead.getName()#">
    	select id from rebatePayments where psaID = '#psaID#';
    </cfquery>
    <cfif figures.recordCount gte 1>
    	<cfreturn true>
    <cfelse>
    	<cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="repairPSA" returntype="string">
    <cfargument name="psaID" required="true">
    <cfset var figsExists = "">
    <cfset var createFigs = "">
    <cfquery name="figsExists" datasource="#dsnRead.getName()#">
      select figuresID, rebateIndexID from turnover where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
    </cfquery>
    <cfif figsExists.recordCount eq 0>
      <cfreturn "There have not been figures entered, so cannot repair">
    <cfelse>
      <cfloop query="figsExists">
        <cfif figuresID neq "">
        <cfquery name="createFigs" datasource="#dsn.getName()#">
          insert into figuresEntry (id,psaID,inputName,inputTypeID)
          VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#figuresID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Turnover">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">
          )
        </cfquery>
        </cfif>
      </cfloop>
      <cfreturn "Figures have been recreated with defaults.">
    </cfif>
  </cffunction>

	<cffunction name="importData" returnType="any" access="public">
    <cfargument name="psaID" required="true" type="numeric">
    <cfargument name="file" required="true" type="string">
    <cfargument name="deal" required="true">
    <cfscript>
      var psaData = "";
      var rebateIndexArray = "";
      var rebateNodes = "";
      var workBook = "";
      var workBookInfo = "";
      var queryCells = "";
      var figuresIDs = "";
      var columnL = "";
      var c = "";
      var rc = {};
      var memberID = "";
      var figuresID = "";
      var thePeriod = "";
      var r = "";
      var i = "";
      var x = "";
      var existing = "";
      var insertFigures = "";
    </cfscript>
    <cfset psaData = xmlParse(deal)>
    <cfset rebateIndexArray = ArrayNew(1)>
    <cfset rebateNodes = psa.getTurnoverElements(psaData)>
    <cfloop array="#rebateNodes#" index="r">
      <cfset arrayAppend(rebateIndexArray,"#r.id.xmlText#")>
    </cfloop>
    <cfset workBook = spreadSheetRead(file)>
    <cfset workBookInfo = spreadSheetInfo(workBook)>
    <cfset queryCells = QueryNew("psaID,period,memberID,figuresID,value","integer,date,integer,integer,Decimal")>
    <cfspreadSheet excludeHeaderRow="true" action="read" src="#file#" sheet="1" query="sheetQuery" /> <!--- get the sheet query --->
    <cfset figuresIDs = ArrayNew(1)>
    <cfset columnL = ListToArray(sheetQuery.columnList)>
    <cfloop from="2" to="#arrayLen(columnL)#" index="c">
      <cfset c = sheetQuery[columnL[c]][1]>
      <cfset ArrayAppend(figuresIDs,ListFirst(c," "))>
    </cfloop>
     <cfloop from="1" to="#workBookInfo.sheets#" index="i">
        <!--- loop through each sheet --->
        <cfset rc.test[i] = structNew()>
        <cfspreadSheet action="read" src="#file#" sheet="#i#" query="sheetQuery" />
        <cfset sheetRow = 2>
        <cfloop query="sheetQuery" startrow="2">
          <cfset rc.x = sheetQuery["COL_1"][sheetRow]>
          <cfif rc.x neq "TOTAL">
            <cfset memberID = company.getCompanyIDByKnownAs(rc.x)>
            <cfset logger.debug("memberID: #memberID#")>
            <cfloop from="2" to="#ArrayLen(columnL)#" index="x">
              <cfset figuresID = figuresIDs[x-1]>
              <cfset thePeriod = getPeriodFromString(ListGetAt(workBookInfo.sheetnames,i))>
              <!--- insert the figures --->
              <cfset QueryAddRow(queryCells)>
              <cfset QuerySetCell(queryCells,"psaID",psaID)>
              <cfset QuerySetCell(queryCells,"period",thePeriod)>
              <cfset QuerySetCell(queryCells,"memberID",memberID)>
              <cfset QuerySetCell(queryCells,"figuresID",figuresID)>
              <cfset QuerySetCell(queryCells,"value",replace(sheetQuery[columnL[x]][sheetRow],",","","ALL"))>
            </cfloop>
          </cfif>
          <cfset sheetRow++>
        </cfloop>
      </cfloop>
      <cfset logger.debug("Length: #queryCells.recordCount#")>
      <cfloop query="queryCells">
          <cfquery name="existing" datasource="#dsn.getName()#">
            select id from turnover where
            psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCells.psaID#">
            AND
            period = <cfqueryparam cfsqltype="cf_sql_date" value="#queryCells.period#">
            AND
            memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryCells.memberID#">
            AND
            figuresID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCells.figuresID#">
          </cfquery>
          <cfif existing.recordCount gte 1>
            <cfif queryCells.value neq 0>
              <cfquery name="insertFigures" datasource="#dsn.getName()#">
               update turnover set
                value =  <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
               where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#existing.id#">
              </cfquery>
            </cfif>
          <cfelse>
            <cfquery name="insertFigures" datasource="#dsn.getName()#">
               insert into turnover (psaID,period,memberID,figuresID,value)
               VALUES (
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#queryCells.psaID#">,
                 <cfqueryparam cfsqltype="cf_sql_date" value="#queryCells.period#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#queryCells.memberID#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryCells.figuresID#">,
                 <cfqueryparam cfsqltype="cf_sql_float" value="#queryCells.value#">
               )
             </cfquery>
          </cfif>
       </cfloop>
     <cfreturn queryCells>
  </cffunction>

  <cffunction name="renderPivots" returntype="Query" access="public">
    <cfargument name="periodYear">
    <cfset var data = "">
    <cfquery datasource="#dsnRead.getName()#" name="data">
      select
        cat.name as category,
        parentCat.name as parentCategory,
        a.name as ArrangementName,
        t.period as period,
        f.inputName,
        c_a.known_as AS SupplierName,
         c_ret.known_as AS Member,
        u.type,
        t.value
      from
        turnover as t,
        figuresEntry as f,
        arrangement as a,
        dealCategory as dc,
        company as c_a,
        company as c_ret,
        contactGroup as cat,
          unitType as u,
        contactGroupRelation,
        contactGroup as parentCat
      where
        a.id = t.psaID
        AND
        (
            year(a.period_from) = '#periodYear#'
            OR
            year(a.period_to) = '#periodYear#'
        )
        AND
        c_ret.id = t.memberID
        AND
        f.id = t.figuresID
        AND
        c_a.id = a.company_id
        AND
        cat.id = dc.categoryID
        AND
        parentCat.id = contactGroupRelation.parentID
        AND
        contactGroupRelation.oID = cat.id
        AND
        contactGroupRelation.oType = 'group'
        AND
        dc.psaID = a.id
          AND
        u.id = f.inputTypeID
        order by period asc
    </cfquery>
    <cfreturn data>
  </cffunction>

  <cffunction name="renderPivotRebate" returntype="Query" access="public">
    <cfargument name="periodYear">
    <cfset var data = "">
    <cfquery datasource="#dsnRead.getName()#" name="data">
    select
        cat.name as category,
        parentCat.name as parentCategory,
        a.name as ArrangementName,
        rp.xmlID as xmlID,
        rp.periodFrom,
        a.period_from,
        a.period_to,
        rp.periodTo,
        c_a.known_as AS SupplierName,
        c_ret.known_as AS Member,
        rebateElement(rp.psaID, rp.xmlID) as rebateName,
        getPayableTo(rp.psaID, rp.xmlID) as payableTo,
        rp.throughPut,
        rp.rebateValue,
        rp.rebateAmount,
        rp.rebatePayable,
        rp.paid
      from
        rebatePayments as rp,
        arrangement as a,
        dealCategory as dc,
        company as c_a,
        company as c_ret,
        contactGroup as cat,
        contactGroupRelation,
        contactGroup as parentCat
      where
        rp.periodTo <= now()
        AND
        rp.throughput != 0
        AND
        a.id = rp.psaID
        AND
        (
            year(a.period_from) = '#periodYear#'
            OR
            year(a.period_to) = '#periodYear#'
        )
        AND
        c_ret.id = rp.memberID
        AND
        c_a.id = a.company_id
        AND
        cat.id = dc.categoryID
        AND
        parentCat.id = contactGroupRelation.parentID
        AND
        contactGroupRelation.oID = cat.id
        AND
        contactGroupRelation.oType = 'group'
        AND
        dc.psaID = a.id
          order by periodFrom asc
    </cfquery>
    <cfreturn data>
  </cffunction>

  <cffunction name="getPaymentDetail" returntype="Query" access="public">
    <cfargument name="paymentID" required="true" default="0" type="numeric">
    <cfset var paymentDetail = "">
    <cfset var deal = "">
    <cfset var dealData = "">
    <cfset var rebateElement = "">
    <cfquery name="paymentDetail" datasource="#dsnRead.getName()#">
      select
			  arrangement.name as dealName,
        arrangement.id as psaID,
        arrangement.company_id,
			  company.name as supplierName,
			  rebatePayments.periodFrom,
			  rebatePayments.periodTo,
        rebatePayments.rebatePayable,
			  rebatePayments.xmlID,
			  "XMLRef"
			from
			  arrangement,
			  company,
			  rebatePayments
			where
			  rebatePayments.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentID#">
			  AND
			  arrangement.id = rebatePayments.psaID
			  AND
			  company.id = arrangement.company_id
    </cfquery>
    <cfset deal = psa.getArrangement(paymentDetail.psaID)>
    <cfset dealData = xmlParse(deal.dealData)>
    <cfset rebateElement = psa.getElementByID(paymentDetail.xmlID,dealData)>
    <cfset paymentDetail.XMLref = rebateElement[1].title.xmlText>
    <cfreturn paymentDetail>
  </cffunction>




  <!--- PRIVATE FUNCTIONS --->

  <cfscript>

    private Struct function createRebateStruct(rebateElement,arrangementFrom,arrangementTo) {
      var rebateInfo = {}; //create an empty structure to return

      // DATE RANGES //
      if (isDefined('rebateElement.dateRange')) { // if this element has a specific date range
        rebateInfo.dateRange = rebateElement.dateRange.xmlText; // boolean value - is element date restricted?
        rebateInfo.dateRangeFrom = rebateElement.dateRange.xmlAttributes.datefrom; // date range restriction start date
        rebateInfo.dateRangeTo = rebateElement.dateRange.xmlAttributes.dateto; // date range restriction end date
        if (rebateInfo.dateRange) { // if the element is date restricted
          if (DateCompare(rebateInfo.dateRangeFrom,arrangementFrom,"d") lte 0) { // compare the dates of the range start to the deal start
            rebateInfo.dateRangeFrom = arrangementFrom; // date date range begins before the deal - doesn't make sense so use the deal start date!
          }
          if (DateCompare(rebateInfo.dateRangeTo,arrangementTo,"d") gte 0) { // compare the range end to the deal end
            rebateInfo.dateRangeTo = arrangementTo; // the ends ends after the deal ends, doesn't make sense so use the deal end date
          }
        } else {
          rebateInfo.dateRangeFrom = arrangementFrom; // there is no date range, so use the deal start date
          rebateInfo.dateRangeTo = arrangementTo; // there is no date range, so use the dal end date
        }
      } else {
        rebateInfo.dateRange = false; // rebate element isn't date restricted
      }

      // MEMBER RESTRICTIONS
      if (isDefined('rebateElement.memberRestrictions')) { // is there member restricions?
        rebateInfo.memberRestrictions = rebateElement.memberRestrictions.xmlText; // set the boolean flag
        rebateInfo.membersParticipating = rebateElement.memberRestrictions.xmlAttributes.MEMBERSPARTICIPATING; // set the members who are participating
        if (rebateInfo.memberRestrictions) { // is there member restrictions?
          rebateInfo.members = rebateInfo.membersParticipating; // if there is, we need the list of which members to include in the calculation.
        } else {
          rebateInfo.members = 0; // otherwise set members to 0 - i.e all members
        }
      } else {
        rebateInfo.memberRestrictions = false; // no member restrictions
      }

      // RETROSPECTIVE
      if (isDefined('rebateElement.nonretrospective')) { // is the element non-retrospective? In other words, does it pay rebate on their entire amount, or just the amount in the current step?
        rebateInfo.nonretrospective = rebateElement.nonretrospective.xmlText; // set a boolean value for non-retrospectgive
      } else {
        rebateInfo.nonretrospective = false; // element is retrospective
      }

      rebateInfo.xmlID = rebateElement.id.XmlText;

       /*
        Legacy code - self target doesn't exist anymore as we have input/output types instead
       if (isDefined('rebateElement.selfTarget')) { // does self target attribute exist?
          if (rebateElement.selfTarget.xmlText eq "inherit") { // if so, are we using another band?
            rebateInfo.selfTarget = false; // we are not using our own target bands
            rebateInfo.theTarget = rebateElement.selfTarget.xmlAttributes.inheritTargetsFrom; // we're using the target bands from another element
            } else {
            rebateInfo.selfTarget = true; // yes, use our own bands
          }
        } else {
            rebateInfo.selfTarget = true; // yes, use our own bands
        }
        */


      // REBATE TYPE INFORAMTION
      rebateInfo.rebateType = {};

      if (NOT isDefined('rebateElement.rebateType.xmlAttributes.name')) {
        rebateElement.rebateType.xmlAttributes.name = rebateElement.rebateElement.rebateType.xmlText;
      }

      rebateInfo.rebateType.name = rebateElement.rebateType.xmlAttributes.name;
      rebateInfo.rebateType.id = rebateElement.rebateType.xmlAttributes.id;
      rebateInfo.rebateType.target = rebateElement.target.xmlAttributes.figures;
      rebateInfo.rebateType.figures = rebateElement.target.xmlAttributes.figures;
      rebateInfo.rebateType.dateFrom = rebateElement.target.xmlAttributes.dateFrom;
      rebateInfo.rebateType.dateTo = rebateElement.target.xmlAttributes.dateTo;

      rebateInfo.outputType = rebateElement.outputType.xmlText; // the output type (hopefully percent!)

      // STEP INFORAMTION
      if (isDefined('rebateElement.step')) { // are there steps/bands in this rebate?
        rebateInfo.steps = true; // yes - set a boolean flag for easy reference
        rebateInfo.rebateSteps = QueryNew("figureFrom,figureTo,rebateValue"); // create a empty query to put the bands in
        for (z=1;z lte ArrayLen(rebateElement.step); z=z+1) { // loop through the rebate bands
          QueryAddRow(rebateInfo.rebateSteps); // add a row to our query
          QuerySetCell(rebateInfo.rebateSteps,"figureFrom",vNum(rebateElement.step[z].from.xmlText)); // put the from band into our query object
          QuerySetCell(rebateInfo.rebateSteps,"figureTo",vNum(rebateElement.step[z].to.xmlText)); // put the to band into our query object (not really needed)
          QuerySetCell(rebateInfo.rebateSteps,"rebateValue",numberFormat(vNum(rebateElement.step[z].value.xmlText),"99999999999999999.00")); // put the rebate amount into our query object
        }
      } else {
        rebateInfo.steps = false; // no - there are no steps/bands - it must be a simple rebate
        rebateInfo.rebateValue = rebateElement.value.xmlText; // in which case, the rebate value is a numeric value
      }

      // COMPOUND INFO
      if (rebateElement.compound.xmlText eq "true") { // do we need to take into account other figures - compound?
        rebateInfo.compound = true; // yes we do
        rebateInfo.compoundTarget = rebateElement.compound.xmlAttributes.compoundAgainst; // the element we need to compound against
      } else { // no
        rebateInfo.compound = false; // no compound calculations required
      }

      // STRING REBATES INFO
      if (isDefined('rebateElement.strung') AND rebateElement.strung.xmlText neq "false") { // do we need to take into account other figures - strung?
        rebateInfo.strung = true; // yes we do
        rebateInfo.strungType = rebateElement.strung.xmlText; // set the strung type - on the input stream, the output stream, or both
        rebateInfo.strungTarget = rebateElement.strung.xmlAttributes.strungAgainst; // the element we need to compound against
      } else { // no
        rebateInfo.strung = false; // no string rebate
        rebateInfo.strungType = "false";
        rebateInfo.strungTarget = "";
      }

      // INPUT AND OUTPUT SOURCES
      if (isDefined('rebateElement.inputSources.xmlAttributes.id') and isDefined('rebateElement.outputSources.xmlAttributes.id')) {
         rebateInfo.inputSources = rebateElement.inputSources.xmlAttributes.id; // set the input streams for this rebate element
         rebateInfo.outputSources = rebateElement.outputSources.xmlAttributes.id; // the output streams for this rebate element
      } else {
       throw("cannot calculate without input sources!"); // if no input/output stream is selected, cannot do any calculations!
      }

      /// REBATE PERIODS INFO
      rebateInfo.periods = DateDiff("m",rebateInfo.dateRangeFrom,rebateInfo.dateRangeTo); // how many months between the start date and end date of this agreement or date restricted rebate element?
      switch (rebateElement.period.XmlText) {
        case "biannual":
          rebateInfo.months = 24;
          break;
        case "annual":
          rebateInfo.months = 12;
          break;
        case "sixmonth":
          rebateInfo.months = 6;
          break;
        case "quarterly":
          rebateInfo.months = 3;
          break;
        case "bimonthly":
          rebateInfo.months = 2;
          break;
        case "monthly":
          rebateInfo.months = 1;
          break;
      }

      // END - RETURN REBATE STRUCTURE
      return rebateInfo;
    }



    // CREATE A REBATE PERIOD STRUCTURE - THERE SHOULD BE ONE STRUCTURE FOR EACH REBATE PERIOD ITERATION

    private Struct function createPeriodStruct(psaID,rebateInf,currentIndex) {
      var rebateInfo = arguments.rebateInf;
      var thisPeriod = {}; // create an empty struct to return
      thisPeriod.periodFrom = DateAdd("m",c-1,rebateInfo.dateRangeFrom); // the element period from date
      thisPeriod.periodTo = DateAdd("m",rebateInfo.months+c-1,rebateInfo.dateRangeFrom); // the element period to date
      thisPeriod.periodName = "Period #c#"; // the period name (period 1, 2 etc.)

      if (rebateInfo.dateRange) { // if this rebate element is date restricted
        if (DateCompare(rebateInfo.dateRangeFrom,thisPeriod.periodFrom,"d") gt 0) {
          thisPeriod.periodFrom = rebateInfo.dateRangeFrom;
        }
        if (DateCompare(rebateInfo.dateRangeTo,thisPeriod.periodTo,"d") lt 0) {
          thisPeriod.periodTo = rebateInf.dateRangeTo;
        }
      }
      thisPeriod.periodTo = DateAdd("d",-1,thisPeriod.periodTo); // minus one day from the period - so the period runs from (for example) Jan 1st to Jan 31st, and not Jan 1st to Feb 1st

      if (rebateInfo.rebateType.name eq "groupgrowth" OR rebateInfo.rebateType.name eq "individualgrowth") {
        thisPeriod.growth.Turnover = getThroughPut(
         rebateInf.rebateType.id,
         rebateInf.rebateType.figures,
         rebateInf.rebateType.dateFrom,
         rebateInf.rebateType.dateTo,
         rebateInf.members
       );
      }
      if (rebateInfo.strung AND rebateInfo.strungType eq "input" OR rebateInfo.strungType eq "both") {
         thisPeriod.members.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,rebateInfo.strung,rebateInfo.strungTarget);
         thisPeriod.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInf.members,false,rebateInfo.strung,rebateInfo.strungTarget);
      } else {
         thisPeriod.members.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,false,"");
         thisPeriod.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,false,"");
      }

      if (rebateInfo.inputSources neq rebateInfo.outputSources) {
       // we've got a different input to output;
       if (rebateInfo.strung AND rebateInfo.strungType eq "output" OR rebateInfo.strungType eq "both") {
         thisPeriod.members.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,rebateInfo.strung,rebateInfo.strungTarget);
         thisPeriod.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,rebateInfo.strung,rebateInfo.strungTarget);
       } else {
         thisPeriod.members.output = getThroughPut(psaID,rebateInf.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInf.members,true,false,"");
         thisPeriod.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInf.members,false,false,"");
       }

      } else {
       thisPeriod.output = thisPeriod.input;
       thisPeriod.members.output = thisPeriod.members.input;
      }
      return thisPeriod;
    }
  </cfscript>

  <cffunction name="getRebateLevels" returntype="struct" access="private">
    <cfargument name="rebateInf">
    <cfargument name="thisP">
    <cfargument name="psaID">

    <cfscript>
      var rebateInfo = arguments.rebateInf;
      var thisPeriod = arguments.thisP;
      var thisMemPerc = "";
      var grouprebate  = "";
      var insert_rebatePayableOTE = "";
      var getTarget = "";
      var getOTETarget = "";
      var getTargetRetro = "";
      var getOTETargetRetro = "";
    </cfscript>
    <cfif rebateInfo.steps>
      <cfif rebateInfo.rebateType.name eq "individualgrowth" OR rebateInfo.rebateType.name eq "groupgrowth">
          <cfif thisPeriod.growth.Turnover.recordCount neq 0 AND thisPeriod.growth.Turnover.total neq 0 AND thisPeriod.input.total neq 0> <!--- we can only work out a comparison percentage if both the current turnover and the grwoth turnover have data --->
            <cfset thisPeriod.growth.Percentage = round(((int(thisPeriod.inputTurnover.total)-int(thisPeriod.targetTurnover.total))/int(thisPeriod.targetTurnover.total))*100)>
            <cfset thisPeriod.comparisonPercentageOTE = round(((int(thisPeriod.OTETurnoverTotal)-int(thisPeriod.targetTurnover.total))/int(thisPeriod.targetTurnover.total))*100)>
          <cfelse>
            <cfset thisPeriod.comparisonPercentage = 0>
            <cfset thisPeriod.comparisonPercentageOTE = 0>
          </cfif>
        <cfquery name="getTarget" dbtype="query">
          select rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.comparisonPercentage,"999999999.00")# order by figureFrom desc;
        </cfquery>
        <cfquery name="getOTETarget" dbtype="query">
          select rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.comparisonPercentageOTE,"999999999.00")# order by figureFrom desc;
        </cfquery>
      <cfelse>
        <cfquery name="getTarget" dbtype="query">
          select rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.inputTurnover.total,"999999999.00")# order by figureFrom desc;
        </cfquery>
        <cfquery name="getOTETarget" dbtype="query">
          select rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.OTETurnoverTotal,"999999999.00")# order by figureFrom desc;
        </cfquery>
      </cfif>
      <cfset thisPeriod.rebateValue = getTarget.rebateValue>
      <cfset thisPeriod.OTEValue = getOTETarget.rebateValue>
    <cfelse>
      <cfset thisPeriod.OTEValue = rebateInf.rebateValue>
      <cfset thisPeriod.rebateValue = rebateInf.rebateValue>
    </cfif>
    <cfif Not isNumeric(thisPeriod.rebateValue)>
      <cfset thisPeriod.rebateValue = 0>
    </cfif>
    <cfif Not isNumeric(thisPeriod.OTEValue)>
      <cfset thisPeriod.OTEValue = 0>
    </cfif>
    <cfif rebateInfo.compound>
      <cfset thisPeriod.totalToRemove = getCalculationsForCompound(psaID,memberID,rebateInf.compoundTarget,thisPeriod.periodFrom,thisPeriod.periodTo)>
    <cfelse>
      <cfset thisPeriod.totalToRemove = 0>
    </cfif>
    <cfif rebateInfo.nonretrospective>
      <!--- things get more complicated here --->

      <!--- first lets grab the turnover but this time in ascending order --->
      <cfif rebateInfo.rebateType.name eq "individualgrowth" OR rebateInfo.rebateType.name eq "groupgrowth">
        <cfset thisPeriod.comparisonPercentage = round(((int(thisPeriod.inputTurnover.total)-int(thisPeriod.targetTurnover.total))/int(thisPeriod.targetTurnover.total))*100)>
        <cfset thisPeriod.comparisonPercentageOTE = round(((int(thisPeriod.OTETurnoverTotal)-int(thisPeriod.targetTurnover.total))/int(thisPeriod.targetTurnover.total))*100)>
        <cfset thisPeriod.levelHit = thisPeriod.comparisonPercentage>
        <cfset thisPeriod.levelHitOTE = thisPeriod.comparisonPercentageOTE>
      <cfelse>
        <cfset thisPeriod.levelHit = thisPeriod.inputTurnover.total>
        <cfset thisPeriod.levelHitOTE = thisPeriod.OTETurnoverTotal>
      </cfif>
      <cfquery name="getTargetRetro" dbtype="query">
        select figureFrom, figureTo, rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.levelHit,"999999999.00")# order by figureFrom desc;
      </cfquery>
      <cfquery name="getOTETargetRetro" dbtype="query">
        select figureFrom, figureTo, rebateValue from rebateInf.rebateSteps where figureFrom <= #NumberFormat(thisPeriod.levelHitOTE,"999999999.00")# order by figureFrom desc;
      </cfquery>
      <!--- now we have the levels in ascending order, we need to step through them one by one --->
      <cfloop query="getTargetRetro">
        <cfif thisPeriod.thismemberoutput.total neq 0>
        <cfset thisPeriod.retroThroughPut = inputTurnover.total - figureFrom>
        <cfif rebateInfo.outputType eq 6>
        <cfif rebateInfo.rebateType.name eq "individual">
          <cfset thisPeriod.insert_rebatePayable = thisPeriod.insert_rebatePayable + "#thisP.retroThroughPut/100*thisP.rebateValue#">
        <cfelse>
          <!--- we need to work out this member's percentage of the total turnover --->
          <!--- Percentage difference between two numbers X and Y is: Y/X - 1 --->

          <!--- or 100 - (x/y * 100) --->
          <cfset thisPeriod.thisMemPerc = ((thisP.OTETurnoverOutputTotalMember/thisPeriod.OTETurnoverOutputTotal * 100))>
          <cfset thisPeriod.grouprebate = thisP.insert_rebatePayable + "#thisPeriodisP.retroThroughPut/100*thisP.rebateValue#">
          <cfset thisPeriod.insert_rebatePayable = "#thisPeriod.grouprebate/100*thisPeriod.thisMemPerc#">
          <cfset logger.debug("Total Output: #thisPeriod.OTETurnoverOutputTotal#, This Member: #thisPeriod.OTETurnoverOutputTotalMember#, output percent: #thisPeriod.thisMemPerc#")>
        </cfif>

        <cfelseif rebateInf.outputType eq 11>
           <cfset thisPeriod.insert_rebatePayable = thisPeriod.rebateValue/ListLen(membersP)>
        <cfelse>
          <cfset thisPeriod.insert_rebatePayable ="#thisPeriod.retroThroughPut*thisPeriod.rebateValue#">
        </cfif>
        <cfset thisPeriod.thismember.output.total = thisPeriod.thismember.input.total - thisPeriod.retroThroughPut>
        <cfelse>
           <cfset thisPeriod.insert_rebatePayable =0>
        </cfif>
      </cfloop>
      <cfloop query="getOTETargetRetro">
        <cfif thisPeriod.thismember.output.total neq 0>
        <cfset thisPeriod.retroThroughPutOTE = outputTurnover.total - figureFrom>
        <cfif rebateInfo.outputType eq 6>
          <cfif rebateInf.rebateType eq "individual">
            <cfset thisPeriod.insert_rebatePayableOTE = thisPeriod.insert_rebatePayableOTE + "#thisPeriod.retroThroughPutOTE/100*thisP.rebateValue#">
          <cfelse>
            <cfset thisMemPerc = ((thisPeriod.thismember.output.total/thisPeriod.outputTurnover.total * 100))>
            <cfset grouprebate = insert_rebatePayableOTE + "#thisPeriod.retroThroughPut/100*thisPeriod.OTEValue#">
            <cfset insert_rebatePayableOTE = "#thisPeriod.grouprebate/100*thisPeriod.rthisMemPerc#">
          </cfif>
         <cfelseif rebateInfo.outputType eq 11>
           <cfset thisPeriod.insert_rebatePayableOTE = thisPeriod.OTEValue/ListLen(membersP)>
        <cfelse>
          <cfset thisPeriod.insert_rebatePayableOTE = thisPeriod.insert_rebatePayableOTE + "#thisPeriod.retroThroughPutOTE*thisPeriod.OTEValue#">
        </cfif>
        <cfset thisPeriod.thismember.output.total = thisPeriod.thismember.output.total - thisPeriod.retroThroughPutOTE>
        <cfelse>
        <cfset thisPeriod.insert_rebatePayableOTE = 0>
        </cfif>
      </cfloop>
    <cfelse>
      <cfif rebateInfo.outputType eq 6>
        <cfif thisPeriod.thismember.output.total neq 0 AND thisPeriod.thismember.output.total neq "">
          <cfset thisPeriod.insert_rebatePayable ="#thisPeriod.thismember.output.total/100*thisPeriod.rebateValue#">
        <cfelse>
          <cfset thisPeriod.insert_rebatePayable = 0>
        </cfif>
        <cfif thisPeriod.OTETurnoverOutputTotalMember neq 0 AND thisPeriod.OTETurnoverOutputTotalMember neq "">
          <cfset thisPeriod.insert_rebatePayableOTE ="#numberFormat(thisPeriod.OTETurnoverOutputTotalMember/100*thisPeriod.OTEValue,"9999999999.00")#">
        <cfelse>
          <cfset thisPeriod.insert_rebatePayableOTE = 0>
        </cfif>
      <cfelseif rebateInfo.outputType eq 11>
        <cfset thisPeriod.insert_rebatePayable ="#thisPeriod.rebateValue/ListLen(membersP)#">
        <cfset thisPeriod.insert_rebatePayableOTE ="#thisPeriod.OTEValue/ListLen(membersP)#">
      <cfelse>
        <cfset thisPeriod.insert_rebatePayable ="#thisPeriod.thismemberoutput.total*thisPeriod.rebateValue#">
        <cfset thisPeriod.insert_rebatePayableOTE ="#thisPeriod.numberFormat(thisPeriod.OTETurnoverOutputTotalMember*thisPeriod.OTEValue,"9999999999.00")#">
      </cfif>
    </cfif>
    <cfset thisPeriod.x_rebatePayable = thisPeriod.insert_rebatePayable-thisPeriod.totalToremove>
    <cfset thisPeriod.x_rebatePayable = thisPeriod.insert_rebatePayable-thisPeriod.totalToremove>
    <cfif thisPeriod.x_rebatePayable lt 0>
      <cfset thisPeriod.x_rebatePayable = 0>
    </cfif>
      <cfreturn thisP>
  </cffunction>


  <cffunction name="delRebatePayments" returntype="void">
    <cfargument name="psaID" />
    <cfset var delOld = "">
    <cfquery name="delOld" datasource="#dsn.getName()#">
      delete from rebatePayments where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#"> and paid = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">;
    </cfquery>
  </cffunction>
  </cfcomponent>