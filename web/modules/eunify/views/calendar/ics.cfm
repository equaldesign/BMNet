<cfoutput>
"BEGIN:VCALENDAR",
"PRODID:-//eBiz.//eBiz//EN",
"BEGIN:VEVENT",
"DTSTART:" #DateFormat(rc.appointment.getStartDate(),"yyyyMMdd")#T#TimeFormat(rc.appointment.getStartDate(),"HHmmss")#Z,
"DTEND:" #DateFormat(rc.appointment.getendDate(),"yyyyMMdd")#T#TimeFormat(rc.appointment.getendDate(),"HHmmss")#Z,
"LOCATION:" #rc.appointment.getAddress()#,
"DESCRIPTION;ENCODING=QUOTED-PRINTABLE:" #rc.appointment.getdescription()#,
"SUMMARY:" + rc.appointment.getname(),
"PRIORITY:3",
"END:VEVENT",
"END:VCALENDAR"
</cfoutput>