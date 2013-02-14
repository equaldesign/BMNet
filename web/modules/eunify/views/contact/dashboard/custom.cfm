<cfset getMyPlugin(plugin="jQuery").getDepends("slimScroll,scrollpane,mousewheel,mousewheelintent","contact/dashboard/custom","dashboard/custom")>
<cfoutput>
  <div id="dashboardSettings" class="btn-group">
    <button class="btn btn-inverse btn-mini"><i class="icon-wrench"></i>Dashboard Settings</button>
    <button class="btn btn-inverse btn-mini dropdown-toggle" data-toggle="dropdown">
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu pull-right">
      <li><a href="##" class="addWidget"><i class="icon-addwidget"></i>Add new widget</a></li>
      <li><a href="##" class="saveLayout"><i class="icon-disk"></i>Save current Layout</a></li>
    </ul>
  </div>
  <div id="dashboard" class="row-fluid">
  <cfloop array="#rc.layout#" index="l">
    <div data-url="#l.url#" data-urlattributes="#l.urlattributes#" class="#l.class#" data-module="#paramValue('l.module',event.getCurrentModule())#">
      <div class="widget-box">
        <div class="widget-title">
          <span class="icon"><a href="##"><i class="icon-arrow-move"></i></a></span>
          <h5>#l.name#</h5>
          <div class="pull-right buttons">
            <div class="btn-group" id="feedTypes_#l.url#">
              <button class="btn btn-mini"><i class="icon-link"></i></button>
              <button class="btn btn-mini dropdown-toggle" data-target="##feedTypes_#l.url#" data-toggle="dropdown">
                <span class="caret"></span>
              </button>
              #renderView("viewlets/dashboarddropdown")#
            </div>
            <div class="btn-group" id="widgetWidth_#l.url#">
              <button class="btn btn-mini"><i class="icon-arrow"></i></button>
              <button class="btn btn-mini dropdown-toggle" data-target="##widgetWidth_#l.url#" data-toggle="dropdown">
                <span class="caret"></span>
              </button>
              <ul class="dropdown-menu pull-right">
                <li><a class="changeSpan" data-width="3"  href="##"><i class="icon-set-size"></i> 3x</a></li>
                <li><a class="changeSpan" data-width="4"  href="##"><i class="icon-set-size"></i> 4x</a></li>
                <li><a class="changeSpan" data-width="5"  href="##"><i class="icon-set-size"></i> 5x</a></li>
                <li><a class="changeSpan" data-width="6"  href="##"><i class="icon-set-size"></i> 6x</a></li>
                <li><a class="changeSpan" data-width="7"  href="##"><i class="icon-set-size"></i> 7x</a></li>
                <li><a class="changeSpan" data-width="8"  href="##"><i class="icon-set-size"></i> 8x</a></li>
                <li><a class="changeSpan" data-width="9"  href="##"><i class="icon-set-size"></i> 9x</a></li>
                <li><a class="changeSpan" data-width="10"  href="##"><i class="icon-set-size"></i> 10x</a></li>
                <li><a class="changeSpan" data-width="11"  href="##"><i class="icon-set-size"></i> 11x</a></li>
                <li><a class="changeSpan" data-width="12"  href="##"><i class="icon-set-size"></i> 12x</a></li>
              </ul>
            </div>
            <a class="closeWidget" href="##"><i class="icon-cross-circle-frame"></i></a>
          </div>
        </div> <!-- /widget-header -->
        <div id="#l.url#" class="ajaxMain widget-content" style="height: #l.height#px">
      </div>
    </div>
    </div>
  </cfloop>
  </div>
</cfoutput>
