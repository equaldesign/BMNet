<cfset getMyPlugin(plugin="jQuery").getDepends("fusioncharts","contact/dashboard","dashboard/overview")>
<div id="overviewChart"></div>
<div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
  <strong>Overview of this chart.</strong></p>
  <p>The bars in this chart represent your companies growth in the last 12 months compared with the 12 months previous. Bars in the positive show your turnover has grown this year over last year</p>
  <p>The line in the chart represents your growth compared with median growth for other Members. Markers in the positive mean you have grown more in comparison than other Members have in this same period. </p>
</div>
<div class="dL">
  <cfoutput>
    <a class="noAjax turnover_download member" href="/figures/memberturnover">
      <h3>Download your turnover</h3>
      <p>This Spreadsheet has all your turnover for #year(now())# in a simple pivot table.</p>
      <p>It is compatible with Excel 2003, 2007 and 2010.</p>
      <p>When prompted, you need to <span class="red bold">save</span> the file somewhere on your PC, and <span class="red bold">then</span> open it.</p>
      <p class="small bold red">The data in this spreadsheet does not update automatically. You will need to re-download this spreadsheet periodically, when new turnover has been added by suppliers.</p>
   </a>
  </cfoutput>
</div>
<cfif isUserInRole("ebiz")>
<div class="dL">
  <cfoutput>
    <a class="noAjax turnover_download group" href="/figures/groupturnover">
      <h3>Download Group turnover</h3>
      <p>This Spreadsheet has all #getSetting("siteName")# turnover for #year(now())# in a simple pivot table.</p>
      <p>It is compatible with Excel 2003, 2007 and 2010.</p>
      <p>When prompted, you need to <span class="red bold">save</span> the file somewhere on your PC, and <span class="red bold">then</span> open it.</p>
      <p class="small bold red">The data in this spreadsheet does not update automatically. You will need to re-download this spreadsheet periodically, when new turnover has been added by suppliers.</p>
   </a>
  </cfoutput>
</div>
</cfif>
<br class="clear" />