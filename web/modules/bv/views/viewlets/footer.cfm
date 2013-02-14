<div class="Logo floatleft"><img src="/includes/images/bottomLogo.png" alt="Building Vine" /></div>
<div id="footerlinks" class="floatright">
  <ul>
    <li class="first"><a href="/pages/payments">Payments</a></li>
    <li><a href="/pages/privacy">Privacy</a></li>
    <li><a href="/pages/terms">Terms of Use</a></li>
    <cfif rc.buildingVine.userName neq "guest"><li><a href="/login/logout">logout</a></li></cfif>
    <li class="last"><a href="/">Home</a></li>
  </ul>
  <div class="floatright padd"><br /><img alt="supported by CEMCO" src="/includes/images/footerInfo.png" /></div>
</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-866816-27");
pageTracker._trackPageview();
<cfoutput>pageTracker._setVar('#rc.buildingVine.userName#');</cfoutput>
} catch(err) {}</script>