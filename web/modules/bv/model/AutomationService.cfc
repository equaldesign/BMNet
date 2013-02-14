<cfcomponent>

  <cffunction name="runIt" returntype="Any">
    <cfset var rc = {}>
    <cfset var rc.fromemails = "">
    <cfset var rc.toEmails = "">
    <cfset var rc.toCCs = "">
    <cfset var rc.headerEmails = "">
    <cfset var rc.ctype = "">
    <cfset var rc.bodyEmails = "">
    <cfset var rc.emailStruct = "">
    <cfset var rc.sourceUser = "">
    <cfset var rc.targetUser = "">
    <cfimap action="open" username="upload@buildingvine.com" password="bugg3rm33" connection="cf.gmail" server="imap.gmail.com" secure="yes">
    <cfimap action="getall" attachmentpath="/tmp" generateUniqueFileNames="true" folder="INBOX" connection="cf.gmail" name="messages">
    <cfset rc.messages = messages>
    <cfloop query="messages">
        <cfset rc.attach = ListToArray(ATTACHMENTFILES,Chr(9))>
        <cfset rc.attachNames = ListToArray(ATTACHMENTS,Chr(9))>
        <cfset rc.fromEmails = getEmails(from)>
        <cfset rc.toEmails = getEmails(to)>
        <cfset rc.toCCs = getEmails(cc)>
        <cfset rc.headerEmails = getEmails(header)>
        <cfset rc.ctype = "outgoing_email">
        <cfset rc.bodyEmails = getEmails(body)>
        <cfset rc.subject = subject>
        <cfset rc.body = body>
        <cfset rc.htmlbody = htmlbody>
        <cfset rc.textbody = textbody>
        <cfif ArrayLen(rc.toEmails) gte 1>
          <!--- we must have incoming to! --->
          <!--- now we need to work out which of the emails is the automation --->
          <cfset rc.emailStruct = findAutomaton(rc.toCCs,rc.toEmails,rc.headerEmails)>
            <cfif StructKeyExists(rc.emailStruct,"automaton")>
              <cfset rc.sourceUser = findUser(rc.fromEmails[1])>
              <cfif rc.sourceUser.recordCount neq 0>
                <cfset Evaluate("#rc.emailStruct.automaton#(rc.sourceUser,rc.subject,rc.body,rc.htmlbody,rc.textbody,rc.attach,rc.attachNames)")>
             </cfif>
           </cfif>
       </cfif>
       <cfimap action="delete" messageNumber="#messageNumber#" connection="cf.gmail">
       <cfset rc.attachments = ArrayNew(1)>
      </cfloop>
      <cfreturn rc>
  </cffunction>

  <cffunction name="publishBlog" returntype="any">
    <cfargument name="blogURL">
    <cfset var blog = "">
    <cfset var blogJSON = {}>
    <cfset var blogObject = {}>
    <!--- CHORE! First we need to get it --->
    <cfset blogJSON["draft"] = "false">
    <cfhttp port="8080" username="admin" password="bugg3rm33" url="http://46.51.188.170/alfresco/service/api/blog/post/node/#arguments.blogURL#" method="get" result="blog"></cfhttp>
    <cfset blogObject = DeSerializeJSON(blog.fileContent)>
    <cfset blogJSON["title"] = blogObject.item.title>
    <cfset blogJSON["content"] = blogObject.item.content>
    <cfset blogJSON["tags"] = blogObject.item.tags>
    <cfhttp port="8080" username="admin" password="bugg3rm33" url="http://46.51.188.170/alfresco/service/api/blog/post/node/#arguments.blogURL#" method="PUT" result="blog">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#serializeJSON(blogJSON)#">
    </cfhttp>
    <cfreturn DeSerializeJSON(blog.fileContent)>
  </cffunction>

  <cffunction name="press" returntype="void">
    <cfargument name="userRecord" type="query" required="true">
    <cfargument name="subject">
    <cfargument name="body">
    <cfargument name="htmlbody">
    <cfargument name="textbody">
    <cfargument name="attachments">
    <cfargument name="attachmentNames">
    <cfset var blogObject = {}>
    <cfset var result = "">
    <cfif userRecord.bvusername eq "" OR userRecord.bvpassword eq "">
      <cfmail from="no-reply@buildingvine.com" to="#userRecord.email#" subject="Error with Press release">You do not have a Building Vine Username or Password. Sorry!</cfmail>
    <cfelse>
      <cfset blogObject["title"] = arguments.subject>
      <cfif arguments.htmlbody neq "">
        <cfset blogObject["content"] = paraGraphFormat(arguments.body)>
      <cfelse>
        <cfset blogObject["content"] = paraGraphFormat(arguments.body)>
      </cfif>
      <cfset blogObject["tags"] = ["Press Release"]>
      <cfset blogObject["draft"] = "true">
      <cfhttp username="#userRecord.bvusername#" password="#userRecord.bvpassword#" port="8080" url="http://46.51.188.170/alfresco/service/api/blog/site/#userRecord.bvsiteid#/blog/posts" method="post" result="blogpost">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(blogObject)#">
      </cfhttp>
      <cfset result = DeSerializeJSON(blogpost.fileContent)>
      <!--- now reply to the sender, giving them the URL to "confirm the blog" --->
      <cfmail from="no-reply@buildingvine.com" subject="Your Press Relase" to="#userRecord.email#" server="46.51.188.170">You now need to confirm your press release by visiting the following link:

