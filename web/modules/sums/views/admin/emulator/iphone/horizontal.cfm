<cfset getMyPlugin(plugin="jQuery").getDepends("","","emulator")>
<div class="simulator-horizontal">
  <cfoutput><input id="weburl" type="text" value="#rc.address#" class="webinput-horizontal weburl"></cfoutput>
  <div class="refresh-horizontal"><a href="#" title="Refresh"><img src="/includes/images/shim.gif"></a></div>
  <div class="home-horizontal" style="display: block;"><a href="/" title="Home"><img src="/includes/images/shim.gif"></a></div>
  <div class="backbtn-horizontal" style="display: block;"><a href="javascript:history.go(-1)" title="Back"><img src="/includes/images/shim.gif"></a></div>

  <div class="mobilesite-horizontal relative" style="visibility: visible; z-index: 100;">
    <!-- phone iframe -->
    <cfoutput>
    <iframe class="mobileframe" id="mobileframe" src="#rc.address#" width="480" height="211" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" allowtransparency="true"></iframe>
    </cfoutput>
    <!-- /phone iframe-->
  </div>
</div>