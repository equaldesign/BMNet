<cfcomponent name="branchService" accessors="true"  output="true" cache="true" cacheTimeout="30" autowire="true">

  <!--- static properties --->
  <cfproperty name="id" />
  <cfproperty name="company_id" />
  <cfproperty name="name" />
  <cfproperty name="known_as" />
  <cfproperty name="address1" />
  <cfproperty name="address2" />
  <cfproperty name="address3" />
  <cfproperty name="town" />
  <cfproperty name="county" />
  <cfproperty name="postcode" />
  <cfproperty name="tel" />
  <cfproperty name="fax" />
  <cfproperty name="email" />
  <cfproperty name="web" />
  <cfproperty name="maplong" />
  <cfproperty name="maplat" />

  <cfproperty name="logger" inject="logbox:root" />
  <!--- injected properties --->
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />

  <!--- get all branches by company --->
  <cffunction name="getAll" returntype="query" output="false">
  	<cfargument name="cid" default="" required="false">
    <cfset var branc  = "">
  	<cfquery name="branc" datasource="#dsnRead.getName()#">
  	 select
      branch.*
    from
      branch
     WHERE
     branch.siteID = <Cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      <cfif arguments.cid neq "">
      AND
      branch.company_id = <Cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cid#">
      </cfif>
  	</cfquery>
  	<cfreturn branc>
  </cffunction>

  <!--- get specific branch --->
  <cffunction name="getBranch" returntype="query" output="false">
    <cfargument name="bid">
    <cfset var branc = "">
    <cfquery name="branc" datasource="#dsnRead.getName()#">
      select * from branch where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bid#">
    </cfquery>

    <cfreturn branc>
  </cffunction>

  <cffunction name="getBranchByRef" returntype="query" output="false">
    <cfargument name="bid">
    <cfset var branc = "">
    <cfquery name="branc" datasource="#dsnRead.getName()#">
      select * from branch where branch_ref = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bid#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>

    <cfreturn branc>
  </cffunction>

  <!--- get full list of branches by active company --->
  <cffunction name="getFullList" returntype="query" output="false">
    <cfargument name="cid">
    <cfset var branc = "">
    <cfquery name="branc" datasource="#dsnRead.getName()#">
      select
        branch.*,
        company.name as companyName,
        company.known_as as companyknown_as
        from branch, company where company.id = branch.company_id      AND
        company.type_id = 1
  	AND
  	   company.hidden = <cfqueryparam cfsqltype="cf_sql_varchar" value="n"> AND company.status = <Cfqueryparam cfsqltype="cf_sql_varchar" value="active">
    </cfquery>
    <cfreturn branc>
  </cffunction>

	<cffunction name="getGenericCoOrdinates" returntype="array">
	  <cfargument name="add">
	  <cfhttp result="pcRequestResult" url="http://maps.google.com/maps/geo?q=#arguments.add#&output=csv">
	  <cfscript>
	  var coOrds = ListToArray(pcRequestResult.fileContent);
	  var returnArray = arrayNew(1);
	  returnArray[1] = 0;
	  returnArray[2] = 0;
	  if (coOrds[1] eq "200") {
	  	returnArray[1] = coOrds[3];
	  	returnArray[2] = coOrds[4];
	  }
	  return returnArray;
	  </cfscript>
	</cffunction>

  <!--- delete branch --->
	<cffunction name="delete" returntype="void">
    <cfargument name="datasource" default="">
    <cfset var del = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
		<cfquery name="del" datasource="#arguments.datasource#">
			delete from branch where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#" />
		</cfquery>
	</cffunction>

  <cffunction name="getBranchesFromAddress" returntype="any">
    <cfargument name="address" required="true" default="">
    <cfargument name="radius" required="true" default="15">
    <cfargument name="companyType" required="true" default="2">
    <cfargument name="companyID" required="true" default="">
    <cfargument name="latitude" required="true" default="">
    <cfargument name="longitude" required="true" default="">
    <cfset var returnS = {}>
    <cfif address neq "">
      <cfset var coOrdinates = getGenericCoOrdinates(arguments.address)>
  	  <cfset returnS.origin = coOrdinates>
    <cfelse>
      <cfset returnS.origin = [arguments.latitude,arguments.longitude]>
      <cfset var coOrdinates = [arguments.latitude,arguments.longitude]>
    </cfif>
    <cfquery name="results" datasource="#dsnRead.getName()#">
      SELECT
        branch.*,
        (3959 * acos( cos( radians('#coOrdinates[1]#') ) * cos( radians( maplat ) ) * cos( radians( maplong ) - radians('#coOrdinates[2]#') ) + sin( radians('#coOrdinates[1]#') ) * sin( radians( maplat ) ) ) ) AS distance
      FROM
        branch
        where
        branch.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        HAVING
        distance < '#arguments.radius#' ORDER BY distance LIMIT 0 , 20;
    </cfquery>
    <cfset returnS.branches = results>
    <cfreturn returnS>
  </cffunction>

  <cffunction name="getNearestBranch" returntype="any">
    <cfargument name="address" required="true" default="">
    <cfargument name="latitude" required="true" default="">
    <cfargument name="longitude" required="true" default="">
    <cfset var returnS = {}>
    <cfif address neq "">
      <cfset var coOrdinates = getGenericCoOrdinates(arguments.address)>
      <cfset returnS.origin = coOrdinates>
    <cfelse>
      <cfset returnS.origin = [arguments.latitude,arguments.longitude]>
      <cfset var coOrdinates = [arguments.latitude,arguments.longitude]>
    </cfif>
    <cfquery name="results" datasource="#dsnRead.getName()#" result="postcodelookup">
      SELECT
        branch.*,
        (3959 * acos( cos( radians('#coOrdinates[1]#') ) * cos( radians( maplat ) ) * cos( radians( maplong ) - radians('#coOrdinates[2]#') ) + sin( radians('#coOrdinates[1]#') ) * sin( radians( maplat ) ) ) ) AS distance
      FROM
        branch
        where
        branch.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        order by distance
    </cfquery>
    <cfset logger.debug(postcodelookup.sql)>
    <cfset returnS.branches = results>
    <cfreturn returnS>
  </cffunction>

  <cffunction name="getStaticMapWithBranches" returntype="any">
  	<cfargument name="address" required="true">
	  <cfargument name="radius" required="true" default="15">
	  <cfargument name="companyType" required="true" default="2">
	  <cfargument name="companyID" required="true" default="">
	  <cfset results= getBranchesFromAddress(arguments.address,arguments.radius,arguments.companyType,arguments.companyID)>
	  <cfset returnString = "http://maps.googleapis.com/maps/api/staticmap?size=450x250&maptype=roadmap&markers=color:blue%7Clabel:U%7C#results.origin[1]#,#results.origin[2]#">
	  <cfloop query="results.branches">
	  	<cfset returnString = "#returnString#&markers=color:red%7Clabel:B%7C#maplat#,#maplong#">
	  </cfloop>
	  <cfset returnString = "#returnString#&sensor=false">
    <cfreturn returnString>
  </cffunction>

  <!--- get co-ordinates for branch --->
	<cffunction name="getCoOrdinates" returntype="void">
		<cfscript>
		var pcRequest = new Http(url="http://maps.google.com/maps/geo?q=#this.getaddress1()#,#this.getaddress2()#,#this.getAddress3()#,#this.getTown()#,#this.getCounty()#,#this.getPostcode()#&output=csv", method="get");
		var pcRequestResult = pcRequest.send().getPrefix();
		var coOrds = ListToArray(pcRequestResult.fileContent);
		if (coOrds[1] eq "200") {
			this.setmaplat(coOrds[3]);
			this.setmaplong(coOrds[4]);
		}
		</cfscript>
	</cffunction>

  <cffunction name="getDirections" returntype="struct">
    <cfargument name="origin">
    <cfargument name="destination">
    <cfhttp url="http://maps.googleapis.com/maps/api/directions/json?origin=#arguments.origin#&destination=#arguments.destination#&sensor=false" result="dirs"></cfhttp>
    <cfreturn DeSerializejson(dirs.fileContent)>
  </cffunction>

  <cffunction name="branchLocator" returnType="query">
    <cfargument name="lat">
    <cfargument name="lng">
    <cfargument name="radius">
    <cfset var results = "">
    <cfquery name="results" datasource="#dsnRead.getName()#">
		  SELECT
		    branch.*,
		    company.name as companyName,
        company.known_as as companyknown_as,
		    company.id as company_id,
		    company.switchboard,
		    (3959 * acos( cos( radians('#lat#') ) * cos( radians( maplat ) ) * cos( radians( maplong ) - radians('#lng#') ) + sin( radians('#lat#') ) * sin( radians( maplat ) ) ) ) AS distance
		  FROM
		    branch,
		    company
		    where
		    company.type_id != <cfqueryparam cfsqltype="cf_sql_integer" value="2">
		    AND
		    branch.company_id = company.id
        AND
        company.hidden = <cfqueryparam cfsqltype="cf_sql_varchar" value="n"> AND company.status = <Cfqueryparam cfsqltype="cf_sql_varchar" value="active">
		    HAVING
		    distance < '#radius#' ORDER BY distance LIMIT 0 , 20;
		</cfquery>
    <cfreturn results>
  </cffunction>

  <!--- save branch --->
	<cffunction name="save" returntype="void">
    <cfset var u = "">
    <cfset var n = "">

		<cfif this.getid() eq 0 OR this.getid() eq "">
			<cfquery name="u" datasource="#dsn.getName()#">
				insert into branch (name,known_as,company_id,address1,address2,address3,town,county,postcode,tel,fax,email,web,maplat,maplong,siteID)
				VALUES
					(<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getknown_as()#" />,
					<cfqueryparam cfsqltype="cf_sql_integer"  value="#this.getcompany_id()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress1()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress2()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress3()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettown()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getcounty()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getpostcode()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettel()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getfax()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getweb()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getemail()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getmaplat()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getmaplong()#" />,
          <cfqueryparam cfsqltype="cf_sql_integer"  value="#request.siteID#" />)
			</cfquery>
			<cfquery name="n" datasource="#dsn.getName()#">
				select LAST_INSERT_ID() as id from branch;
			</cfquery>
			<cfset this.setid(n.id)>
		<cfelse>
			<cfquery name="u" datasource="#dsn.getName()#">
				update branch
					set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
					known_as = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getknown_as()#" />,
					company_id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#this.getcompany_id()#" />,
					address1 = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress1()#" />,
					address2 = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress2()#" />,
					address3 = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress3()#" />,
					town = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettown()#" />,
					county = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getcounty()#" />,
					postcode = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getpostcode()#" />,
					tel = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettel()#" />,
					fax = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getfax()#" />,
					web = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getweb()#" />,
					email = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getemail()#" />,
					maplat = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getmaplat()#" />,
					maplong = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getmaplong()#" />
				where
					id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
			</cfquery>
		</cfif>
    <cftry><cfset feed.createFeedItem('contact',request.BMNet.contactID,'company',getcompany_id(),'editCompany','company',request.BMNet.siteID,0,"edited branch",datasource)><cfcatch type="any"><cflog application="true" text="#cfcatch.Message#"></cfcatch></cftry>
	</cffunction>

  <cffunction name="exportData" returntype="query">
    <cfset var b = "">
    <cfquery name="b" datasource="#dsnRead.getName()#">
    select
  company.name as companyName,
  company.known_as as companyKnownAs,
  branch.name,
  branch.known_as,
  branch.address1,
  branch.address2,
  branch.address3,
  branch.town,
  branch.county,
  branch.postcode,
  branch.tel,
  branch.fax,
  branch.email,
  branch.maplong,
  branch.maplat,
  branch.web
from
  branch,
  company
where company.type_id = 1
  and branch.company_id = company.id
  order by companyKnownAs, name asc
    </cfquery>
    <cfreturn b>
  </cffunction>
</cfcomponent>