 /**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :  Luis Majano
Date        : 10/16/2007
Description :
  This is the Application.cfc for usage withing the ColdBox Framework
*/
component{
  // Application properties
  appName = Replace(cgi.HTTP_HOST,".","","ALL");
  this.name = appName;
  this.sessionManagement = true;
  
  this.setClientCookies = false;
  
  this.loginstorage = "cookie";
  this.cache.resource = "ramcache";
  this.cache.query = "#appName#";
  if (StructKeyExists(cookie, "cfid")) {
    //this.sessionstorage = '#appName#';
    //this.sessioncluster = true;
    this.sessiontimeout = CreateTimeSpan(0,0,30,0);
  } else {
    this.sessiontimeout = CreateTimeSpan(0,0,2,0);
  }


  // Mappings Imports
  import coldbox.system.*;
  // ColdBox Specifics
  COLDBOX_APP_ROOT_PATH   = getDirectoryFromPath( getCurrentTemplatePath() );
  COLDBOX_APP_MAPPING   = "/bmnet";
  COLDBOX_CONFIG_FILE   = "";
  COLDBOX_APP_KEY     = "";

  public boolean function onApplicationStart(){
    application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
    application.cbBootstrap.loadColdbox();
    return true;
  }

  public boolean function onRequestStart(String targetPage){

    // ORM Reload: REMOVE IN PRODUCTION IF NEEDED
    if( structKeyExists(url,"ormReload") ){ ormReload(); }

    // Bootstrap Reinit
    if( not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit() ){
      lock name="coldbox.bootstrap_#this.name#" type="exclusive" timeout="5" throwonTimeout=true{
        structDelete(application,"cbBootStrap");
        application.cbBootstrap = new ColdBox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
      }
    }

    // ColdBox Reload Checks
    application.cbBootStrap.reloadChecks();

    //Process a ColdBox request only
    if( findNoCase('index.cfm',listLast(arguments.targetPage,"/")) ){
      application.cbBootStrap.processColdBoxRequest();
    }

    return true;
  }

  public void function onSessionStart(){
    application.cbBootStrap.onSessionStart();
  }

  public void function onSessionEnd(struct sessionScope, struct appScope){
    arguments.appScope.cbBootStrap.onSessionEnd(argumentCollection=arguments);
  }

  public boolean function onMissingTemplate(template){
    return application.cbBootstrap.onMissingTemplate(argumentCollection=arguments);
  }
}
