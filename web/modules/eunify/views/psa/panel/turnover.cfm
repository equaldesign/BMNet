<cfset arrangement = getModel("psa")>
<h2>Export turnover</h2>
<cfoutput>
  <cfif DateDiff('m',rc.panelData.psa.period_from,rc.panelData.upto) gte 0>
	  <h4>Turnover has been entered up until (and including) #DateFormat(rc.panelData.upto,"MMMM YYYY")#</h4>
    <cfif rc.fe.recordCount neq 0>
      <p>Download the turnover, and click "Yes" when excel prompts to open the file now.</p>
      <div class="niceSilverbg">
        <cfoutput><h3><a class="noAjax xls" href="/figures/turnoverSpreadsheet?psaID=#rc.panelData.psa.id#">Download this as a full Excel Spreadsheet</a></h3></cfoutput>
      </div>
      <cfelse>
       <h4>Although figures exist, no input streams exists! Therefore no spreadsheet can be downloaded.</h4>
       <p>You can attempt to repair the deal by using the existing figures to recreate the input stream(s).</p>
       <p>If you want to try this, <a class="red" href="/psa/repair/psaid/#rc.panelData.psa.id#">click to proceed &raquo;</a></p>
      </cfif>
   <cfelse>
    <h4>No turnover has been input yet</h4>
  </cfif>
</cfoutput>


