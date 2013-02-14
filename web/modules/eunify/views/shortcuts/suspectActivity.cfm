<h2>Suspicious activity report</h2>
<div style="margin: 10px 0; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
  The table below shows all suspicious activity within the last 7 days.</p>
  <p>Suspicious activity is when a user views a large amount of different agreements within a single day.</p>
</div>
<table class="v tableCloth">
  <thead>
    <tr>
      <th># deals viewed</th>
      <th>Name</th>
      <th>Company</th>
      <th>Date</th>
    </tr>
  </thead>
  <tbody>
  <cfoutput query="rc.activity">
    <tr>
      <td>#deals#</td>
      <td><a href="/contact/fullHistory/id/#id#?date_from=#DateFormat(visitDate,'YYYY-MM-DD')#&date_to=#DateFormat(dateAdd('d',1,visitDate),'YYYY-MM-DD')#&logFilter=/psa/index/psaid/">#first_name# #surname#</a></td>
      <td>#known_as#</td>
      <td>#DateFormat(visitDate,"DD/MM/YYYY")#</td>
    </tr>
  </cfoutput>
  </tbody>
</table>
