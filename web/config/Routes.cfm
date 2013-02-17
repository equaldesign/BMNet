<cfscript>
  // General Properties
  setEnabled(true);
  setUniqueURLS(false);
  //setAutoReload(false);
 setExtensionDetection( true );
  // Base URL
  setBaseURL("/");

  addRoute(pattern="/webinar",handler="eunify:calendar",action="register",id=5);

  addModuleRoutes(pattern="/bv",module="bv");
  addModuleRoutes(pattern="/mxtra",module="mxtra");
  addModuleRoutes(pattern="/eunify",module="eunify");
  addModuleRoutes(pattern="/sums",module="sums");
  addModuleRoutes(pattern="/eGroup",module="eGroup");
  addModuleRoutes(pattern="/bugs",module="bugs");
  addModuleRoutes(pattern="/flo",module="flo");  
  addRoute(pattern="/html",handler="sums:page",action="index");
  addRoute(pattern="/site/:siteID",handler="bv:site",action="detail");
  addRoute(pattern="/sites/:siteID",handler="bv:site",action="detail");
  addRoute(pattern="/sites",handler="bv:site",action="list");
  addRoute(pattern="/api/i",handler="bv:api",action="productImage");  
  addRoute(pattern="/api/gt",handler="bv:api",action="gt"); 
  addRoute(pattern="/products/:action?",handler="bv:products");
  addRoute(pattern="/documents/:action?",handler="bv:documents"); 
  addRoute(pattern="/blog/:action?",handler="bv:blog");
  addRoute(pattern="/promotions/:action?",handler="bv:promotions");
  addRoute(pattern="/api/viewItem",handler="bv:api",action="viewItem");
  addRoute(pattern="/api/productImage",handler="bv:api",action="productImage");
  addRoute(pattern="/api/getAssociatedDocuments",handler="bv:api",action="getAssociatedDocuments");
  addRoute(pattern="/api/getProductMeta",handler="bv:api",action="getProductMeta");
  addRoute(pattern="/api/products/download",handler="bv:products",action="download");
  addRoute(pattern="/api/products/feed",handler="bv:products",action="feed");
  addRoute(pattern="/api/activity",handler="eunify:api",action="activity");
  addRoute(pattern="/auto/index",handler="bugs:auto",action="index");  
  addRoute(pattern="/api/contact",handler="eunify:api",action="contact");
  addRoute(pattern="/api/getUser",handler="eunify:api",action="getUser");

  addRoute(pattern="/api/contactList",handler="eunify:api",action="contactList");

  addRoute(pattern="/media", handler="sums:media",action="index");
  addRoute(pattern="/rd", handler="marketing:email.campaign",action="clickthrough");
  addRoute(pattern="/mcv/:campaignID/:templateID/:contactID?", handler="marketing:email.template",action="getTemplate");
  addRoute(pattern="/mus/:contactID/:campaignID", handler="marketing:email.recipient",action="unsubscribe");

  addRoute(pattern=":handler/:action?");


</cfscript>