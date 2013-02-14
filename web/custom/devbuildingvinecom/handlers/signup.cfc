<!-----------------------------------------------------------------------
Author   :  Your Name
Date     :  September 25, 2005
Description :
  This is a ColdBox event handler for general methods.

Please note that the extends needs to point to the eventhandler.cfc
in the ColdBox system directory.
extends = coldbox.system.eventhandler

----------------------------------------------------------------------->
<cfcomponent name="login" output="false">
  <cfproperty name="UserService" inject="model:UserService" >
  <cfproperty name="siteService" inject="model:SiteService">
  <cfproperty name="faceBook" inject="model:FacebookService">
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
    <cfset event.setView(view="web/signup/index",module="bv")>
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
      
      user = populateModel("bv.UserService");
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
      event.setView(name="public/signup/complete",module="bv");      
    </cfscript>
  </cffunction>

  <cffunction name="bgcheck" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.result = {}>
    <cfquery name="c" datasource="#rc.datasource#">
      select 
        company.name,
        company.type_id,
        company.address1,
        company.address2,
        company.address3,
        company.town,
        company.county,
        company.postcode,
        company.web,
        company.switchboard,
        contact.first_name,
        contact.surname             
      from 
        contact,
        company
      where 
        contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.username#">
      and
        contact.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.password#">
      and
        company.id = contact.company_id
    </cfquery>    
    <cfset event.renderData(data=c,type="json")>
  </cffunction>

  <cffunction name="nmbsCheck" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()> 
    <cfset rc.result = {}>
    <cfquery name="c" datasource="nmbs">
      select 
        Supplier_Name,
        [Address@1] as address1,
         [Address@2] as address2,
         Postcode,
         Website,
         Telephone
      from 
        suppliers 
      where 
        [A/C_No] = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.NMBSCode#">      
    </cfquery>
    <cfset event.renderData(data=c,type="json")>
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