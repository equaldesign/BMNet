component
  name="jQueryService"
  output="true"
  cache="true"
  cacheTimeOut="30"

  {
    property name="version" inject="coldbox:setting:version";
    public any function init() {
      return this;
    }

    public void function getDepends(required string plugins="",required string scripts="",required string stylesheets="",required boolean obeyModule=true,required string module="") output="true" {
    var event = controller.getRequestService().getContext();
    var rc = event.getCollection();
    var m = event.getCurrentModule();

    if (arguments.module eq "" AND event.getCurrentModule() neq "" AND arguments.obeyModule) {
      srcPath = "/modules/#event.getCurrentModule()#/includes/";
    } else if (arguments.module neq ""){
      srcPath = "/modules/#arguments.module#/includes/";
    } else {
      srcPath = "/includes/";
    }


      for (i=1;i lte ListLen(plugins);i++) { // loop through the scripts list
        p = ListGetAt(plugins,i);
        WriteOutput("<script language='javascript' type='text/javascript' src='/includes/javascript/jQuery/jQuery.#p#.js'></script>");
      }
      for (i=1;i lte ListLen(scripts);i++) { // do the same for custom scripts (if any)
        s = ListGetAt(scripts,i);
       //getPlugin("JSMin2").minifyToHead("#srcPath#javascript/#s#.js",false,false);
       WriteOutput("<script language='javascript' type='text/javascript' src='#srcPath#/javascript/#s#.js'></script>");
      }
      stylesheetList = "";
      WriteOutput('<style type="text/css">');
      for (i=1;i lte ListLen(stylesheets);i++) { // do the same for custom scripts (if any)
        c = ListGetAt(stylesheets,i);
        //getPlugin("JSMin2").minifyToHead("#srcPath#style/#c#.css",false,false);
        WriteOutput('@import url("#srcPath#/style/#trim(c)#.css");#Chr(13)##Chr(10)#');
      }
      WriteOutput('</style>');
    }
  }