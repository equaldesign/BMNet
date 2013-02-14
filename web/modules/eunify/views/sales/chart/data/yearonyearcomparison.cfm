
<cfset rc.json = SerializeJSON(rc.data)>
<cfcontent type="application/json">
<cfoutput>#rc.json#</cfoutput>



<!---
 <cfxml variable="graph">
  <cfoutput>
  <graph
    sNumberSuffix='%a3'
    numberPrefix ='%25'
    legendPosition='RIGHT'
    PYAxisName='Growth'
    SYAxisName='This year'
    shownames='1'
    showvalues='0'
    showLegend='1'
    rotateNames='0'
    formatNumberScale='1'
    decimalPrecision='2'
    limitsDecimalPrecision='0'
    divLineDecimalPrecision='1'
    formatNumber='1'
    chartTopMargin='15'>

    <categories>
      <cfloop query="rc.data">
        <category
          sNumberSuffix='%25'
          name='#DateFormat(DateThis,"MMM")#'
          hoverText='#DateFormat(DateThis,"MMMM YYYY")# vs #DateFormat(DateLast,"MMMM YYYY")#'
          parentYAxis='P'/>
      </cfloop>
     </categories>
     <dataset
      seriesname='Growth'
      parentYAxis='P'
      color='#madcolor()#'
      showValue='1'
      sNumberSuffix ='%25'>
        <cfloop query="rc.data">
          <cfif valueThis neq "" AND valueLast neq "">
            <cfset value = round(((int(valueThis)-int(valueLast))/int(ValueLast))*100)>
            <set value="#value#" />
          <cfelseif valueThis neq "">
            <set value="100" />
          <cfelseif valueLast neq "">
            <set value="-100" />
          <cfelse>
            <set value="0" />
          </cfif>
        </cfloop>
      </dataset>
      <dataset
        seriesname='Turnover'
        showValues='1'
        color='#madcolor()#'
        parentYAxis='S'
        lineThickness='3'
        numberprefix='%a3'>
        <cfloop query="rc.data">
          <set value="#valueThis#"  />
        </cfloop>
      </dataset>
  </graph>
  </cfoutput>
</cfxml>
<cfheader name="Content-Type" value="text/xml">
<cfcontent type="text/xml; charset=UTF-8">
<cfoutput>#graph#</cfoutput>


 --->
