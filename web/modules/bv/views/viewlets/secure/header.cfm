<cfoutput><div class="brand">
	<cfif fileExists("#rc.app.appRoot#includes/images/companies/#lcase(rc.siteid)#.png")>
	 <img src="/includes/images/companies/#lcase(rc.siteid)#.png" alt="Building Vine"/>
	<cfelse>
	 <img src="/includes/images/companies/#lcase(rc.siteid)#/large.jpg" alt="Building Vine"/>
	</cfif>
	</div></cfoutput>
<cfif isUserLoggedIn()>
  <div class="pull-right">
    <div class="right" id="user">
      <cfoutput>
        <div class="left">
          <p><a href="/profile">#rc.buildingVine.userProfile.firstName# #rc.buildingVine.userProfile.lastName#</a></p>
          <p><a href="/login/logout">Logout &raquo;</a></p>
        </div>
        <img width="30" alt="Profile Picture" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(rc.buildingVine.userProfile.email)))#?size=30&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
      </cfoutput>
    </div>
  </div>
<cfelse>
	<cfset CS = getPlugin("cookiestorage")>
  <cfset CS.setEncryption(true)>
  <cfset login = CS.getVar("username","")>
  <cfset password = CS.getVar("password","")>
  <cfset r = CS.getVar("rememberMe","")>
  <form id="loginForm" class="hidden-phone pull-right form-horizontal" action="/login/doLogin" method="post">
    <div>
    	<div class="input-prepend">
        <span class="add-on">@</span><input placeholder="email address" type="text" class="input" name="username" />
      </div>
			<input placeholder="password" type="password" class="input" name="password" />
			<input type="submit" class="btn btn-success" value="LOGIN &raquo;" />
    </div>
		<div class="pull-right" id="socialSignIn">
      Or use our social signin: <a href="##" class="janrainEngage"><img src="/includes/images/socialIcons.png" border="0"></a>
    </div>
		<div class="">
			<label class="checkbox inline">
        <input type="checkbox" id="rememberme" value="true"> Remember Me?
      </label>
		</div>

  </form>
</cfif>
<cfoutput>
<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
</a>
<div class="pull-right nav-collapse">
  <ul class="nav">
		<cfif request.siteID neq "buildingVine">
      <li><a class="n-companies" href="/site/overview?siteID=#request.siteID#">overview</a></li>
      </cfif>
		<cfif rc.siteID eq "buildingVine" AND NOT isUserLoggedIn()>
			<li><a class="n-signup" href="/signup?siteID=buildingVine">register</a></li>
      <li><a class="n-blog" href="/blog?siteID=buildingVine">blog</a></li>
      <li><a class="n-pricing" href="/pricing?siteID=buildingVine">pricing</a></li>
			<li><a class="n-tour" href="/tour?siteID=buildingVine">take the tour</a></li>
      <li><a class="n-contact" href="/pages/contact?siteID=buildingVine">Contact</a></li>
			<li><a class="n-home" href="/?siteID=buildingVine">home</a></li>
		<cfelse>
      <cfoutput>
      <cfif rc.buildingVine.siteDB.siteType eq "Supplier">
        <li><a class="n-products" href="/products?siteID=#request.siteID#">products</a></li>
        <!---
        <li><a class="n-stockists" href="/stockist/map">stockists</a></li>
        --->
        <li><a class="n-promotions" href="/promotions?siteID=#request.siteID#">promotions</a></li>
      </cfif>
      <li><a class="n-documents" href="/documents?siteID=#request.siteID#">documents</a></li>
      <li><a class="n-press" href="/blog?siteID=#request.siteID#">press</a></li>
      <!---<li><a class="n-pages" href="/sums?siteID=#request.siteID#">Pages</a></li> --->
			<cfif NOT isUserLoggedIn()>
	      <cfif rc.canChangeSite>
	        <li><a class="n-companies" href="/sites?siteID=buildingVine">companies</a></li>
	        <li><a class="n-home" href="/?siteID=buildingVine">home</a></li>
	      <cfelse>
	        <li><a class="n-home" href="/?siteID=#request.siteID#">home</a></li>
	      </cfif>
	    <cfelseif rc.canChangeSite>
	      <li><a class="n-home" href="/sites?siteID=buildingVine">companies</a></li>
	    <cfelse>
	      <li><a class="n-home" href="/?siteID=#request.siteID#">home</a></li>
	    </cfif>
      </cfoutput>
		</cfif>
  </ul>
</div>
</cfoutput>