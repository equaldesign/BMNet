<cfset getMyPlugin(plugin="jQuery").getDepends("fusioncharts,mapcluster","sales/site/warningsMap","charts,form")>
<cfoutput>
<input type="hidden" id="filterColumn" value="#rc.filterColumn#" />
<input type="hidden" id="filterValue" value="#rc.filterValue#" />
</cfoutput>
<div>
<h2>Customer Disapearance</h2>
<cfoutput>
<p>The following customers had at least 50 invoices between #DateFormat(DateAdd("m",-8,now()),"MMMM")# and #DateFormat(DateAdd("m",-2,now()),"MMMM")#, but haven't made any purchases since then</p>
</cfoutput>
<div id="googleHeatMap" style="width: 100%; height:600px"></div>
</div>

<div class="form-container" id="">
  <form>
    <cfoutput>
    <fieldset>
      <legend>Filter Chart</legend>
      <div>
        <cfset accVal = "">
        <cfset acc = ListFind(rc.filterColumn,"account_number")>
        <cfif acc neq 0>
          <cfset accVal = ListGetAt(rc.filterValue,acc)>
        </cfif>
        <label for="account_number">Acc/No</label>
        <input class="filter" type="text" value="#accVal#" id="account_number" />
      </div>
      <div>
        <cfset prodVal = "">
        <cfset prod = ListFind(rc.filterColumn,"product_code")>
        <cfif prod neq 0>
          <cfset prodVal = ListGetAt(rc.filterValue,prod)>
        </cfif>
        <label for="product_code">Product Code</label>
        <input class="filter" type="text" value="#prodVal#" id="product_code" />
      </div>
      <div>
        <cfset salesVal = "">
        <cfset smn = ListFind(rc.filterColumn,"salesman")>
        <cfif smn neq 0>
          <cfset salesVal = ListGetAt(rc.filterValue,smn)>
        </cfif>
        <label for="salesman">Salesman</label>
        <input class="filter" type="text" value="#salesVal#" id="salesman" />
      </div>
      <div>
        <cfset branchVal = "">
        <cfset bnc = ListFind(rc.filterColumn,"branch_id")>
        <cfif bnc neq 0>
          <cfset branchVal = ListGetAt(rc.filterValue,bnc)>
        </cfif>
        <label for="branch_id">Branch ID</label>
        <input class="filter" type="text" value="#branchVal#" id="branch_id" />
      </div>
      <input type="button" class="doIt" value="redo chart &raquo;" id="doChart" />
    </fieldset>
    </cfoutput>
  </form>
</div>
