<html>
<head>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
<cfset getMyPlugin(plugin="jQuery").getDepends("cookie,block,bbq,address,hoverIntent,json,ckeditor,jstree","admin","form,admin,tree/style",false,"sums")>
</head>
<body>
  <div id="dialog">
  <cfoutput>#renderView()#</cfoutput>
</div>
</body>
</html>