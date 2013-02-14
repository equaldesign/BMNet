<cfscript>
  component {
  // Module Properties
  this.title      = "mxtra";
  this.author       = "Tom Miller";
  this.webURL       = "http://www.ebizuk.net";
  this.description    = "";
  this.version      = "1.0";
  // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
  this.viewParentLookup   = true;
  // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
  this.layoutParentLookup = true;
  this.entryPoint = "mxtra";
  this.handlerParentLookup = false;

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
  // SES Routes
  routes = [
    {pattern="/shop/category/index",handler="shop.category",action="index"},
    {pattern="/shop/category/:slug?",handler="shop.category",action="index"},
    {pattern="/shop/category",handler="shop.category",action="index"},
    {pattern="/shop/basket/:action?",handler="shop.basket"},
    {pattern="/shop/search/jsonsearch",handler="shop.search",action="jsonsearch"},
    {pattern="/shop/search",handler="shop.search"},
    {pattern="/shop/quote/:action?",handler="shop.quote"},
    {pattern="/shop/product/specials",handler="shop.product",action="specials"},
    {pattern="/shop/product/search",handler="shop.product",action="search"},
    {pattern="/shop/product/clearance",handler="shop.product",action="clearance"},
    {pattern="/shop/product/:slug?",handler="shop.product",action="index"},
    {pattern="/shop/checkout/:action?",handler="shop.checkout"},
    {pattern="/account/main/:action",handler="account.main"},
    {pattern="/admin/orders/:action",handler="admin.orders"},
    {pattern="/dataImport",handler="shop.product",action="dataDump"},
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