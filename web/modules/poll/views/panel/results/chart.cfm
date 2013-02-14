<cfoutput query="rc.resultList" group="name">
  <cfoutput group="label">
    <div id="chart_#hash('#name#_#label#')#" class="chart" title="#label#">
    <cfoutput>
      <span class="chartName" title="#optionLabel#" rel="#optionCount#"></span>
    </cfoutput>
    </div>
  </cfoutput>
</cfoutput>