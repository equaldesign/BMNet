<cfcomponent name="feedService" output="true" cache="true" cacheTimeout="30" autowire="true">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="App" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="BVuserService" inject="id:bv.UserService">
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="favourites" inject="id:eunify.FavouritesService" />
  <cfproperty name="logger" inject="logbox:root">

  <cffunction name="createFeedItem" returntype="void" output="true">
    <cfargument name="so" required="true" default="contact" type="String">
    <cfargument name="sOID" required="true" default="0" type="numeric">
    <cfargument name="tO" required="true" default="arrangement" type="String">
    <cfargument name="tOID" required="true" default="0" type="numeric">
    <cfargument name="action" required="true" default="editDeal" type="String">
    <cfargument name="rO" required="true" default="" type="String">
    <cfargument name="rOID" required="true" default="0" type="numeric">
    <cfargument name="memberID" required="true" default="0" type="numeric">
    <cfargument name="message" required="true" default="" type="string">
    <cfargument name="siteID" required="true" default="0" type="numeric">
    <cfargument name="datasource">
    <cfset var actionID = getAction(arguments.action).id>
    <cfset var insertFeed = "">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfquery name="insertFeed" datasource="#dsn.getName()#">
        insert into newsFeed
          (sourceObject,sourceID,targetObject,targetID,actionID,relatedObject,relatedID,memberID,message,siteID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#so#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#soID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#to#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#toID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#actionID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#ro#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#roID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">,
          <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#message#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          )
      </cfquery>
  </cffunction>

  <cffunction name="getAction" returntype="query">
    <cfargument name="actionName" required="true" default="editDeal">
    <cfset var a = "">
    <cfquery name="a" datasource="#dsnRead.getName()#">
        select * from newsFeedAction where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#actionName#">
      </cfquery>
    <cfreturn a>
  </cffunction>

  <cffunction name="getFeedCount" returntype="numeric">
    <cfargument name="filter" required="true">
    <cfargument name="searchOn" required="true" default="">
    <cfargument name="searchID" required="true" default="0">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var feed = "">
    <cfset var favList = "">

    <cfquery name="feed" datasource="#dsnRead.getName()#">
        select
  				count(nf.id) as total
    		from
    		  newsFeed as nf,
    		  newsFeedAction as nfa
    		where
    		  nfa.id = nf.actionID
    		AND
        <cfif isUserInRole("view")>
          nfa.security IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#BMNet.roles#">)
        <cfelse>
          companyID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#BMNet.companyID#">
        </cfif>
        <cfif CookieStorage.getVar("showFavouritesOnly",false)>
          <cfset favList = favourites.get()>
          AND companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ValueList(favList.id)#">)
        </cfif>
        <cfif arguments.filter neq 0>
          AND  nfa.id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.filter#">)
        </cfif>
        <cfif arguments.searchOn neq "">
        AND
        (
          (
            sourceObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            sourceID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )
          OR
          (
            targetObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            targetID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )
          OR
          (
            relatedObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            relatedID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )
        )
        </cfif>
      </cfquery>
    <cfreturn feed.total>
  </cffunction>

  <cffunction name="deleteCache" returntype="void">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var createFeedCache = "">
    <cfquery name="createFeedCache" datasource="#dsn.getName()#">
        delete from newsFeedCache
        where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#">
      </cfquery>
  </cffunction>

  <cffunction name="getCacheFeed" returntype="Query">
    <cfargument name="sRow" required="true" default="1">
    <cfargument name="eRow" required="true" default="10">
    <cfargument name="sql" required="true" default="0">
    <cfargument name="companyID" required="true" default="0">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var feed = "">
    <cfset var createFeedCache = "">
    <cfquery name="feed" datasource="#dsnRead.getName()#">
        select
          cachefile
        from
          newsFeedCache
        where
          contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#">
        AND
          timesaved > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n',-30,now())#">
          AND
          sRow = <cfqueryparam cfsqltype="cf_sql_integer" value="#sRow#">
          AND
          eRow = <cfqueryparam cfsqltype="cf_sql_integer" value="#eRow#">
          <cfif sql neq 0>
            AND sql = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sql#">
          </cfif>
          <cfif companyID neq 0>
            AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
          </cfif>
      </cfquery>
    <cfthread action="run" name="#createUUID()#" priority="LOW" eGroup="#eGroup#" instance="#instance#">
      <cfquery name="createFeedCache" datasource="#dsn.getName()#">
          delete from newsFeedCache
          where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.eGroup.contactID#">
          AND
            timesaved < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('h',-1,now())#">
        </cfquery>
    </cfthread>
    <cfreturn feed>
  </cffunction>

  <cffunction name="getFeed" returntype="Query">
    <cfargument name="sRow" required="true" default="1">
    <cfargument name="mxRows" required="true" default="10">
    <cfargument name="sql" required="true" default="0">
    <cfargument name="companyID" required="true" default="0">
    <cfargument name="dateFrom" required="true" default="">
    <cfargument name="dateTo" required="true" default="#now()#">
    <cfargument name="contactID" required="true" default="">
    <cfargument name="summary" required="true" default="false" type="boolean">
    <cfargument name="filter" required="true" default="0">
    <cfargument name="searchOn" required="true" default="">
    <cfargument name="searchID" required="true" default="0">
    <cfargument name="secure" required="true" default="true">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var appRoot = App.getVar("appRoot")>
    <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfset var favList = "">
    <cfset var feed = "">
    <cfset var a = "">
    <cfset var feedString = "">
    <cfset var fields = "">
    <cfset var l = "">
    <cfset var table = "">
    <cfset var indentifier = "">
    <cfset var column = "">
    <cfset var value = "">
    <cfset var dd = "">
    <cfset var ref = "">
    <cfset var nfeed = "">
    <cfset var x = "">
    <cfset var groupNames = "">
    <cfif arguments.contactID neq "" AND arguments.secure>
      <cfset userGrps = groups.getSecurity(contactID)>
      <cfset groupNames = Trim(ValueList(userGrps.name))>
    <cfelseif  arguments.secure>
      <cfset groupNames = BMNet.roles>
    </cfif>

    <cfif NOT isUserInRole("view")>
      <cfset arguments.companyID = BMNet.companyID>
    </cfif>
    
    <cfquery name="feed" datasource="#dsnRead.getName()#">
      select
        nf.id as fID,
        nf.sourceObject,
        nf.sourceID,
        nf.targetObject,
        nf.targetID,
        nf.tstamp,
        nf.companyID,
        nf.message,
        nf.relatedObject,
        nf.relatedID,
        nfa.details,
        nfa.id as actionID,
        nfa.name as catName,
        nfa.security,
        CONCAT("related_",nf.relatedID,"contact_",c.id,"_action",nfa.id,"_time",Date_format(nf.tstamp,'%y%d%m%k')) as groupKey,
        count(nf.id) as itemCount,
        c.email as contactEmail
      from
        newsFeed as nf,
        newsFeedAction as nfa,
        contact as c
      where
      nf.siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">)
      AND
        nfa.id = nf.actionID
      AND
        c.id = nf.sourceID
        <cfif arguments.dateFrom neq "">
          AND
          tstamp BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateFrom#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateTo#">
        </cfif>
        <cfif isUserInRole("member")>
          AND
          nfa.security IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#groupNames#">)
        </cfif>
        <cfif sql neq 0>
          AND #sql#
        </cfif>
        <cfif companyID neq 0>
          AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
        </cfif>
        <cfif CookieStorage.getVar("showFavouritesOnly",false)>
          <cfset favList = favourites.get()>
          AND companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ValueList(favList.id)#">)
        </cfif>
        <cfif filter neq 0>
          AND actionID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#filter#">)
        </cfif>
        <cfif arguments.searchOn neq "">          
        AND
        (
          
          (
            sourceObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            sourceID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )          
          OR          
          (
            targetObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            targetID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )
          
          OR
          (
            relatedObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchOn#">
            AND
            relatedID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchID#">
          )
          
        )
        </cfif>
      GROUP BY groupKey
      ORDER BY tstamp desc
      LIMIT #sRow-1#, #mxRows#;
    </cfquery>

    <cfreturn feed>    
  </cffunction>

  <cffunction name="getFields" returntype="Array">
    <cfargument name="str" required="true">
    <cfscript>
      var returnArray = ArrayNew(1);
      for (var i=1;i LT len(str);i=i+1) {
        f = REFindNoCase("\[([a-z\.\_])+\]",str,i,"TRUE");
          if (f.pos[1] IS 0){
            i = len(str);
          } else {
            ArrayAppend(returnArray,MID(str,f.pos[1]+1,f.len[1]-2));
            i = f.pos[2] + f.len[2];
					}
				}
				return returnArray;
    </cfscript>
  </cffunction>

  <cffunction name="getExternalFeeds" returntype="Struct">
    <cfargument name="startRow" required="true" default="0">
    <cfargument name="maxRows" required="true" default="10">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var retFeed = QueryNew("title,description,content,pdate,source,link,category,authorName,authorUri,site","VarChar,VarChar,VarChar,Time,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar")>
    <cfset var retStruct = {}>
    <cfset var bmf = "">
    <cfset var bmj = "">
    <cfset var bmn = "">
    <!--- BMF --->
    <cffeed action="read" query="bmf" source="http://www.bmf.org.uk/?pageid=10920&format=rss" />
    <cfloop query="bmf">
      <cfscript>
        QueryAddRow(retFeed);
        QuerySetCell(retFeed,"title",title);
        QuerySetCell(retFeed,"description",content);
        QuerySetCell(retFeed,"pdate",PUBLISHEDDATE);
        QuerySetCell(retFeed,"source","bmf");
        QuerySetCell(retFeed,"link",RSSLINK);
      </cfscript>
    </cfloop>
    <cffeed action="read" query="bmj" source="http://www.buildersmerchantsjournal.net/news/BMJnews.xml" />
    <cfloop query="bmj">
      <cfscript>
        QueryAddRow(retFeed);
        QuerySetCell(retFeed,"title",title);
        QuerySetCell(retFeed,"description",content);
        QuerySetCell(retFeed,"pdate",PUBLISHEDDATE);
        QuerySetCell(retFeed,"source","bmj");
        QuerySetCell(retFeed,"link",RSSLINK);
      </cfscript>
    </cfloop>
    <cffeed action="read" query="bmn" source="http://feeds.feedburner.com/BuildersMerchantsNews" />
    <cfloop query="bmn">
      <cfscript>
        QueryAddRow(retFeed);
        QuerySetCell(retFeed,"title",title);
        QuerySetCell(retFeed,"description",content);
        QuerySetCell(retFeed,"pdate",PUBLISHEDDATE);
        QuerySetCell(retFeed,"source","bmn");
        QuerySetCell(retFeed,"link",RSSLINK);
      </cfscript>
    </cfloop>
    <cfquery name="feedQuery" dbtype="query">
        select * from retFeed order by pdate desc;
      </cfquery>
    <cfset retStruct.count = feedQuery.recordCount>
    <cfset logger.debug("startRow: #startRow#")>
    <cfset logger.debug("maxRows: #maxRows#")>
    <cfset retStruct.feed = feedQuery>
    <cfreturn retStruct>
  </cffunction>

  <cffunction name="getCategory" returntype="query" output="no">
    <cfargument name="id" required="yes">
    <cfset var cats = "">
    <cfquery name="cats" datasource="#dsnRead.getName()#">
        select * from blogCategory where id = #id#;
      </cfquery>
    <cfreturn cats>
  </cffunction>

  <cffunction name="getCategories" returntype="query" output="no">
    <cfset var cats = "">
    <cfquery name="cats" datasource="#dsnRead.getName()#">
      select * from newsFeedAction;
    </cfquery>
  <cfreturn cats>
</cffunction>

  <cfscript>

  function queryConcat(q1,q2) {
      var row = "";
      var col = "";

      if(q1.columnList NEQ q2.columnList) {
          return q1;
      }

      for(row=1; row LTE q2.recordCount; row=row+1) {
       queryAddRow(q1);
       for(col=1; col LTE listLen(q1.columnList); col=col+1)
          querySetCell(q1,ListGetAt(q1.columnList,col), q2[ListGetAt(q1.columnList,col)][row]);
      }
      return q1;
  }

  function capFirstTitle(initText){

      var Words = "";
      var j = 1; var m = 1;
      var doCap = "";
      var thisWord = "";
      var outputString = "";

      initText = LCASE(initText);

      //Words to never capitalize
      excludeWords = "an,the,at,by,for,of,in,up,on,to,and,as,but,if,or,nor,a,ltd,plc";
      //Make each word in text an array variable
  		uppercaseWords = "ltd,plc";

      Words = ListToArray(initText, " ");

      //Check words against exclude list
      for(j=1; j LTE (ArrayLen(Words)); j = j+1){
          doCap = true;

          //Word must be less that four characters to be in the list of excluded words
          if(LEN(Words[j]) LT 4 ){
              if(ListFind(excludeWords,Words[j])){
              	if (ListFind(uppercaseWords,Words[j])) {
              		Words[j] = UCASE(Words[j]);
              	}
                 doCap = false;
              }
          }

          //Capitalize hyphenated words
          if(ListLen(Words[j],"-") GT 1){
              for(m=2; m LTE ListLen(Words[j], "-"); m=m+1){
                  thisWord = ListGetAt(Words[j], m, "-");
                  thisWord = UCase(Mid(thisWord,1, 1)) & Mid(thisWord,2, LEN(thisWord)-1);
                  Words[j] = ListSetAt(Words[j], m, thisWord, "-");
              }
          }

          //Automatically capitalize first and last words
          if(j eq 1){
              doCap = true;
          }

          //Capitalize qualifying words
          if(doCap){
              Words[j] = UCase(Mid(Words[j],1, 1)) & Mid(Words[j],2, LEN(Words[j])-1);
          }
      }

      outputString = ArrayToList(Words, " ");

      return outputString;

  }
	</cfscript>
</cfcomponent>