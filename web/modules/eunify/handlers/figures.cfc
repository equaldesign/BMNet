<cfcomponent name="figuresHandler" cache="true" cacheTimeout="30" output="false">
	<cfproperty name="psa" inject="id:eunify.PSAService" />
	<cfproperty name="groups" inject="id:eunify.GroupsService" />
	<cfproperty name="figures" inject="id:eunify.FiguresService" />
  <cfproperty name="calculations" inject="id:eunify.CalculationsService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
	<cfproperty name="company" inject="id:eunify.SUpplierService" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="dsn" inject="coldbox:datasource:eGroup" />


	<cfscript>
	/**
	* Creates a unique file name; used to prevent overwriting when moving or copying files from one location to another.
	* v2, bug found with dots in path, bug found by joseph
	* v3 - missing dot in extension, bug found by cheesecow
	*
	* @param fullpath      Full path to file. (Required)
	* @return Returns a string.
	* @author Marc Esher (marc.esher@cablespeed.com)
	* @version 3, July 1, 2008
	*/
	function createUniqueFileName(fullPath){
		var extension = "";
		var thePath = "";
		var newPath = arguments.fullPath;
		var counter = 0;

		if(listLen(arguments.fullPath,".") gte 2) extension = listLast(arguments.fullPath,".");
		thePath = listDeleteAt(arguments.fullPath,listLen(arguments.fullPath,"."),".");

		while(fileExists(newPath)){
			counter = counter+1;
			newPath = thePath & "_" & counter & "." & extension;
		}
		return newPath;
	}
	</cfscript>
	<cffunction name="import" returnType="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfscript>
			rc.psaID = arguments.event.getValue("psaID","");
			rc.fileName = trim(URLDecode(arguments.event.getValue("filename","")));
			rc.psa = psa.getPSA(rc.psaID);
		</cfscript>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cftry>
    <cfset rc.results = figures.importData(rc.psaID,rc.filename,rc.psa.getdealData())>

    <cfset arguments.event.setView("turnover/importsuccess")>
    <cfcatch type="database">
      <cfset rc.message = "Some data in your spreadsheet was corrupt. Are you sure your cells contained numeric values only? #cfcatch.Detail# #cfcatch.Message#">
      <cfset rc.nextURL = "/psa/index/psaID/#rc.psaID#">
      <cfset arguments.event.setView("message")>
    </cfcatch>
    </cftry>
	</cffunction>

	<cffunction name="index" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  rc.psaID = arguments.event.getValue('psaid',0);
		  rc.layout = arguments.event.getValue("layout","Main");
		  rc.psa = psa.getArrangement(rc.psaID);
		</cfscript>


		<cfset arguments.event.setView('psa/#getSetting("sitename")#/view')>
	</cffunction>

	<cffunction name="recalculate" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

    <cfsetting requesttimeout="1900">
		<cfscript>
		  var rc = arguments.event.getCollection();
		  rc.psaID = arguments.event.getValue('psaid',0);
		  rc.figs = calculations.calculateRebate(rc.psaID);
		</cfscript>
			<cfset arguments.event.setLayout('Layout.ajax')>
			<cfset arguments.event.setView('blank')>
	</cffunction>
  <cffunction name="showReport" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      var c = "";
      rc.psaID = arguments.event.getValue('psaid',0);
    </cfscript>
    <cfquery name="c" datasource="#dsn.getName()#">
      select dumpO from arrangementCalculationReport where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rc.psaID#">
    </cfquery>
    <cfset rc.calcReport = c.dumpO>
      <cfset arguments.event.setLayout('Layout.ajax')>
      <cfset arguments.event.setView('psa/calcReport')>
  </cffunction>

  <cffunction name="wipe" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.period = arguments.event.getValue("period","")>
    <cfset figures.wipeFigures(rc.psaID,rc.period)>
    <cfset setNextEvent(uri="/figures/returns/psaID/#rc.psaID#")>
  </cffunction>

  <cffunction name="doReturns" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset var fieldN = "">
    <cfset var removeCurrent = "">
    <cfset var insertD = "">
    <cfset var x = "">
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.arrangementQ = psa.getArrangement(rc.psaID)>
    <cfset rc.PSA = XmlParse(rc.arrangementQ.dealData)>
    <cfset rc.period = readForm('period',now())>
    <cfset rc.dataB = QueryNew("memberID,figuresID,value,unitTypeID")>
    <cfloop list="#form.fieldnames#" index="fieldN">
      <cfif left(fieldN,6) eq "rebate">
		    <cfset rc.dataset = ListToArray(fieldN,"_")>
		    <cfset x = QueryAddRow(rc.dataB)>
		    <cfset x = QuerySetCell(rc.dataB,"memberID","#rc.dataset[2]#")>
		    <cfset x = QuerySetCell(rc.dataB,"figuresID","#rc.dataset[3]#")>
		    <cfset x = QuerySetCell(rc.dataB,"value","#arguments.event.getValue("#fieldN#","")#")>
		    <cfset x = QuerySetCell(rc.dataB,"unitTypeID","#psa.getFiguresEntryElement(rc.dataset[3]).inputTypeID#")>
		  </cfif>
		</cfloop>

		  <!--- first delete any figures already in there --->
		  <cfquery name="removeCurrent" datasource="#dsn.getName()#">
		    delete from turnover where psaID = '#rc.psaID#' and period = '#rc.period#';
		  </cfquery>
		  <cfloop query="rc.dataB">
		    <cfquery name="insertD" datasource="#dsn.getName()#">
		      insert into turnover
		        (psaID,period,memberID,figuresID,value,unit_type_id)
		       VALUES
		        ('#rc.psaID#','#rc.period#','#memberID#','#figuresID#','#value#','#unitTypeID#')
		    </cfquery>
		  </cfloop>
  <cftry><cfset feed.createFeedItem('contact',rc.sess.eGroup.contactID,'arrangement',rc.arrangementQ.id,'enterFigures','company',rc.sess.eGroup.companyID,rc.arrangementQ.memberID,rc.arrangementQ.company_id)><cfcatch type="any"><cflog application="true" text="#cfcatch.Message#"></cfcatch></cftry>
  <cftry><cfset calculations.calculateRebate(rc.psaID,rc.arrangementQ)><cfcatch type="any"></cfcatch></cftry>
  <cfset setNextEvent("figures.returns.psaID.#rc.psaID#")>
  </cffunction>

	<cffunction name="returns" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  rc.psaID = arguments.event.getValue('psaid',0);
		  rc.layout = arguments.event.getValue("layout","Main");
			rc.nextDate = figures.getNextInputDate(rc.psaID);
		  rc.psa = psa.getPSA(rc.psaID);
		  rc.company = company.getCompany(rc.psa.getcompany_id());
			rc.date = arguments.event.getValue("date",rc.nextDate);
			rc.turnoverElements = psa.getFiguresEntryElements(rc.psaID,false);
			rc.dealstart = rc.psa.getperiod_from();
			rc.dealend = rc.psa.getperiod_to();
			rc.participants = psa.getParicipants(rc.psaID,rc.psa.getparticipation());
			rc.monthsInPeriod = DateDiff("m",rc.dealstart,rc.dealend);
			if (dateCompare(rc.nextDate,rc.psa.getperiod_to()) lt 0) {
        rc.monthsRequired = DateDiff("m",rc.nextDate,now());
      } else {
       rc.monthsRequired = 0;
      }

			if (isUserInAnyRoles("edit,admin") OR rc.psa.getcontact_id() eq rc.sess.eGroup.contactID) {
				rc.editable = true;
			} else if (IsUserInRole("figuresEntry") AND isUserInRole("supplier") AND rc.date eq rc.nextDate) {
				rc.editable = true;
			} else {
				rc.editable = false;
			}
			if (rc.date neq rc.nextDate) {
				rc.figures = figures.getEntryTurnover(rc.psaID,rc.date);
			}
		</cfscript>


		<cfset arguments.event.setView('turnover/enter')>
	</cffunction>

	<cffunction name="returnsSpreadsheetDownload" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  var c = "";
		  var i = "";
		  rc.psaID = arguments.event.getValue('psaid',0);
		  rc.layout = arguments.event.getValue("layout","Main");
			rc.fileName = "/tmp/#createUUID()#.xls";
			rc.nextDate = figures.getNextInputDate(rc.psaID);
		  rc.psa = psa.getArrangement(rc.psaID);
			rc.date = arguments.event.getValue("date",rc.nextDate);
			if (IsUserInRole("admin")) {
			 rc.date = rc.psa.period_from;
			}
			rc.turnoverElements = psa.getFiguresEntryElements(rc.psaID,false);
			rc.dealstart = rc.psa.period_from;
			rc.dealend = rc.psa.period_to;
			rc.participants = psa.getParicipants(rc.psaID,rc.psa.participation);
			rc.monthsInPeriod = DateDiff("m",rc.dealstart,rc.dealend);
		</cfscript>
		<cfset rc.alphaRef = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]>
		<cfset rc.monthsRequired = DateDiff('m',rc.date,DateAdd('m',-1,now()))>
    <cfif isUserInRole("admin")>
      <cfset rc.monthsRequired = DateDiff('m',rc.dealstart,DateAdd('m',-1,now()))>
    </cfif>
		<cfif rc.monthsRequired gte 0>
		<cfloop from="0" to="#rc.monthsRequired#" index="i">
			<cfset rc.period = DateAdd('m',i,rc.date)>
			<cfset rc.ssQ = ArrayNew(1)>
			<cfset ArrayAppend(rc.ssQ,"Member")>
			<cfset rc.sheetName = "Turnover for " & DateFormat(rc.period,"MMMM YYYY")>
			<cfset rc.theSheet = SpreadSheetNew("#rc.sheetName#")>
		  <!--- loop over the nodes, and create the columns in a query object --->
		  <cfloop query="rc.turnoverElements">
		  	<cfset ArrayAppend(rc.ssQ,"#id# #cleanTurnoverName(inputName)# (#getUnitType2(inputtypeID).type#)")>
		  </cfloop>
			<cfset spreadSheetAddRow(rc.theSheet,ArrayToList(rc.ssQ))>

		  <cfloop query="rc.participants">
		  	<cfset rc.mmQ = ArrayNew(1)>
		  	<cfset ArrayAppend(rc.mmQ,"#known_as#")>
					<cfloop query="rc.turnoverElements">
						<cfset ArrayAppend(rc.mmQ,0)>
					</cfloop>
				<cfset spreadSheetAddRow(rc.theSheet,ArrayToList(rc.mmQ))>
		  </cfloop>
		  <!--- add a new row for the totals --->
		  <cfset rc.totalN = rc.participants.recordCount+2>
		  <cfset rc.rowTotals = "TOTAL">
		  <cfset rc.ttQ = ArrayNew(1)>
		  <cfset ArrayAppend(rc.ttQ,"TOTAL")>
		  <cfloop query="rc.turnoverElements">
		    <cfset ArrayAppend(rc.ttQ,0)>
		  </cfloop>

			<cfset spreadSheetAddRow(rc.theSheet,ArrayToList(rc.ttQ))>
		  <!--- now create a forumula for the totals --->
		  <cfloop query="rc.turnoverElements">
		    <cfset c = currentRow+1>
		    <cfset SpreadsheetSetCellFormula(rc.theSheet,"SUM(#convertToColumnRef(2,c)#:#convertToColumnRef(rc.totalN-1,c)#)",rc.totalN,c)>
		  </cfloop>
		  <!--- now lets sort out the look and feel --->
		  <cfset rc.header = StructNew()>
		  <cfset rc.header.color = "WHITE">
		  <cfset rc.header.locked = true>
		  <cfset rc.header.fgcolor = "BLACK">
		  <cfset rc.header.fillpattern = "SOLID_FOREGROUND">
		  <cfset rc.header.bold = "yes">
		  <cfset rc.members = StructNew()>
		  <cfset rc.dataGrid = StructNew()>
		  <cfset rc.members.locked = true>
		  <cfset rc.members.fillpattern = "SOLID_FOREGROUND">
		  <cfset rc.members.fgcolor = "GREY_25_PERCENT">
		  <cfset rc.dataGrid.locked = false>
		  <cfset rc.dataGrid.dataformat = "##,##0.00">
		  <cfset spreadsheetformatRows(rc.thesheet,rc.dataGrid,"2-#rc.totalN-1#")>
		  <cfset spreadsheetformatColumn(rc.theSheet,rc.members,1)>
		  <cfset spreadsheetformatRow(rc.thesheet,rc.header,1)>
		  <cfset spreadsheetformatRow(rc.thesheet,rc.header,rc.totalN)>
		  <cfset SpreadsheetSetHeader(rc.thesheet,rc.psaID,dateFormat(rc.period,"YYYY-MM-DD"),"")>
		  <cfif i eq 0>
		  	<cfspreadsheet action="write" filename="#rc.fileName#" name="rc.theSheet" sheet="#i+1#" sheetname="#rc.sheetName#" overwrite=true />
		  <cfelse>
		  	<cfspreadsheet action="update" filename="#rc.fileName#" name="rc.theSheet" sheet="#i+1#" sheetname="#rc.sheetName#" />
		  </cfif>


		</cfloop>
		</cfif>
		<cfset arguments.event.setLayout('Layout.ajax')>
		<cfset arguments.event.setView('turnover/enterspreadsheet')>
	</cffunction>

	<cffunction name="turnoverSpreadsheet" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  rc.psaID = arguments.event.getValue('psaid',0);
		  rc.psa = psa.getArrangement(rc.psaID);
		  rc.fileName = "#createUUID()#.xls";
		  rc.company = company.getCompany(rc.psa.company_id);
		  rc.xml = XMLParse(rc.psa.dealData);
		  rc.turnoverElements = psa.getFiguresEntryElements(rc.psaID,false);
		  rc.series = ArrayNew(1);
		  </cfscript>
		  <cfloop query="rc.turnoverelements">
		  	<cfset rc.turnover = figures.getTurnover(rc.psaID,id,0)>
		  	<cfset rc.x = StructNew()>
		  	<cfset rc.x["q"] = rc.turnover>
		  	<cfset rc.x["type"] = [getUnitType2(inputtypeID).type,"#cleanTurnoverName(inputName)#"]>
				<cfset ArrayAppend(rc.series,rc.x)>
			</cfloop>
		<cfset arguments.event.setLayout('Layout.ajax')>
		<cfset arguments.event.setView('turnover/spreadsheet')>
	</cffunction>

  <cffunction name="pivotTables" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfsetting requesttimeout="900">
    <cfset rc.sourceID = arguments.event.getValue("id",0)>
    <cfset rc.type = arguments.event.getValue("type","turnover")>
    <cfset rc.emailAddress = urlDecrypt(arguments.event.getValue("email",""))>
    <cfif contact.getContactByEmail(rc.emailAddress).recordCount neq 0>
      <cfdirectory action="list" directory="#rc.app.appRoot#/dms" filter="pivot_#rc.type#_#rc.sourceID#.xml" name="rc.p">
      <cfif rc.p.recordCount eq 0 OR DateCompare(rc.p.dateLastModified,DateAdd("h",-23,now())) lt 0>
        <cfif rc.type eq "turnover">
          <cfset rc.query = figures.renderPivots(rc.sourceID)>
          <cfset arguments.event.setView("turnover/pivotTables/render",true)>
        <cfelse>
          <cfset rc.query = figures.renderPivotRebate(rc.sourceID)>
          <cfset arguments.event.setView("turnover/pivotTables/renderRebates",true)>
        </cfif>
      <cfelse>
        <cfset arguments.event.setView("turnover/pivotTables/output",true)>
      </cfif>
    </cfif>
  </cffunction>
  <cffunction name="renderPivotTables" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.sourceID = arguments.event.getValue("id",0)>
    <cfset rc.query = figures.renderPivots(rc.sourceID)>
    <cfset arguments.event.setView("turnover/pivotTables/render",true)>
  </cffunction>
	<cffunction name="upload" returnType="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfscript>
			rc.psaID = arguments.event.getValue("psaID","");
			rc.fileData = arguments.event.getValue("fileData","");
			rc.filename = arguments.event.getValue("filename","speng");
			rc.fullPath = createUniqueFileName("/tmp/spreadsheet.xls");
		</cfscript>
		<cffile action="copy" source="#rc.fileData#" destination="#rc.fullPath#">
		<cfscript>
			arguments.event.setLayout("Layout.ajax");
			arguments.event.setView("turnover/uploadcomplete");
		</cfscript>
	</cffunction>

  <cffunction name="dashboard" returntype="void" output="false" cache="true">
    <cfargument name="event" required="true" type="any">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.deals = psa.getCurrentDeals()>
    <cfscript>
      arguments.event.setView("turnover/dashboard");
    </cfscript>
  </cffunction>
  <cffunction name="dashboarddata" returntype="void" output="false">
    <cfargument name="event" required="true" type="any">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.deals = psa.getCurrentDeals()>
    <cfset rc.late = QueryNew("Late")>
    <cfloop query="rc.deals">
      <cfif DateCompare(period_to,now()) gte 1>
        <!--- the deal hasn't ended --->
        <cfset rc.monthsLate = DateDiff("m",lastDate,now())-1>
      <cfelse>
        <cfset rc.monthsLate = DateDiff("m",lastDate,period_to)>
      </cfif>
      <cfset QueryAddRow(rc.late)>
      <cfset QuerySetCell(rc.late,"Late",rc.monthsLate)>
    </cfloop>
    <cfquery name="rc.late" dbtype="query">
      select count(Late) as monthsLate, Late from rc.late group by Late;
    </cfquery>
    <cfscript>

      arguments.event.setLayout("Layout.ajax");
      arguments.event.setView("charts/turnoverdashboard");
    </cfscript>
  </cffunction>

  <cffunction name="runCalculations" returntype="void" output="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfsetting requesttimeout="9000">
    <cfset rc.currentDeals = psa.getCurrentDeals()>
    <cfset rc.errorLog = "">
    <cfset rc.errors = false>
    <cfloop query="rc.currentDeals">
      <cfset calculations.calculateRebate(id)>
    </cfloop>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("blank")>
  </cffunction>

  <cffunction cache="true" name="targets" returntype="void" output="true">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset var difference = "">
    <cfset var i  = "">
    <cfset var x  = "">
    <cfset var stepQuery  = "">
    <cfset var calcs  = "">
    <cfsetting requesttimeout="900">
    <cfset rc.difference = arguments.event.getValue("difference",7)>
    <cfset rc.missed = arguments.event.getValue("missed",false)>
    <cfif rc.missed>
      <cfset rc.currentDeals = psa.getCurrentDeals()>
    <cfelse>
      <cfset rc.currentDeals = psa.getCurrentDeals()>
    </cfif>
    <!--- select all deals with a stepped rebate --->
		<cfset rc.currentDeals = psa.getCurrentDeals()>
		<!--- create an array object to hold all the deals --->
		<cfset rc.dealObject = ArrayNew(1)>
		<cfset rc.workers = QueryNew("supplier,dealID,currentValue,possibleValue,percentIncrease,payout,currentOTETurnover,requiredTurnover,rebateName")>
		<cfoutput query="rc.currentDeals">
		  <cfset rc.dealObject[currentRow] = StructNew()>
		  <cfset rc.dealObject[currentRow].dealID = id>
		  <cfset rc.dealObject[currentRow].elements = ArrayNew(1)>
		  <cfset rc.xmlData = xmlParse(dealData)><!--- parse the XML --->
		  <cfset rc.nodes = xmlSearch(rc.xmlData,"//component/rebateType[@name='stepped']//parent::*")><!--- grab the elements which have stepped rebate --->
		  <cfloop from="1" to="#ArrayLen(rc.nodes)#" index="x">
        <cftry>
		    <cfset rc.node = rc.nodes[x]>
        <cfif isDefined('rc.node.step')>
			    <cfset stepQuery = QueryNew("valuefrom,valueto,amount")><!--- create an empty query object to hold the steps --->
			    <cfloop from="1" to="#ArrayLen(rc.node.step)#" index="i">
			      <cfset QueryAddRow(stepQuery)>
			      <cfset QuerySetCell(stepQuery,"valuefrom", Iif(rc.node.step[i].from.XmlText eq "" or not isNumeric(rc.node.step[i].from.XmlText),"0","#rc.node.step[i].from.XmlText#"))>
			      <cfset QuerySetCell(stepQuery,"valueto",Iif(rc.node.step[i].to.XmlText eq "" or not isNumeric(rc.node.step[i].to.XmlText),"0","#rc.node.step[i].to.XmlText#"))>
			      <cfset QuerySetCell(stepQuery,"amount",rc.node.step[i].value.XmlText)>
			    </cfloop>
			    <cfif rc.node.outputType.xmlText eq "6">
			      <!--- get the estimated turnover for the element --->
			      <cfset calcs = figures.targetCalculations(id,rc.node.id.xmlText)>
			      <!--- now get the current step they are in --->
			      <cfif isNumeric(calcs.OTEThroughput)>
			        <cfquery name="rc.currentStep" dbtype="query">
			          select * from stepQuery where valuefrom < <cfqueryparam value="#calcs.OTEThroughput#" cfsqltype="cf_sql_decimal"> order by amount desc;
			        </cfquery>
			        <cfquery name="rc.nextStep" dbtype="query">
			          select * from stepQuery where valuefrom > <cfqueryparam value="#calcs.OTEThroughput#" cfsqltype="cf_sql_decimal"> order by amount asc;
			        </cfquery>
			        <cfset rc.dealObject[currentRow].elements[x] = StructNew()>
			        <cfset rc.dealObject[currentRow].elements[x].calculations = calcs>
			        <cfset rc.dealObject[currentRow].elements[x].steps = stepQuery>
			        <cfset rc.dealObject[currentRow].elements[x].rebateID = rc.node.id.xmlText>
              <cfset rc.dealObject[currentRow].elements[x].rebateName = rc.node.title.xmlText>
			        <cfset rc.dealObject[currentRow].elements[x].currentStep = StructNew()>
			        <cfset rc.dealObject[currentRow].elements[x].currentStep.from = Iif(rc.currentStep.valuefrom eq "","0","#rc.currentStep.valuefrom#")>
			        <cfset rc.dealObject[currentRow].elements[x].currentStep.to = Iif(rc.currentStep.valueto eq "" or not isNumeric(rc.currentStep.valueto),"0","#rc.currentStep.valueto#")>
			        <cfset rc.dealObject[currentRow].elements[x].currentStep.value = Iif(rc.currentStep.amount eq "","0","#rc.currentStep.amount#")>
			        <cfset rc.dealObject[currentRow].elements[x].nextStep = StructNew()>
			        <cfset rc.dealObject[currentRow].elements[x].nextStep.from = Iif(rc.nextStep.valuefrom eq "","'0'","'#rc.nextStep.valuefrom#'")>
			        <cfset rc.dealObject[currentRow].elements[x].nextStep.to = Iif(rc.nextStep.valueto eq "" or not isNumeric(rc.nextStep.valueto),"'0'","'#rc.nextStep.valueto#'")>
			        <cfset rc.dealObject[currentRow].elements[x].nextStep.value = Iif(rc.nextStep.amount eq "","'0'","'#rc.nextStep.amount#'")>
			        <cfif rc.dealObject[currentRow].elements[x].nextStep.from neq 0>
			          <!--- there is a next step --->
			          <cfset difference = 100-calcs.OTEThroughput/rc.dealObject[currentRow].elements[x].nextStep.from*100>
			          <cfset rc.dealObject[currentRow].elements[x].difference = difference>
			          <cfset rc.dealObject[currentRow].elements[x].currentPayable = rc.dealObject[currentRow].elements[x].calculations.OTEThroughput/100*rc.dealObject[currentRow].elements[x].currentStep.value>
			          <cfset rc.dealObject[currentRow].elements[x].possiblePayable = rc.dealObject[currentRow].elements[x].nextStep.from/100*rc.dealObject[currentRow].elements[x].nextStep.value>
			          <cfset rc.dealObject[currentRow].elements[x].gain = rc.dealObject[currentRow].elements[x].possiblePayable-rc.dealObject[currentRow].elements[x].currentPayable>
			          <cfif difference lte rc.difference>
			            <cfset QueryAddRow(rc.workers)>

			            <cfset QuerySetCell(rc.workers,"supplier",known_as)>
			            <cfset QuerySetCell(rc.workers,"dealID",id)>
			            <cfset QuerySetCell(rc.workers,"currentValue",rc.dealObject[currentRow].elements[x].currentStep.value)>
			            <cfset QuerySetCell(rc.workers,"possibleValue",rc.dealObject[currentRow].elements[x].nextStep.value)>
			            <cfset QuerySetCell(rc.workers,"percentIncrease",difference)>
			            <cfset QuerySetCell(rc.workers,"currentOTETurnover",rc.dealObject[currentRow].elements[x].calculations.OTEThroughput)>
			            <cfset QuerySetCell(rc.workers,"requiredTurnover",rc.dealObject[currentRow].elements[x].nextStep.from)>
			            <cfset QuerySetCell(rc.workers,"payout",rc.dealObject[currentRow].elements[x].gain)>
                  <cfset QuerySetCell(rc.workers,"rebateName",rc.dealObject[currentRow].elements[x].rebateName)>
			           </cfif>
			        </cfif>
			      </cfif>
			    </cfif>
        </cfif>
        <cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
        </cftry>
		  </cfloop>
		</cfoutput>
		<cfquery name="rc.fullList" dbtype="query">
		  select * from rc.workers order by percentIncrease asc;
		</cfquery>

    <cfset arguments.event.setView("turnover/targets")>
  </cffunction>

  <cffunction name="memberturnover" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.dateFrom = arguments.event.getValue("dateFrom",createDate(year(now()),1,1))>
    <cfset rc.dateTo = arguments.event.getValue("dateTo",createDate(year(now()),12,31))>
    <cfset rc.figures = figures.getAllMemberTurnover(rc.dateFrom,rc.dateTo)>
    <cfset arguments.event.setView("turnover/memberspreadsheet",true)>
  </cffunction>
  <cffunction name="groupturnover" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.dateFrom = arguments.event.getValue("dateFrom",createDate(year(now()),1,1))>
    <cfset rc.dateTo = arguments.event.getValue("dateTo",createDate(year(now()),12,31))>
    <cfset rc.figures = figures.getAllTurnover(rc.dateFrom,rc.dateTo)>
    <cfset arguments.event.setView("turnover/groupspreadsheet",true)>
  </cffunction>
  <cffunction name="rebatePaid" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.paymentID = arguments.event.getValue("paymentID",0)>
    <cfset rc.paid = arguments.event.getValue("paid","")>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.xmlID = arguments.event.getValue("xmlID",0)>
    <cfset rc.periodName = arguments.event.getValue("periodName",0)>
    <cfset figures.setPaid(rc.paymentID,rc.paid,rc.psaID,rc.xmlID,rc.periodName)>
    <cfif paid eq "true">
      <cftry><cfset feed.createFeedItem('contact',rc.sess.eGroup.contactID,'rebatePayments',rc.paymentID,'memberPaid','company',rc.sess.eGroup.companyID,rc.sess.eGroup.companyID,rc.paymentID)><cfcatch type="any"><cflog application="true" text="#cfcatch.Message#"></cfcatch></cftry>
    <cfelseif paid eq "holding">
      <cftry><cfset feed.createFeedItem('contact',rc.sess.eGroup.contactID,'arrangement',rc.psaID,'groupPaid','company',rc.sess.eGroup.companyID,rc.sess.eGroup.companyID,rc.paymentID)><cfcatch type="any"><cflog application="true" text="#cfcatch.Message#"></cfcatch></cftry>
    </cfif>
    <cfif rc.paymentID eq 0>
      <cfset rc.figuresPeriod = figures.getCalculationPeriod(rc.paymentID,rc.psaID,rc.xmlID,rc.periodName)>
      <cfset arguments.event.setView(name="turnover/calculationperiod",noLayout=true)>
    <cfelse>
    <cfset arguments.event.setView(name="blank",noLayout=true)>
    </cfif>
  </cffunction>

  <cffunction name="pollCalculations" returntype="void" output="false" cache="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.json = {}>
    <cfset rc.calcStatus = calculations.pollStatus(rc.psaID)>
    <cfif rc.calcStatus.recordCount neq 0>
      <cfset rc.jsonO["status"] = rc.calcStatus.percent>
      <cfset rc.jsonO["secondsAgo"] = DateDiff("s",rc.calcStatus.timestarted,DateConvert('local2utc',now()))>
    <cfelse>
      <cfset rc.jsonO["status"] =100>
      <cfset rc.jsonO["secondsAgo"] =0>
    </cfif>
    <cfset rc.json = Serializejson(rc.jsonO)>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>
</cfcomponent>

