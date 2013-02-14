<cfcomponent name="groupService" output="true" cache="true" cacheTimeout="0" autowire="true">

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />


  <cffunction name="init">
    <cfargument name="dsn" inject="coldbox:datasource:BMNet" >
    <cfargument name="logger" inject="logbox:root">
     <cfset variables.dsn = arguments.dsn>
     <cftry>
        <cfset this.groupRelationships = cacheget("groupService",true,replaceNoCase(cgi.http_host,'.','','ALL'))>
        <cfcatch type="any">
          <cfset this.groupRelationships = getGrouprelationships()>
          <cfset cacheput("groupService",this.groupRelationships,createTimeSpan(0,0,10,0),createTimeSpan(0,0,10,0),replaceNoCase(cgi.http_host,'.','','ALL'))>
        </cfcatch>
     </cftry>
     <cftry>
       <cfset this.securityGroups = cacheget("securityGroups",true,replaceNoCase(cgi.http_host,'.','','ALL'))>
       <cfset this.securityGroupIDs = cacheget("securityGroupIDs",true,replaceNoCase(cgi.http_host,'.','','ALL'))>
       <cfcatch type="any">
         <cfset var memberGroupID = getGroupByName("Member Permissions")>
         <cfset var groupGroupID = getGroupByName("Group Permissions")>
         <cfset var supplierGroupID = getGroupByName("Supplier Permissions")>
         <cfset var memberGroups = recurseForwards(memberGroupID)>
         <cfset var groupGroups = recurseForwards(groupGroupID)>
         <cfset var suppierGroups = recurseForwards(supplierGroupID)>
         <cfset var securityGroups = {
           group = [],
           members = [],
           suppliers = []
         }>
         <cfset var securityGroupIDs = "">
         <cfloop query="groupGroups">
           <cfset x = StructNew()>
           <cfset x["name"] = name>
           <cfset x["id"] = id>
           <cfset arrayAppend(securityGroups.group,x)>
           <cfset listAppend(securityGroupIDs,id)>
         </cfloop>
         <cfloop query="memberGroups">
           <cfset x = StructNew()>
           <cfset x["name"] = name>
           <cfset x["id"] = id>
           <cfset arrayAppend(securityGroups.members,x)>
           <cfset listAppend(securityGroupIDs,id)>
         </cfloop>
         <cfloop query="suppierGroups">
           <cfset x = StructNew()>
           <cfset x["name"] = name>
           <cfset x["id"] = id>
           <cfset arrayAppend(securityGroups.suppliers,x)>
           <cfset listAppend(securityGroupIDs,id)>
         </cfloop>
         <cfset this.securityGroups = securityGroups>
         <cfset this.securityGroupIDs = securityGroupIDs>
         <cfset cacheput("securityGroups",this.securityGroups,createTimeSpan(1,0,0,0),createTimeSpan(1,0,0,0),replaceNoCase(cgi.http_host,'.','','ALL'))>
         <cfset cacheput("securityGroupIDs",this.securityGroupIDs,createTimeSpan(1,0,0,0),createTimeSpan(1,0,0,0),replaceNoCase(cgi.http_host,'.','','ALL'))>
         <cfset arguments.logger.debug("initing...")>
       </cfcatch>
     </cftry>

     <cfset this.instance = structnew()>

     <cfreturn this>
  </cffunction>

  <cfscript>

      function QueryDeDupe(theQuery,keyColumn) {
        var checkList='';
        if (theQuery.recordCount)
        var newResult=QueryNew(Lcase(theQuery.ColumnList));
        var keyvalue='';
        var q = 1;
        for (;q LTE theQuery.RecordCount;q=q+1) {
          keyvalue = theQuery[keycolumn][q];
          if (NOT ListFind(checkList,keyvalue) AND keyvalue neq "") {
            checkList=ListAppend(checklist,keyvalue);
            QueryAddRow(NewResult);
            for (x=1;x LTE ListLen(theQuery.ColumnList);x=x+1) {
              QuerySetCell(NewResult,ListGetAt(theQuery.ColumnList,x),theQuery[ListGetAt(theQuery.ColumnList,x)][q]);
            }
          }
        }
        return NewResult;
      }
  </cfscript>

  <cffunction name="renameGroup" returntype="Any">
    <cfargument name="id">
    <cfargument name="name">
    <cfquery name="u" datasource="#dsn.getName()#">
      update contactGroup
      set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
      where
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
  </cffunction>

  <cffunction name="getAllChildContactsforGrid" returntype="any">
    <cfargument name="groupData" required="yes">
    <cfset var groupIDs = ArrayNew(1)>
    <cfset var returnQ = queryNew("id,known_as,name,company_id")>
    <cfset var x = "">
    <cfset var i = "">
    <cfset var groupID = "">
    <cfloop from="1" to="#ArrayLen(groupData)#" index="i">
      <cfscript>
        if (StructKeyExists(groupData[i],'groupname')) {
          // it's a a group, add it to the group Array
          x = ArrayAppend(groupIDs,groupData[i].id);
        } else {
          x = QueryAddRow(returnQ);
          x = QuerySetCell(returnQ,"id","#groupData[i].id#");
          x = QuerySetCell(returnQ,"company_id","#groupData[i].company_id#");
          x = QuerySetCell(returnQ,"name","#groupData[i].name#");
          x = QuerySetCell(returnQ,"known_as","#groupData[i].known_as#");
        }
      </cfscript>
    </cfloop>
    <cfloop array="#groupIDs#" index="groupID">
      <cfset returnQ = recurseChildren(returnQ,groupID)>
    </cfloop>
    <cfreturn returnQ>
  </cffunction>

  <cffunction name="recurseChildren" access="private" returntype="Query">
    <cfargument name="q" required="true" type="query">
    <cfargument name="pID" required="true" type="numeric">
    <cfset var children = getChildrenContacts(pID)>
    <cfset var groups = getChildrenGroups(pID)>
    <cfloop query="children">
      <cfset QueryAddRow(arguments.q)>
      <cfset QuerySetCell(arguments.q,"id",id)>
      <cfset QuerySetCell(arguments.q,"known_as",known_as)>
      <cfset QuerySetCell(arguments.q,"name","#first_name# #surname#")>
      <cfset QuerySetCell(arguments.q,"company_id",companyID)>
    </cfloop>
    <cfloop query="groups">
      <cfset arguments.q = recurseChildren(arguments.q,oID)>
    </cfloop>
    <cfreturn arguments.q>
  </cffunction>

  <cffunction name="getChildrenGroups" returntype="query">
    <cfargument name="parentID" required="yes" type="numeric">
    <cfquery name="childrenG" datasource="#dsn.getName()#">
  		SELECT
      	oID, parentID,
        name,oType
        from
        contactGroupRelation,
        contactGroup
       where
  		 parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parentID#">
  		 AND
  		 oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="group">
       AND
       contactGroup.id = contactGroupRelation.oid
       order by name asc;
  	</cfquery>
    <cfreturn childrenG>
  </cffunction>

  <cffunction name="getRecursiveChildrenContacts" returntype="query">
    <cfargument name="parentID" required="yes" type="numeric">
    <cfargument name="q" required="false" type="q">
    <cfif NOT isDefined("arguments.q")>
     <cfset q = QueryNew("id,known_as,name,company_id")>
    </cfif>
    <cfset var children = getChildrenContacts(parentID)>
    <cfset var groups = getChildrenGroups(parentID)>
    <cfloop query="children">
      <cfset QueryAddRow(q)>
      <cfset QuerySetCell(q,"id",id)>
      <cfset QuerySetCell(q,"known_as",known_as)>
      <cfset QuerySetCell(q,"name","#first_name# #surname#")>
      <cfset QuerySetCell(q,"company_id",companyID)>
    </cfloop>
    <cfloop query="groups">
      <cfset q = recurseChildren(q,oID)>
    </cfloop>
    <cfreturn q>
  </cffunction>

  <cffunction name="getChildrenContacts" returntype="query">
    <cfargument name="parentID" required="yes" type="numeric">
    <cfargument name="s" required="true" default="false">
    <cfquery name="childrenC" datasource="#dsn.getName()#">
  		SELECT
      	contact.id,
  			first_name,
        company.id as companyID,
  			surname,
  			known_as
        from
  			contact left join company on company.id = contact.company_id,
        contactGroupRelation
       where
  		 contactGroupRelation.parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parentID#">
  		 AND
  		 contactGroupRelation.oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
       AND
       <cfif arguments.s>
       contact.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
       AND
       </cfif>
       contact.id = contactGroupRelation.oid

  	</cfquery>
    <cfreturn childrenC>
  </cffunction>

  <cffunction name="getChildrenContactsList" returntype="query">
    <cfargument name="parentID" required="yes" type="any">
    <cfquery name="childrenC" datasource="#dsn.getName()#">
      SELECT
        contact.id,
        first_name,
        site.id as companyID,
        surname,
        known_as
        from
        contact,
        site,
        contactGroupRelation
       where
       contactGroupRelation.parentID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#parentID#" list="true">)
       AND
       contactGroupRelation.oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
       AND
       contact.id = contactGroupRelation.oid
       AND
       site.id = contact.company_id
    </cfquery>
    <cfreturn childrenC>
  </cffunction>

  <cffunction name="getContactsRemote" returntype="query">
    <cfquery name="c" datasource="#dsn.getName()#">
    select
         contact.id,
         concat(contact.first_name," ",contact.surname) as name,
         "contact" as oType,
         company.known_as,
        contact.company_id
           from contact,
           company
         where
        contact.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        company.id = contact.company_id
    </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="calendarGroups" returntype="query">
    <cfquery name="g" datasource="#dsn.getName()#">
            select id, name as groupname, "group" as oType from contactGroup
            ;
          </cfquery>
    <cfreturn g>
  </cffunction>

  <cffunction name="CompanyMember" returntype="numeric" output="no">
    <cfargument name="companyID" required="yes">
    <cfquery name="co" datasource="#dsn.getName()#">
      	select siteID from site where id = '#companyID#';
      </cfquery>
    <cfreturn co.siteID>
  </cffunction>

  <cffunction name="getGroupName" returntype="string">
    <cfargument name="groupID" required="yes" type="numeric">
    <cfquery name="getGroup" datasource="#dsn.getName()#">
      	select name from contactGroup where id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#groupID#">
      </cfquery>
    <cfreturn getGroup.name>
  </cffunction>

  <cffunction name="getGroupByName" returntype="numeric">
    <cfargument name="groupName" required="yes" type="string">
    <cfquery name="getGroup" datasource="#dsn.getName()#">
        select id from contactGroup where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#groupName#">
    </cfquery>
    <cfif getGroup.recordCount neq 0>
      <cfreturn getGroup.id>
    <cfelse>
      <cfreturn 0>
    </cfif>
  </cffunction>

  <cffunction name="canViewDoc" returntype="boolean">
    <cfargument name="docID">
    <cfquery name="getSec" datasource="#dsn.getName()#">
      	select groupID from dmsSecurity where relatedID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.docID#">
        AND securityAgainst = 'document'
        AND priviledge = 'view'
      </cfquery>
    <cfif getSec.recordCount gte 1>
      <cfif IsUserInRole(getGroupName(getSec.groupID))>
        <cfreturn true>
        <cfelse>
        <cfreturn false>
      </cfif>
      <cfelse>
      <cfreturn true>
    </cfif>
  </cffunction>

  <cffunction name="getChildContacts" returntype="query" access="remote">
    <cfargument name="groupData" required="yes">
    <cfset var groupIDs = ArrayNew(1)>
    <Cfset var returnQ = queryNew("id,known_as,name,company_id")>
    <cfset var x = "">
    <cfset var z = "">
    <cfset var i = "">
    <cfloop from="1" to="#ArrayLen(arguments.groupData)#" index="i">
      <cfscript>
  			if (StructKeyExists(arguments.groupData[i],'groupname')) {
  				// it's a a group, add it to the group Array
  				x = ArrayAppend(groupIDs,arguments.groupData[i].id);
  			} else {
  				x = QueryAddRow(returnQ);
  				x = QuerySetCell(returnQ,"id","#arguments.groupData[i].id#");
  				x = QuerySetCell(returnQ,"company_id","#arguments.groupData[i].company_id#");
  				x = QuerySetCell(returnQ,"name","#arguments.groupData[i].name#");
  				x = QuerySetCell(returnQ,"known_as","#arguments.groupData[i].known_as#");
  			}
  		</cfscript>
    </cfloop>
    <cfset x = ArrayToList(groupIDs)>
    <cfquery name="childCategories" datasource="#dsn.getName()#">
    	select
      	concat(contact.first_name," ",contact.surname) as name,
        contact.id as id,
        contactGroupRelation.oType,
        contact.company_id,
        site.known_as
      from
      	contact,
        site,
        contactGroupRelation
      where
      	contactGroupRelation.parentID IN(#x#)
      and
      	contactGroupRelation.oType = 'contact'
      and
      	contact.id = contactGroupRelation.oID
      and
      	site.id = contact.company_id
      group by id;
     </cfquery>
    <cfloop query="childCategories">
      <cfscript>
  			x = QueryAddRow(returnQ);
  			x = QuerySetCell(returnQ,"id","#id#");
  			x = QuerySetCell(returnQ,"company_id","#company_id#");
  			x = QuerySetCell(returnQ,"name","#name#");
  			x = QuerySetCell(returnQ,"known_as","#known_as#");
  		</cfscript>
    </cfloop>
    <cfset z = QueryDeDupe(returnQ,'id')>
    <cfreturn z>
  </cffunction>

  <cffunction name="getRecursiveChildContacts" returntype="query" access="remote">
    <cfargument name="groupData" required="yes">
    <cfset var groupIDs = ArrayNew(1)>
    <cfset var x = "">
    <cfset var z = "">
    <cfset var i = "">
    <cfset var GroupList = "">
    <Cfset variables.returnQ = queryNew("id,known_as,name,company_id")>
    <cfloop from="1" to="#ArrayLen(groupData)#" index="i">
      <cfscript>
  			if (StructKeyExists(groupData[i],'groupname')) {
  				// it's a a group, add it to the group Array
  				x = ArrayAppend(groupIDs,groupData[i].id);
  			} else {
  				x = QueryAddRow(variables.returnQ);
  				x = QuerySetCell(variables.returnQ,"id","#groupData[i].id#");
  				x = QuerySetCell(variables.returnQ,"company_id","#groupData[i].company_id#");
  				x = QuerySetCell(variables.returnQ,"name","#groupData[i].name#");
  				x = QuerySetCell(variables.returnQ,"known_as","#groupData[i].known_as#");
  			}
  		</cfscript>
    </cfloop>
    <cfset GroupList = ArrayToList(groupIDs)>
    <cfset x = putChildrenContactsIntoQuery(GroupList)>
    <cfset z = QueryDeDupe(variables.returnQ,'id')>
    <cfreturn z>
  </cffunction>

  <cffunction name="arrayFind" access="public" hint="returns the index number of an item if it is in the array" output="false" returntype="numeric">
    <cfargument name="array" required="true" type="array">
    <cfargument name="valueToFind" required="true" type="string">
    <cfreturn (arguments.array.indexOf(arguments.valueToFind)) + 1>
  </cffunction>

  <cffunction name="putChildrenContactsIntoQuery" returntype="any">
    <cfargument name="groupList" required="yes">
    <cfset var x = "">
    <cfset var newGroupList = "">
    <cfquery name="childCategories" datasource="#dsn.getName()#">
    	select
      	concat(contact.first_name," ",contact.surname) as name,
        contact.id as id,
        contactGroupRelation.oType,
        contact.company_id,
        site.known_as
      from
      	contact,
        site,
        contactGroupRelation
      where
      	contactGroupRelation.parentID IN(#groupList#)
      and
      	contactGroupRelation.oType = 'contact'
      and
      	contact.id = contactGroupRelation.oID
      and
      	site.id = contact.company_id
      group by id;
     </cfquery>
    <cfloop query="childCategories">
      <cfscript>
  			x = QueryAddRow(variables.returnQ);
  			x = QuerySetCell(variables.returnQ,"id","#id#");
  			x = QuerySetCell(variables.returnQ,"company_id","#company_id#");
  			x = QuerySetCell(variables.returnQ,"name","#name#");
  			x = QuerySetCell(variables.returnQ,"known_as","#known_as#");
  		</cfscript>
    </cfloop>
    <!--- now get the child groups --->
    <cfquery name="childCategories" datasource="#dsn.getName()#">
    	select
      	contactGroupRelation.oid as oid
      from
        contactGroupRelation
      where
      	contactGroupRelation.parentID IN(#groupList#)
      and
      	contactGroupRelation.oType = 'group'
     </cfquery>
    <cfset newGroupList = ValueList(childCategories.oid)>
    <cfif ListLen(newGroupList) gte 1>
      <cfset x = putChildrenContactsIntoQuery(newGroupList)>
    </cfif>
  </cffunction>

  <cffunction name="getChildren" returntype="query">
    <cfargument name="parentID" required="yes">
    <cfargument name="sortBy" required="true" default="name">
    <cfargument name="sortOrder" required="true" default="asc">
    <cfquery name="children" datasource="#dsn.getName()#">
      SELECT
        oID, parentID,
        name
        from
        contactGroupRelation,
        contactGroup
       where
       parentID = '#arguments.parentid#'
       AND
       oType = 'group'
       AND
       contactGroup.id = contactGroupRelation.oid
       order by #sortBy# #sortOrder#
    </cfquery>
    <cfreturn children>
  </cffunction>

  <cffunction name="getChildrenBT" returntype="query">
    <cfargument name="parentID" required="yes">
    <cfargument name="secure" required="yes" type="boolean" default="true">
    <cfquery name="children" datasource="#dsn.getName()#">
  		SELECT
      	id, parentID,
        name
        from
        buyingTeam
       where
       parentID = '#arguments.parentid#'
  		 order by name asc;
  	</cfquery>
    <cfreturn children>
  </cffunction>

  <cffunction name="getParents" returntype="query">
    <cfargument name="parentID" required="yes">
    <cfquery name="children" datasource="#dsn.getName()#">
      select
        oID, parentID,
        name
        from
        contactGroupRelation,
        contactGroup
        where oID = '#parentID#' and oType = 'group'
        AND
       contactGroup.id = contactGroupRelation.oid;
    </cfquery>
    <cfreturn children>
  </cffunction>

  <cffunction name="formatName" returntype="string">
    <cfargument name="name">
    <cfset var x = "">
    <cfset x = Replace(name,"&","&amp;","ALL")>
    <cfreturn x>
  </cffunction>

  <cffunction name="writeNode" returntype="string" output="no">
    <cfargument name="tree" type="string" required="yes">
    <cfargument name="parentid" required="yes">
    <cfset var children = getChildren(arguments.parentid)>
    <cfset var thisHasChildren = "">
    <cfloop query="children">
      <cfset tree = '#tree#<category label="#xmlFormat(name)#" id="#oID#">'>
      <cfset thisHasChildren = getChildren(oID)>
      <cfif thisHasChildren.recordCount neq 0>
        <cfset tree = writeNode(tree,oID)>
      </cfif>
      <cfset tree = '#tree#</category>'>
    </cfloop>
    <cfreturn tree>
  </cffunction>

  <cffunction name="writeHTMLNode" returntype="string" output="no">
    <cfargument name="tree" type="string" required="yes">
    <cfargument name="parentid" required="yes">
    <cfset var children = getChildren(arguments.parentid,false)>
    <cfset var thisHasChildren = "">
    <cfloop query="children">
      <cfset tree = '#tree#<li label="#xmlFormat(name)#" id="#oID#"><a href="/intranet/main/agreementList?btID=#oID#">#name#</a>'>
      <cfset thisHasChildren = getChildren(oID,false)>
      <cfif thisHasChildren.recordCount neq 0>
        <cfset tree = '#tree#<ul>'>
        <cfset tree = writeHTMLNode(tree,oID)>
        <cfset tree = '#tree#</ul>'>
      </cfif>
      <cfset tree = '#tree#</li>'>
    </cfloop>
    <cfreturn tree>
  </cffunction>

  <cffunction name="writeHTMLCountNode" returntype="string" output="no">
    <cfargument name="tree" type="string" required="yes">
    <cfargument name="parentid" required="yes">
    <cfset var children = getChildren(arguments.parentid,false)>
    <cfset var thisHasChildren = "">
    <cfset var getDealCount = "">
    <cfloop query="children">
      <cfset getDealCount = getArrangementByTeam(oID).recordCount>
      <cfset tree = '#tree#<li label="#xmlFormat(name)#" id="#oID#"><a href="/psa/list?btID=#oID#">#name#  <span style="font-size: 9px; color: ##666;">(#getDealCount#)</span></a>'>
      <cfset thisHasChildren = getChildren(oID,false)>
      <cfif thisHasChildren.recordCount neq 0>
        <cfset tree = '#tree#<ul>'>
        <cfset tree = writeHTMLCountNode(tree,oID)>
        <cfset tree = '#tree#</ul>'>
      </cfif>
      <cfset tree = '#tree#</li>'>
    </cfloop>
    <cfreturn tree>
  </cffunction>

  <cffunction name="getArrangementByTeam" returntype="query" output="false" access="remote">
    <cfargument name="team" required="yes">
    <!--- for this year only --->
    <cfset var thisyear = "#DateFormat(now(),'YYYY')#">
    <cfset var favList = "">
    <cfquery name="arrangement" datasource="#dsn.getName()#">
    	    select
    	      arrangement.name as name,
    	      site.known_as as cname,
    	      arrangement.PSA_status,
    	      arrangement.id
    	    from
    	      arrangement, site
    	   where
    	      PSA_status = 'confirmed'
    	      AND
    	      buyingTeamID = '#arguments.team#'
    	   and
    	      period_from <= '#DateFormat(now(),'YYYY-MM-')#-01'
    	  AND
    	      period_to >= '#DateFormat(now(),'YYYY-MM')#-01'

    	   AND
    	      site.id = arrangement.company_id
    	      and arrangement.siteID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#UserStorage.getVar('eGroup.companyID')#">)
  			<cfif CookieStorage.getVar("showFavouritesOnly",false)>
  					<cfset favList = favourites.get()>
  						AND arrangement.company_id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ValueList(favList.id)#">)
  			</cfif>
  		  order by cname;
    	    </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="buildTree" access="remote" output="no">
    <cfset var tree = ''>
    <cfset var z = writeNode(tree,0)>
    <cfset var x = "">
    <cfsavecontent variable="x">
    <cfoutput>
      <categories label="Groups" id="0">#z#</categories>
    </cfoutput>
    </cfsavecontent>
    <cfreturn x>
  </cffunction>

  <cffunction name="updateGroupRelationships" output="false" description="" access="remote">
    <cfargument name="datagrid" required="yes">
    <cfargument name="groupID" type="string">
    <cfset var i = "">
    <cfloop from="1" to="#ArrayLen(arguments.datagrid)#" index="i">
      <cfif NOT isInGroup(arguments.groupID,arguments.datagrid[i].oType,arguments.datagrid[i].id)>
        <cfquery name="ins" datasource="#dsn.getName()#">
          insert into contactGroupRelation (parentID,oType,oID) VALUES ('#arguments.groupID#','#arguments.datagrid[i].oType#','#arguments.datagrid[i].id#');
        </cfquery>
      </cfif>
    </cfloop>
    <cfreturn getChildGroupsAndContacts(groupID)>
  </cffunction>

  <cffunction name="deleteFromGroup" access="remote" returntype="any">
    <cfargument name="id">
    <cfargument name="parentID">
    <cfargument name="oType">
    <cfquery name="deleteA" datasource="#dsn.getName()#">
    	delete from contactGroupRelation where
    	 oid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    	 AND
    	 parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentID#">
    	 AND
    	 oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oType#">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="move" access="remote" returntype="any">
    <cfargument name="originalParent">
    <cfargument name="newParent">
    <cfargument name="oID">
    <cfargument name="oType">
    <cfquery name="moveOb" datasource="#dsn.getName()#">
      update
        contactGroupRelation
      set
        parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newParent#">
      where
        oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.oID#">
      AND
        oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oType#">
      AND
        parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.originalParent#">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="addToGroup" access="remote" returntype="any">
    <cfargument name="id">
    <cfargument name="parentID">
    <cfargument name="oType">
    <cfquery name="deleteA" datasource="#dsn.getName()#">
      insert into contactGroupRelation (oid,parentID,oType)
      VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
              <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentID#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oType#">
             )
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="getUsersSecurityGroups" returntype="string" output="no" access="public">
    <cfargument name="forWhat" required="yes" default="cemco">
    <cfargument name="contactID" type="numeric" required="yes">
    <cfquery name="getParentIDs" datasource="#dsn.getName()#">
    	select parentID from contactGroupRelation
      where
      	oType = 'contact'
        AND
        oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
        AND
        <cfif forWhat eq "Group">
        parentID IN (#securityGroupIDs#);
        <cfelseif forWhat eq "member">
        parentID IN (#securityGroupIDs#);
        </cfif>
   </cfquery>
    <cfif getParentIDs.recordCount eq 0>
      <cfreturn 0>
      <cfelse>
      <cfreturn ValueList(getParentIDs.parentID,",")>
    </cfif>
  </cffunction>

  <cffunction name="moveUserToGroup" access="public" returntype="string">
    <cfargument name="contactID" type="numeric" required="yes">
    <cfargument name="newGroupID" type="numeric"  required="yes">
    <cfargument name="oldGroupID" type="numeric"  required="yes">
    <cfquery name="delFrom" datasource="#dsn.getName()#">
    	delete
      	from
      contactGroupRelation
      	where
       oType = 'contact'
       	AND
       oID = #arguments.contactID#
        AND
       parentID = #arguments.oldGroupID#
    </cfquery>
    <cfquery name="addTo" datasource="#dsn.getName()#">
    	INSERT
      	into
      contactGroupRelation
      	(oType,oID,parentID)
      VALUES
      	('contact',#contactID#,#newGroupID#)
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="isInGroup" returntype="boolean">
    <cfargument name="parentID">
    <cfargument name="oType">
    <cfargument name="oID">
    <cfquery name="isThere" datasource="#dsn.getName()#">
    	select id from contactGroupRelation where parentID = #parentID#
      AND
      oType = '#oType#'
      AND
      oID = #oID#
    </cfquery>
    <cfif isThere.recordCount eq 0>
      <cfreturn false>
      <cfelse>
      <cfreturn true>
    </cfif>
  </cffunction>

  <cffunction name="RemoveGroups" output="false" description="" access="remote">
    <cfargument name="datagrid" required="yes">
    <cfset var arr = ArrayNew(1)>
    <cfset var i = "">
    <cfset var x = "">
    <cfloop from="1" to="#ArrayLen(arguments.datagrid)#" index="i">
      <cfset x = ArrayAppend(arr,arguments.datagrid[i].id)>
    </cfloop>
    <cfquery name="ins" datasource="#dsn.getName()#">
  			delete from contactGroup where id NOT IN(#ArrayToList(arr)#);
  	</cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="remove" output="false" description="" access="remote">
    <cfargument name="groupID" required="yes">
    <cfquery name="ins" datasource="#dsn.getName()#">
        delete from contactGroup where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupID#">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="createGroup" returntype="nuneric" access="remote">
    <cfargument name="parentID" required="yes" default="0">
    <cfargument name="name" required="yes" default="0">
    <cfset var siteID = "">
    <cfset var newID = "">
    <cfquery name="createGroup" datasource="#dsn.getName()#">
    	insert into contactGroup (name,siteID) VALUES ('#name#',#request.siteID#);
    </cfquery>
    <cfquery name="newID" datasource="#dsn.getName()#">
    	select LAST_INSERT_ID() as id from contactGroup;
    </cfquery>
    <cfquery name="createGroupInTree" datasource="#dsn.getName()#">
    	insert into contactGroupRelation (parentID,oType,oID) VALUES (#parentID#,'group','#newID.id#');
    </cfquery>
    <cfreturn newID.id>
  </cffunction>

  <cffunction name="getChildGroupsAndContacts" returntype="query" access="remote">
    <cfargument name="groupID" required="yes" default="0">
    <cfargument name="getContacts" required="true" default="true">
    <cfset var retQ = QueryNew("id,name,oType,img,cgrid")>
    <cfset var x = "">
    <cfif arguments.getContacts>
      <cfquery name="childCategories" datasource="#dsn.getName()#">
      	select
        	concat(contact.first_name," ",contact.surname) as name,
          contact.id as id,
          site.id as siteID,
          contactGroupRelation.id as cgrid
        from
        	contact,
          site,
          contactGroupRelation
        where
        	contactGroupRelation.parentID = #groupID#
        and
        	contactGroupRelation.oType = 'contact'
        and
        	site.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        	AND
        	contact.siteID = site.id
          AND
        	contact.id = contactGroupRelation.oID
        	ORDER by name;
       </cfquery>
      <cfloop query="childCategories">
        <cfset x = QueryAddRow(retQ)>
        <cfset x = QuerySetCell(retQ,"id",id)>
        <cfset x = QuerySetCell(retQ,"name",name)>
        <cfset x = QuerySetCell(retQ,"oType","contact")>
        <cfset x = QuerySetCell(retQ,"img","/images/icons/userjpg.jpg")>
        <cfset x = QuerySetCell(retQ,"cgrid",cgrid)>
      </cfloop>
    </cfif>
    <cfquery name="childGroups" datasource="#dsn.getName()#">
    	select
      	contactGroup.name as name,
        contactGroup.id as id,
        contactGroup.siteID,
        contactGroupRelation.id as cgrid
      from
      	contactGroup,
        contactGroupRelation
      where
      	contactGroupRelation.parentID = #groupID#
      and
      	contactGroupRelation.oType = 'group'
      and
      	contactGroup.id = contactGroupRelation.oID
      	ORDER by name;
     </cfquery>
    <cfloop query="childGroups">
      <cfset x = QueryAddRow(retQ)>
      <cfset x = QuerySetCell(retQ,"id",id)>
      <cfset x = QuerySetCell(retQ,"name",name)>
      <cfset x = QuerySetCell(retQ,"oType","group")>
      <cfset x = QuerySetCell(retQ,"img","/images/icons/usersjpg.jpg")>
      <cfset x = QuerySetCell(retQ,"cgrid",cgrid)>
    </cfloop>
    <cfreturn retQ>
  </cffunction>

  <cffunction name="userCanEditCompany" returntype="boolean" output="no">
    <cfargument name="companyID" required="yes">
    <cfset var companym = "">
    <cfif IsUserInRole("ebiz")>
      <cfreturn true>
      <cfelse>
      <cfset companym = CompanyMember(companyID)>
      <cfif companym eq 0>
        <cfif IsUserInRole("admin")>
          <cfreturn true>
          <cfelse>
          <cfreturn false>
        </cfif>
        <cfelse>
        <cfif companym eq session.companyID>
          <cfif IsUserInRole("member_admin")>
            <cfreturn true>
            <cfelse>
            <cfreturn false>
          </cfif>
          <cfelse>
          <cfreturn false>
        </cfif>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="isActiveCompany" returntype="boolean" output="no">
    <cfargument name="companyID" required="yes">
    <cfquery name="active" datasource="#dsn.getName()#">
     	select status from site where id = '#arguments.companyID#';
     </cfquery>
    <cfif active.status eq "active">
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="fullGroupList" returntype="query" output="no">
    <cfargument name="companyID" required="true" default="0">
    <cfargument name="ignoreList" required="true" default="0">
    <cfquery name="gList" datasource="#dsn.getName()#">
        select id, name, "group" as oType from contactGroup where siteID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="0,#companyID#">)
        <cfif ignoreList neq 0>
        AND id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ignoreList#" list="true">)
        </cfif>
        order by name;
      </cfquery>
    <cfreturn gList>
  </cffunction>

  <cffunction name="fullGroupListGrid" returntype="query" output="no">
    <cfargument name="sortdir" type="string" required="yes">
    <cfargument name="sortcol" type="string" required="yes">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var companyID = eGroup.companyID>
    <cfquery name="gList" datasource="#dsn.getName()#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
        select id, name from contactGroup where siteID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="0,#request.siteID#">)
  			<cfif sortcol neq "" AND sortdir neq "">
  				order by
  				#lcase(sortcol)# #lcase(sortdir)#
  				</cfif>
      </cfquery>
    <cfreturn gList>
  </cffunction>

  <cffunction name="getCommittees" returntype="query" output="no">
    <cfargument name="rootOnly" required="yes" default="false" type="boolean">
    <cfset var theID = "">

    <cfset var xQuery = QueryNew("id,name")>
    <cfquery name="parentID" datasource="#dsn.getName()#">
        select id from contactGroup where name = 'PSA Categories';
      </cfquery>

    <cfset theID = parentID.id>
    <cfset xQuery = getChildGroups(theID,xQuery)>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="getContactsGroups" returntype="query">
    <cfargument name="contactID">
    <cfset var userGroups = ArrayNew(1)>
    <cfset var z = "">
    <cfscript>
        var xQuery = QueryNew("id,name");
      </cfscript>
    <cfquery name="defaultGroups" datasource="#dsn.getName()#">
        select
          parentID, name
         from
          contactGroupRelation,
          contactGroup
         where
          oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#"> and oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
          AND
           contactGroup.id = contactGroupRelation.parentID;
      </cfquery>
    <cfloop query="defaultGroups">
      <cfset z = QueryAddROw(xQuery)>
      <cfset z= QuerySetCell(xQuery,"id","#parentID#")>
      <cfset z = QuerySetCell(xQuery,"name","#name#")>
      <cfset xQuery = recursiveChildren(parentID,xQuery)>
    </cfloop>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="recursiveChildren" returntype="query">
    <cfargument name="pID">
    <cfargument name="xQuery">
    <cfset var z = "">
    <cfset var childGroups = "">
    <cfif ListFind(ValueList(xQuery.id),pID) eq 0>
      <cfset childGroups = getParents(pid)>
      <cfloop query="childGroups">
        <cfset z = QueryAddROw(xQuery)>
        <cfset z= QuerySetCell(xQuery,"id","#oid#")>
        <cfset z = QuerySetCell(xQuery,"name","#name#")>
        <cfif parentID neq 0>
          <cfset xQuery = recursiveChildren(parentID,xQuery)>
        </cfif>
      </cfloop>
    </cfif>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="getChildGroups" returntype="query">
    <cfargument name="pID" required="yes" type="numeric">
    <cfargument name="xQuery" required="yes" default="false" type="Query">
    <cfargument name="recurse" required="true" default="true" type="boolean">
    <cfargument name="rootOnly" required="true" default="false" type="boolean">
    <cfset var childGroups = getChildrenGroups(arguments.pID)>
    <cfset var subs = "">
    <cfset var z = "">
    <cfloop query="childGroups">
      <cfset subs = getChildrenGroups(oid)>
      <cfif subs.recordCount eq 0>
        <cfset z = QueryAddROw(xQuery)>
        <cfset z = QuerySetCell(xQuery,"id","#oID#")>
        <cfset z = QuerySetCell(xQuery,"name","#getGroupName(oID)#")>
        <cfif recurse>
          <cfset xQuery = getChildGroups(oID,xQuery,recurse,rootOnly)>
        </cfif>
        <cfelse>
        <cfset xQuery = getChildGroups(oID,xQuery,recurse,rootOnly)>
      </cfif>
    </cfloop>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="recurseForwards" returntype="any">
    <cfargument name="groupID" required="yes" type="numeric">
    <cfargument name="objectType" required="true" default="group">
    <cfargument name="xQuery" required="false" type="Query">
    <cfset var z = "">
    <cfquery name="childGroups" dbtype="query" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
          select
            oID
          from
             this.groupRelationships
          where
         parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupID#"> and oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectType#">
    </cfquery>
    <cfif NOT isDefined("arguments.xQuery")>
      <cfset xQuery = QueryNew("id,name")>
    </cfif>
    <cfloop query="childGroups">
      <cfset QueryAddRow(xQuery)>
      <cfset QuerySetCell(xQuery,"id","#oID#")>
      <cfset QuerySetCell(xQuery,"name","#getLocalGroupName(oID)#")>
      <cfset xQuery = recurseForwards(oID,arguments.objectType,xQuery)>
    </cfloop>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="recurseBackwards" returntype="any">
    <cfargument name="groupID" required="yes" type="numeric">
    <cfargument name="objectType" required="true" default="group">
    <cfargument name="xQuery" required="false" type="Query">
    <cfset var z = "">
    <cfquery name="childGroups" dbtype="query" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
          select
            parentID
          from
             this.groupRelationships
          where
         oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupID#"> and oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectType#">
    </cfquery>
    <cfif NOT isDefined("arguments.xQuery")>
      <cfset xQuery = QueryNew("id,name")>
    </cfif>
    <cfloop query="childGroups">
      <cfset QueryAddRow(xQuery)>
      <cfset QuerySetCell(xQuery,"id","#parentID#")>
      <cfset QuerySetCell(xQuery,"name","#getLocalGroupName(parentID)#")>
      <cfset xQuery = recurseBackwards(parentID,arguments.objectType,xQuery)>
    </cfloop>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="getParentGroups" returntype="any">
    <cfargument name="pID" required="yes" type="numeric">
    <cfargument name="xQuery" required="yes" default="false" type="Query">
    <cfargument name="recurse" required="true" default="true" type="boolean">
    <cfset var z = "">
    <cfquery name="childGroups" datasource="#dsn.getName()#">
          select oID,parentID from contactGroupRelation where oID = '#arguments.pID#' and oType = 'group';
    </cfquery>
    <cfloop query="childGroups">
      <cfset z = QueryAddROw(xQuery)>
      <cfset z = QuerySetCell(xQuery,"id","#oID#")>
      <cfset z = QuerySetCell(xQuery,"name","#getGroupName(oID)#")>
      <cfif recurse>
        <cfset xQuery = getParentGroups(parentID,xQuery)>
      </cfif>
    </cfloop>
    <cfreturn xQuery>
  </cffunction>

  <cffunction name="getLocalGroupName" returntype="string">
    <cfargument name="groupID" required="yes" type="numeric">
    <cfset var lGL = fullGroupList()>
    <cfquery name="getGroup" dbtype="query">
        select name from lGL where id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#groupID#">
      </cfquery>
    <cfreturn getGroup.name>
  </cffunction>

  <cffunction name="getGroupRelationships" returntype="any">
    <cfquery name="grouprelationships" datasource="#dsn.getName()#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
          select
            *
          from
            contactGroupRelation
        </cfquery>
    <cfreturn grouprelationships>
  </cffunction>

  <cffunction name="getSecurity" returntype="Query">
    <cfargument name="contactID">
    <cfscript>
        var xQuery = QueryNew("id,name");
        var groupList = "";
        var contactGroups = "";
        var theQ = "";

      </cfscript>
      <cfquery name="contactGroups" datasource="#dsn.getName()#">
         select
          parentID
         from
           contactGroupRelation
         where
          oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
          and
          oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
       </cfquery>
    <cfloop query="contactGroups">
        <cfset QueryAddRow(xQUery)>
        <cfset QuerySetCell(xQuery,"id",parentID)>
        <cfset QuerySetCell(xQuery,"name",getLocalGroupName(parentID))>
        <cfset groupList = recurseBackwards(parentID,"group",xQuery)>
    </cfloop>
    <cfset theQ = QueryDeDupe(groupList,"name")>
    <cfreturn theQ>
  </cffunction>

  <cffunction name="getBaseSecurityGroups" returntype="string">
  <cfargument name="contactID">
  <cfscript>
      var xQuery = QueryNew("id,name");
      var rQuery = QueryNew("id,name");
      var BaseLevelGroups = [];
    </cfscript>
    <cfset var g = "">
    <cfset var groupList = "">
    <cfset var theQ = "">
  <cfloop array="#baseGroups.group#" index="g">
    <cfset arrayAppend(BaseLevelGroups,g.id)>
  </cfloop>
  <cfloop array="#baseGroups.members#" index="g">
    <cfset arrayAppend(BaseLevelGroups,g.id)>
  </cfloop>
  <cfquery name="contactGroups" datasource="#dsn.getName()#">
       select
        parentID, name
       from
        contactGroupRelation,
        contactGroup
       where
        oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
        and
        oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
       AND
         contactGroup.id = contactGroupRelation.parentID;
     </cfquery>
  <cfloop query="contactGroups">
    <cfset QueryAddRow(xQUery)>
    <cfset QuerySetCell(xQuery,"id",parentID)>
    <cfset QuerySetCell(xQuery,"name",name)>
    <cfset groupList = getParentGroups(parentID,xQuery)>
  </cfloop>
  <cfif contactGroups.recordCount neq 0>
    <cfset theQ = QueryDeDupe(groupList,"name")>
  <cfelse>
    <cfset theQ = contactGroups>
  </cfif>
  <cfloop query="theQ">
    <cfif ArrayFind(BaseLevelGroups,id) gte 1>
      <cfset QueryAddRow(rQuery)>
      <cfset QuerySetCell(rQuery,"id",id)>
      <cfset QuerySetCell(rQuery,"name",name)>
    </cfif>
  </cfloop>
  <cfreturn ValueList(rQuery.name)>
</cffunction>

</cfcomponent>