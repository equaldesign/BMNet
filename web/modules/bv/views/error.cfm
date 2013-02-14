<cfset httpData = getHTTPRequestData()>
<cfset isAjax = structKeyExists(httpData.headers, 'X-Requested-With') && httpData.headers['X-Requested-With'] eq 'XMLHttpRequest'>

<cfset exceptionBean = event.getValue("ExceptionBean") />
<link rel="stylesheet" href="/includes/style/main.css">
<div class="blueBox">
<img align="left" src="/includes/images/404/face-embarrassed.png" hspace="10"><h1>Oh dear</h1>
<h2>This is embarrassing.</h2>
<p>It seems something has gone wrong somewhere. You can try again, but if the error occurs again, it's probably best to stop trying for now.</p>
<p>A ticket has been created in the bugs system, which you can follow and track the status of if you wish.</p>
<p>Alternatively, if this error occurrs repeatedly, trying emailing <a href="mailto:support@ebizuk.net">support@ebizuk.net</a></p>
</div>
