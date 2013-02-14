<cfoutput>
<cfif arrayLen(rc.message.bodyparts.html) gte 1>
<link rel="stylesheet" href="/modules/eunify/includes/style/email.css"/>
#rc.message.bodyparts.html[1]#
<cfelse>
<link rel="stylesheet" href="/modules/eunify/includes/style/email.css"/>
#paragraphFormat(rc.message.bodyparts.text[1])#
</cfif>
</cfoutput>
