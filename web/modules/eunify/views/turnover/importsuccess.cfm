<cfif isQuery(rc.results)>
	<h2>Success</h2>
	<cfoutput>	
	<p>#rc.results.recordCount# records were imported</p>
	</cfoutput>
</cfif>
