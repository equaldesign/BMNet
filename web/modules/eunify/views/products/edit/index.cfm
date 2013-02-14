<cfset getMyPlugin(plugin="jQuery").getDepends("","form/submitdialog,products/edit")>
<cfoutput>
  <form class="form form-horizontal" id="editProduct" method="post" action="/eunify/products/doEdit">
    <ul class="nav nav-tabs">
      <li class="active"><a class="noAjax" href="##core" data-toggle="tab">Core Properties</a></li>
      <li><a class="noAjax" href="##web" data-toggle="tab">Web Only properties</a></li>
      <li><a class="noAjax" href="##overrides" data-toggle="tab">Web Overrides</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active" id="core">
       <cfoutput>#renderView("products/edit/detail")#</cfoutput>
      </div>
      <div class="tab-pane" id="web">
        <cfoutput>#renderView("products/edit/web")#</cfoutput>
      </div>
      <div class="tab-pane" id="overrides">
        <cfoutput>#renderView("products/edit/overrides")#</cfoutput>
      </div>
    </div>
  </form>
</cfoutput>