	<cfcomponent output="false" hint="My App Configuration">
	<cfscript>
	/**
	structures/arrays to create for configuration

	- coldbox (struct)
	- settings (struct)
	- conventions (struct)
	- environments (struct)
	- ioc (struct)
	- models (struct)
	- debugger (struct)
	- mailSettings (struct)
	- i18n (struct)
	- bugTracers (struct)
	- webservices (struct)
	- datasources (struct)
	- layoutSettings (struct)
	- layouts (array of structs)
	- cacheEngine (struct)
	- interceptorSettings (struct)
	- interceptors (array of structs)
	- modules (struct)
	- logBox (struct)

	Available objects in variable scope
	- controller
	- logBoxConfig
	- appMapping (auto calculated by ColdBox)

	Required Methods
	- configure() : The method ColdBox calls to configure the application.
	Optional Methods
	- detectEnvironment() : If declared the framework will call it and it must return the name of the environment you are on.
	- {environment}() : The name of the environment found and called by the framework.

	*/

	  // Configure ColdBox Application
	  function configure(){

	    // coldbox directives
	    coldbox = {
	      //Application Setup
	      appName         = "#replaceNoCase(cgi.http_host,'.','','ALL')#",
	      eventName         = "event",

	      //Development Settings
	      debugMode       = false,
	      debugPassword     = "bugg3rm33",
	      reinitPassword      = "bugg3rm33",
	      handlersIndexAutoReload = false,
	      configAutoReload    = false,

	      //Implicit Events
	      defaultEvent      = "sums:page.index",
	      requestStartHandler   = "main.onRequestStart",
	      requestEndHandler   = "main.onRequestEnd",
	      applicationStartHandler = "main.onAppInit",
	      applicationEndHandler = "",
	      sessionStartHandler   = "main.onSessionStart",
	      sessionEndHandler   = "main.onSessionEnd",

	      //Extension Points
	      UDFLibraryFile      = "/includes/helpers/ApplicationHelper.cfm",
	      coldboxExtensionsLocation = "",
	      modulesExternalLocation     = "",
	      pluginsExternalLocation = "plugins",
	      viewsExternalLocation = "views",
	      layoutsExternalLocation = "layouts",
	      handlersExternalLocation  = "bmnet/handlers", 
	      requestContextDecorator = "",

          //Error/Exception Handling
        exceptionHandler    = "main.onException",
        onInvalidEvent      = "main.onInvalidEvent",
        customErrorTemplate   = "views/error.cfm", 

	      //Application Aspects
	      handlerCaching      = true,
	      eventCaching      = false, 
	      proxyReturnCollection   = false,
        flash = {
          scope = "session",
          properties = {}, // constructor properties for the flash scope implementation
          inflateToRC = true, // automatically inflate flash data into the RC scope
          inflateToPRC = false, // automatically inflate flash data into the PRC scope
          autoPurge = true, // automatically purge flash data for you
          autoSave = true // automatically save flash scopes at end of a request and on relocations.
        }
	    };

	    // custom settings
	    settings = {
      javaloader_libpath = "/fs/sites/ebiz/resources/java",
        bugsystem = "BMNet",
        version = "1.4",
      ignoreURLS = [
        "contact.currentUsers",
        "contact.recentlyViewed",
        "wiki.tree",
        "calendar.index",
        "favourites.tree",
        "psa.menu",
        "documents.tree"
        ],
      CookieStorage_encryption = true,
      siteName = "cemco",
      rootGroupCategory = 91,
      documentDefaults = {
          deals = [
            {
              name="Prices",
              permission="view"
            },
            {
              name="Documents",
              permission="rebates"
            },
            {
              name="Correspondence",
              permission="view"
            }
          ]
        },
      platform = "CF9",
      bvAddress = "46.51.188.170",
      defaultHomePage = "blog",
      remoteDatasource = "",
      emailAdministrator = false,
      groupDMSRoot = 2229,
      siteAdministratorEmail = "",
      siteAdministrator = "bob",
      bugsystem="buildersmerchant",
      emailTitle = "speng",
      defaultPSA = 2254,
      siteID = 1,
      siteTitle = "CEMCO Merchant Network",
      groupName = "CEMCO",
      siteRoot = "/fs/sites/cemco/cemco.dev.ebiz.co.uk",
      jsmin_cacheLocation = "/cache/cemco",
      securityGroupIDs = "3,4,89,2,1",
      PagingMaxRows = 10,
      PagingBandGap = 2,
      securityGroups = {
        group  = [
          {
            name = "admin",
            id = 3
          },
          {
            name = "edit",
            id = 4
          },
          {
            name = "figures",
            id = 89
          },
          {
            name = "rebates",
            id = 2
          },
          {
            name = "view",
            id = 1
          }
        ],
        members = [
          {
            name = "member_admin",
            id = 6
          },
          {
            name = "member_edit",
            id = 5
          },
          {
            name = "member_viewrebate",
            id = 7
          },
          {
            name = "memberview",
            id = 54
          }
        ],
        suppliers = [
          {
            name = "supplieradmin",
            id = 95
          },
          {
            name = "FiguresEntry",
            id = 90
          }
        ]
      }

	    };

	    // environment settings, create a detectEnvironment() method to detect it yourself.
	    // create a function with the name of the environment so it can be executed if that environment is detected
	    // the value of the environment is a list of regex patterns to match the cgi.http_host.
	    environments = {
	      // development = "^cf8.,^railo."
	    };

	    // Module Directives
	    modules = {
	      //Turn to false in production
	      autoReload = false,
	      // An array of modules names to load, empty means all of them
	      include = [],
	      // An array of modules names to NOT load, empty means none
	      exclude = []
	    };

  	   //LogBox DSL


      //Layout Settings
      layoutSettings = {
        defaultLayout = "Layout.Main.cfm"
      };

      //WireBox Integration
      wireBox = {
        enabled = true,
        //binder="config.WireBox",
        singletonReload=true
      };

      //Interceptor Settings
      interceptorSettings = {
        throwOnInvalidStates = false,
        customInterceptionPoints = ""
      };


	    //Register interceptors as an array, we need order
	    interceptors = [
	      //SES
	      {
          class="bmnet.interceptors.Deploy",
          properties={
            tagFile = "config/_deploy.tag"
          }
        },
        {class="coldbox.system.interceptors.SES",
         properties={
         	configFile="/config/Routes.cfm",
         	debugMode=false
         }
        },
        {class="coldbox.system.interceptors.Security",
         properties={
          rulesSource = "xml",
          debugMode = true,
          rulesFile="/config/Rules.xml.cfm",
          preEventSecurity=true
         }
        },
	      {class="coldbox.system.interceptors.Autowire",
	       properties={
	       	debugMode = true,
	       	completeDIMethodName = "onDIComplete",
	       	enableSetterInjection = false,
	       	StopRecursion = "model.groups"
	       }
	      },
        //Security
        {class="bmnet.interceptors.eGroupCache",
         properties={}
        },
        {class="bmnet.interceptors.formCollection",
         properties={}
        }
	    ];
      //LogBox DSL
      logBox = {
        // Define Appenders
        appenders = {
          coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" },
          files = {
            class="coldbox.system.logging.appenders.FileAppender",
            properties= {
              filePath="logs",
              levelMin=0,
              levelMax=4,
              fileName=coldbox.AppName
            }
          }
        },
        // Root Logger
        root = {levelMin="FATAL", levelMax="DEBUG", appenders="*"},
        // Implicit Level Categories
        info = [ "coldbox.system" ],
        debug  = ["coldbox.system.web","coldbox.system.cache"]
      };
      cacheBox = {
        scopeRegistration = {
            enabled = true,
            scope   = "application",
            key   = "TurnbullacheBox"
        },
        defaultCache = {
          objectDefaultTimeout = 120, //two hours default
          objectDefaultLastAccessTimeout = 30, //30 minutes idle time
          useLastAccessTimeouts = true,
          reapFrequency = 2,
          freeMemoryPercentageThreshold = 0,
          evictionPolicy = "LRU",
          evictCount = 1,
          maxObjects = 300,
          objectStore = "ConcurrentStore", //guaranteed objects
          coldboxEnabled = true
        },

        caches = {
          template = {
            provider = "coldbox.system.cache.providers.RailoColdBoxProvider",
            properties = {
              cacheName="#coldbox.appName#"
            }
          },
          services = {
            provider = "coldbox.system.cache.providers.RailoColdBoxProvider",
            properties = {
              cacheName="services"
            }
          },
          UserStorage = {
            provider = "coldbox.system.cache.providers.RailoColdBoxProvider",
            properties = {
              cacheName="#coldbox.appName#"
            }
          }
        }
      };

	    //Debugger Settings
	    debugger = {
        showRCPanel = true
      };

      conventions = {
        handlersLocation = "custom/#coldbox.appName#/handlers",
        pluginsLocation  = "plugins",
        viewsLocation    = "custom/#coldbox.appName#/views",
        layoutsLocation  = "custom/#coldbox.appName#/layouts",
        modelsLocation   = "model",
        modulesLocation  = "modules",
        eventAction    = "index"
      };

	    //Datasources
	    datasources = {
	      eGroup   = {name="eGroup_cemco"},
	      eGroupRead = {name="eGroup_cemco"},
        easyRec = {name="easyRec"},
	      bugs = {name="bugs"},
	      BMNet = {name="BMnet"},
	      BMNetRead = {name="BMnet"}
	    };
	    mailSettings = {
        server = "email-smtp.us-east-1.amazonaws.com",
        username = "AKIAI3EY3YSOVJF37TRA",
        defaultType="HTML",
        password = "AsBr0dGv8iX6TJf0RPnihRzMhtw42VAeRWu/9rpuToD7",
        port = 25
      };

	  }
	</cfscript>
</cfcomponent>