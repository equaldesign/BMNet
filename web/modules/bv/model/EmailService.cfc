<cfcomponent>
    <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
    <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
    <cffunction name="getMessage" returntype="any">
      <cfargument name="nodeRef">
       <cfset var ticket = request.buildingVine.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/email/message?nodeRef=#listLast(nodeRef,'/')#&alf_ticket=#ticket#" result="message"></cfhttp>
      <cfreturn DeSerializeJSON(message.fileContent)>
    </cffunction>
  <cffunction name="parseRaw" returntype="any">
    <cfargument name="downloadURL" required="true" default="raw">
	  <cfargument name="fileData" required="true" default="none">
	  <cfif arguments.fileData eq "none">
      <cfset var ticket = request.buildingVine.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco#downloadURL#?ticket=#ticket#" result="rawmessage"></cfhttp>
      <cfset myEmailString = rawmessage.fileContent>
	  <cfelse>
  	  <cfset myEmailString = arguments.fileData>
	  </cfif>
    
  <cfscript> 
    myStream = createObject("java","java.io.ByteArrayInputStream").init(myEmailstring.getBytes());
    // Create a java mimemessage and feed it our source inputSteam
    // Set up a fake MailSession so we can ingest emails from a file
    variables.alfNodeName = ListFirst(ListLast(arguments.downloadURL,"/"),".");
    local.props = createObject("java", "java.util.Properties").init();
    local.props.put( javacast("string", "mail.host"), javacast("string", "smtp.somedomain.com"));
    local.props.put( javacast("string", "mail.transport.protocol"),  javacast("string", "smtp"));
    local.mailSession = createObject("java", "javax.mail.Session").getDefaultInstance(local.props,javacast("null", ""));

    local.message = createObject("java", "javax.mail.internet.MimeMessage").init(local.mailSession, myStream);

    local.recipientObj = createObject("java", "javax.mail.Message$RecipientType");

    // Set up our data structure to hold all the elements of the mail object.
    local.mailStruct = structNew();
    local.mailStruct.subject = "";
    local.mailStruct.from = "";
    local.mailStruct.toRecipients = "";
    local.mailStruct.ccRecipients = "";
    local.mailStruct.receivedDate = "";
    local.mailStruct.sentDate = "";
    local.mailStruct.attachments = arrayNew(1);
    local.mailStruct.bodyParts = structNew();
    local.mailStruct.bodyParts.html = arrayNew(1);
    local.mailStruct.bodyParts.text = arrayNew(1);


    // Handle all the header stuff.  Mostly just to: and from: at this point.
    local.mailStruct.subject = fixNull(local.message.getSubject());
    local.mailStruct.from = parseAddress(fixNull(local.message.getFrom()));
    local.mailStruct.toRecipients = parseAddress(fixNull(local.message.getRecipients(local.recipientObj.TO)));
    local.mailStruct.ccRecipients = parseAddress(fixNull(local.message.getRecipients(local.recipientObj.CC)));
    local.mailStruct.receivedDate = fixNull(local.message.getReceivedDate());
    local.mailStruct.sentDate = fixNull(local.message.getSentDate());

    // Handle the body stuff.
    parseEmailBody(local.message,local.mailStruct,"#ApplicationStorage.getVar('appRoot',getTempDirectory())#/cache/");
    return fixInlineImages(local.mailStruct);
</cfscript>


  </cffunction>

