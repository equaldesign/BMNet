<cfcomponent>
    <!--- Dependencies --->
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="figures" inject="id:eunify.FiguresService" />
  <cfproperty name="psa" inject="id:eunify.PSAService" />

  <cffunction name="pollStatus" returntype="query">
    <cfargument name="psaID">
    <cfset var s = "">
    <cfquery name="s" datasource="#dsn.getName()#">
      select percent, timestarted from calculationJob where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="calculateRebate" returntype="any" output="yes">
    <cfargument name="psaID" required="yes">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var arrangementQ = psa.getArrangementAndSupplier(psaID)>
    <cfset var dealXML = XmlParse(arrangementQ.dealData)>
    <cfset var rebateNodes = XMLSearch(dealXML,"//component[calculate='true']")>
    <cfset var psaFrom = arrangementQ.period_from>
    <cfset var psaTo = arrangementQ.period_to>
    <cfset var debugArray = []>
    <cfset var figuresLastDate = getLastInputDate(psaID)>
    <cfset var delCal = "">
    <cfset var debugDump = "">
    <cfset var createJob = "">
    <cfset var pp = "">
    <cfset var exists = "">
    <cfset var insertPayments = "">
    <cfset var debugDump = "">
    <cfset var percentDone = 1>
    <cfset var LoopItems = 1>
    <cfset var PercentIncrease = "">
    <cfset var rebateInfo = "">
    <cfset var rebateElement = "">
    <cfset var delCalc = "">
    <cfset var dumpO = "">
    <cfset var c = "">
    <cfset var thisPeriod = "">
    <cfset delRebatePayments(psaID)>
    <cfquery name="delCalc" datasource="#dsn.getName()#">
      delete from calculationJob  where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">;
    </cfquery>
    <cfquery name="debugDump" datasource="#dsn.getName()#">
      delete from arrangementCalculationReport where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">;
    </cfquery>
    <cfquery name="createJob" datasource="#dsn.getName()#">
      insert into calculationJob (psaID,percent) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,1)
    </cfquery>
    <cfthread
      figuresLastDate="#figuresLastDate#"
      UserStorage="#UserStorage#"
      ApplicationStorage="#ApplicationStorage#"
      dsn="#dsn#"
      psaID="#psaID#"
      figures="#figures#"
      LoopItems="#LoopItems#"
      PercentIncrease="#PercentIncrease#"
      rebateInfo="#rebateInfo#"
      rebateElement="#rebateElement#"
      company="#company#"
      psa="#psa#"
      action="run"
      percentDone="#percentDone#"
      name="calculations_#psaID#"
      priority="HIGH"
      eGroup="#eGroup#"
      psaFrom="#psaFrom#"
      psaTo="#psaTo#"
      debugArray="#debugArray#"
      rebateNodes="#rebateNodes#">
      <cftry>
        <cfset rebateInfo = attributes.rebateInfo>
        <cfset rebateElement = attributes.rebateElement>
        <cfset figuresLastDate = attributes.figuresLastDate>
        <cfset UserStorage = attributes.UserStorage>
        <cfset ApplicationStorage = attributes.ApplicationStorage>
        <cfset dsn = attributes.dsn>
        <cfset psaID = attributes.psaID>
        <cfset figures = attributes.figures>
        <cfset LoopItems = attributes.LoopItems>
        <cfset PercentIncrease = attributes.PercentIncrease>
        <cfset rebateInfo = attributes.rebateInfo>
        <cfset psa = attributes.psa>
        <cfset company = attributes.company>
        <cfset percentDone = attributes.percentDone>
        <cfset eGroup = attributes.eGroup>
        <cfset psaFrom = attributes.psaFrom>
        <cfset psaTo = attributes.psaTo>
        <cfset debugArray = attributes.debugArray>
        <cfset rebateNodes = attributes.rebateNodes>

      <cfloop array="#rebateNodes#" index="rebateElement">
        <cfset rebateInfo = createRebateStruct(rebateElement,psaFrom,psaTo)>
        <cfloop from="1" to="#rebateInfo.periods#" step="#rebateInfo.months#" index="c">
            <cfset LoopItems = LoopItems + 1>
        </cfloop>
      </cfloop>
      <cfset PercentIncrease = 100/LoopItems>
      <cfloop array="#rebateNodes#" index="rebateElement">
        <cfset rebateInfo = createRebateStruct(rebateElement,psaFrom,psaTo)>
        <cfloop from="1" to="#rebateInfo.periods#" step="#rebateInfo.months#" index="c"><!--- loop through as many months as there are in the period calculation period --->
          <cfset thisPeriod = createPeriodStruct(psaID,rebateInfo,c)>
          <cfloop query="thisPeriod.members.input">
            <cftry>
            <cfset thisPeriod.member = {}>
            <cfset thisPeriod.member.output = getTurnoverIndex(thisPeriod.members.output,memberID)>
            <cfset thisPeriod.member.input = getTurnoverIndex(thisPeriod.members.input,memberID)>
            <cfif rebateInfo.rebateType.name eq "individualgrowth">
              <cfquery name="pp" dbtype="query">
                select
                  *
                from
                  thisPeriod.growth.Turnover
                where
                  memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
              </cfquery>
              <cfset thisPeriod.growth.member.turnover = pp>
            </cfif>
            <cfset thisPeriod = doAverageCalcs(rebateInfo,thisPeriod,psaID)>
            <cfset thisPeriod = getRebateLevels(rebateInfo,thisPeriod,psaID)>
            <!--- check to see if a rebate payment already exists --->
            <cfquery name="exists" datasource="#dsn.getName()#">
              select id from rebatePayments
              WHERE
              psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
              AND
              memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
              AND
              periodFrom = <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodFrom#">
              AND
              xmlID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rebateInfo.xmlID#">
            </cfquery>
            <cfif exists.recordCount gte 1>
              <cfquery name="insertPayments" datasource="#dsn.getName()#">
              update rebatePayments
              set
                throughput = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.input.total),'.00')#">,
                throughputRebateable = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.output.total),'.00')#">,
                rebateValue = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.rebate.Value),'.00')#">,
                rebateAmount = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.rebate.Payable),'.00')#">,
                rebatePayable = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.adjustedRebate.payable),'.00')#">,
                periodName = <cfqueryparam cfsqltype="cf_sql_float" value="#thisPeriod.periodName#">,
                OTEValue = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.estimate.rebate.Value),'.00')#">,
                OTEThroughput = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.estimate.input.total),'.00')#">,
                OTEPayable = <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.estimate.rebate.Value),'.00')#">,
                figuresLastDate = <cfqueryparam cfsqltype="cf_sql_date" value="#figuresLastDate#">
              WHERE
              id = <cfqueryparam cfsqltype="cf_sql_integer" value="#exists.id#">
              </cfquery>
            <cfelse>
              <cfquery name="insertPayments" datasource="#dsn.getName()#">
              insert into rebatePayments
                (psaID, memberID,periodFrom,periodTo,throughput,throughputRebateable,rebateValue,rebateAmount,rebatePayable,xmlID,periodName,OTEValue,OTEThroughput,OTEPayable,figuresLastDate)
              VALUES
                (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodFrom#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#thisPeriod.periodTo#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.input.total),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.output.total),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.rebate.Value),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.rebate.payable),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.adjustedRebate.payable),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rebateInfo.xmlid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#thisPeriod.periodName#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.estimate.rebate.Value),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.member.estimate.input.total),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#NumberFormat(vNum(thisPeriod.rebate.estimate.payable),'.00')#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#figuresLastDate#">
                )
              </cfquery>
            </cfif>
          <cfcatch type="any">
            <cfset logger.debug("#cfcatch.Message#, #cfcatch.Detail#")>
          </cfcatch>
          </cftry>
          </cfloop>
          <cfquery name="insertPayments" datasource="#dsn.getName()#">
            update calculationJob set percent = <cfqueryparam cfsqltype="cf_sql_integer" value="#int(percentDone+percentIncrease)#"> where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
          </cfquery>
          <cfset percentDone += percentIncrease>
        </cfloop>
        <cfset arrayAppend(debugArray,rebateInfo)>
      </cfloop>
      <cfquery name="insertPayments" datasource="#attributes.dsn.getName()#">
          delete from calculationJob where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
      </cfquery>
      <cfsavecontent variable="dumpO">
      <cfdump var="#debugArray#">
      </cfsavecontent>
      <cfquery name="debugDump" datasource="#attributes.dsn.getName()#">
        insert into arrangementCalculationReport (psaID,dumpO) VALUES (
          <Cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,
          <Cfqueryparam cfsqltype="cf_sql_longvarchar" value="#dumpO#">
        )
      </cfquery>
      <cfcatch type="any">
            <cfset logger.debug("#cfcatch.Message#, #cfcatch.Detail# : #cfcatch.ExtendedInfo#")>
      </cfcatch>
      </cftry>
    </cfthread>
  </cffunction>

  <!--- PRIVATE FUNCTIONS --->

  <cfscript>
    private Numeric function vNum(num) {
      if (IsNumeric(num)) {
        return num;
      } else {
        return 0;
      }
    }
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
        rebateInfo.dateRangeFrom = arrangementFrom; // there is no date range, so use the deal start date
        rebateInfo.dateRangeTo = arrangementTo; // there is no date range, so use the dal end date
      }

      // MEMBER RESTRICTIONS
      if (isDefined('rebateElement.memberRestrictions')) { // is there member restricions?
        rebateInfo.memberRestrictions = rebateElement.memberRestrictions.xmlText; // set the boolean flag
        rebateInfo.membersParticipating = rebateElement.memberRestrictions.xmlAttributes.MEMBERSPARTICIPATING; // set the members who are participating
        if (rebateInfo.memberRestrictions) { // is there member restrictions?
          rebateInfo.members = rebateInfo.membersParticipating; // if there is, we need the list of which members to include in the calculation.
          rebateInfo.memberCount = ListLen(rebateInfo.members);
        } else {
          rebateInfo.members = 0; // otherwise set members to 0 - i.e all members
          rebateInfo.memberCount = company.getMembers().recordCount;
        }
      } else {
        rebateInfo.memberRestrictions = false; // no member restrictions
        rebateInfo.members = 0;
        rebateInfo.memberCount = company.getMembers().recordCount;
      }

      // RETROSPECTIVE
      if (isDefined('rebateElement.nonretrospective')) { // is the element non-retrospective? In other words, does it pay rebate on their entire amount, or just the amount in the current step?
        rebateInfo.nonretrospective = rebateElement.nonretrospective.xmlText; // set a boolean value for non-retrospectgive
      } else {
        rebateInfo.nonretrospective = false; // element is retrospective
      }

      rebateInfo.xmlID = rebateElement.id.XmlText;
      rebateInfo.rebateName = rebateElement.title.xmlText;

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
      if (rebateInfo.rebateType.name eq "groupgrowth" OR rebateInfo.rebateType.name eq "individualgrowth") {
        rebateInfo.rebateType.target = rebateElement.rebateType.target.xmlAttributes.id;
        rebateInfo.rebateType.figures = rebateElement.rebateType.target.xmlAttributes.figures;
        rebateInfo.rebateType.dateFrom = rebateElement.rebateType.target.xmlAttributes.dateFrom;
        rebateInfo.rebateType.dateTo = rebateElement.rebateType.target.xmlAttributes.dateTo;
      }

      rebateInfo.outputType = rebateElement.outputType.xmlText; // the output type (hopefully percent!)

      // STEP INFORAMTION
      if (isDefined('rebateElement.step')) { // are there steps/bands in this rebate?
        rebateInfo.steps = true; // yes - set a boolean flag for easy reference
        rebateInfo.rebateSteps = QueryNew("figureFrom,figureTo,rebateValue"); // create a empty query to put the bands in
        for (z=1;z lte ArrayLen(rebateElement.step); z=z+1) { // loop through the rebate bands
          QueryAddRow(rebateInfo.rebateSteps); // add a row to our query
          QuerySetCell(rebateInfo.rebateSteps,"figureFrom",vNum(rebateElement.step[z].from.xmlText)); // put the from band into our query object
          QuerySetCell(rebateInfo.rebateSteps,"figureTo",vNum(rebateElement.step[z].to.xmlText)); // put the to band into our query object (not really needed)
          QuerySetCell(rebateInfo.rebateSteps,"rebateValue",vNum(rebateElement.step[z].value.xmlText)); // put the rebate amount into our query object
        }
      } else {
        rebateInfo.steps = false; // no - there are no steps/bands - it must be a simple rebate
        rebateInfo.rebateValue = rebateElement.value.xmlText; // in which case, the rebate value is a numeric value
      }

      // COMPOUND INFO
      if (isDefined('rebateElement.compound') AND rebateElement.compound.xmlText eq "true") { // do we need to take into account other figures - compound?
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
      rebateInfo.periodArray =[];

      // END - RETURN REBATE STRUCTURE
      return rebateInfo;
    }



    // CREATE A REBATE PERIOD STRUCTURE - THERE SHOULD BE ONE STRUCTURE FOR EACH REBATE PERIOD ITERATION

    private Struct function createPeriodStruct(psaID,rebateInf,currentIndex) {
      var rebateInfo = arguments.rebateInf;
      var thisPeriod = {}; // create an empty struct to return
      thisPeriod.periodFrom = DateAdd("m",currentIndex-1,rebateInfo.dateRangeFrom); // the element period from date
      thisPeriod.periodTo = DateAdd("m",rebateInfo.months+currentIndex-1,rebateInfo.dateRangeFrom); // the element period to date
      thisPeriod.periodName = "Period #c#"; // the period name (period 1, 2 etc.)

      if (rebateInfo.dateRange) { // if this rebate element is date restricted
        if (DateCompare(rebateInfo.dateRangeFrom,thisPeriod.periodFrom,"d") gt 0) {
          thisPeriod.periodFrom = rebateInfo.dateRangeFrom;
        }
        if (DateCompare(rebateInfo.dateRangeTo,thisPeriod.periodTo,"d") lt 0) {
          thisPeriod.periodTo = rebateInf.dateRangeTo;
        }
      } else {
        thisPeriod.periodTo = DateAdd("d",-1,thisPeriod.periodTo); // minus one day from the period - so the period runs from (for example) Jan 1st to Jan 31st, and not Jan 1st to Feb 1st
      }

      if (rebateInfo.rebateType.name eq "groupgrowth") {
        thisPeriod.growth.Turnover = getThroughPut(
         rebateInfo.rebateType.id,
         rebateInfo.rebateType.figures,
         rebateInfo.rebateType.dateFrom,
         rebateInfo.rebateType.dateTo,
         rebateInfo.members,
         false,
         false,
         "",
         false
       );
      } else if (rebateInfo.rebateType.name eq "individualgrowth") {
        thisPeriod.growth.Turnover = getThroughPut(
         rebateInfo.rebateType.id,
         rebateInfo.rebateType.figures,
         rebateInfo.rebateType.dateFrom,
         rebateInfo.rebateType.dateTo,
         rebateInfo.members,
         true,
         false,
         "",
         false
       );
      }
      if (rebateInfo.strung AND rebateInfo.strungType eq "input" OR rebateInfo.strungType eq "both") {
         thisPeriod.members.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,rebateInfo.strung,rebateInfo.strungTarget);
         thisPeriod.group.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,rebateInfo.strung,rebateInfo.strungTarget);
      } else {
         thisPeriod.members.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,false,"");
         thisPeriod.group.input = getThroughPut(psaID,rebateInfo.inputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,false,"");
      }

      if (rebateInfo.inputSources neq rebateInfo.outputSources OR (rebateInfo.strung AND rebateInfo.strungType eq "output" OR rebateInfo.strungType eq "both")) {
       // we've got a different input to output or a strung output;
       if (rebateInfo.strung AND rebateInfo.strungType eq "output" OR rebateInfo.strungType eq "both") {
         thisPeriod.members.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,rebateInfo.strung,rebateInfo.strungTarget);
         thisPeriod.group.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,rebateInfo.strung,rebateInfo.strungTarget);
       } else {
         thisPeriod.members.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,true,false,"");
         thisPeriod.group.output = getThroughPut(psaID,rebateInfo.outputSources,thisPeriod.periodFrom,thisPeriod.periodTo,rebateInfo.members,false,false,"");
       }

      } else {
       thisPeriod.group.output = thisPeriod.group.input;
       thisPeriod.members.output = thisPeriod.members.input;
      }
      ArrayAppend(rebateInfo.periodArray,thisPeriod);
      return thisPeriod;
    }
  </cfscript>


  <cffunction name="getRebateLevels" returntype="struct" access="private">
    <cfargument name="rebateInf">
    <cfargument name="thisP">
    <cfargument name="psaID">
    <cfset var rebateInfo = arguments.rebateInf>
    <cfset var thisPeriod = arguments.thisP>
    <cfset var getTarget = "">
    <cfset var getOTETarget = "">
    <cfif rebateInfo.steps>
      <cfif rebateInfo.rebateType.name eq "individualgrowth" OR rebateInfo.rebateType.name eq "groupgrowth">
        <cfif thisPeriod.growth.Turnover.recordCount neq 0 AND thisPeriod.growth.Turnover.total neq 0 AND thisPeriod.group.input.total neq 0> <!--- we can only work out a comparison percentage if both the current turnover and the grwoth turnover have data --->
          <cfif rebateInfo.rebateType.name eq "individualgrowth">
            <cfif vNum(thisPeriod.growth.member.Turnover.total) neq 0 AND vNum(thisPeriod.member.input.total) neq 0>
              <cfset thisPeriod.growth.Percentage = round(((int(vNum(thisPeriod.member.input.total))-int(vNum(thisPeriod.growth.member.Turnover.total)))/int(vNum(thisPeriod.growth.member.Turnover.total)))*100)>
              <cfset thisPeriod.growth.estimate.Percentage = round(((int(vNum(thisPeriod.member.estimate.input.total))-int(vNum(thisPeriod.growth.member.turnover.total)))/int(vNum(thisPeriod.growth.member.turnover.total)))*100)>
            <cfelseif vNum(thisPeriod.growth.member.Turnover.total) eq 0 AND vNum(thisPeriod.member.input.total) neq 0>
              <!--- they didn't do any turnover last year --->
              <cfset thisPeriod.growth.Percentage = 100>
              <cfset thisPeriod.growth.estimate.Percentage = 100>
            <cfelseif vNum(thisPeriod.growth.member.Turnover.total) eq 0 AND vNum(thisPeriod.member.input.total) eq 0>
              <!--- they didn't go any turnover this year --->
              <cfset thisPeriod.growth.Percentage = -100>
              <cfset thisPeriod.growth.estimate.Percentage = 100>
            </cfif>
          <cfelse>
            <cfif vNum(thisPeriod.growth.Turnover.total) neq 0 AND vNum(thisPeriod.group.input.total) neq 0>
              <cfset thisPeriod.growth.Percentage = round(((int(vNum(thisPeriod.group.input.total))-int(vNum(thisPeriod.growth.Turnover.total)))/int(vNum(thisPeriod.growth.Turnover.total)))*100)>
              <cfset thisPeriod.growth.estimate.Percentage = round(((int(vNum(thisPeriod.group.estimate.input.total))-int(vNum(thisPeriod.growth.Turnover.total)))/int(vNum(thisPeriod.growth.Turnover.total)))*100)>
            <cfelseif vNum(thisPeriod.growth.Turnover.total) eq 0 AND vNum(thisPeriod.group.input.total) neq 0>
              <!--- they didn't do any turnover last year --->
              <cfset thisPeriod.growth.Percentage = 100>
              <cfset thisPeriod.growth.estimate.Percentage = 100>
            <cfelseif vNum(thisPeriod.growth.Turnover.total) neq 0 AND vNum(thisPeriod.group.input.total) eq 0>
              <cfset thisPeriod.growth.Percentage = -100>
              <cfset thisPeriod.growth.estimate.Percentage = -100>
            </cfif>
          </cfif>
        <cfelse>
          <cfset thisPeriod.growth.Percentage  = 0>
          <cfset thisPeriod.growth.estimate.percentage  = 0>
        </cfif>
        <cfquery name="getTarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.growth.percentage)# order by figureFrom desc;
        </cfquery>
        <cfquery name="getOTETarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.growth.estimate.percentage)# order by figureFrom desc;
        </cfquery>
      <cfelseif rebateInfo.rebateType.name eq "individual">
        <cfquery name="getTarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.member.input.total)# order by figureFrom desc;
        </cfquery>
        <cfquery name="getOTETarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.member.estimate.input.total)# order by figureFrom desc;
        </cfquery>
      <cfelse>
        <cfquery name="getTarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.group.input.total)# order by figureFrom desc;
        </cfquery>
        <cfquery name="getOTETarget" dbtype="query">
          select rebateValue from rebateInfo.rebateSteps where figureFrom <= #vNum(thisPeriod.group.estimate.input.total)# order by figureFrom desc;
        </cfquery>
      </cfif>
      <cfset thisPeriod.rebate.value = getTarget.rebateValue>
      <cfset thisPeriod.estimate.rebate.Value = getOTETarget.rebateValue>
    <cfelse>
      <cfset thisPeriod.rebate.value = rebateInfo.rebateValue>
      <cfset thisPeriod.estimate.rebate.Value = rebateInfo.rebateValue>
    </cfif>
    <cfif Not isNumeric(thisPeriod.rebate.Value)>
      <cfset thisPeriod.rebate.Value = 0>
    </cfif>
    <cfif Not isNumeric(thisPeriod.estimate.rebate.Value)>
      <cfset thisPeriod.estimate.rebate.Value = 0>
    </cfif>
    <cfif rebateInfo.compound>
      <cfset thisPeriod.totalToRemove = getCalculationsForCompound(psaID,memberID,rebateInfo.compoundTarget,thisPeriod.periodFrom,thisPeriod.periodTo)>
    <cfelse>
      <cfset thisPeriod.totalToRemove = 0>
    </cfif>
      <cfif rebateInfo.outputType eq 6>
        <cfif thisPeriod.member.output.total neq 0 AND thisPeriod.member.output.total neq "">
          <cfset thisPeriod.rebate.payable =thisPeriod.member.output.total*(thisPeriod.rebate.Value/100)>
        <cfelse>
          <cfset thisPeriod.rebate.payable = 0>
        </cfif>
        <cfif thisPeriod.member.estimate.output.total neq 0 AND thisPeriod.member.estimate.output.total neq "">
          <cfset thisPeriod.rebate.estimate.payable =thisPeriod.member.estimate.output.total*(thisPeriod.estimate.rebate.Value/100)>
        <cfelse>
          <cfset thisPeriod.rebate.estimate.payable = 0>
        </cfif>
      <cfelseif rebateInfo.outputType eq 11>
        <cfset thisPeriod.rebate.payable =(thisPeriod.rebate.Value/rebateInfo.memberCount)>
        <cfset thisPeriod.rebate.estimate.payable =(thisPeriod.rebate.Value/rebateInfo.memberCount)>
      <cfelseif rebateInfo.outputType eq 12>
        <cfif thisPeriod.member.output.total neq 0 AND thisPeriod.member.output.total neq "">
          <cfset thisPeriod.rebate.payable =(thisPeriod.member.output.total/thisPeriod.group.output.total*thisPeriod.rebate.Value)>
        <cfelse>
          <cfset thisPeriod.rebate.payable = 0>
        </cfif>
        <cfif thisPeriod.member.estimate.output.total neq 0 AND thisPeriod.member.estimate.output.total neq "">
          <cfset thisPeriod.rebate.estimate.payable =(thisPeriod.member.estimate.output.total/thisPeriod.group.estimate.output.total*thisPeriod.estimate.rebate.Value)>
        <cfelse>
          <cfset thisPeriod.rebate.estimate.payable = 0>
        </cfif>
      <cfelse>
        <cfset thisPeriod.rebate.payable =(thisPeriod.member.output.total*thisPeriod.rebate.Value)>
        <cfset thisPeriod.rebate.estimate.payable =thisPeriod.member.estimate.output.total*thisPeriod.estimate.rebate.value>
      </cfif>
    <cfset thisPeriod.adjustedRebate.payable = thisPeriod.rebate.payable-thisPeriod.totalToremove>
    <cfif thisPeriod.adjustedRebate.payable lt 0 AND thisPeriod.totalToremove neq 0>
      <cfset thisPeriod.adjustedRebate.payable = 0>
    </cfif>
      <cfreturn thisPeriod>
  </cffunction>

  <cffunction name="delRebatePayments" returntype="void">
    <cfargument name="psaID" />
    <cfset var delOld = "">
    <cfquery name="delOld" datasource="#dsn.getName()#">
      delete from rebatePayments where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#"> and paid = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">;
    </cfquery>
  </cffunction>

  <cffunction name="doAverageCalcs" returntype="struct" access="private">
    <cfargument name="rebateInf" required="true">
    <cfargument name="thisP" required="true">
    <cfargument name="psaID" required="true">
    <cfset var rebateInfo = arguments.rebateInf>
    <cfset var thisPeriod = arguments.thisP>
      <cfset rebateInfo.nextDate = DateAdd("d",-1,figures.getNextInputDate(psaID))>
       <!--- if the end date of the period is less than the next input date for the deal, the period is over and
       we don't really even need to estimate --->
      <cfif dateCompare(rebateInfo.nextDate,thisPeriod.periodTo) lt 0>
        <cfset thisPeriod.maxTurnoverDate = rebateInfo.nextDate>
      <cfelse>
        <cfset thisPeriod.maxTurnoverDate = thisPeriod.periodTo+1>
      </cfif>

       <!--- number of months between beginning of period, and to date (either next input date, or period end) --->
       <cfset thisPeriod.monthsDone = datediff("m",thisPeriod.periodFrom,thisPeriod.maxTurnoverDate)>
       <cfif thisPeriod.monthsDone eq 0>
         <cfset thisPeriod.monthsDone = 1>
       </cfif>
       <!--- months between period start and period end --->
       <cfset thisPeriod.periodLength = datediff("m",thisPeriod.periodFrom,thisPeriod.periodTo)+1> <!--- we add 1 on here, as we've already minus'd one day --->
       <cfif thisPeriod.group.input.total neq 0 AND thisPeriod.group.input.total neq "">
         <cfset thisPeriod.group.estimate.input.average = thisPeriod.group.input.total/thisPeriod.monthsDone><!--- average monthly turnover for this period --->
       <cfelse>
         <cfset thisPeriod.group.estimate.input.average = 0>
       </cfif>
       <cfif thisPeriod.group.output.total neq 0 AND thisPeriod.group.output.total neq "">
         <cfset thisPeriod.group.estimate.output.average = thisPeriod.group.output.total/thisPeriod.monthsDone>
       <cfelse>
         <cfset thisPeriod.group.estimate.output.average = 0>
       </cfif>
       <cfif thisPeriod.member.input.total neq 0 AND thisPeriod.member.input.total neq "">
         <cfset thisPeriod.member.estimate.input.average= thisPeriod.member.input.total/thisPeriod.monthsDone><!--- average turnover for the period for this member --->
       <cfelse>
         <cfset thisPeriod.member.estimate.input.average = 0>
       </cfif>
       <cfif thisPeriod.member.output.total neq "">
         <cfset thisPeriod.member.estimate.output.average = thisPeriod.member.output.total/thisPeriod.monthsDone>
       <cfelse>
         <cfset thisPeriod.member.estimate.output.average = 0>
       </cfif>
       <cfif thisPeriod.periodTo lte rebateInfo.nextDate><!--- don't reduce the calculation to 95% as the period is over! --->
         <cfset thisPeriod.group.estimate.output.total = thisPeriod.group.estimate.output.average*thisPeriod.periodLength><!--- target earnings for the group for the period (used to estimate rebate target band)--->
         <cfset thisPeriod.group.estimate.input.total = thisPeriod.group.estimate.input.average*thisPeriod.periodLength>
         <cfset thisPeriod.member.estimate.output.total = thisPeriod.member.estimate.output.average*thisPeriod.periodLength><!--- target earnings for the member for the period --->
         <cfset thisPeriod.member.estimate.input.total = thisPeriod.member.estimate.input.average*thisPeriod.periodLength>
       <cfelse>
         <cfset thisPeriod.group.estimate.output.total = thisPeriod.group.estimate.output.average*(thisPeriod.periodLength/100*95)>
         <cfset thisPeriod.group.estimate.input.total = thisPeriod.group.estimate.input.average*(thisPeriod.periodLength/100*95)><!--- target earnings for the group for the period (used to estimate rebate target band)--->
         <cfset thisPeriod.member.estimate.output.total = thisPeriod.member.estimate.output.average*(thisPeriod.periodLength/100*95)>
         <cfset thisPeriod.member.estimate.input.total = thisPeriod.member.estimate.input.average*(thisPeriod.periodLength/100*95)><!--- target earnings for the member for the period --->
       </cfif>
       <cfreturn thisPeriod>
  </cffunction>

  <cffunction name="getCalculationsForCompound" returntype="numeric">
    <cfargument name="psaID" required="yes">
    <cfargument name="memberID" required="yes" default="0">
    <cfargument name="xmlID" required="yes" default="0">
    <cfargument name="periodFrom" required="yes">
    <cfargument name="periodTo" required="yes">
    <cfset var getCalculations = "">
    <cfquery name="getCalculations" datasource="#dsnRead.getName()#">
      select SUM(rebateAmount) as totalPaid from rebatePayments
      where
      psaID = '#psaID#'
      AND
      xmlID = '#xmlID#'
      AND
      rebatePayments.memberID = '#memberID#'
      AND
            periodFrom >= <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#">
      AND
      periodTo <= <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">

    </cfquery>
    <cfif isNumeric(getCalculations.totalPaid)>
      <cfreturn getCalculations.totalPaid>
    <cfelse>
      <cfreturn 0>
    </cfif>
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
  <cfargument name="chained" required="true" default="true">
  <cfset var figuresPSA = "">
  <cfset var inputStreams = "">
  <cfset var thispsa = "">
  <cfset var fromDiff = "">
  <cfset var throughPut = "">
  <cfset var tp = "">
  <cfset inputStreams = psa.getFiguresEntryElementsFromList(figuresID)>
  <cfset thispsa = psa.getArrangement(dealID)>
  <cfquery name="throughPut" result="tp" datasource="#dsnRead.getName()#">
    select
        sum(value) as throughPut,
        sum(value)
          <cfif strung>
              -
          (select
            sum(rebatePayable) as paymentTotal from rebatePayments
            where
          rebatePayments.psaID = turnover.psaID
            AND
          rebatePayments.xmlID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#strungTarget#" list="true">)
            AND
          rebatePayments.periodFrom >= <cfqueryparam cfsqltype="cf_sql_date" value="#periodFrom#">
            AND
          rebatePayments.periodTo <= <cfqueryparam cfsqltype="cf_sql_date" value="#periodTo#">
            AND
          rebatePayments.memberID = turnover.memberID
        )
          </cfif> as total,
        turnover.psaID,
        period,
        turnover.memberID
      from
        turnover
      where
      <cfif members neq 0>
        turnover.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#members#" list="true">) and
      </cfif>
      <cfif figuresID neq 0>

        <cfif inputStreams.recordCount gte 1>
        (
        </cfif>
        <cfloop query="inputStreams">

        <cfif inputStreams.psaID neq arguments.dealID AND chained>
          <cfset figuresPSA = psa.getArrangement(inputStreams.psaID)>
          <cfset fromDiff = DateDiff("yyyy",thispsa.period_from,figuresPSA.period_from)>
          <cfset periodFrom = CreateDate(Year(DateAdd("yyyy",fromDiff,thispsa.period_from)),month(arguments.periodFrom),day(arguments.periodFrom))>
          <cfset periodTo = CreateDate(Year(DateAdd("yyyy",fromDiff,thispsa.period_from)),month(arguments.periodTo),day(arguments.periodTo))>

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
    <cfreturn throughPut>
  </cffunction>

  <cffunction name="getTurnoverIndex" returntype="query">
    <cfargument name="q" type="query" required="true">
    <cfargument name="memberID" required="true" type="numeric">
    <cfset var thisq = "">
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

  <cffunction name="getLastInputDate" returntype="date">
    <cfargument name="psaID">
    <cfset var latestDate = "">
    <cfset var a = "">
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
</cfcomponent>