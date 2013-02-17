<cfcomponent>

  <cfproperty name="dsn" inject="coldbox:datasource:bugs" />
  <cffunction name="check" returntype="Any">
    <cfquery name="messages" datasource="#dsn.getName()#">
      select * from incoming;
    </cfquery>
    <cfloop query="messages">
		  <cfset ticketWithin = "subject">
		  <cfset toEmail = ListGetAt(getEmails(mailto),1)>      
      <cfset fromName = ReReplaceNoCase(mailfrom, "<[^>]*>", "", "ALL")>
      <cfset fromEmail = ListGetAt(getEmails(mailfrom),1)>
      <cfset subject = subject>
      <cfset subject = Trim(ReplaceNoCase(subject,"Re:","","ALL"))>
      <cfset ticket = Trim(ReplaceNoCase(subject," ","","ALL"))>
      <cfset ticketA = ReFindNoCase("[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}",subject,1,true)>
      <cfif ticketA.len[1] eq 0>
	     <cfset ticketA = ReFindNoCase("[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}",textbody,1,true)>
		   <cfset ticketWithin = "body">
	    </cfif>
        <cfswitch expression="#ListGetAt(ListGetAt(toEmail,1,'@'),1,'.')#">
			    <cfcase value="eGroup">
					  <cfset functionType = ListGetAt(ListGetAt(toEmail,1,'@'),2,'.')>
					  <cfif ticketWithin eq "subject">
					    <cfset ticket = mid(subject,ticketA.pos[1],ticketA.len[1])>
					  <cfelse>
					  	<cfset ticket = mid(textbody,ticketA.pos[1],ticketA.len[1])>
					  </cfif>
					  <cfset userObject = findUser(fromEmail,ticket)>
					  <cfset doeGroup(functionType,ticket,userObject,textbody)>
				  </cfcase>
          <cfcase value="buildersmerchant">
            <cfset functionType = ListGetAt(ListGetAt(toEmail,1,'@'),2,'.')>
            <cfif ticketWithin eq "subject">
              <cfset ticket = mid(subject,ticketA.pos[1],ticketA.len[1])>
            <cfelse>
              <cfset ticket = mid(textbody,ticketA.pos[1],ticketA.len[1])>
            </cfif>
            <cfset userObject = findUser(fromEmail,ticket)>
            <cfset doBMNet(functionType,ticket,userObject,textbody)>
          </cfcase>
			    <cfdefaultcase>
            <cfset system = ListGetAt(ListGetAt(toEmail,2,'@'),1,'.')>
            <cflog application="true" text="#system#">
            <cfif system neq "buildersmerchant">
              <cfset system = "intranet">
            <cfelse>
              <cfset system = "BMNet">
            </cfif>
					  <cfset userObject = findUser(fromEmail,system)>
		        <cfif ticketA.len[1] neq 0>
		          <cfset newTicket = false>
		          <cfset ticket = mid(subject,ticketA.pos[1],ticketA.len[1])>
		          <cfquery name="bug" datasource="bugs">
		            select * from bug where ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ticket#">
		          </cfquery>
		          <cfif bug.recordCount eq 0>
		            <cfset newTicket = true>
		            <cfset ticket = createUUID()>
		          </cfif>
		        <cfelse>
		          <cfset newTicket = true>
		          <cfset ticket = createUUID()>
		        </cfif>
		        <cfset userObject = findUser(fromEmail)>
		        <cfif newTicket>
		          <cfquery name="alreadyexists" datasource="bugs">
		            select id from bug where description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#textbody#">
		          </cfquery>
		          <cfif alreadyexists.recordCount eq 0>
		            <cfquery name="generateTicket" datasource="bugs">
		              insert into bug (title,ticket,description,status,priority,contactID,email,username,site,created,type,system)
		              values
		              (
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ticket#">,
		                <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#textbody#">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="open">,
		                <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
		                <cfqueryparam cfsqltype="cf_sql_integer" value="#userObject.user.id#">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#fromEmail#">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#userObject.user.first_name# #userObject.user.surname#">,

		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#userObject.site#">,
		                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="help">,
		                <cfqueryparam cfsqltype="cf_sql_varchar" value="#system#">
		              )
		            </cfquery>

		            <cfloop list="#attachments#" delimiters="#Chr(9)#" index="attach">
		              <cfquery name="insertAttach" datasource="bugs">
		                insert into attachment (ticket,filename) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ticket#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attach#">)
		              </cfquery>
		            </cfloop>
		            <cfmail server="email-smtp.us-east-1.amazonaws.com" username="AKIAI3EY3YSOVJF37TRA" password="AsBr0dGv8iX6TJf0RPnihRzMhtw42VAeRWu/9rpuToD7" subject="Ticket: #ticket#" to="#mailfrom#" from="eBiz Support <#toEmail#>" bcc="tom.miller@ebiz.co.uk,james.colin@ebiz.co.uk">
