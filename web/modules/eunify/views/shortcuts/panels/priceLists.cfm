<cfoutput>
  <ul>
    <li class="prices_thisweek"><a class="ajax" href="/documents/documentNameList?period=#DateFormat(dateAdd('d',-7,now()),'DD/MM/YY')#&name=Prices">Prices updated this week</a></li>
    <li class="prices_thismonth"><a class="ajax" href="/documents/documentNameList?period=#DateFormat(dateAdd('d',-31,now()),'DD/MM/YY')#&name=Prices">Prices updated this month</a></li>
  </ul>
</cfoutput>