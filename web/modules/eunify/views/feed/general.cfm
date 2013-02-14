<cfdump var="#rc.feed#">
<cfabort>
<cfsavecontent variable="feedtext">
<h2>Updates &amp; Activity</h2>

<cfoutput query="rc.feed">
  <div class="article articlestyle_#catName#">
    <div class="newstitle">
    #details# <span class="timestamp">(#DateFormat(tstamp,"DD MMM YY")# @ #TimeFormat(tstamp,"HH:MM")#)</span>
    </div>
  </div>
</cfoutput>
</cfsavecontent>
<cfset feedtext = replaceNoCase(feedtext,"&##","&####","ALL")>
<cfset fileID = createUUID()>
<cffile action="write" output="#feedtext#" file="ram://#fileID#.cfm">
<cfoutput>
<!---<cftry>--->
<cfinclude template="/ram/#fileID#.cfm">
<!---<cfcatch type="expression">
  <cffile action="read" file="ram://#fileID#.cfm" variable="dump">
  <cfdump var="#cfcatch#">

  <cfoutput>#dump#</cfoutput>
</cfcatch>
</cftry>--->
</cfoutput>
