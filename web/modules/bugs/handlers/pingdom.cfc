<cfcomponent>
  <cfproperty name="pingdom" inject="model:pingdomService">
  <cfproperty name="bugs" inject="model:BugService" scope="instance" />

  <cffunction name="preHandler" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfif NOT rc.isAjax>
      <cfset rc.bugCount = instance.bugs.cCount("","true")>
    </cfif>
  </cffunction>
  <cffunction name="index" returntype="void" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.server1 = pingdom.getResponseTime(checkid=481586,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.server2 = pingdom.getResponseTime(checkid=481587,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.server3 = pingdom.getResponseTime(checkid=481589,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.loadBalancer = pingdom.getResponseTime(checkid=210436,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset event.setView("pingdom/dashboard")>
  </cffunction>

  <cffunction name="hoursofDayAverageChart" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.chartData = {}>
    <cfset rc.chartData.server1 = pingdom.getHoursOfDayAverage(checkid=481586,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.chartData.server2 = pingdom.getHoursOfDayAverage(checkid=481587,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.chartData.server3 = pingdom.getHoursOfDayAverage(checkid=481589,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset rc.chartData.loadBalancer = pingdom.getHoursOfDayAverage(checkid=210436,from="#pingdom.GetEpochTime(DateAdd("d",-1,now()))#",to="#pingdom.GetEpochTime()#",includeuptime=true)>
    <cfset event.renderData(data=rc.chartData,type="JSON")>
  </cffunction>
  <cffunction name="responseTimeChart" cache="true">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.chartData = {}>
    <cfset rc.chartData.server1 = []>
    <cfset rc.chartData.server2 = []>
    <cfset rc.chartData.server3 = []>
    <cfset rc.chartData.loadBalancer = []>
    <cfset server1 = pingdom.getAvgResponseIntervals(481586,"#pingdom.GetEpochTime(DateAdd("d",-90,now()))#","#pingdom.GetEpochTime()#","day",true)>
    <cfset server2 = pingdom.getAvgResponseIntervals(481587,"#pingdom.GetEpochTime(DateAdd("d",-90,now()))#","#pingdom.GetEpochTime()#","day",true)>
    <cfset loadBalancer = pingdom.getAvgResponseIntervals(210436,"#pingdom.GetEpochTime(DateAdd("d",-90,now()))#","#pingdom.GetEpochTime()#","day",true)>
    <cfset server3 = pingdom.getAvgResponseIntervals(481589,"#pingdom.GetEpochTime(DateAdd("d",-90,now()))#","#pingdom.GetEpochTime()#","day",true)>
    <cfloop array="#server1.summary.days#" index="d">
      <cfset arrayAppend(rc.chartData.server1,[d.starttime*1000,d.avgresponse/1000])>
    </cfloop>
    <cfloop array="#server2.summary.days#" index="d">
      <cfset arrayAppend(rc.chartData.server2,[d.starttime*1000,d.avgresponse/1000])>
    </cfloop>
    <cfloop array="#loadBalancer.summary.days#" index="d">
      <cfset arrayAppend(rc.chartData.loadBalancer,[d.starttime*1000,d.avgresponse/1000])>
    </cfloop>
    <cfloop array="#server3.summary.days#" index="d">
      <cfset arrayAppend(rc.chartData.server3,[d.starttime*1000,d.avgresponse/1000])>
    </cfloop>
    <cfset event.renderData(data=rc.chartData,type="JSON")>
  </cffunction>
</cfcomponent>
