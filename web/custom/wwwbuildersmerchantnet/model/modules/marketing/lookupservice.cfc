<cfcomponent>
  <cffunction name="lookupPSACountbyBV" returntype="string">
    <cfargument name="contactID" default="51794">
    <cfquery name="contact" datasource="BMNet">
      select * from contact where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
    </cfquery>
    <cfquery name="company" datasource="BMNet">
      select * from company where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact.company_id#">
    </cfquery>

    <cfset bvSiteID = company.bvsiteID>
    <cfset purchasingAgreementsHits = 0>
    <cfloop list="eGroup_cbagroup,eGroup_cemco,eGroup_nbg,eGroup_handbgroup" index="e">
      <cfquery name="currentPSAs" datasource="#e#">
        select
          arrangement.id
        from
          arrangement,
          company
        where
          company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvSiteID#">
          AND
          arrangement.company_id = company.id
          AND
          arrangement.period_from < now()
          AND
          arrangement.period_to > now()
      </cfquery>
      <cfloop query="currentPSAs">
        <cfquery name="hit" datasource="#e#">
          select count(*) as hits
          from visitorLog
          where
          visitorLog.address = '/psa/index/psaid/#id#/?'
        </cfquery>
        <cfset purchasingAgreementsHits+= hit.hits >
      </cfloop>
    </cfloop>
    <cfreturn purchasingAgreementsHits>
  </cffunction>

  <cffunction name="lookupTodayCount" returntype="string">
    <cfset loginHits = 0>
    <cfloop list="eGroup_cbagroup,eGroup_cemco,eGroup_nbg,eGroup_handbgroup" index="e">
      <cfquery name="hit" datasource="#e#">
        select count(distinct contactID) as hits
        from visitorLog
        where
        Date(visitorLog.stamp) >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d",-1,now())#">
      </cfquery>
      <cfset loginHits+= hit.hits >
    </cfloop>
    <cfreturn loginHits>
  </cffunction>
</cfcomponent>