<!-----------------------------------------------------------------------
Author 	 :	Your Name
Date     :	September 25, 2005
Description :
	This is a ColdBox event handler for general methods.

Please note that the extends needs to point to the eventhandler.cfc
in the ColdBox system directory.
extends = coldbox.system.eventhandler

----------------------------------------------------------------------->
<cfcomponent name="login" output="false">
  <cfproperty name="UserService" inject="id:bv.UserService" >
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="faceBook" inject="id:bv.FacebookService"> 
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:applicationstorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage">
  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
	<!--- Default Action --->

  <cffunction name="index" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset arrValidChars = ListToArray("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,2,3,4,5,6,7,8,9")>
    <cfset CreateObject("java","java.util.Collections").Shuffle(arrValidChars) />
    <cfset rc.strCaptcha = (arrValidChars[ 1 ] & arrValidChars[ 2 ] & arrValidChars[ 3 ] & arrValidChars[ 4 ] & arrValidChars[ 5 ] & arrValidChars[ 6 ] & arrValidChars[ 7 ] & arrValidChars[ 8 ]) />
    <cfset rc.captcha_check = Encrypt(rc.strCaptcha,"bots-aint-sexy","CFMX_COMPAT","HEX") />
    <cfset rc.showMenu = false>
    <cfset event.setView("web/signup/index")>
  </cffunction>

  <cffunction name="accept" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
	  <cfset rc.userName = urlDecrypt(event.getValue("id",""))>
	  <cfset rc.inviteID = event.getValue("inviteID","")>
	  <cfset UserService.confirm(rc.userName)>
	  <cfset ticketID = UserService.startInvite(rc.userName,rc.inviteID)>  
    <cfset setNextEvent(uri="/signup/accepted")>    
  </cffunction>
  
  <cffunction name="accepted" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
	   <cfset rc.showMenu = false>
    <cfset event.setView("public/signup/accepted")>  
  </cffunction>

  <cffunction name="invite" returntype="void" output="false" cache="false">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>
    <cfset rc.siteRole = event.getValue("SiteRole","SiteConsumer")>
    <cfset rc.password = MakePassword()>
    <cfset invitation = siteService.invite(request.siteID,rc.email,rc.first_name,rc.surname,rc.siteRole,rc.password,request.user_ticket)>
    <cfset rc.cc = event.getValue("CC",false)>        
	  <cfsavecontent variable="accountCredentials"><cfoutput>An account has been created for you and your login details are:<br /><br />
	  
Username: #rc.email#<br />

Password: #rc.password#.<br /><br />

We strongly advise you to change your password when you log in for the first time.<br /><br />

