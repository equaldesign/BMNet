<cfoutput>
<div id="homepagecontrols" class="glow">
  <ul>
    <li class="first"><a rev="blog" href="/general/sethomepage?page=blog">News</a></li>
  </ul>
  <br clear="both">
</div>
</cfoutput>
<cfif rc.cookie.getVar("showIEMessage","true")>
<!--[if lte IE 8]>
<div style="height: 5px;"></div>
<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
  <strong>Old Browser</strong>
    <a href="/contact/noiemessage" class="noIEMessage">don't show this again</a>
  </p>
  <p>You are using an old browser which may cause you issues when running the intranet.</p>
  <p>Our recommendation is to install Google&reg; Chrome&trade; Frame, a plugin for your current browser which will speed up your browsing experience and make your browser more standards compliant. It's free, and only takes a minute to install: <a style="font-weight: bold;" target="_blank" href="http://www.google.com/chromeframe/eula.html?user=true ">Install Google Chrome Frame &raquo;</a>.</p>
</div>
<![endif]-->
</cfif>