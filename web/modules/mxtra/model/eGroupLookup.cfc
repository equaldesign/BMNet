<cfcomponent cache="true">
	<cffunction name="getBranches" returntype="query">
	  <cfargument name="bvsiteid" required="true">	  
	  <cfargument name="currentCoOrdinates" required="true" default="#ArrayNew(1)#">
	  <cfset var returnQuery = QueryNew("eGroup_datasource,companyID,branchID,companyName,branchAddress1,branchAddress2,town,maplong,maplat")>
	  <cfif bvsiteID neq "">
	  <cfloop list="cemco,cbagroup,handbgroup" index="ds">
	  	<cfquery name="stockist" datasource="eGroup_#ds#" cachedwithin="#CreateTimeSpan(7,0,0,0)#">
		  	select
          branch.id as branchID, branch.tel, branch.name, branch.address1,branch.address2, branch.address3, branch.town,branch.county, branch.postcode,branch.maplat,branch.maplong,
          member.id as memberID, member.name as memberName, member.known_as     
          <cfif ArrayLen(currentCoOrdinates) gt 1>
		  	  ,(3959 * acos( cos( radians('#currentCoOrdinates[1]#') ) * cos( radians( maplat ) ) * cos( radians( maplong ) - radians('#currentCoOrdinates[2]#') ) + sin( radians('#currentCoOrdinates[1]#') ) * sin( radians( maplat ) ) ) ) AS distance
		      </cfif>     
        from
          branch,
          company,
          company as member,
          arrangement,
          turnover
        where
          company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bvsiteID#">
          AND
          arrangement.company_id = company.ID
          AND
          arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(year(now()),1,1)#">
          AND
          turnover.psaID = arrangement.id
          AND
          turnover.value > 0
          AND
          turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(Year(now()),1,1)#">
          AND
          member.id = turnover.memberID
          AND
          branch.company_id = member.id
          group by branch.id
          <cfif arrayLen(currentCoOrdinates) gt 1> 
		  	   HAVING
            distance < '25' ORDER BY distance LIMIT 0,20		      
		      
			  	  
		      </cfif>
		      
       ;
		  </cfquery>
		  <cfloop query="stockist">
		  	<cfset QueryAddRow(returnQuery)>
			  <cfset QuerySetCell(returnQuery,"eGroup_datasource","eGroup_#ds#")>
			  <cfset QuerySetCell(returnQuery,"companyID",memberID)>
			  <cfset QuerySetCell(returnQuery,"branchID",branchID)>
				<cfset QuerySetCell(returnQuery,"companyName",memberName)>
				<cfset QuerySetCell(returnQuery,"branchAddress1",address1)>
				<cfset QuerySetCell(returnQuery,"branchAddress2",address2)>
				<cfset QuerySetCell(returnQuery,"town",town)>
				<cfset QuerySetCell(returnQuery,"maplat",maplat)>
				<cfset QuerySetCell(returnQuery,"maplong",maplong)>
		  </cfloop>
	  </cfloop>
	  </cfif>
	  <cfreturn returnQuery>
	</cffunction>
	
	
</cfcomponent>