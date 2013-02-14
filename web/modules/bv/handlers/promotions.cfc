
<cfcomponent output="false" autowire="true" cache="true">

	<!--- dependencies --->
	<cfproperty name="userService" inject="id:bv.userService">
	<cfproperty name="promotionService" inject="id:bv.PromotionService">
  <cfproperty name="productService" inject="id:bv.ProductService">
  <cfproperty name="documentService" inject="id:bv.DocumentService">
  <cfproperty name="ratingService" inject="id:bv.RatingService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="commentService" inject="id:bv.CommentService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="Paging" inject="coldbox:myPlugin:Paging">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
	<!--- preHandler --->

	<!--- index --->
	<cffunction cache="true" name="index" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","0");
			rc.type = event.getValue("ptype","current");
			rc.boundaries = Paging.getBoundaries();
      rc.promotions = promotionService.list(nodeRef=rc.nodeRef,siteID=rc.siteID,type=rc.type);
			event.setView("#rc.viewPath#promotions/index");
		</cfscript>
	</cffunction>

  <cffunction cache="true" name="editassociations" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","0");
      rc.promotions = promotionService.detail(nodeRef=rc.nodeRef);
      rc.productCategories = productService.listFlatCategories(rc.siteID);
      event.setView("#rc.viewPath#promotions/assocations");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="edit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","");
      rc.boundaries = Paging.getBoundaries();
      if (rc.nodeRef neq "") {
        rc.promotion = promotionService.detail(nodeRef=rc.nodeRef,siteID=rc.siteID);
      }
      event.setView("#rc.viewPath#promotions/edit");
    </cfscript>
  </cffunction>
</cfcomponent>