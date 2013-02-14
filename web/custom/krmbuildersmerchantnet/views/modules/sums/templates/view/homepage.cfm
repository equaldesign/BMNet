<div id="myCarousel" class="carousel slide">
  <div class="carousel-inner">
    <cfoutput>
      <cfset features = rc.templateModel.getFeatures()>
      <cfloop array="#features.items#" index="feature">
        <div class="item">
          <a href="##">
          <img border="0" width="100%" height="380" name="" src="https://www.buildingvine.com/api/productImage?nodeRef=#ListLast(feature.nodeRef,"/")#&size=698" alt="" title="">
          </a>
        </div>
      </cfloop>
    </cfoutput>
  </div>
  <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
  <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
</div>
<cfoutput>
<div #isE()# name="content">
  #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#
</div>
<div class="row-fluid">
  <div class="span4" name="p1" #isE()#>
  #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.p1","Content"))#
  </div>
  <div class="span4" name="p2" #isE()#>
  #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.p2","Content"))#
  </div>
  <div class="span4" name="p3" #isE()#>
  #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.p3","Content"))#
  </div>
</div>
</cfoutput>





