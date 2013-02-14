<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","",true,"eGroup")>
<!--- just a nice tabbed panel --->
<h2><cfoutput>#rc.supplier.name#</cfoutput></h2>
<div class="tabs Aristo">
<cfoutput>
<ul>
  <li><a class="overview" href="#bl('suppliers.overview','id=#rc.account_number#')#"><span>Overview</span></a></li>
  <li><a class="invoices" href="#bl('purchases.list','filter=account_number&filterid=#rc.account_number#')#"><span>Purchases</span></a></li>
  <li><a class="sales" href="#bl('purchases.index','filterColumn=account_number&filterValue=#rc.account_number#')#"><span>Purchase Analysis</span></a></li>
</ul>
</cfoutput>
</div>