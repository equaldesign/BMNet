<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/companies/list","secure/companies/list")>
<cfoutput>
  <h2>#rc.Type#</h2>
  <ul id="alphabet" rel="/bv/company/ajaxList">
    <cfset alphabet = getAlphabet()>
    <cfloop array="#alphabet#" index="letter">
    <li><a class="getcustomers" href="/bv/company/ajaxList?letter=#letter#&type=#rc.type#">#letter#</a></li>
    </cfloop>
  </ul>
  <div id="customerpanel"></div>
</cfoutput>