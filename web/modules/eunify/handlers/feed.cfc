<cfcomponent name="general" cache="true" output="false"  autowire="true">

  <cfproperty name="feed" inject="id:eunify.FeedService">
  <cfproperty name="ContactService" inject="id:eunify.ContactService">
  <cfproperty name="CookieStorage" cache="true" cacheTimeout="30" inject="coldbox:plugin:cookiestorage">

  <cfproperty name="dsn" inject="coldbox:datasource:eGroup" />


  <cffunction name="index" cache="true">
    <cfargument name="event">

    <cfscript>
    var rc = arguments.event.getCollection();
    rc.boundaries = getMyPlugin("Paging").getBoundaries(15);
    rc.filter = paramValue("rc.sess.eGroup.newsfilter","");
    rc.page = arguments.event.getValue("page",1);
    rc.searchOn = arguments.event.getValue("searchOn","");
    rc.searchID = arguments.event.getValue("searchID","");
    rc.force = arguments.event.getValue("force",false);
    rc.linkCats = "1,2,3,10";
    rc.fullDescCats = "3,10";
    rc.filter = ContactService.getContact(rc.sess.BMNet.contactID).feedFilter;
    rc.feedCount = feed.getFeedCount(rc.filter,rc.searchOn,rc.searchID);
    rc.feed = feed.getFeed(sRow=rc.boundaries.startRow,mxRows=rc.boundaries.maxrow,filter=rc.filter,searchOn=rc.searchOn,searchID=rc.searchID);
    arguments.event.setView(name='feed/index');


    </cfscript>
  </cffunction>

  <cffunction name="indexNew">
    <cfargument name="event">

    <cfscript>
    var rc = arguments.event.getCollection();
    rc.boundaries = getMyPlugin("Paging").getBoundaries(15);
    rc.filter = arguments.event.getValue('filter',0);
    rc.linkCats = "1,2,3,10";
    rc.fullDescCats = "3,10";
    rc.datasource = dsn.getName();
    if (rc.filter neq 0) {
      rc.sess.eGroup.newsFilter = filter;
      getPlugin("CookieStorage").setVar("newsFilter",rc.filter);
    }


    rc.feedcache = feed.getCacheFeed(rc.boundaries.startRow,rc.boundaries.maxrow);
    if (rc.feedcache.recordCount eq 0) {
      rc.feed = feed.getFeed(rc.boundaries.startRow,rc.boundaries.maxrow);
      arguments.event.setView('feed/index');
    } else {
      arguments.event.setView('feed/cache');
    }
    arguments.event.setLayout("Layout.Main.Promos");

    </cfscript>
  </cffunction>

  <cffunction name="filter">
    <cfargument name="event">

    <cfscript>
    var rc = arguments.event.getCollection();
    rc.categories = feed.getCategories();
    arguments.event.setView('feed/filter');
    </cfscript>
  </cffunction>

	  <cffunction name="external">
    <cfargument name="event">

    <cfscript>
  var rc = arguments.event.getCollection();
    rc.boundaries = getMyPlugin("Paging").getBoundaries();
    rc.feed = feed.getExternalFeeds(startRow=rc.boundaries.startRow-1,maxRows=rc.boundaries.maxrow);
    rc.feedCount = rc.feed.count;
    rc.feedQ = rc.feed.feed;
    arguments.event.setView('feed/external');
    </cfscript>
  </cffunction>

  <cffunction name="doFilter">
    <cfargument name="event">

    <cfscript>
    var rc = arguments.event.getCollection();
		rc.favourites = arguments.event.getValue("favourites","");
		rc.filtercat = arguments.event.getValue("filterCat","");
		if (rc.favourites neq "") {
		  CookieStorage.setVar("showFavouritesOnly",true);
			rc.sess.eGroup.showFavouritesOnly = true;
		} else {
		  CookieStorage.setVar("showFavouritesOnly",false);
			rc.sess.eGroup.showFavouritesOnly = false;
		}
		if (rc.filtercat neq "") {
		  CookieStorage.setVar("filter",rc.filtercat);
		  rc.user = user.GetUser(rc.sess.eGroup.contactID);
		  user.setfeedFilter(rc.filtercat);
			rc.sess.BMNet.newsfilter = rc.filtercat;
		}
    runEvent("feed.index");
    </cfscript>
  </cffunction>
</cfcomponent>