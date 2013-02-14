<cfscript>
  component {
  // Module Properties
  this.title      = "flow";
  this.author       = "Tom Miller";
  this.webURL       = "http://www.ebizuk.net";
  this.description    = "";
  this.version      = "1.0";
  // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
  this.viewParentLookup   = true;
  // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
  this.layoutParentLookup = true;
  this.entryPoint = "flo:general.index";
  this.handlerParentLookup = true;

function configure(){

  // parent settings
  parentSettings = {
    woot = "Module set it!"
  };

  // module settings - stored in the main configuration settings struct as modules.{moduleName}.settings
  settings = {
    display = "core",
    enableQuotes = true,
    parentSystem = "BMnet",
    parentOb = "eunify",
    securityGroups = ""
  };

  // datasources
  datasources = {
    flo   = {name="flow"}
  };

  // web services
  webservices = {
    //google = "http://news.google.com/news?pz=1&cf=all&ned=us&hl=en&topic=h&num=3&output=rss"
  };
// Module Conventions
  conventions = {
    handlersLocation = "handlers",
    viewsLocation = "views",
    layoutsLocation = "layouts",
    pluginsLocation = "plugins",
    modelsLocation = "model"
  };
  // SES Routes
  routes = [
		{pattern="/:handler/:action?"},
		{pattern="/",handler="general",action="index"}


  ];

  // Interceptor Config
  interceptorSettings = {
    customInterceptionPoints = "onModuleError"
  };
  interceptors = [];
}
}
</cfscript>