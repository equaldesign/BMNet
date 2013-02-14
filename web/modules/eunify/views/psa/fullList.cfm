<cfset getMyPlugin(plugin="jQuery").getDepends("","","psa/fullList")>

<h2>Full Agreement List</h2>
<div style="margin: 5px 0px; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
  <strong>Did you know?....</strong></p>
  <p>You can search for an agreement by company or product type using the search box at the top right of the page?</p>
</div>
<div id="fullList" class="Aristo">
  <cfoutput>#rc.psaList#</cfoutput>
</div>
