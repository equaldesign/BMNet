<cfcomponent name="help" cache="false" cachetimeout="50">

  <cfproperty name="automaton" inject="model:automaton" scope="instance" />
  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.result = instance.automaton.check()>

     <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("debug")>
  </cffunction>
  <cffunction name="dbBackup" returntype="void">
    <cfargument name="event">
    <cfsetting requesttimeout="900000">
    <cfset var rc = event.getCollection()>
    <cfexecute name="/fs/sites/ebiz/help.ebiz.co.uk/mysqlbackup.sh" arguments="#DateFormat(now(),'YYYY-MM-DD')#" timeout="300" />
    <cffile action="copy" destination="s3://AKIAJ7KY7OTQMJ4QN24Q:J/30AAjnCnwAGGyCRHqlwxEaAr7nOcvpeKQ3JyjO@ebiz_mysql_#DateFormat(now(),'YYYY-MM-DD')#/dump.sql.gz" source="/fs/backups/#DateFormat(now(),'YYYY-MM-DD')#_dump.sql.gz" />
    <cffile action="delete" file="/fs/backups/#DateFormat(now(),'YYYY-MM-DD')#_dump.sql.gz">
  </cffunction>
</cfcomponent>