https://46.51.188.170/tools/confirmAction?action=publishBlog&actionUrl=#Replace(result.item.nodeRef,":/","")#


Thank you.

Building Vine Automation

      </cfmail>
    </cfif>

  </cffunction>

  <cffunction name="promotions" returntype="void">
    <cfargument name="userRecord" type="query" required="true">
    <cfargument name="subject">
    <cfargument name="body">
    <cfargument name="htmlbody">
    <cfargument name="textbody">
    <cfargument name="attachments">
    <cfargument name="attachmentNames">
    <cfset var content = "">
    <cfset var result = "">
    <cfif userRecord.bvusername eq "" OR userRecord.bvpassword eq "">
      <cfmail from="no-reply@buildingvine.com" to="#userRecord.email#" subject="Error with Press release">You do not have a Building Vine Username or Password. Sorry!</cfmail>
    <cfelse>
      <cfif arguments.htmlbody neq "">
        <cfset content = paraGraphFormat(arguments.body)>
      <cfelse>
        <cfset content = paraGraphFormat(arguments.body)>
      </cfif>
      <cfhttp username="#userRecord.bvusername#" password="#userRecord.bvpassword#" port="8080" url="http://46.51.188.170/alfresco/service/bv/promotion" method="post" result="promotion">
        <cfhttpparam type="formfield" name="siteID" value="#userRecord.bvsiteid#">
        <cfhttpparam type="formfield" name="title" value="#arguments.subject#">
        <cfhttpparam type="formfield" name="description" value="#content#">
        <cfhttpparam type="formfield" name="draft" value="true">
      </cfhttp>
      <cfset result = DeSerializeJSON(promotion.fileContent)>
      <!--- now add the files --->
      <cfloop from="1" to="#arrayLen(arguments.attachments)#" index="i">
        <cfhttp username="#userRecord.bvusername#" password="#userRecord.bvpassword#" port="8080" url="http://46.51.188.170/alfresco/service/api/upload" method="post" result="promotion">
          <cfhttpparam type="formfield" name="destination" value="workspace://SpacesStore/#result.nodeRef#">
          <cfhttpparam type="file" name="#arguments.attachmentNames[i]#" file="#arguments.attachments[i]#">
        </cfhttp>
      </cfloop>
      <!--- now reply to the sender, giving them the URL to "confirm the blog" --->
      <cfmail from="no-reply@buildingvine.com" subject="Your Promotion" to="#userRecord.email#" server="46.51.188.170">You now need to confirm your press release by visiting the following link:

