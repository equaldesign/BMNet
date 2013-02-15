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
- cacheBox (struct)
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
			appName 				= "eBiz Help System",
			eventName 				= "event",

			//Development Settings
			debugMode				= false,
			debugPassword			= "bugg3rm33",
			reinitPassword			= "bugg3rm33",
			handlersIndexAutoReload = true,
			configAutoReload		= false,

			//Implicit Events
			defaultEvent			= "bugs.index",
			requestStartHandler		= "main.onRequestStart",
			requestEndHandler		= "",
			applicationStartHandler = "main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "main.onSessionStart",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Extension Points
			UDFLibraryFile 				= "includes/helpers/ApplicationHelper.cfm",
			coldboxExtensionsLocation 	= "",
			modulesExternalLocation		= [],
			pluginsExternalLocation 	= "",
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",

			//Error/Exception Handling
			exceptionHandler		= "",
			onInvalidEvent			= "",
			customErrorTemplate		= "",

			//Application Aspects
			handlerCaching 			= false,
			eventCaching			= false,
			proxyReturnCollection 	= false,
			flashURLPersistScope	= "session"
		};

		// custom settings
		settings = {
        CookieStorage_encryption = true,
        siteName = "Help",
        version = "1.0a",
        bugsystem="",
        jsmin_cacheLocation = "/includes/cache",
        jsmin_cacheLocalLocation = "/includes/cache",
        jsmin_includeLocation  = "/includes/cache",
        PagingMaxRows = 10,
        PagingBandGap = 4
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			//development = "^cf8.,^railo."
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
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

    cacheBox = {
        scopeRegistration = {
            enabled = true,
            scope   = "application",
            key   = "BugscacheBox"
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
            provider = "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
            properties = {
              objectDefaultTimeout = 120,
              objectDefaultLastAccessTimeout = 30,
              useLastAccessTimeouts = true,
              freeMemoryPercentageThreshold = 0,
              reapFrequency = 2,
              evictionPolicy = "LRU",
              evictCount = 2,
              maxObjects = 300,
              objectStore = "MemcachedStore",
              servers = "46.51.188.170:11211",
              defaultTimeout = "100",
              defaultUnit="MILLISECONDS"
            }
          },
          UserStorage = {
            provider = "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
            properties = {
              objectDefaultTimeout = 120,
              objectDefaultLastAccessTimeout = 30,
              useLastAccessTimeouts = true,
              freeMemoryPercentageThreshold = 0,
              reapFrequency = 2,
              evictionPolicy = "LRU",
              evictCount = 2,
              maxObjects = 300,
              objectStore = "MemcachedStore",
              servers = "46.51.188.170:11211",
              defaultTimeout = "100",
              defaultUnit="MILLISECONDS"
            }
          }
        }
      };

		//Layout Settings
		layoutSettings = {
			defaultLayout = "Layout.Main.cfm",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptors = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [
        ///SES
        {
          class="interceptors.Deploy",
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
          debugMode = false,
          rulesFile="/config/Rules.xml.cfm",
          preEventSecurity=true
         }
        },
        {class="interceptors.bugs"
        }
      ];


		/*
		//Register Layouts
		layouts = [
			{ name = "login",
		 	  file = "Layout.tester.cfm",
			  views = "vwLogin,test",
			  folders = "tags,pdf/single"
			}
		];

		//Model Integration
		models = {
			objectCaching = true,
			definitionFile = "config/modelMappings.cfm",
			externalLocation = "coldbox.testing.testmodel",
			SetterInjection = false,
			DICompleteUDF = "onDIComplete",
			StopRecursion = "",
			parentFactory 	= {
				framework = "coldspring",
				definitionFile = "config/parent.xml.cfm"
			}
		};

		//Conventions
		conventions = {
			handlersLocation = "handlers",
			pluginsLocation  = "plugins",
			viewsLocation 	 = "views",
			layoutsLocation  = "layouts",
			modelsLocation 	 = "model",
			modulesExternalLocation  = "",
			eventAction 	 = "index"
		};

		//IOC Integration
		ioc = {
			framework 		= "lightwire",
			reload 	  	  	= true,
			objectCaching 	= false,
			definitionFile  = "config/coldspring.xml.cfm",
			parentFactory 	= {
				framework = "coldspring",
				definitionFile = "config/parent.xml.cfm"
			}
		};

		//Debugger Settings
		debugger = {
			enableDumpVar = false,
			persistentRequestProfilers = true,
			maxPersistentRequestProfilers = 10,
			maxRCPanelQueryRows = 50,
			//Panels
			showTracerPanel = true,
			expandedTracerPanel = true,
			showInfoPanel = true,
			expandedInfoPanel = true,
			showCachePanel = true,
			expandedCachePanel = true,
			showRCPanel = true,
			expandedRCPanel = true,
			showModulesPanel = true,
			expandedModulesPanel = false
		};

		//Mailsettings
		mailSettings = {
			server = "",
			username = "",
			password = "",
			port = 25
		};

		//i18n & Localization
		i18n = {
			defaultResourceBundle = "includes/i18n/main",
			defaultLocale = "en_US",
			localeStorage = "session",
			unknownTranslation = "**NOT FOUND**"
		};

		//bug tracers
		bugTracers = {
			enabled = false,
			bugEmails = "",
			mailFrom = "",
			customEmailBugReport = ""
		};

		//webservices
		webservices = {
			testWS = "http://www.test.com/test.cfc?wsdl",
			AnotherTestWS = "http://www.coldbox.org/distribution/updatews.cfc?wsdl"
		};
		*/
		//Datasources
		datasources = {
      bugs   = {name="bugs"}
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