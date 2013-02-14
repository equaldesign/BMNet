<cfscript>
  component {
  // Module Properties
  this.title      = "Marketing";
  this.author       = "Tom Miller";
  this.webURL       = "http://www.ebizuk.net";
  this.description    = "";
  this.version      = "1.0";
  // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
  this.viewParentLookup   = true;
  // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
  this.layoutParentLookup = true;
  this.entryPoint = "marketing:general.index";
  this.handlerParentLookup = false;
  

  function configure(){

    // parent settings
    parentSettings = {
      woot = "Module set it!"
    };

    // module settings - stored in the main configuration settings struct as modules.{moduleName}.settings
    settings = {
      display = "core",
      javaloader_libpath = "/fs/sites/ebiz/resources/java",
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