<cfcomponent output="false" cache="true" cacheTimeout="30" >

  <cfproperty name="bugs" inject="model:BugService" scope="instance" />
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
  <cfproperty name="pingdom" inject="model:pingdomService">
  <cfscript>
    instance = structnew();
  </cfscript>

  <cffunction name="preHandler" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfif NOT rc.isAjax>
      <cfset rc.bugCount = instance.bugs.cCount("","true")>
    </cfif>
  </cffunction>

  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.do = event.getValue("do","login")>
    <cfset rc.overviewData = instance.bugs.dashBoardData()>

    <cfset event.setView('list')>
  </cffunction>

  <cffunction name="current" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.hideClosed = event.getValue("hideClosed","true")>
    <cfset rc.mine = event.getValue("mine","false")>
    <cfset event.setView('current')>
  </cffunction>

  <cffunction name="overview" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.do = event.getValue("do","login")>
	  <cfset rc.overviewData = instance.bugs.dashBoardData()>
    <cfset event.setView('dashboard')>
  </cffunction>

  <cffunction name="chart" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.type = event.getValue("type","help")>
    <cfset event.setView('charts/overview/#rc.type#')>
  </cffunction>

  <cffunction name="chartDataOverview" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
      rc.salesData = instance.bugs.chartOverview();
      event.renderData(data=rc.salesData,type="JSON");
  </cfscript>
  </cffunction>

  <cffunction name="chartDataServer" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
      rc.salesData = instance.bugs.chartServer();
      event.renderData(data=rc.salesData,type="JSON");
  </cfscript>
  </cffunction>

  <cffunction name="chartDataResolved" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
      rc.salesData = instance.bugs.chartResolved();
      event.renderData(data=rc.salesData,type="JSON");
  </cfscript>
  </cffunction>

  <cffunction cache="false" name="list" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.sortColumn1 = event.getValue("iSortCol_0",0);
      rc.sortDirection1 = event.getValue("sSortDir_0","asc");
      rc.sortColumn2 = event.getValue("iSortCol_10",0);
      rc.sortDirection2 = event.getValue("sSortDir_1","asc");
      rc.sortColumn3 = event.getValue("iSortCol_2",0);
      rc.sortDirection3 = event.getValue("sSortDir_2","asc");
      rc.sortColumn4 = event.getValue("iSortCol_3",0);
      rc.sortDirection4 = event.getValue("sSortDir_3","asc");
      rc.hideClosed = event.getValue("hideClosed","true");
      rc.showMine = event.getValue("showMine","false");
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection1 = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.sortStatement = dataTablesSorter(event,["id","status","priority","info","username","title","created","modified","comments","fixDate","fixVersion","site","assigneeName","version","componentType","description"]);
      rc.bugCount = instance.bugs.cCount(rc.searchQuery,rc.hideClosed);
      rc.bugData = instance.bugs.list(rc.startRow,rc.maxRows,rc.searchQuery,rc.hideClosed,rc.sortStatement,rc.showMine);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.bugCount;
      rc.json["iTotalDisplayRecords"] = rc.bugCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.bugData">
      <cfsavecontent variable="actionTD"><cfoutput><cfif status neq "closed"><a href="##" rev="#id#" class="tooltip tdicon closeTicket door" title="Close Ticket"></a></cfif><a href="##" rev="#id#" class="tooltip tdicon #type#" title="Type: #type#"></a><a href="##" rev="#id#" title="Delete Bug" class="tooltip delete tdicon"></a></cfoutput></cfsavecontent>
	    <cfif commentCount eq 0>
			  <cfset labelStyle = "">
			<cfelseif commentCount gt 0 AND commentCount lt 5>
				<cfset labelStyle = "label-warning">
			<cfelse>
				<cfset labelStyle = "label-important">
		  </cfif>
		  <cfif title eq "">
		  	<cfset coltitle = "no subject">
			<cfelse>
				<cfset coltitle = "#title#">
		  </cfif>
      <cfset thisRow = [
	       "#id#",
	       '<a href="#bl('bugs.setStatus','id=#id#',event)#" rel="#status#" title="Status: #status#" class="noAjax modaldialog tooltip tdicon #status#"></a>',
	       '<a href="##" rev="#id#" rel="#priority#" title="Priority: #priority#" class="noAjax tooltip priority tdicon traffic_#priority#"></a>',
         "#actionTD#",
         "#username#",
         '<a href="#bl('bugs.detail','id=#id#',event)#" title="Ticket: #ticket#" class="tooltip showmessage">#coltitle#</a><span class="hidden"><pre>#description#</pre></span><br/>',
         "#dateFormatOrdinal(created,"D MMM")#",
         "#dateFormatOrdinal(modified,"D MMM")#",
         "#assigneeName#",
         "#version#",
         "#componentType#",
         "#dateFormatOrdinal(fixDate,"D MMM")#",
         "#fixVersion#",
         '<span class="label #labelStyle#">#commentCount#</span>',
         "#site#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction name="detail" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.bug = instance.bugs.getBug(rc.id)>
    <cfset event.setView('detail')>
  </cffunction>

  <cffunction name="edit" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.bug = instance.bugs.getBug(rc.id)>
    <cfset event.setView('edit')>
  </cffunction>

  <cffunction name="download" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.attachment = instance.bugs.getAttachment(rc.id)>
    <cfheader name="Content-Disposition" value="attachment;filename=#ListLast(rc.attachment.filename,"/")#">
    <cfcontent file="#rc.attachment.filename#" type="#getPageContext().getServletContext().getMimeType('#rc.attachment.filename#')#">
  </cffunction>

  <cffunction name="doEdit" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
    rc.id = event.getValue('id',0);
        if (rc.id neq 0 and rc.id neq "") {
          rc.bug = instance.bugs.getBug(rc.id);
          rc.bug = populateModel(rc.bug);
        } else {
          rc.bug = populateModel(instance.bugs);
        }
        rc.bug.save();
        setNextEvent(uri="/bugs/detail/id/#rc.bug.getid()#");
    </cfscript>
  </cffunction>


  <cffunction name="priority" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.priority = event.getValue("priority",1)>
    <cfset rc.newpriority = instance.bugs.changePriority(rc.id,rc.priority)>
    <cfset rc.jsonOb = StructNew()>
    <cfset rc.jsonOb["priority"] = rc.newpriority>
    <cfset rc.json = SerializeJSON(rc.jsonOb)>
    <cfset event.setView("renderJSON")>
  </cffunction>

  <cffunction name="createcomment" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.bugID = event.getValue("bugID",0)>
    <cfset rc.comment = event.getValue("comment",1)>
    <cfset rc.newpriority = instance.bugs.addComment(rc.bugID,rc.comment)>
    <cfset setNextEvent(uri="/bugs/detail/id/#rc.bugID#")>
  </cffunction>

  <cffunction name="delete" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset instance.bugs.delete(rc.id)>
    <cfset rc.jsonOb = StructNew()>
    <cfset rc.jsonOb["ok"] = "ok">
    <cfset rc.json = SerializeJSON(rc.jsonOb)>
    <cfset event.setView(view="renderJSON",noLayout=true)>
  </cffunction>

  <cffunction name="status" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.status = event.getValue("status",1)>
    <cfset rc.newstatus = instance.bugs.changeStatus(rc.id,rc.status)>
    <cfset rc.jsonOb = StructNew()>
    <cfset rc.jsonOb["status"] = rc.newstatus>
    <cfset rc.json = SerializeJSON(rc.jsonOb)>
    <cfset event.setView(view="renderJSON",noLayout=true)>
  </cffunction>

  <cffunction name="setStatus" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.bug = instance.bugs.getBug(rc.id)>
    <cfset event.setView('status')>
  </cffunction>

  <cffunction name="dashboarddata" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.resolveDays = instance.bugs.overViewData()>

    <cfset event.setView('charts/overview')>
  </cffunction>

  <cffunction name="escalate" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.ticket = event.getValue("ticket","")>
    <cfset instance.bugs.escalate(rc.ticket)>
    <cfset event.setView("escalated")>
  </cffunction>

</cfcomponent>