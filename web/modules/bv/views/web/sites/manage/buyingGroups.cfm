<div class="page-heading">
	<h1>Buying Group Integration</h1>
</div>
<br />
<cfoutput>
<cfif rc.groupInfo.cemco.recordCount eq 0>
	<cfset cemcoStyle = "error">
<cfelse>
	<cfset cemcoStyle = "success">
</cfif> 
<div id="inviteAlert" class="alert alert-#cemcoStyle#">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>CEMCO Merchant Network</h3>
    <cfif rc.groupInfo.cemco.recordCount eq 0>
		  <strong>Not connected!</strong> Your site is not connected to the CEMCO Intranet.
			<p>If you supply goods and services to CEMCO, you should contact your negotiator to ensure your Building Vine&trade; account is properly connected.</p>
		<cfelse>
	   <strong>Awesome!</Strong> Your site is all hooked up to the CEMCO intranet!</p>
		 <p>You should have a CEMCO group in your User List - this covers all CEMCO Member contacts. This means all your products, promotions and CEMCO specific prices can be viewed by CEMCO intranet users.</p>		 
	  </cfif>
  </div>
</div>
<cfif rc.groupInfo.cba.recordCount eq 0>
  <cfset CBAStyle = "error">
<cfelse>
  <cfset CBAStyle = "success">
</cfif> 
<div id="inviteAlert" class="alert alert-#CBAStyle#">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>The CBA Group</h3>
    <cfif rc.groupInfo.cba.recordCount eq 0>
      <strong>Not connected!</strong> Your site is not connected to the CBA Group.
      <p>If you supply goods and services to The CBA, you should contact your negotiator to ensure your Building Vine&trade; account is properly connected.</p>
    <cfelse>
     <strong>Awesome!</Strong> Your site is all hooked up to the CBA intranet!</p>
     <p>You should have a CBA group in your User List - this covers all CBA Member contacts. This means all your products, promotions and CBA specific prices can be viewed by CBA intranet users.</p>
    </cfif>
  </div>
</div>
<cfif rc.groupInfo.handb.recordCount eq 0>
  <cfset HBStyle = "error">
<cfelse>
  <cfset HBStyle = "success">
</cfif> 
<div id="inviteAlert" class="alert alert-#HBStyle#">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>The h&amp;b Group</h3>
    <cfif rc.groupInfo.handb.recordCount eq 0>
      <strong>Not connected!</strong> Your site is not connected to the The h&amp;b Group.
      <p>If you supply goods and services to The h&amp;b Group, you should contact your negotiator to ensure your Building Vine&trade; account is properly connected.</p>
    <cfelse>
     <strong>Awesome!</Strong> Your site is all hooked up to the The h&amp;b Group intranet!</p>
     <p>You should have a h&amp;b group in your User List - this covers all h&amp;b Member contacts. This means all your products, promotions and h&amp;b specific prices can be viewed by h&amp;b intranet users.</p>
    </cfif>
  </div>
</div>
<cfif rc.groupInfo.nbg.recordCount eq 0>
  <cfset NBGStyle = "error">
<cfelse>
  <cfset NBGStyle = "success">
</cfif> 
<div id="inviteAlert" class="alert alert-#NBGStyle#">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>The NBG Group</h3>
    <cfif rc.groupInfo.nbg.recordCount eq 0>
      <strong>Not connected!</strong> Your site is not connected to the The NBG Group.
      <p>If you supply goods and services to The NBG Group, you should contact your negotiator to ensure your Building Vine&trade; account is properly connected.</p>
    <cfelse>
     <strong>Awesome!</Strong> Your site is all hooked up to the The NBG Group intranet!</p>
     <p>You should have a NBG group in your User List - this covers all NBG Partner contacts. This means all your products, promotions and NBG specific prices can be viewed by NBG intranet users.</p>
    </cfif>
  </div>
</div>
</cfoutput>
