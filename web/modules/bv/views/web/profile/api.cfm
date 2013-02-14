<div class="page-header">
  <h3>API Key</h3>
</div>
<cfset loginStruct = {}>
<cfset loginStruct.username = ListGetAt(getAuthUser(),1,"|")>
<cfset loginStruct.password = ListGetAt(getAuthUser(),2,"|")>
<cfset safeStruct = SerializeJSON(loginStruct)>
<cfset key = urlencrypt(safeStruct)>
<pre><cfoutput>#key#</cfoutput></pre>