Your issue has been assigned a ticket number of: #ticket#

Your issue has been added to our database, and you will be notified when it has been resolved.

You can track the status of this ticket at the following URL:

http://help.ebiz.co.uk/bugs/bugs/detail?ticket=#ticket#&key=#hash(fromEmail)#


Many Thanks,


eBiz Support.


Ticket details
--------------------------------------
Ticket: #ticket#
Title: #subject#
DETAILS: #textbody#
		            <cfloop list="#attachments#" delimiters="#Chr(9)#" index="attach">
		              <cfmailparam file="#attach#" disposition="attachment" />
		            </cfloop>

		            </cfmail>
		          </cfif>
		        <cfelse>
		          <!--- create a comment against an existing ticket, maybe --->
              <cfset var commands = checkCommands(textbody,ticket)>
              <cfif commands.doComment>
                <cfquery name="alreadyexists" datasource="bugs">
                  select id from comment where comment = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#commands.body#">
                </cfquery>
                <cfif alreadyexists.recordCount eq 0>
                <cfquery name="generateTicket" datasource="bugs">
                  insert into comment (title,email,username,comment,bugID)
                  values
                  (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#fromEmail#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#userObject.user.first_name# #userObject.user.surname#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#commands.body#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#bug.id#">
                  )
                </cfquery>
                <cfloop list="#attachments#" delimiters="#Chr(9)#" index="attach">
                  <cfquery name="insertAttach" datasource="bugs">
                    insert into attachment (ticket,filename) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ticket#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attach#">)
                  </cfquery>
                </cfloop>
                <cfif fromEmail neq bug.email>
                    <cfset t = "#bug.username# <#bug.email#>">
                <cfelse>
                  <cfset t = "Tom Miller <tom.miller@ebizuk.net>">
                </cfif>
                <cfset ticketStatus = bug.status>
                <cfif FindNoCase("*CLOSED*",subject) neq 0>
                  <cfset ticketStatus = "closed">
                <cfelseif FindNoCase("*OPEN*",subject) neq 0>
                  <cfset ticketStatus = "open">
                </cfif>

                  <cfmail failto="tom.miller@ebiz.co.uk" to="#t#" subject="Ticket: #bug.ticket#" from="eBiz Support <#toEmail#>" bcc="tom.miller@ebiz.co.uk,james.colin@ebiz.co.uk">
#commands.body#

--------------------------------------------------

#bug.username#,

#userObject.user.first_name# #userObject.user.surname# has responded to your ticket. You can respond by replying to this email, and your repsonse will be logged alongside your ticket.

You can also view the status of this ticket using the following URL:

http://help.ebiz.co.uk/bugs/bugs/detail?ticket=#ticket#&key=#hash(t)#

Please note this URL is encyrpted and only someone with the url above can access it.

<cfif ticketStatus eq "closed">
NOTE.

This ticket is now closed. If you do not feel this ticket has been resolved, you can still respond and outline any issues that still remain.

</cfif>

Ticket details
==================================================
Ticket: #bug.ticket#
Title: #bug.title#
Status: #bug.status#


Many Thanks,


eBiz Support



