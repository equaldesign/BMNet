<cfheader statuscode="503">

<cfset httpData = getHTTPRequestData()>
<cfset isAjax = structKeyExists(httpData.headers, 'X-Requested-With') && httpData.headers['X-Requested-With'] eq 'XMLHttpRequest'>
<cfset exceptionBean = event.getValue("ExceptionBean") />
<cfset controller = getController()>
<cfset rc = event.getCollection()>
<cfif NOT rc.isAjax>
  <html>
    <head>
      <script language="javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
      <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
      <link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800' rel='stylesheet' type='text/css'>
      <title>Something went wrong</title>
      <cfoutput>
      <script language="javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
      <link rel="stylesheet" href="/includes/style/bootstrap.css">
      <link rel="stylesheet" href="/includes/style/error.css">
      </cfoutput>
    </head>
    <body style="margin:10px;">
</cfif>
    <cfoutput><script language="javascript" src="/includes/javascript/bug/escalte.js"></script></cfoutput>
    <link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
<div id="info" class="alert alert-error">
  <a href="#" class="close" data-dismiss="alert">&times;</a>
  <h2 class="alert-heading">Whoops! You've encountered a missing or broken link.</h2>
  <p>If this happens more than once, it's probably best to stop trying for now. Otherwise, please <a href="javascript:location.reload();">try again.</a></p>
  <p>A ticket has been created in the bugs system which will be dealt with as soon as possible. A reference for this ticket is shown below<br /><br /><span class="label label-important"><i class="icon-ticket"></i> <cfoutput>#rc.newTicketID#</cfoutput></span></p>
  <a href="/" class="noAjax btn btn-danger"><i class="icon-home"></i> home</a>
</div>
<div id="other">
<div id="" class="alert alert-info">
  <a href="#" class="close" data-dismiss="alert">&times;</a>
  <cfoutput><p>If you feel this issue needs addressing urgently, you can <a href="/bugs/bugs/escalate?ticket=#rc.newTicketID#" class="escalate">escalate this issue</a> and get alerted via email when the status of this bug changes or is resolved.</p>  </cfoutput>

</div>
<cfif isUserLoggedIn()>
<a href="#debugModal" role="button" class="noAjax btn btn-info " data-toggle="modal"><i class="icon-question"></i>View debug output</a>
<div id="debugModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3 id="myModalLabel">Error Details</h3>
  </div>
  <div class="modal-body">
    <cfoutput>
    <h3>Details</h3>
    <table class="table table-striped table-condensed table-bordered">
      <tr>
        <td colspan="2">#rc.bugDetail.gettitle()#</td>
      </tr>
      <tr>
        <th>Ticket No.</th>
        <td>#rc.bugDetail.getticket()#</td>
      </tr>
      <tr>
        <th>Detail</th>
        <td>#rc.bugDetail.getdescription()#</td>
      </tr>
      <tr>
        <th>URL</th>
        <td>#rc.bugDetail.geturl()#</td>
      </tr>
      <tr>
        <th>Username</th>
        <td>#rc.bugDetail.getusername()#</td>
      </tr>
      <tr>
        <th>System Version</th>
        <td>#rc.bugDetail.getversion()#</td>
      </tr>
      <tr>
        <th>Url Parameters</th>
        <td><cfdump var="#DeSerializeJSON(rc.bugDetail.geturlVars())#"></td>
      </tr>
      <tr>
        <th>Form Parameters</th>
        <td><cfdump var="#DeSerializeJSON(rc.bugDetail.getformVars())#"></td>
      </tr>
    </table>
    </cfoutput>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
</cfif>
</div>
<cfif NOT rc.isAjax>
    </body>
  </html>

</cfif>