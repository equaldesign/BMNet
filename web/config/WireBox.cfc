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
      scanLocations = ["bmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.modules.mxtra","bmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.modules.sums","bmnet.model","bmnet.modules"],

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


    map("eunify.GroupsService").to("bmnet.modules.eunify.model.GroupsService").inCacheBox(timeout=40,lastAccessTimeout=20,provider="template").asEagerInit();

    map("mxtra.basket").to("bmnet.modules.mxtra.model.basket");
    map("mxtra.account").to("bmnet.modules.mxtra.model.account");
    map("mxtra.category").to("bmnet.modules.mxtra.model.category");
    map("mxtra.products").to("bmnet.modules.mxtra.model.products");
    map("mxtra.quote").to("bmnet.modules.mxtra.model.quote");
    map("mxtra.orders").to("bmnet.modules.mxtra.model.orders");
    map("mxtra.checkout").to("bmnet.modules.mxtra.model.checkout");
    map("eunify.ProductService").to("bmnet.modules.eunify.model.ProductService");
    map("eunify.FeedService").to("bmnet.modules.eunify.model.FeedService");
    map("eunify.UserService").to("bmnet.modules.eunify.model.UserService");
    map("eunify.FavouritesService").to("bmnet.modules.eunify.model.FavouritesService");
    map("eunify.FiguresService").to("bmnet.modules.eunify.model.FiguresService");
    map("eunify.EmailService").to("bmnet.modules.eunify.model.EmailService");
    map("eunify.PSAService").to("bmnet.modules.eunify.model.PSAService");
    map("eunify.SiteService").to("bmnet.modules.eunify.model.SiteService");
    map("eunify.BranchService").to("bmnet.modules.eunify.model.BranchService");
    map("eunify.CommentService").to("bmnet.modules.eunify.model.CommentService");
    map("eunify.DocumentService").to("bmnet.modules.eunify.model.DocumentService");
    map("eunify.CalendarService").to("bmnet.modules.eunify.model.CalendarService");
    map("eunify.InvoiceService").to("bmnet.modules.eunify.model.InvoiceService");
    map("eunify.PromotionsService").to("bmnet.modules.eunify.model.PromotionsService");
    map("eunify.CompanyService").to("bmnet.modules.eunify.model.CompanyService");
    map("eunify.ImportService").to("bmnet.modules.eunify.model.ImportService");
    map("eunify.RecommendationService").to("bmnet.modules.eunify.model.RecommendationService");
    map("eunify.SalesService").to("bmnet.modules.eunify.model.SalesService");
    map("eunify.EcommerceService").to("bmnet.modules.eunify.model.EcommerceService");
    map("eunify.ContactService").to("bmnet.modules.eunify.model.ContactService");
    map("eunify.SubscriptionService").to("bmnet.modules.eunify.model.SubscriptionService");
    map("eunify.geoService").to("bmnet.modules.eunify.model.geoService");

    map("sums.PageService").to("bmnet.modules.sums.model.PageService");
    map("eunify.TagService").to("bmnet.modules.eunify.model.TagService");

    map("quote.QuoteService").to("bmnet.modules.quote.model.QuoteService");

    map("poll.PollService").to("bmnet.modules.poll.model.PollService");
    map("poll.formbuilder").to("bmnet.modules.poll.model.formbuilder");

    map("bv.UserService").to("bmnet.modules.bv.model.UserService");
    map("bv.WikiService").to("bmnet.modules.bv.model.WikiService");
    map("bv.EmailService").to("bmnet.modules.bv.model.EmailService");
    map("bv.BlogService").to("bmnet.modules.bv.model.BlogService");
    map("bv.FeedService").to("bmnet.modules.bv.model.FeedService");
    map("bv.SiteService").to("bmnet.modules.bv.model.SiteService");
    map("bv.ProductService").to("bmnet.modules.bv.model.ProductService");
    map("bv.TagService").to("bmnet.modules.bv.model.TagService");
    map("bv.PromotionService").to("bmnet.modules.bv.model.PromotionService");
    map("bv.RatingService").to("bmnet.modules.bv.model.RatingService");
    map("bv.DocumentService").to("bmnet.modules.bv.model.DocumentService");
    map("bv.StockistService").to("bmnet.modules.bv.model.StockistService");
    map("bv.CommentService").to("bmnet.modules.bv.model.CommentService");
    map("bv.ReportService").to("bmnet.modules.bv.model.ReportService");
    map("bv.VoteService").to("bmnet.modules.bv.model.VoteService");
    map("bv.SearchService").to("bmnet.modules.bv.model.SearchService");
    map("bv.aws.shopping").to("bmnet.modules.bv.model.aws.shopping");
    map("bv.aws.amazonsig").to("bmnet.modules.bv.model.aws.amazonsig");
    map("bv.AuditService").to("bmnet.modules.bv.model.AuditService");
    map("bv.RecommendationService").to("bmnet.modules.bv.model.RecommendationService");
    map("aws.Alexa").to("bmnet.model.aws.amazonAlexa").asSingleton().initWith(
      awsAccessKeyId = "AKIAI3TRZVUN4UWK6SMQ",
      secretAccessKey = "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"
    );

    map("marketing.CampaignService").to("bmnet.modules.marketing.model.CampaignService");
    map("marketing.ResponseService").to("bmnet.modules.marketing.model.ResponseService");
    map("marketing.social.TwitterService").to("bmnet.modules.marketing.model.social.TwitterService");
    map("bugs.BugService").to("bmnet.modules.bugs.model.BugService");


    map("flo.RelationShipService").to("bmnet.modules.flo.model.RelationShipService");
    map("flo.TaskService").to("bmnet.modules.flo.model.TaskService");


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