<cffunction name="fixInlineImages" returntype="struct">
  <cfargument name="emailStruct" required="true">
  <cfif arrayLen(emailStruct.bodyparts.html) gte 1 AND arrayLen(emailStruct.attachments) gte 1>
    <!--- only support one html attachement --->
    <cfset htmlmessage = emailStruct.bodyparts.html[1]>
    <cfset findstart = 1>
    <cfloop index="i" from="1" to="25">
      <cfset stringStart[i] = Find('"cid:', htmlmessage, findstart)>
      <cfif (stringstart[i] EQ 0)>
        <cfbreak>
      </cfif>
      <cfset findstart = stringstart[i] +5 >
      <cfset rightpart[i]=Mid(htmlmessage, findstart, 30)>
      <cfset imagename[i]=ListFirst(rightpart[i], '"')>
      <cfset imagenameFix[i]=ListFirst(imagename[i], '@')>
      <cfloop array="#emailStruct.attachments#" index="attachment">
        <cfif ListLast(attachment,"/") EQ "#variables.alfNodeName#_#imagenameFix[i]#">
          <cfset htmlmessage = Replace(htmlmessage,"cid:#imagename[i]#","/eunify/email/getImage?file=#variables.alfNodeName#_#imagenameFix[i]#")>
        </cfif>
      </cfloop>
    </cfloop>
    <cfset emailStruct.bodyparts.html[1] = htmlmessage>
    <cfreturn emailStruct>
  <cfelse>
    <cfreturn emailStruct>
  </cfif>
</cffunction>

<cffunction name="parseEmailBody" output="false">
    <cfargument name="messagePart" required="true" />
    <cfargument name="mailStruct" required="true" />
    <cfargument name="attachDir" required="true" />
    <cfset var local=structNew()>
    <cfscript>
        if (arguments.messagePart.isMimeType("text/plain")) {
            // Text Body Part
            arrayAppend(arguments.mailStruct.bodyParts.text,arguments.messagePart.getContent());
        } else if (arguments.messagePart.isMimeType("text/html")) {
            // HTML Body Part
            arrayAppend(arguments.mailStruct.bodyParts.html,arguments.messagePart.getContent());
        } else {
            // this is a multipart email part.
            local.mp = arguments.messagePart.getContent();
            try {
              local.count = local.mp.getCount();
            } catch (any e) {
               WriteDump(e);
               abort;

            }
            for(local.i=0; local.i < local.count; local.i++) {
                    local.part = local.mp.getBodyPart(javacast("int",local.i));
                    local.disp = local.part.getFileName(); // getDisposition() doesn't work??
                    if (  isDefined("local.disp") && (UCase(local.disp) neq "UNDEFINED") ) {
                      /* This is an attachment.  Handle accordingly */
                      local.newFileName = "#arguments.attachDir#" & variables.alfNodeName & "_" & part.getFileName();
                      inputStream = part.getInputStream();
                      outStream = createObject("java","java.io.ByteArrayOutputStream").init();

                      // create byte array. read up to the first
                      // 1024 bytes (or however many) into the array
                      byteClass = createObject("java", "java.lang.Byte").TYPE;
                      byteArray = createObject("java","java.lang.reflect.Array").newInstance(byteClass, javacast("int", 1024));
                      length = inputStream.read(byteArray);

                      // if there is any data to read
                      offset = 0;
                      while ( length GT 0) {
                        outStream.write( byteArray, offset, length );
                        length = inputStream.read( byteArray );
                      }

                      outStream.close();
                      inputStream.close();

                      FileWrite( local.newFileName, outStream.toByteArray() );
                      arrayAppend(arguments.mailStruct.attachments,local.newFileName);
                    } else {
                        /* This part is not a binary attachment - could be another multipart bit,
                            or could be a single part.  Either way, we need to run it through again
                            to see what it is and handle it properly.
                        */
                        parseEmailBody(local.part,arguments.mailStruct,arguments.attachDir);
                    }
            }
        }
    </cfscript>
</cffunction>

<cffunction name="parseAddress" output="false">
    <cfargument name="addressObj" required="true" />
    <cfset var local=structNew()>
    <cfscript>
        local.addressArray = ArrayNew(1);
        if (isArray(arguments.addressObj)) {
            for (local.i=1; local.i lte arrayLen(arguments.addressObj); local.i++) {
                local.addressArray[local.i] = arguments.addressObj[local.i].getAddress();
            }
        }
        return local.addressArray;
    </cfscript>
</cffunction>

<cffunction name="fixNull" access="private" output="false">
    <cfargument name="valueToFix" default="" />
    <cfset rStr = "" />
    <cfif isDefined("arguments.valueToFix")>
        <cfset rStr = arguments.valueToFix />
    </cfif>
    <cfreturn rStr />
</cffunction>
</cfcomponent>