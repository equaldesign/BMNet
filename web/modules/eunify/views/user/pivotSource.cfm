<h1>Pivot table access</h1>
<p>The old Microsoft Web Components plugin we used to use has been discontinued by Microsoft for some time, and is not compatible with Internet Explorer 9 onwards.</p>
<p>However, you can get direct access to all turnover directly from within Microsoft&reg; Excel&trade;, for fast and powerful access to turnover data.</p>
<p>This new method of data access gives you data portability, increased speed, and a faster user experience.</p>
<cfoutput>
<div style="padding: .5em" class="Aristo ui-state-highlight ui-corner-all">
  <p>
    <span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>Your unique URL</strong>
  </p>
  <p>Your unique access URL to the pivot tables is:</p>
  <h4>Turnover</h4>
  <pre>http://#cgi.HTTP_HOST#/pivots/#year(now())#/#rc.e#</pre>
  <h4>Earnings</h4>
  <pre>http://#cgi.HTTP_HOST#/pivots/#year(now())#/#rc.e#/rebates</pre>
</div>
<p>To get setup, follow the steps below, depending on your current version of Excel&trade;</p>

<div class="accordion">
  <h5><a href="##">Excel 2003</a></h5>
  <div>
    <h2>Excel 2003</h2>
    <p>Setup</p>
  </div>
  <h5><a href="##">Excel 2007</a></h5>
  <div>
    <h2>Excel 2007</h2>
  </div>
</div>
</cfoutput>