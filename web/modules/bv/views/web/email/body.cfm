<cfoutput>
<cfif arrayLen(rc.message.bodyparts.html) gte 1>
#rc.message.bodyparts.html[1]#
<cfelse>
<link rel="stylesheet" href="/bv/includes/style/fonts.css"/>
<link rel="stylesheet" href="/bv/includes/style/text.css"/>
#paragraphFormat(rc.message.bodyparts.text[1])#
</cfif>
</cfoutput>
