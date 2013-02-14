<cfoutput>
  <input type="hidden" id="bvsiteID" value="#request.bvsiteID#">
</cfoutput>
<div id="wrap">
  <div id="main">    
    <div class="topnav navbar-fixed-top">
      <div class="container relative">
        <cfsavecontent variable="logoLink">
          <a class="brand" href="#"><img src="/includes/images/sites/14/logo.png" border="0" /></a>
        </cfsavecontent>
        <cfsavecontent variable="navigation">
          <cfoutput>
            <li><a href="/"><i class="icon-home"></i> Home</a></li>
            <li><a href="/bv/site/list?siteID=#request.bvsiteID#"><i class="icon-building"></i> Companies</a></li>
            <li><a href="/signup"><i class="icon-vcard"></i> Register</a></li>
            <li><a href="/bv/blog?siteID=buildingVine"><i class="icon-feed"></i> Blog</a></li>
            <li><a href="/html/pricing.html?siteID=buildingVine"><i class="icon-question-frame"></i> Pricing</a></li>
            <li><a href="/html/tour.html?siteID=buildingVine"><i class="icon-camera"></i> Take the tour</a></li>
            <li><a href="/html/contact.html?siteID=buildingVine"><i class="icon-mobile-phone"></i> Contact</a></li>
          </cfoutput>
        </cfsavecontent>
        <cfif event.getCurrentModule() eq "bv">
          <cfif request.bvsiteID neq "buildingVine">
            <cfsavecontent variable="navigation">
              <cfoutput>
                <li><a href="/site/#request.bvsiteID#"><i class="icon-house"></i> Home</a></li>                
                <li><a href="/bv/products?siteID=#request.bvsiteID#"><i class="icon-drill"></i> Products</a></li>
                <li><a href="/bv/documents?siteID=#request.bvsiteID#"><i class="icon-document-pdf"></i> Downloads</a></li>
                <li><a href="/bv/promotions?siteID=#request.bvsiteID#"><i class="icon-store"></i> Promotions</a></li>
                <li><a href="/bv/blog?siteID=#request.bvsiteID#"><i class="icon-newspaper"></i> News</a></li>
                <li><a href="/bv/site/list?siteID=#request.bvsiteID#"><i class="icon-building"></i> Company List</a></li>                
              </cfoutput>
            </cfsavecontent>
            <cfset defImage = paramImage2("/modules/bv/includes/images/companies/#request.bvsiteID#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>
            <cfset uImage = paramImage2("/modules/bv/includes/images/companies/#request.bvsiteID#/small_white.png",defImage)>
            <cfsavecontent variable="logoLink">
              <cfoutput>
                <a class="brand" href="/bv/site/overview?siteID=#request.bvsiteID#"><img src="#uImage#" border="0" /></a>
              </cfoutput>
            </cfsavecontent>
          </cfif>
        </cfif>
        <cfoutput>#logoLink#</cfoutput>
        <div class="nav">
          <cfif isUserLoggedIn() AND isDefined("request.buildingVine.userProfile")>
            <div id="user">
              <cfoutput>
                <div class="dropdown">
                  <a class="dropdown-toggle" data-toggle="dropdown" href="##">#request.buildingVine.userProfile.firstName# #request.buildingVine.userProfile.lastName# <span class="caret"></span></a>
                  <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                    <li><a href="/bv/profile">Your Profile</a></li>
                    <li><a href="/login/logout">Logout</a></li>
                  </ul>
                </div>
                <img class="img-polaroid" width="30" alt="Profile Picture" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(request.buildingVine.userProfile.email)))#?size=30&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
              </cfoutput>
            </div>
          <cfelse>
            <cfset securedLoginDetails = getPlugin("CookieStorage").getVar("SecuredLoginDetails","")>
            <cfif isSimpleValue(securedLoginDetails) AND securedLoginDetails eq "">
              <cfset loginUserName = "">
              <cfset loginUserPassword = "">
              <cfset isRemember = false>
            <cfelse>
              <cfset loginStruct = deserializeJSON(securedLoginDetails)>
              <cfset loginUserName = loginStruct.username>
              <cfset loginUserPassword = loginStruct.password>
              <cfset isRemember = true>
            </cfif>
            <cfoutput>
            <form class="pull-right form form-inline" action="/login/doLogin" method="post">
              <div class="input-prepend">
                <span class="add-on">@</span>
                <input class="input-medium" type="text" placeholder="email address" name="j_username" value="#loginUserName#" />
              </div>
              <input class="input-medium" type="password"  placeholder="password" name="j_password" value="#loginUserPassword#" />
              <input type="submit" class="btn btn-success" value="LOGIN" />

              <div><label class="checkbox"><input #vm(isRemember,true,"checkbox")# type="checkbox" name="rememberme" />Remember Me?</label></div>
            </form>
            </cfoutput>
          </cfif>
          <div class="navigation">
            <ul class="nav">
              <cfoutput>#navigation#</cfoutput>
            </ul>
          </div>
        </div>
      </div>
    </div>