=========    END MESSAGE     ======================
                   <cfloop list="#attachments#" delimiters="#Chr(9)#" index="attach">
                    <cfmailparam file="#attach#" disposition="attachment" />
                  </cfloop>
                  </cfmail>
                  <cfdump var="#commands#"><cfabort>
                  <cfquery name="c" datasource="bugs">
                    update bug set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ticketStatus#">
                    where
                    ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ticket#">
                  </cfquery>
                </cfif>
		          </cfif>
		        </cfif>
		        <cfset rc.attachments = ArrayNew(1)>
          </cfdefaultcase> 
        </cfswitch>         
      </cfloop> 
      <!--- now delete the messages --->
      <cfquery name="d" datasource="#dsn.getName()#">
        delete from incoming;
      </cfquery>
      <cfreturn messages>
  </cffunction>

  <cffunction name="findUser" returntype="struct">
    <cfargument name="email" required="true">
	  <cfargument name="ticket" required="true" default="" >
    <cfset returnOb = structNew()>
	  <cfif ticket neq "">
	  	<!--- we have a ticket --->
      <cfquery name="bmnet" datasource="BMnet">
        select siteID from subscriptions where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfquery>
      <cfif bmnet.recordCount gte 1>
        <cfquery name="u" datasource="BMnet">
          select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
          AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bmnet.siteID#">
        </cfquery>
        <cfset returnOb.system = "bmnet">
        <cfset returnOb.site = bmnet.siteID>
        <cfset returnOb.user = u>
        <cfreturn returnOb>
      </cfif>

      <!--- we have a ticket --->
	  	<cfquery name="handbgroup" datasource="eGroup_handbgroup">
        select id from subscriptions where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfquery>
      <cfif handbgroup.recordCount gte 1>
	  	  <cfquery name="u" datasource="eGroup_handbgroup">
          select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        </cfquery>
        <cfset returnOb.system = "intranet">
        <cfset returnOb.site = "eGroup_handbgroup">
        <cfset returnOb.user = u>
        <cfreturn returnOb>
      </cfif>
      <cfquery name="cba" datasource="eGroup_cbagroup">
        select id from subscriptions where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfquery>
      <cfif cba.recordCount gte 1>
	  	    <cfquery name="u" datasource="eGroup_cbagroup">
            select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
          </cfquery>
          <cfset returnOb.system = "intranet">
          <cfset returnOb.site = "eGroup_cbagroup">
          <cfset returnOb.user = u>
          <cfreturn returnOb>
      </cfif>
      <cfquery name="cemco" datasource="eGroup_cemco">
        select id from subscriptions where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfquery>
      <cfif cemco.recordCount gte 1>
	  	    <cfquery name="u" datasource="eGroup_cemco">
            select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
          </cfquery>
          <cfset returnOb.system = "intranet">
          <cfset returnOb.site = "eGroup_cemco">
          <cfset returnOb.user = u>
          <cfreturn returnOb>
      </cfif>
       <cfquery name="nbg" datasource="eGroup_nbg">
        select id from subscriptions where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfquery>
      <cfif nbg.recordCount gte 1>
	  	  <cfquery name="u" datasource="eGroup_nbg">
          select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        </cfquery>
        <cfset returnOb.system = "intranet">
        <cfset returnOb.site = "eGroup_nbg">
        <cfset returnOb.user = u>
        <cfreturn returnOb>
      </cfif>
      <cfset returnOb.system = "unknown">
      <cfset returnOb.site = "ebiz">
      <cfset returnOb.user = QueryNew("id,first_name,surname,company")>
      <cfset QueryAddRow(returnOb.user)>
      <cfset QuerySetCell(returnOb.user,"id",1)>
      <cfset QuerySetCell(returnOb.user,"first_name","unknown")>
      <cfset QuerySetCell(returnOb.user,"surname","user")>
      <cfset QuerySetCell(returnOb.user,"company","ebiz")>
	  <cfelse>
      <cfset foundInstances = 0>
	    <cfquery name="handbgroup" datasource="eGroup_handbgroup">
	      select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
	    </cfquery>
	    <cfif handbgroup.recordCount gte 1>
	      <cfset returnOb.system = "intranet">
	      <cfset returnOb.site = "eGroup_handbgroup">
	      <cfset returnOb.user = handbgroup>
	      <cfset foundInstances++>
	    </cfif>
	    <cfquery name="cba" datasource="eGroup_cbagroup">
	      select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
	    </cfquery>
	    <cfif cba.recordCount gte 1>
	        <cfset returnOb.system = "intranet">
	        <cfset returnOb.site = "eGroup_cbagroup">
	        <cfset returnOb.user = cba>
	        <cfset foundInstances++>
	    </cfif>
	    <cfquery name="cemco" datasource="eGroup_cemco">
	      select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
	    </cfquery>
	    <cfif cemco.recordCount gte 1>
	        <cfset returnOb.system = "intranet">
	        <cfset returnOb.site = "eGroup_cemco">
	        <cfset returnOb.user = cemco>
	        <cfset foundInstances++>
	    </cfif>

	    <cfquery name="nbg" datasource="eGroup_nbg">
	      select * from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
	    </cfquery>
	    <cfif nbg.recordCount gte 1>
	      <cfset returnOb.system = "intranet">
	      <cfset returnOb.site = "eGroup_nbg">
	      <cfset returnOb.user = nbg>
	      <cfset foundInstances++>
	    </cfif>
      <cfif foundInstances eq 1>
        <cfreturn returnOb>
      </cfif>
	    <cfset returnOb.system = "unknown">
	    <cfset returnOb.site = "ebiz">
	    <cfset returnOb.user = QueryNew("id,first_name,surname,company")>
	    <cfset QueryAddRow(returnOb.user)>
	    <cfset QuerySetCell(returnOb.user,"id",1)>
	    <cfset QuerySetCell(returnOb.user,"first_name","unknown")>
	    <cfset QuerySetCell(returnOb.user,"surname","user")>
	    <cfset QuerySetCell(returnOb.user,"company","ebiz")>
	  </cfif>
    <cfreturn returnOb>
  </cffunction>
  <cffunction name="doeGroup" returntype="void">
    <cfargument name="fType" required="true">
	  <cfargument name="ticketA" required="true">
	  <cfargument name="userObject" required="true">
	  <cfargument name="emailBody" required="true">
	  <cfswitch expression="#arguments.fType#">
	    <cfcase value="comment">
			   <cfset BodyFind = FindNoCase("--",emailBody)>
			   <cfif BodyFind eq 0>
			     <cfset BodyFind = FindNoCase("From",emailBody,1)>
			   </cfif>
			   <cfset JustThisContent = Left(emailBody,BodyFind-1)>
			   <!--- someone has responded to a comment via email --->
			   <cfswitch expression="#userObject.site#">
			     <cfcase value="handbgroup">
				 	   <cfset postURL = "http://www.handbgroup.com">
				 	   <!--- simply post to handb --->
				   </cfcase>
				   <cfcase value="cemco">
             <cfset postURL = "http://www.cemco.co.uk">
             <!--- simply post to handb --->
           </cfcase>
			   </cfswitch>
			   <cfhttp method="post" url="#postURL#/comment/add" result="postComment">
			     <cfhttpparam type="formfield" name="commentKey" value="#arguments.ticketA#">
				   <cfhttpparam type="formfield" name="comment" value="#JustThisContent#">
				   <cfhttpparam type="formfield" name="contactID" value="#arguments.userObject.user.id#">
			   </cfhttp>
			   <cfoutput>#postComment.fileContent#</cfoutput><cfabort>
		  </cfcase>
	  </cfswitch>
  </cffunction>

  <cffunction name="doBMNet" returntype="void">
    <cfargument name="fType" required="true">
    <cfargument name="ticketA" required="true">
    <cfargument name="userObject" required="true">
    <cfargument name="emailBody" required="true">
    <cfswitch expression="#arguments.fType#">
      <cfcase value="comment">
         <cfset BodyFind = FindNoCase("--",emailBody)>
         <cfif BodyFind eq 0>
           <cfset BodyFind = FindNoCase("From",emailBody,1)>
         </cfif>
         <cfset JustThisContent = Left(emailBody,BodyFind-1)>
         <cfquery name="site" datasource="BMNet">
            select host from site where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#userObject.site#">
          </cfquery>
         <cfhttp method="post" url="http://#listFirst(site.host)#/eunify/comment/add" result="postComment">
           <cfhttpparam type="formfield" name="commentKey" value="#arguments.ticketA#">
           <cfhttpparam type="formfield" name="comment" value="#JustThisContent#">
           <cfhttpparam type="formfield" name="contactID" value="#arguments.userObject.user.id#">
         </cfhttp>
         <cfoutput>#postComment.fileContent#</cfoutput><cfabort>
      </cfcase>
    </cfswitch>
  </cffunction>

  <!--- placeHolderReplacer --->
  <cffunction name="checkCommands" access="public" returntype="struct" hint="PlaceHolder Finder for strings containing ${} patterns" output="false" >
    <!---************************************************************************************************ --->
    <cfargument name="str" 		required="true" type="any" hint="The string variable to look for instances">
    <cfargument name="ticket" 		required="true" type="any" hint="The ticketnum">
    <!---************************************************************************************************ --->
    <cfscript>
      var returnString = arguments.str;
      var regex = "\{([0-9a-z\-\.\_\:\@\=]+)\}";
      var lookup = 0;
      var varName = 0;
      var returnObject = {};
      var commands = ArrayNew(1);
      /* Loop and Replace */
      returnObject.body = str;
      while(true){
        /* Search For Pattern */
        lookup = reFindNocase(regex,returnString,1,true);
        /* Found? */
        if( lookup.pos[1] ){
          /* Get Variable Name From Pattern */
          varName = mid(returnString,lookup.pos[2],lookup.len[2]);
          /* Lookup Value */
          /* Remove PlaceHolder Entirely */
          returnString = removeChars(returnString, lookup.pos[1], lookup.len[1]);

          ArrayAppend(commands,varName);

          /* Insert Var Value */
        }
        else{
          break;
        }
      }
      /* Return Parsed String. */
      returnObject.body = returnString;
      returnObject = doCommands(returnObject,ticket,commands);
      return returnObject;
    </cfscript>
  </cffunction>

  <cffunction name="doCommands" returntype="struct">
    <cfargument name="strc" required="true" type="struct" hint="The Starting Structure">
    <cfargument name="ticket" required="true" type="string" hint="The current Ticket Number">
    <cfargument name="commands" required="true" type="array" hint="An Array of commands to perform">
    <cfset var returnObject = arguments.strc>
    <cfset returnObject.doComment = true>
    <cfloop array="#arguments.commands#" index="cmd">
      <cfset commandA = listToArray(cmd,":")>
      <cfset theCommand = commandA[1]>
      <cfset theValue = commandA[2]>
      <cfswitch expression="#theCommand#">
        <cfcase value="assignTo">
          <!--- assign the ticket to a user --->
          <cfset returnObject.body = "----#chr(13)#Ticket Update: This ticket has been reassigned to: #theValue##chr(13)#----#chr(13)##chr(13)##returnObject.body#">
        </cfcase>
        <cfcase value="fixDate">
          <!--- assign a fix date --->
          <cfset returnObject.body = "----#chr(13)#Ticket Update: This ticket has been assign a fix date ETA of: #theValue##chr(13)#----#chr(13)##chr(13)##returnObject.body#">
        </cfcase>
        <cfcase value="releaseVersion">
          <!--- assign a release Version --->
          <cfset returnObject.body = "----#chr(13)#Ticket Update: This ticket has been assign a fix version Number of: #theValue##chr(13)#----#chr(13)##chr(13)##returnObject.body#">
        </cfcase>
        <cfcase value="status">
          <!--- assign a release Version --->
          <cfset returnObject.body = "----#chr(13)#Ticket Update: This ticket has changes status to: #theValue##chr(13)#----#chr(13)##chr(13)##returnObject.body#">
        </cfcase>
        <cfcase value="sendresponse">
          <cfset returnObject.doComment = theValue>
        </cfcase>
      </cfswitch>
    </cfloop>
    <cfreturn returnObject>
  </cffunction>

  <cfscript>
  function getEmails(str) {
    var email = "(['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel)))";
    var res = "";
    var marker = 1;
    var matches = "";

    matches = reFindNoCase(email,str,marker,marker);

    while(matches.len[1] gt 0) {
        res = listAppend(res,mid(str,matches.pos[1],matches.len[1]));
        marker = matches.pos[1] + matches.len[1];
        matches = reFindNoCase(email,str,marker,marker);
    }
    return res;
}
  </cfscript>
</cfcomponent>