https://46.51.188.170/tools/confirmAction?action=publishPromotion&actionUrl=workspace/SpacesStore/#result.nodeRef#


Thank you.

Building Vine Automation
      </cfmail>
    </cfif>

  </cffunction>

  <cffunction name="findUser" returntype="query">
    <cfargument name="email">
    <cfargument name="site">
    <cfset var returnOb = structNew()>
    <cfset var user = "">
    <!--- we'll try cemco first --->
    <cfquery name="user" datasource="eGroup_cemco">
      select
          contact.*,
          company.bvsiteid
        from
          contact,
          company
        where
          contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        AND
          company.id = contact.company_id
    </cfquery>
    <cfif user.recordCount eq 0>
      <cfquery name="user" datasource="eGroup_cbagroup">
        select
          contact.*,
          company.bvsiteid
        from
          contact,
          company
        where
          contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        AND
          company.id = contact.company_id
      </cfquery>
      <cfif user.recordCount eq 0>
        <cfquery name="user" datasource="eGroup_handbgroup">
          select
          contact.*,
          company.bvsiteid
        from
          contact,
          company
        where
          contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        AND
          company.id = contact.company_id
        </cfquery>
      </cfif>
    </cfif>
    <cfreturn user>
  </cffunction>
  <cfscript>
  function getEmails(str) {
    var email = "(['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel)))";
    var res = [];
    var marker = 1;
    var matches = "";

    matches = reFindNoCase(email,str,marker,marker);

    while(matches.len[1] gt 0) {
        arrayAppend(res,mid(str,matches.pos[1],matches.len[1]));
        marker = matches.pos[1] + matches.len[1];
        matches = reFindNoCase(email,str,marker,marker);
    }
    return res;
  }
  function findAutomaton(cc,to,headers) {
    var retStruct = {};
    if (ArrayLen(cc) gte 1) {
     // someone is in the CC;
     for (i=1;i<=ArrayLen(cc);i++) {
      tmp2 = ListToArray(cc[i],"@");
      tmp = ListToArray(tmp2[1],".");
        if (tmp[1] eq "promotions" OR tmp[1] eq "intranet" OR tmp[1] eq "private" OR tmp[1] eq "public" OR tmp[1] eq "shared" OR tmp[1] eq "press") {
          ArrayDeleteAt(cc,i);
          retStruct.automaton = tmp[1];
          retStruct.cc = cc;
          retStruct.to = to;
          retStruct.headers = headers;
          return retStruct;
          break;
        }
     }
   }
   if (ArrayLen(to) gte 1) {
      for (i=1;i<=ArrayLen(to);i++) {
      tmp2 = ListToArray(to[i],"@");
      tmp = ListToArray(tmp2[1],".");
        if (tmp[1] eq "promotions" OR tmp[1] eq "intranet" OR tmp[1] eq "private" OR tmp[1] eq "public" OR tmp[1] eq "shared" OR tmp[1] eq "press") {
          ArrayDeleteAt(to,i);
          retStruct.automaton = tmp[1];
          retStruct.cc = cc;
          retStruct.to = to;
          retStruct.headers = headers;
          return retStruct;
          break;
        }
     }
   }
   if (ArrayLen(headers) gte 1) {
     for (i=1;i<=ArrayLen(headers);i++) {
      tmp2 = ListToArray(headers[i],"@");
      tmp = ListToArray(tmp2[1],".");
        if (tmp[1] eq "promotions" OR tmp[1] eq "intranet" OR tmp[1] eq "private" OR tmp[1] eq "public" OR tmp[1] eq "shared" OR tmp[1] eq "press") {
          ArrayDeleteAt(headers,i);
          retStruct.automaton = tmp[1];
          retStruct.cc = cc;
          retStruct.to = to;
          retStruct.headers = headers;
          return retStruct;
          break;
        }
     }
   }
   return retStruct;

  }
  </cfscript>
</cfcomponent>