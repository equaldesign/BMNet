 <cfxml variable="graph">
  <cfoutput>
  <graph  caption="Monthly Sales Comparison"
                lineThickness="1"
                showValues="0"
                formatNumberScale="0"
                anchorRadius="2"
                divLineAlpha="20"
                divLineColor="CC3300"
                showAlternateHGridColor="1"
                alternateHGridColor="CC3300"
                shadowAlpha="40"
                numvdivlines="5"
                chartRightMargin="35"
                numberPrefix ='%a3'
                bgColor="FDF5F3"
                alternateHGridAlpha="5"
                limitsDecimalPrecision='0'
                divLineDecimalPrecision='0'
                decimalPrecision="0">

        <categories>
          <cfloop query="rc.data">
            <category name="#DateFormat(dateThis,"DD")#"/>
          </cfloop>
        </categories>

        <dataset seriesName="Current Month" color="1D8BD1" anchorBorderColor="1D8BD1" anchorBgColor="1D8BD1">
          <cfloop query="rc.data">
                <set value="#Iif(ValueThis eq "","'0'","'#valueThis#'")#"/>

          </cfloop>
        </dataset>

        <dataset seriesName="Previous Month" color="F1683C" anchorBorderColor="F1683C" anchorBgColor="F1683C">
          <cfloop query="rc.data">
                <set value="#Iif(valueLast eq "","'0'","'#valueLast#'")#"/>
          </cfloop>
        </dataset>

</graph>
  </cfoutput>
</cfxml>
<cfheader name="Content-Type" value="text/xml">
<cfcontent type="text/xml; charset=UTF-8">
<cfoutput>#graph#</cfoutput>


