<cfoutput>

<div id="dayControls">
<a class="p" href="#bl('calendar.day','date=#rc.yesterday###calendar')#">&nbsp;</a>
<p class="currentDay">#DateFormat(rc.day,"long")#</p>
<a class="n" href="#bl('calendar.day','date=#rc.tomorrow###calendar')#">&nbsp;</a>
</div>
<br class="clear" />
</cfoutput>
<div id="fullDay">
<cfoutput>
<cfloop from="0" to="#DateDiff('h',rc.dayStart,rc.dayEnd)#" index="h">
	<div class="hour"><h5>#TimeFormat(DateAdd("h",h,rc.dayStart),"short")#</h5></div>
</cfloop>
</cfoutput>
<cftry>
<cfoutput query="rc.appointments">
  <cfif DateCompare(startDate,rc.dayStart,"d") eq -1>
    <cfset posTop = 0>
  <cfelse>
    <cfset posTop = DateDiff("h",rc.dayStart,startDate)*50>
  </cfif>
  <cfif DateCompare(endDate,rc.dayStart,"d") eq 1>
    <cfset posBottom = 650>
  <cfelse>
    <cfset posBottom = DateDiff('h',rc.dayStart,endDate)*50>
  </cfif>
  <cfset eventHeight = posBottom-posTop>
  <cfif currentRow neq 1>
    <cfset eventLeft = 50+(rc.appWidth*currentRow-(rc.appWidth-1)+10)>
  <cfelse>
    <cfset eventLeft = 50>
  </cfif>
    <div class="calendarEvent #getCalendarClass(invited,attending)#" style="top: #posTop#px; left:#eventLeft#px; height:#eventHeight#px; width:#rc.appWidth#px;">
      <div class="eventDetail">
          <h2><a href="#bl('calendar.detail','id=#id#')#" class="ajax" rel="#bl('calendar.detail','id=#id#')#">#name#</a></h2>
          <h4>#TimeFormat(startDate,"HH:MM")# - #TimeFormat(endDate,"HH:MM")#</h4>
          <p>#attendees# people have been invited to this meeting</p>
      </div>
    </div>
</cfoutput>
<cfcatch type="any" >
	<cfdump var="#rc.appointments#">
	<br class="clear" />
</cfcatch>
</cftry>
</div>
