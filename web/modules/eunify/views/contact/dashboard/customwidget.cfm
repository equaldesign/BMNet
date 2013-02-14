<cfoutput>
  <div data-url="dashboard.intro" data-urlattributes="" class="portlet span3">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><a href="##"><i class="icon-arrow-move"></i></a></span>
        <h5>New Widget</h5>
        <div class="pull-right buttons">
          <div class="btn-group" id="feedTypes_i">
            <button class="btn btn-mini"><i class="icon-link"></i></button>
            <button class="btn btn-mini dropdown-toggle" data-target="##feedTypes_i" data-toggle="dropdown">
              <span class="caret"></span>
            </button>
            #renderView("viewlets/dashboarddropdown")#
          </div>
          <div class="btn-group" id="widgetWidth_i">
            <button class="btn btn-mini"><i class="icon-arrow"></i></button>
            <button class="btn btn-mini dropdown-toggle" data-target="##widgetWidth_i" data-toggle="dropdown">
              <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
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
      <div class="widget-content"></div>
    </div>
  </div>
</cfoutput>