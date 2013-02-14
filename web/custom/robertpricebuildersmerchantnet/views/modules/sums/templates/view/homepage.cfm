<div id="myCarousel" class="carousel slide">
  <div class="carousel-inner">
    <!--- <cfoutput>
      <cfset features = getModel("templates.#rc.requestdata.page.template#").getFeatures()>
      <cfloop array="#features.items#" index="feature">
        <div class="item">
          <a href="#feature.page.attributes.customProperties.feature_link#">
          <img width="100%" height="250" src="#feature.page.attributes.customProperties.feature_image#" alt="">
          <div class="carousel-caption">
            <h4>#feature.page.attributes.title#</h4>
            <p>#feature.page.attributes.customProperties.feature_name#</p>
          </div>
          </a>
        </div>
      </cfloop>
    </cfoutput> --->
  </div>
  <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
  <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
</div>
<cfoutput>
  #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#
</cfoutput>





