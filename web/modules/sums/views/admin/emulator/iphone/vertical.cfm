<cfset getMyPlugin(plugin="jQuery").getDepends("","","emulator")>
<div class="simulator">
  <cfoutput><input id="weburl" type="text" value="#rc.address#" class="webinput weburl"></cfoutput>
  <div class="refresh"><a href="#" title="Refresh"><img src="/includes/images/shim.gif"></a></div>
  <div class="home" style="display: block;"><a href="/" title="Home"><img src="/includes/images/shim.gif"></a></div>
  <div class="backbtn" style="display: block;"><a href="javascript:history.go(-1)" title="Back"><img src="/includes/images/shim.gif"></a></div>

  <div class="mobilesite relative" style="visibility: visible; z-index: 100;">
    <!-- phone iframe -->
    <cfoutput>
    <iframe class="mobileframe" id="mobileframe" src="#rc.address#" width="320" height="353" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" allowtransparency="true"></iframe>
    </cfoutput>
    <!-- /phone iframe-->
  </div>
</div>