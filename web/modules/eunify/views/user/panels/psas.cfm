<h2>Negotiating</h2>
<cfif rc.psas.recordCount eq 0>
	<div class="Aristo ui-widget">
			<div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
				<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
				No deals negotiated by this contact</p>
			</div>
	</div>
</cfif>
<ul class="psastatus">
	<cfoutput query="rc.psas" group="period_to">
		<li class="date">Expiring in #DateFormat(period_to,"MMMM YYYY")#</li>
		<ul>
			<cfoutput>
				<li class="#psa_status#">
          <cfif period_to lt now()>
            <cfset endDate = period_to>
          <cfelse>
            <cfset endDate = DateAdd("m",-1,now())>
          </cfif>
          <cfif DateCompare(getModel("figures").getNextInputDate(id),endDate,"m") lt 0>
          <span class="alert"></span>
          </cfif>
          <a href="#bl('psa.index','psaid=#id#')#">#name#</a> (<a href="#bl('company.index','id=#company_id#')#">#known_as#</a>)</li>
			</cfoutput>
		</ul>
	</cfoutput>
</ul>

