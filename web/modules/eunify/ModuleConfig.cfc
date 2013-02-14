<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Description :
	Relax Module Configuration
----------------------------------------------------------------------->
<cfcomponent output="false" hint="Relaxed Configuration">
<cfscript>
	// Module Properties
	this.title 				= "eunify";
	this.author 			= "Tom Miller";
	this.webURL 			= "http://eunity.co.uk";
	this.description 		= "eUnify Module";
	this.version			= "1.4";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "eunify:dashboard";
  this.handlerParentLookup = false;
	function configure(){

		// Relax Configuration Settings
		settings = {
			securityGroups = {
          group  = [
            {
              name = "admin",
              id = 1
            },
            {
              name = "edit",
              id = 2
            },
            {
              name = "figures",
              id = 3
            },
            {
              name = "rebates",
              id = 4
            },
            {
              name = "view",
              id = 5
            }
          ],
          members = [
            {
              name = "member_admin",
              id = 6
            },
            {
              name = "member_edit",
              id = 7
            },
            {
              name = "member_viewrebate",
              id = 8
            },
            {
              name = "memberview",
              id = 9
            }
          ],
          suppliers = [
            {
              name = "supplieradmin",
              id = 10
            },
            {
              name = "FiguresEntry",
              id = 11
            }
          ]
        }
		};
		// Layout Settings
		layoutSettings = { defaultLayout = "Layout.Main.cfm" };
		// SES Routes
		routes = [
      {pattern="/:handler/:action?"},
      {pattern="/",handler="general",action="index"}
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}
</cfscript>
</cfcomponent>