You can do this by going to My Profile and selecting Change Password.</cfoutput></cfsavecontent>
    <cfset local.Email = MailService.newMail().config(
		      from="#rc.buildingVine.userProfile.firstName# #rc.buildingVine.userProfile.lastName# <#rc.buildingVine.userProfile.email#>",
		      to=rc.email,
		      Bcc="tom.miller@ebiz.co.uk",
		      subject="#rc.subject#"
		    )>
		<cfset local.Email.addMailPart(
		      charset='utf-8',
		      type='text/plain',
		      body=Renderer.renderLayout(layout="www.buildingvine.com/email/basic/invite.plain",args={message=rc.message})
		    )>
    <cfset local.Email.addMailPart(
		      charset='utf-8',
		      type='text/html',
		      body=Renderer.renderLayout(layout="www.buildingvine.com/email/basic/invite.html",args={message=rc.message})
		    )>
    <cfset local.Email.setBodyTokens({
		      first_name = rc.first_name,
		      password = rc.password,
		      accountCredentials = accountCredentials,
		      signuplink = "http://www.buildingvine.com/signup/accept?id=#urlEncrypt(rc.email)#&inviteId=#invitation.data.inviteId#"
		    })>
    <cfset rc.mailResult = MailService.send(local.Email)>
    <cfset event.setView("blank")>             
  </cffunction>

  <cffunction name="emailCheck" returntype="void"> 
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset userExists = UserService.getUser(rc.email)>
	  <cfset event.renderData(data=userExists,type="JSON")>
    <cfif isDefined("userExists.status.code")>
      <cfset event.renderData(data="true",type="text")>
    <cfelse>
      <cfset event.renderData(data="false",type="text")>
    </cfif>
  </cffunction> 

  <cffunction name="cemco" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.supplierID = event.getValue("companyID",0)>
    <cfset rc.contactID = event.getValue("contactID",0)>
    <cfset arrValidChars = ListToArray("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,2,3,4,5,6,7,8,9")>
    <cfset CreateObject("java","java.util.Collections").Shuffle(arrValidChars) />
    <cfset rc.strCaptcha = (arrValidChars[ 1 ] & arrValidChars[ 2 ] & arrValidChars[ 3 ] & arrValidChars[ 4 ] & arrValidChars[ 5 ] & arrValidChars[ 6 ] & arrValidChars[ 7 ] & arrValidChars[ 8 ]) />
    <cfset rc.captcha_check = Encrypt(rc.strCaptcha,"bots-aint-sexy","CFMX_COMPAT","HEX") />
    <cfset rc.showMenu = false>
    <cfset event.setView("web/signup/cemco")>
  </cffunction>

  <cffunction name="doExtranet">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>
    <cfset user = populateModel("UserService")>
    <cfset user.createUser()>
    <cfset user.confirm(rc.email)>
    <cfset user.setQuickLogin(rc.email,rc.password1,rc.identifier)>
    <cfscript>
    rc.Email = MailService.newMail().config(
      from="Building Vine <no-reply@buildingvine.com>",
      to=user.getemail(),
      Bcc="tom.miller@ebiz.co.uk",
      subject="Welcome to Building Vine!"
    );
    rc.Email.addMailPart(
      charset='utf-8',
      type='text/plain',
      body=Renderer.renderLayout("www.buildingvine.com/email/basic/welcome.plain")
    );
    rc.Email.addMailPart(
      charset='utf-8',
      type='text/html',
      body=Renderer.renderLayout("www.buildingvine.com/email/basic/welcome.html")
    );
    rc.Email.setBodyTokens({
      username = user.getemail(),
      password = user.getpassword1(),
      first_name = user.getfirst_name(),
      encryptedUserName = urlEncrypt(user.getemail()),
      siteID   = user.getsiteID()
    });
    rc.mailResult = MailService.send(rc.Email);
    </cfscript>
    <cfset event.setView("public/signup/complete")>
  </cffunction>

  <cffunction name="checkCaptcha" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.captcha_check = event.getValue("captcha_check",0)>
    <cfset rc.captcha = event.getValue("captcha",0)>
    <cfset rc.realcaptcha = Decrypt(rc.captcha_check,"bots-aint-sexy","CFMX_COMPAT","HEX")>
    <cfif rc.realcaptcha eq rc.captcha>
      <cfset rc.json = "true">
    <cfelse>
      <cfset rc.json = "false">
    </cfif>
    <cfset event.setView("renderJSON")>
  </cffunction>

  <cffunction name="confirm">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.uid = event.getValue("uid","")>
    <cfset rc.email = urlDecrypt(rc.uid)>
    <cfset UserService.confirm(rc.email)>
    <cfset rc.showMenu = false>
    <cfset event.setView("public/signup/confirmed")>
  </cffunction>

  <cffunction name="do" returntype="void" output="false" cache="false">
    <cfargument name="Event">

    <cfscript>
      var rc = event.getCollection();
      rc.access_type = event.getValue("access_type","personal");
      rc.captcha_check = event.getValue("captcha_check",0);
      rc.captcha = event.getValue("captcha",0);
      rc.realcaptcha = Decrypt(rc.captcha_check,"bots-aint-sexy","CFMX_COMPAT","HEX");
      rc.headerImage = "/includes/images/email/welcome.jpg";
      rc.showMenu = false;
      

        user = populateModel("UserService");
        user.createUser();
        rc.DEmail = MailService.newMail().config(
          from="Building Vine <mail@buildingvine.com>",
          to=user.getemail(),
          Bcc="tom.miller@ebiz.co.uk,alison.miller@buildingvine.com",
          subject="Welcome to Building Vine!",
          type="html"
        );
        rc.DEmail.setBodyTokens({
          username = user.getemail(),
          password = user.getpassword1(),
          first_name = user.getfirst_name(),
          encryptedUserName = urlEncrypt(user.getemail()),
          siteID   = user.getsiteID()
        });
        rc.DEmail.addMailPart(
          charset='utf-8',
          type='text/plain',
          body=Renderer.renderLayout("www.buildingvine.com/email/basic/welcome.plain")
        );
        rc.DEmail.addMailPart(
          charset='utf-8',
          type='text/html',
          body=Renderer.renderLayout("www.buildingvine.com/email/basic/welcome.html")
        ); 
        if (rc.access_type neq "personal") {
         site = populateModel("SiteService");
         site.createSite(user);
         rc.DEmail.addMailPart(
            charset='utf-8',
            type='text/plain',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
          );
          rc.DEmail.addMailPart(
            charset='utf-8',
            type='text/html',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
          );
        }
       
        rc.mailResult = MailService.send(rc.DEmail);
        event.setView("public/signup/complete");
      
    </cfscript>
  </cffunction>

  <cffunction name="doCEMCO" returntype="void" output="true" cache="false">
    <cfargument name="event" required="true">
    <cfset var rc = arguments.event.getCollection()>
    <cfscript>
      rc.access_type = arguments.event.getValue("access_type","personal");
      rc.captcha_check = arguments.event.getValue("captcha_check",0);
      rc.captcha = event.getValue("captcha",0);
      rc.realcaptcha = Decrypt(rc.captcha_check,"bots-aint-sexy","CFMX_COMPAT","HEX");
      rc.headerImage = "/includes/images/email/welcome.jpg";
    </cfscript>
    <cfscript>
      if (rc.realcaptcha eq rc.captcha) {
        rc.user = populateModel("UserService");
        rc.user.createUser();
        rc.site = populateModel("SiteService");
        rc.site.createSite(rc.user);

        rc.Email = MailService.newMail().config(
          from="Building Vine <no-reply@buildingvine.com>",
          to=rc.user.getemail(),
          subject="Welcome to Building Vine!"
        );
        rc.Email.addMailPart(
          charset='utf-8',
          type='text/plain',
          body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
        );
        rc.Email.addMailPart(
          charset='utf-8',
          type='text/html',
          body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
        );
        rc.Email.setBodyTokens({
            username = rc.user.getemail(),
            password = rc.user.getpassword1(),
            first_name = rc.user.getfirst_name(),
            encryptedUserName = urlEncrypt(rc.user.getemail()),
            siteID   = rc.site.getshortName()
          });
        rc.Email.addMailParam(disposition='attachment',
          file="/fs/sites/ebiz/www.buildingvine.com/web/includes/files/SupplierBrochure.pdf",
          type='application/pdf');
        // rc.mailResult = MailService.send(rc.Email);
        if (event.getValue("first_name1","") neq "") {
          rc.user1 = getModel("UserService");
          rc.user1.setfirst_name(event.getValue("first_name1",""));
          rc.user1.setsurname(event.getValue("last_name1",""));
          rc.user1.setemail(event.getValue("email1",""));
          rc.user1.setpassword1(MakePassword());
          rc.user1.setsiteID(rc.site.getshortName());
          rc.user1.createSiteUser("SiteManager");
          rc.user1.doBuyingGroups(rc.site.getshortName());
          rc.Email = MailService.newMail().config(
            from="Building Vine <no-reply@buildingvine.com>",
            to=rc.user1.getemail(),
            subject="Welcome to Building Vine!"
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/plain',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/html',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
          );
          rc.Email.setBodyTokens({
            username = rc.user1.getemail(),
            password = rc.user1.getpassword1(),
            first_name = rc.user1.getfirst_name(),
            encryptedUserName = urlEncrypt(rc.user1.getemail()),
            siteID   = rc.site.getshortName()
          });
          rc.Email.addMailParam(disposition='attachment',
            file="/fs/sites/ebiz/www.buildingvine.com/web/includes/files/SupplierBrochure.pdf",
            type='application/pdf');
          // rc.mailResult = MailService.send(rc.Email);
        }
        if (event.getValue("first_name2","") neq "") {
          rc.user2 = getModel("UserService");
          rc.user2.setfirst_name(event.getValue("first_name2",""));
          rc.user2.setsurname(event.getValue("last_name2",""));
          rc.user2.setemail(event.getValue("email2",""));
          rc.user2.setpassword1(MakePassword());
          rc.user2.setsiteID(rc.site.getshortName());
          rc.user2.createSiteUser("SiteManager");
          rc.user2.doBuyingGroups(rc.site.getshortName());
          rc.Email = MailService.newMail().config(
            from="Building Vine <no-reply@buildingvine.com>",
            to=rc.user2.getemail(),
            subject="Welcome to Building Vine!"
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/plain',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/html',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
          );
          rc.Email.setBodyTokens({
            username = rc.user2.getemail(),
            password = rc.user2.getpassword1(),
            first_name = rc.user2.getfirst_name(),
            encryptedUserName = urlEncrypt(rc.user2.getemail()),
            siteID   = rc.site.getshortName()
          });
          rc.Email.addMailParam(disposition='attachment',
            file="/fs/sites/ebiz/www.buildingvine.com/web/includes/files/SupplierBrochure.pdf",
            type='application/pdf');
          // rc.mailResult = MailService.send(rc.Email);
        }
        if (event.getValue("first_name3","") neq "") {
          rc.user3 = getModel("UserService");
          rc.user3.setfirst_name(event.getValue("first_name3",""));
          rc.user3.setsurname(event.getValue("last_name3",""));
          rc.user3.setemail(event.getValue("email3",""));
          rc.user3.setpassword1(MakePassword());
          rc.user3.setsiteID(rc.site.getshortName());
          rc.user3.createSiteUser("SiteManager");
          rc.user3.doBuyingGroups(rc.site.getshortName());
          rc.Email = MailService.newMail().config(
            from="Building Vine <no-reply@buildingvine.com>",
            to=rc.user3.getemail(),
            subject="Welcome to Building Vine!"
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/plain',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/html',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
          );
          rc.Email.setBodyTokens({
            username = rc.user3.getemail(),
            password = rc.user3.getpassword1(),
            first_name = rc.user3.getfirst_name(),
            encryptedUserName = urlEncrypt(rc.user3.getemail()),
            siteID   = rc.site.getshortName()
          });
          rc.Email.addMailParam(disposition='attachment',
            file="/fs/sites/ebiz/www.buildingvine.com/web/includes/files/SupplierBrochure.pdf",
            type='application/pdf');
          rc.mailResult = MailService.send(rc.Email);
        }
        if (event.getValue("first_name4","") neq "") {
          rc.user4 = getModel("UserService");
          rc.user4.setfirst_name(event.getValue("first_name4",""));
          rc.user4.setsurname(event.getValue("last_name4",""));
          rc.user4.setemail(event.getValue("email4",""));
          rc.user4.setpassword1(MakePassword());
          rc.user4.setsiteID(rc.site.getshortName());
          rc.user4.createSiteUser("SiteManager");
          rc.user4.doBuyingGroups(rc.site.getshortName());
          rc.Email = MailService.newMail().config(
            from="Building Vine <no-reply@buildingvine.com>",
            to=rc.user4.getemail(),
            subject="Welcome to Building Vine!"
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/plain',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.plain")
          );
          rc.Email.addMailPart(
            charset='utf-8',
            type='text/html',
            body=Renderer.renderLayout("www.buildingvine.com/email/welcome.html")
          );
          rc.Email.setBodyTokens({
            username = rc.user4.getemail(),
            password = rc.user4.getpassword1(),
            first_name = rc.user4.getfirst_name(),
            encryptedUserName = urlEncrypt(rc.user4.getemail()),
            siteID   = rc.site.getshortName()
          });
          rc.Email.addMailParam(disposition='attachment',
            file="/fs/sites/ebiz/www.buildingvine.com/web/includes/files/SupplierBrochure.pdf",
            type='application/pdf');
          rc.mailResult = MailService.send(rc.Email);
        }
        event.setView("public/signup/complete");
      } else {
        event.setView("public/signup/error");
      }
    </cfscript>
  </cffunction>

  <cffunction name="doCatchPA" returntype="boolean">
    <cfargument name="challenge">
    <cfargument name="response">
    <cftry>
      <cfhttp url="http://api-verify.recaptcha.net/verify" method="post" timeout="5" throwonerror="true">
        <cfhttpparam type="formfield" name="privatekey" value="6LcDvsUSAAAAAOfBwJqHNRgopB41OkqUPZGIUulI">
        <cfhttpparam type="formfield" name="remoteip" value="#cgi.REMOTE_ADDR#">
        <cfhttpparam type="formfield" name="challenge" value="#arguments.challenge#">
        <cfhttpparam type="formfield" name="response" value="#arguments.response#">
      </cfhttp>
    <cfcatch>
      <cfthrow  type="RECAPTCHA_NO_SERVICE"
        message="recaptcha: unable to contact recaptcha verification service on url '#VERIFY_URL#'">
    </cfcatch>
    </cftry>

    <cfset aResponse = listToArray(cfhttp.fileContent, chr(10))>
    <cfset recaptcha = aResponse[1]>
    <cfif aResponse[1] eq "false" and aResponse[2] neq "incorrect-captcha-sol">
      <cfreturn false>
    <cfelse>
      <cfreturn true>
    </cfif>
  </cffunction>
</cfcomponent>