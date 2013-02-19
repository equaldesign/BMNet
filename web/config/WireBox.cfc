<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	 :	Luis Majano
Description :
	Your WireBox Configuration Binder
----------------------------------------------------------------------->
<cfcomponent output="false" hint="The default WireBox Injector configuration object" extends="coldbox.system.ioc.config.Binder">
<cfscript>

	/**
	* Configure WireBox, that's it!
	*/
	function configure(){

		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			},

			// DSL Namespace registrations
			customDSL = {
				// namespace = "mapping name"
			},

			// Custom Storage Scopes
			customScopes = {
				// annotationName = "mapping name"
			},

			// Package scan locations
      scanLocations = ["devbmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.modules.mxtra","devbmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.modules.sums","devbmnet.model","devbmnet.modules"],

			// Stop Recursions
			stopRecursions = ["model.groups","modules.eGroup.model.groups"],

			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",

			// Register all event listeners here, they are created in the specified order
			listeners = [
				// { class="", name="", properties={} }
			]
		};

		// Map Bindings below#

    // map("eunify.securitygroups").toDSL("coldbox:setting:securityGroups@eunify");


    map("eunify.GroupsService").to("devbmnet.modules.eunify.model.GroupsService").inCacheBox(timeout=40,lastAccessTimeout=20,provider="template").asEagerInit();

    map("mxtra.basket").to("devbmnet.modules.mxtra.model.basket"); 
    map("mxtra.account").to("devbmnet.modules.mxtra.model.account");
    map("mxtra.category").to("devbmnet.modules.mxtra.model.category");
    map("mxtra.products").to("devbmnet.modules.mxtra.model.products");
    map("mxtra.quote").to("devbmnet.modules.mxtra.model.quote");
    map("mxtra.orders").to("devbmnet.modules.mxtra.model.orders");
    map("mxtra.checkout").to("devbmnet.modules.mxtra.model.checkout");
    map("eunify.ProductService").to("devbmnet.modules.eunify.model.ProductService");
    map("eunify.FeedService").to("devbmnet.modules.eunify.model.FeedService");
    map("eunify.UserService").to("devbmnet.modules.eunify.model.UserService");
    map("eunify.FavouritesService").to("devbmnet.modules.eunify.model.FavouritesService");
    map("eunify.FiguresService").to("devbmnet.modules.eunify.model.FiguresService");
    map("eunify.EmailService").to("devbmnet.modules.eunify.model.EmailService");
    map("eunify.PSAService").to("devbmnet.modules.eunify.model.PSAService");
    map("eunify.SiteService").to("devbmnet.modules.eunify.model.SiteService");
    map("eunify.BranchService").to("devbmnet.modules.eunify.model.BranchService");
    map("eunify.CommentService").to("devbmnet.modules.eunify.model.CommentService");
    map("eunify.DocumentService").to("devbmnet.modules.eunify.model.DocumentService");
    map("eunify.CalendarService").to("devbmnet.modules.eunify.model.CalendarService");
    map("eunify.InvoiceService").to("devbmnet.modules.eunify.model.InvoiceService");
    map("eunify.PromotionsService").to("devbmnet.modules.eunify.model.PromotionsService");
    map("eunify.CompanyService").to("devbmnet.modules.eunify.model.CompanyService");
    map("eunify.ImportService").to("devbmnet.modules.eunify.model.ImportService");
    map("eunify.RecommendationService").to("devbmnet.modules.eunify.model.RecommendationService");
    map("eunify.SalesService").to("devbmnet.modules.eunify.model.SalesService");
    map("eunify.EcommerceService").to("devbmnet.modules.eunify.model.EcommerceService");
    map("eunify.ContactService").to("devbmnet.modules.eunify.model.ContactService");
    map("eunify.SubscriptionService").to("devbmnet.modules.eunify.model.SubscriptionService");
    map("eunify.geoService").to("devbmnet.modules.eunify.model.geoService");

    map("sums.PageService").to("devbmnet.modules.sums.model.PageService");
    map("eunify.TagService").to("devbmnet.modules.eunify.model.TagService");

    map("quote.QuoteService").to("devbmnet.modules.quote.model.QuoteService");

    map("poll.PollService").to("devbmnet.modules.poll.model.PollService");
    map("poll.formbuilder").to("devbmnet.modules.poll.model.formbuilder");

    map("bv.UserService").to("devbmnet.modules.bv.model.UserService");
    map("bv.WikiService").to("devbmnet.modules.bv.model.WikiService");
    map("bv.EmailService").to("devbmnet.modules.bv.model.EmailService");
    map("bv.BlogService").to("devbmnet.modules.bv.model.BlogService");
    map("bv.FeedService").to("devbmnet.modules.bv.model.FeedService");
    map("bv.SiteService").to("devbmnet.modules.bv.model.SiteService");
    map("bv.ProductService").to("devbmnet.modules.bv.model.ProductService");
    map("bv.TagService").to("devbmnet.modules.bv.model.TagService");
    map("bv.PromotionService").to("devbmnet.modules.bv.model.PromotionService");
    map("bv.RatingService").to("devbmnet.modules.bv.model.RatingService");
    map("bv.DocumentService").to("devbmnet.modules.bv.model.DocumentService");
    map("bv.StockistService").to("devbmnet.modules.bv.model.StockistService");
    map("bv.CommentService").to("devbmnet.modules.bv.model.CommentService");
    map("bv.ReportService").to("devbmnet.modules.bv.model.ReportService");
    map("bv.VoteService").to("devbmnet.modules.bv.model.VoteService");
    map("bv.SearchService").to("devbmnet.modules.bv.model.SearchService");
    map("bv.aws.shopping").to("devbmnet.modules.bv.model.aws.shopping"); 
    map("bv.aws.amazonsig").to("devbmnet.modules.bv.model.aws.amazonsig");
    map("bv.AuditService").to("devbmnet.modules.bv.model.AuditService");
    map("bv.RecommendationService").to("devbmnet.modules.bv.model.RecommendationService");
    map("aws.Alexa").to("devbmnet.model.aws.amazonAlexa").asSingleton().initWith(
      awsAccessKeyId = "AKIAI3TRZVUN4UWK6SMQ",
      secretAccessKey = "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"
    ); 
    map("UserStorage").toDSL("coldbox:myPlugin:UserStorage");
    /*map("gitAPI").toDSL("coldbox:myPlugin:oAuth").initWith(
      client_id = "c228a7fc718992fe86e5",
      client_secret = "b13a08380c42e64e3fe500a55d7fed49e794fb87",
      authEndpoint = "https://github.com/login/oauth/authorize",
      accessTokenEndpoint = "https://github.com/login/oauth/authorize",
      redirect_uri = "http://help/ebiz.co.uk/bugs/bugs/git"
    );*/
    map("marketing.CampaignService").to("devbmnet.modules.marketing.model.CampaignService");
    map("marketing.ResponseService").to("devbmnet.modules.marketing.model.ResponseService");
    map("marketing.social.TwitterService").to("devbmnet.modules.marketing.model.social.TwitterService");
    map("bugs.BugService").to("devbmnet.modules.bugs.model.BugService");
    map("bugs.automaton").to("devbmnet.modules.bugs.model.automaton");


    map("flo.RelationShipService").to("devbmnet.modules.flo.model.RelationShipService");
    map("flo.TaskService").to("devbmnet.modules.flo.model.TaskService");
    map("flo.WorklogService").to("devbmnet.modules.flo.model.ActivityRecordingService");


    map("eGroup.blog").to("eGroup.model.blog");
    map("eGroup.branch").to("eGroup.model.branch");
    map("eGroup.calculations").to("eGroup.model.calculations");
    map("eGroup.calendar").to("eGroup.model.calendar");
    map("eGroup.chart").to("eGroup.model.chart");
    map("eGroup.comment").to("eGroup.model.comment");
    map("eGroup.company").to("eGroup.model.company");
    map("eGroup.contact").to("eGroup.model.contact");
    map("eGroup.dms").to("eGroup.model.dms");
    map("eGroup.email").to("eGroup.model.email");
    map("eGroup.favourites").to("eGroup.model.favourites");
    map("eGroup.feed").to("eGroup.model.feed");
    map("eGroup.figures").to("eGroup.model.figures");
    map("eGroup.formbuilder").to("eGroup.model.formbuilder");
    map("eGroup.groupService").to("eGroup.model.groupService");
    map("eGroup.invoice").to("eGroup.model.invoice");
    map("eGroup.notification").to("eGroup.model.notification");
    map("eGroup.oolib").to("eGroup.model.oolib");
    map("eGroup.poll").to("eGroup.model.poll");
    map("eGroup.promotions").to("eGroup.model.promotions");
    map("eGroup.psa").to("eGroup.model.psa");
    map("eGroup.siteLog").to("eGroup.model.siteLog");
    map("eGroup.subscriptions").to("eGroup.model.subscriptions");
    map("eGroup.tag").to("eGroup.model.tag");
    map("eGroup.wiki").to("eGroup.model.wiki");    
	}
</cfscript>
</cfcomponent>