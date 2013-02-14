<cfcomponent output="false" autowire="true">
  <cfproperty name="SiteService" inject="id:bv.SiteService" scope="instance">
  <cfproperty name="ProductService" inject="id:bv.ProductService" scope="instance">
  <cfproperty name="BlogService" inject="id:bv.BlogService" scope="instance">
  <cfproperty name="UserService" inject="id:bv.UserService" scope="instance">
  <cfproperty name="logger" inject="logbox:root" scope="instance">


  <cffunction name="do" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfthread host="#cgi.HTTP_HOST#" instance="#instance#" action="run" name="sitemapgenerator" priority="LOW" rc="#rc#">
      <cfsetting requesttimeout="9000000000000">
      <cfset hostA = ListToArray(attributes.host,".")>
      <cfset isMobile = false>
      <cfset subHost = hostA[2]>
      <cfif hostA[1] eq "m">
        <cfset isMobile = true>
      </cfif>
      <cfxml variable="sitemap">
      <?xml version="1.0" encoding="UTF-8" ?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:mobile="http://www.google.com/schemas/sitemap-mobile/1.0">
        <!--- output the homepages --->
        <cfoutput>
        <url>
            <loc>http://#host#</loc>
            <!--- <cfhttp url="http://#attributes.host#"></cfhttp> --->
            <changefreq>daily</changefreq>
            <priority>0.8</priority>
            <cfif left(cgi.HTTP_HOST,1) eq "m">
            <mobile:mobile/>
            </cfif>
        </url>
        </cfoutput>
      <cfset var ticket = request.user_ticket>
      <!--- get a list of sites --->
      <cfquery name="siteList" datasource="bvine">
        select LCASE(shortName) as shortName, siteType from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfif isMobile and subHost neq "buildingvine">
        AND
        shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hostA[2]#">
        </cfif>
      </cfquery>
      <cfoutput query="siteList">
        <!--- output the basic site homepages --->
        <cfif NOT isMobile>
        <url>
            <loc>http://www.buildingvine.com/sites/#shortName#</loc>
            <changefreq>weekly</changefreq>
            <priority>0.8</priority>
            <cfhttp redirect="true" url="http://www.buildingvine.com/sites/#shortName#"></cfhttp>
        </url>
        <cfelseif subHost neq "buildingVine">
        <url>
            <loc>http://m.#shortName#.buildingvine.com</loc>
           <cfhttp redirect="true" url="m.#shortName#.buildingvine.com"></cfhttp>
            <changefreq>weekly</changefreq>
            <priority>0.8</priority>
            <mobile:mobile/>
        </url>
        <cfelse>
        <url>
            <loc>http://m.buildingvine.com/sites/#shortName#</loc>
            <cfhttp redirect="true" url="http://m.buildingvine.com/sites/#shortName#"></cfhttp>
            <changefreq>weekly</changefreq>
            <priority>0.8</priority>
            <mobile:mobile/>
        </url>
        </cfif>
        <!--- output the site sections --->
        <cfif siteType eq "Supplier">
          <!--- products --->
          <cfif NOT isMobile>
          <url>
              <loc>http://www.buildingvine.com/products?sitesID=#shortName#</loc>
              <cfhttp redirect="true" url="http://www.buildingvine.com/products?sitesID=#shortName#"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
          </url>
          <cfelseif subHost neq "buildingVine">
          <url>
              <loc>http://m.#shortName#.buildingvine.com/products</loc>
              <cfhttp redirect="true" url="http://m.#shortName#.buildingvine.com/products"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
              <mobile:mobile/>
          </url>
          <cfelse>
          <url>
              <loc>http://m.buildingvine.com/products?siteID=#shortName#</loc>
              <cfhttp redirect="true" url="http://m.buildingvine.com/products?siteID=#shortName#"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
              <mobile:mobile/>
          </url>
          </cfif>

          <!--- blog --->
          <cfif NOT isMobile>
          <url>
              <loc>http://www.buildingvine.com/blog?sitesID=#shortName#</loc>
              <cfhttp redirect="true" url="http://www.buildingvine.com/blog?sitesID=#shortName#"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
          </url>
          <cfelseif subHost neq "buildingVine">
          <url>
              <loc>http://m.#shortName#.buildingvine.com/blog</loc>
              <cfhttp redirect="true" url="http://m.#shortName#.buildingvine.com/blog"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
              <mobile:mobile/>
          </url>
          <cfelse>
          <url>
              <loc>http://m.buildingvine.com/blog?siteID=#shortName#</loc>
             <cfhttp redirect="true" url="http://m.buildingvine.com/blog?siteID=#shortName#"></cfhttp>
              <changefreq>weekly</changefreq>
              <priority>0.8</priority>
              <mobile:mobile/>
          </url>
          </cfif>
            <!--- stockists --->
            <cfif NOT isMobile>
            <url>
                <loc>http://www.buildingvine.com/stockist/map?sitesID=#shortName#</loc>
                <cfhttp redirect="true" url="http://www.buildingvine.com/stockist/map?sitesID=#shortName#"></cfhttp>
                <changefreq>weekly</changefreq>
                <priority>0.8</priority>
            </url>
            <cfelseif subHost neq "buildingVine">
            <url>
                <loc>http://m.#shortName#.buildingvine.com/stockist/map</loc>
                <cfhttp redirect="true" url="http://m.#shortName#.buildingvine.com/stockist/map"></cfhttp>
                <changefreq>weekly</changefreq>
                <priority>0.8</priority>
                <mobile:mobile/>
            </url>
            <cfelse>
            <url>
                <loc>http://m.buildingvine.com/stockist/map?siteID=#shortName#</loc>
               <cfhttp redirect="true" url="http://m.buildingvine.com/stockist/map?siteID=#shortName#"></cfhttp>
                <changefreq>weekly</changefreq>
                <priority>0.8</priority>
                <mobile:mobile/>
            </url>
            </cfif>
          <cftry>
          <!--- first, lets get the products --->
          <cfset categoryList = attributes.instance.productService.listAllCategories(shortName)>
          <cfloop array="#categoryList.categories#" index="category">
            <cfif NOT isMobile>
            <url>
              <loc>http://www.buildingvine.com/products?nodeRef=#category.nodeRef#&amp;siteID=#shortName#</loc>
              <cfhttp redirect="true" url="http://www.buildingvine.com/products?nodeRef=#category.nodeRef#&amp;siteID=#shortName#"></cfhttp>
              <changefreq>weekly</changefreq>
            </url>
            <cfelseif subHost neq "buildingVine">
            <url>
                <loc>http://m.#shortName#.buildingvine.com/products?nodeRef=#category.nodeRef#</loc>
                <cfhttp redirect="true" url="http://m.#shortName#.buildingvine.com/products?nodeRef=#category.nodeRef#"></cfhttp>
                <changefreq>weekly</changefreq>
                <mobile:mobile/>
            </url>
            <cfelse>
            <url>
                <loc>http://m.buildingvine.com/products?nodeRef=#category.nodeRef#&amp;siteID=#shortName#</loc>
                <cfhttp redirect="true" url="http://m.buildingvine.com/products?nodeRef=#category.nodeRef#&amp;siteID=#shortName#<"></cfhttp>
                <changefreq>weekly</changefreq>
                <mobile:mobile/>

            </url>
            </cfif>
          </cfloop>
          <cfset productList = attributes.instance.productService.listAllProducts(shortName)>
          <cfif ArrayLen(productList.products) eq "0">
            <cfset instance.logger.debug("Array Empty for #shortName#")>
          </cfif>
          <cfloop array="#productList.products#" index="product">
            <cfif NOT isMobile>
            <url>
                <loc>http://www.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#&amp;siteID=#shortName#</loc>
                <cfhttp redirect="true" url="http://www.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#&amp;siteID=#shortName#"></cfhttp>
                <changefreq>weekly</changefreq>
            </url>
            <cfelseif subHost eq "buildingVine">
            <url>
                <loc>http://m.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#&amp;siteID=#shortName#</loc>
                <cfhttp  redirect="true" url="http://m.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#&amp;siteID=#shortName#"></cfhttp>
                <changefreq>weekly</changefreq>
                <mobile:mobile/>
            </url>
            <cfelse>
            <url>
                <loc>http://m.#shortName#.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#</loc>
                <cfhttp redirect="true" url="http://m.#shortName#.buildingvine.com/products/productDetail?nodeRef=#product.nodeRef#"></cfhttp>
                <changefreq>weekly</changefreq>
                <mobile:mobile/>
            </url>
            </cfif>
          </cfloop>
          <cfcatch type="any"></cfcatch>
          </cftry>
        </cfif>
        <!--- now get the blog articles --->
        <!---<cftry>
         <cfset blogPosts = attributes.instance.blogService.getPosts(shortName)>
        <cfloop array="#blogPosts.products#" index="item">
          <url>
              <loc>http://www.buildingvine.com/blog/item?nodeRef=#item.url#&siteID=#shortName#</loc>
              <changefreq>weekly</changefreq>
          </url>
          <url>
              <loc>http://m.buildingvine.com/blog/item?nodeRef=#item.url#&amp;siteID=#shortName#</loc>
              <changefreq>weekly</changefreq>
              <mobile:mobile/>
          </url>
          <url>
              <loc>http://m.#shortName#.buildingvine.com/blog/item?nodeRef=#item.url#</loc>
              <changefreq>weekly</changefreq>
              <mobile:mobile/>
          </url>
        </cfloop>
        <cfcatch type="any"><cfset instance.logger.debug(cfcatch.Message)></cfcatch>
        </cftry> --->
      </cfoutput>
      </urlset>
      </cfxml>
      <!--- now save the file --->
      <cffile action="write" output="#ToString(sitemap)#" file="/fs/sites/ebiz/www.buildingvine.com/web/sitemaps/#attributes.host#.sitemap.xml">
    </cfthread>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="index" returntype="void" output="true">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset host = cgi.HTTP_HOST>
    <cfif fileExists("/fs/sites/ebiz/www.buildingvine.com/web/sitemaps/#host#.sitemap.xml") AND DateCompare(getFileinfo("/fs/sites/ebiz/www.buildingvine.com/web/sitemaps/#host#.sitemap.xml").Lastmodified,DateAdd("d",-7,now())) gte 0>
      <cfcontent file="/fs/sites/ebiz/www.buildingvine.com/web/sitemaps/#host#.sitemap.xml">
    <cfelse>
      <cfset setNextEvent(uri="/sitemap/do")>
    </cfif>
  </cffunction>

  <cffunction name="doMaps" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <!--- do BV Main Site, and BV Mobile --->
    <cfhttp url="http://www.buildingvine.com/sitemap"></cfhttp>
    <cfhttp url="http://m.buildingvine.com/sitemap"></cfhttp>
    <cfquery name="sites" datasource="bvine">
      select LCASE(shortName) as shortName, siteType from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
       AND

        siteType = <cfqueryparam cfsqltype="cf_sql_varchar" value="Supplier">
    </cfquery>
    <cfloop query="sites">
      <cfhttp url="http://m.#shortName#.buildingvine.com/sitemap"></cfhttp>
    </cfloop>
    <cfset event.noRender()>
  </cffunction>
</cfcomponent>