<cfscript>
  component {
  // Module Properties
  this.title      = "poll";
  this.author       = "Tom Miller";
  this.webURL       = "http://www.ebizuk.net";
  this.description    = "";
  this.version      = "1.0";
  // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
  this.viewParentLookup   = true;
  // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
  this.layoutParentLookup = true;
  // If true, looks for handlers in the parent first, if not found, then in the module. Lese vice-versa
  this.handlerParentLookup = true;
  // If true, looks for modles in the parent first, if not found, then in the module. Lese vice-versa
  this.modelParentLookup = true;

  this.entryPoint = "poll:index";


function configure(){

  // parent settings
  parentSettings = {
    woot = "Module set it!"
  };

  // module settings - stored in the main configuration settings struct as modules.{moduleName}.settings
  settings = {
    display = "core",
    enableQuotes = true
  };

  // datasources
  datasources = {
    //mysite   = {name="mySite", dbType="mysql", username="root", password="root"}
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
    // Interceptor Config
  interceptorSettings = {
    customInterceptionPoints = "onModuleError"
  };
  interceptors = [];
  routes = [
      {pattern="/page",handler="page",action="index"},
      {pattern="/link",handler="page",action="index"},
      {pattern="/:handler/:action?"},

      {pattern="/",handler="page",action="index"}
    ];
}
}
</cfscript>