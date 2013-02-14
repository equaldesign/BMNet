<cfcomponent>
  <cfproperty name="ContactService" inject="id:eunify.ContactService">
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService">
  <cfproperty name="TagService" inject="id:eunify.TagService">
  <cffunction name="salesForceImport">
    <cfsetting requesttimeout="900">
    <cfquery name="companies" datasource="BMNet">
      select * from companyTmp
    </cfquery>
    <cfloop query="companies">
      <cfquery name="findCo" datasource="BMNet">
        select id from company where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <cfif findCo.recordCount eq 0>
        <cfquery name="i" datasource="BMNet">
          insert into company
            (account_number,name,company_address_1,company_address_4,company_address_5,company_postcode,company_phone,company_fax,company_website,siteID)
            VALUES
            (
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#street#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#city#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#state#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#postcode#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#phone#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#website#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
            )
        </cfquery>
      <cfelse>
        <cfquery name="u" datasource="BMNet">
          update company set account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
          where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#findCo.id#">
        </cfquery>
      </cfif>
    </cfloop>
    <cfquery name="contacts" datasource="BMNet">
      select * from contactTmp
    </cfquery>
    <cfloop query="contacts">
      <cfquery name="com" datasource="BMNet">
        select id from company where account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountID#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">      
      </cfquery>
      <cfif com.recordCOunt neq 0>
        <cfset comID = com.id>
      <cfelse>
        <cfset comID = 0>
      </cfif>
      <cfquery name="emailExists" datasource="BMNet">
        select id from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <cfif emailExists.recordCount eq 0>
      <cfquery name="createContact" datasource="BMNet">
        insert into contact (first_name,surname,email,company_id,emailArchive,siteID,jobTitle)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#first_name#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#comID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="create">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#job#">

        )
      </cfquery>
      <cfelse>
        <cfquery name="a" datasource="BMNet">
          update contact set company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#comID#"> where
          email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        </cfquery>
      </cfif>
    </cfloop>
    <cfquery name="feed" datasource="BMNet">
      select * from feedTmp;
    </cfquery>
    <cfloop query="feed">
      <cfquery name="com" datasource="BMNet">
        select id from company where account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountID#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">      
      </cfquery>
      <cfif com.recordCOunt neq 0>
        <cfset comID = com.id>
      <cfelse>
        <cfset comID = 0>
      </cfif>
      <cfquery name="createContact" datasource="BMNet">
        insert into comment (content,relatedType,relatedID,security,ctype,contactID,stamp)
        VALUES
        (

          <cfqueryparam cfsqltype="cf_sql_varchar" value="#comment#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="company">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#comid#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="public">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="web">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="63244">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdDate#">
        )
      </cfquery>
      <cfquery name="commentID" datasource="BMNet">
        select LAST_INSERT_ID() as id from comment
      </cfquery>      
    </cfloop>
  </cffunction>



  <cffunction name="tageGroup" returntype="void">
  	<cfsetting requesttimeout="900000" >
  	<cfquery name="eunifyContact" datasource="BMNet">
	  	select id, email from contact where siteID = 3
	  </cfquery>
      <cfset dbA = [
        {
          name="CBA",
          ds="eGroup_cbagroup"
        },
        {
          name="CEMCO",
          ds="eGroup_cemco"
        },
        {
          name="NBG",
          ds="eGroup_nbg"
        },
        {
          name="hb Group",
          ds="eGroup_handbgroup"
        }
      ]>
	  <cfloop query="eunifyContact">
      <--- find eGroup --->
      <cfloop array="#dbA#" index="d">
        <cfquery name="existsIneGroup" datasource="#d.ds#">
          select contact.id, company.type_id from contact, company where contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#"> AND company.id = contact.company_id
        </cfquery>
        <cfif existsIneGroup.recordCount neq 0>
          <cfset typeName = "Supplier">
          <cfif existsIneGroup.type_id eq 1>
            <cfset typeName = "Merchant">
          </cfif>
          <cfif NOT TagService.hasTag("contact",eunifyContact.id,"#typeName#")>
            <cfset TagService.add("#typeName#","contact",eunifyContact.id)>
          </cfif>
        </cfif>
      </cfloop>
	  </cfloop>

  </cffunction>

  <cffunction name="removeDuplicates" returntype="void">
    <cfsetting requesttimeout="900000" >
    <cfthread action="run" name="dupes" priority="LOW" >
    <cfquery name="invoiceItems" datasource="BMNet">
      select Invoice_Header.*, CONCAT(invoice_num,quantity,product_code) as ununique from Invoice_Header group by ununique
    </cfquery>
    <cfloop query="invoiceItems">
      <cfquery name="dupes" datasource="BMNet">
        delete from Invoice_Header where invoice_num = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_num#">
      AND
      quantity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#quantity#">
      AND
      product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code#">
      AND
      id != <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
      </cfquery>
    </cfloop>
    </cfthread>
  </cffunction>

  <cffunction name="importBuildingVine" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/api/sites" username="admin" password="bugg3rm33" result="siteList"></cfhttp>
    <cfset rc.siteList = DeSerializejson(siteList.fileContent)>
    <cfloop array="#rc.siteList#" index="site">
      <cfif site.isPublic>
        <cfloop array="#site.siteManagers#" index="manager">
          <cfset eunifyContact = ContactService.getContactByEmail(emailAddress=manager,siteID=3)>
          <cfif eunifyContact.recordCount eq 0>
            <!--- get the contact --->
            <cfhttp url="http://www.buildingvine.com/alfresco/service/api/people/#manager#" username="admin" password="bugg3rm33" result="person"></cfhttp>
            <cfset rc.person = Deserializejson(person.fileContent)>
            <!--- add the contact to BM.net --->
            <cfquery name="a" datasource="BMNet">
              insert into contact (first_name,surname,email)
              VALUES
              (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.person.firstName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.person.lastName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.person.username#">
              )
            </cfquery>
            <cfquery name="n" datasource="BMNet">
              select last_insert_id() as id from contact;
            </cfquery>
            <cfset TagService.add("Building Vine","contact",n.id)>
          <cfelse>
            <cfif NOT TagService.hasTag("contact",eunifyContact.id,"Building Vine")>
              <cfset TagService.add("Building Vine","contact",eunifyContact.id)>
            </cfif>
            <!--- what about a company ??? --->
            <cfif eunifyContact.company_id eq "" OR eunifyContact.company_id eq 0>
              <cfhttp url="http://www.buildingvine.com/alfresco/service/api/people/#manager#" username="admin" password="bugg3rm33" result="person"></cfhttp>
              <cfset rc.person = Deserializejson(person.fileContent)>
              <cfset eunifyCompany = CompanyService.getcompanyByName(rc.person.organization)>
              <cfif eunifyCompany.recordCount eq 0>
                <!--- create the company --->
                <cfquery name="cc" datasource="BMNet">
                  insert into company
                    (name, known_as, type_id)
                    VALUES
                    (
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.person.organization#">,
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.person.organization#">,
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
                    )
                </cfquery>
                <cfquery name="n" datasource="BMNet">
                  select last_insert_id() as id from company
                </cfquery>
                <cfquery name="uc" datasource="BMNet">
                  update contact set company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#n.id#">
                  where
                  id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eunifyContact.id#">
                </cfquery>
              <cfelse>
                <cfquery name="uc" datasource="BMNet">
                  update contact set company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eunifycompany.id#">
                  where
                  id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eunifyContact.id#">
                </cfquery>
              </cfif>
            </cfif>
          </cfif>
        </cfloop>
      </cfif>
    </cfloop>
  </cffunction>

  <cffunction name="importeGroup" returntype="void">
		<cfsetting requesttimeout="990000">

    <cfset dbA = [
        {
          name="CBA",
          ds="eGroup_cbagroup"
        },
        {
          name="CEMCO",
          ds="eGroup_cemco"
        },
        {
          name="NBG",
          ds="eGroup_nbg"
        },
        {
          name="hb Group",
          ds="eGroup_handbgroup"
        }
      ]>
		<cfloop array="#dbA#" index="e">
			<!--- get the members --->
		  <cfquery name="members" datasource="#e.ds#">
		  	select * from company
		  </cfquery>
		  <cfloop query="members">
        <!--- does the company exist? --->
        <cfquery name="companyExists" datasource="BMNet">
          select id from company where siteID = 3 AND (
            <cfif members.bvsiteid neq "">
            bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#members.bvsiteid#">
            OR
            </cfif>
            name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#members.name#">
            <cfif members.email neq "">
            OR
            company_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#members.email#">
            </cfif>
          )
        </cfquery>
        <cfif companyExists.recordCount eq 0>
  		  	<!--- create the company --->
  			  <cfquery name="cc" datasource="BMNet">
  			  	INSERT INTO company
  				    (
  				      account_number,
  				      company_contact,
  				      contact_id,
  				      name,
  				      known_as,
  				      company_address_1,
  				      company_address_2,
  				      company_address_3,
  				      company_address_4,
  				      company_address_5,
  				      company_postcode,
  				      company_phone,
  				      company_fax,
  				      company_email,
  				      company_website,
  				      type_id,
  				      eGroup_id,
  				      eGroup_site,
  				      buildingVine,
  				      bvsiteid,
  				      siteID
  				    )
  				    VALUES
  				    (
  				      <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
  					    <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#known_as#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#address1#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#address2#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#address3#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#town#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#county#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#postcode#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#switchboard#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#web#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#e.ds#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#buildingVine#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvsiteid#">,
  						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.siteID#">
  				    )
  			  </cfquery>
  			  <cfquery name="bmc" datasource="BMNet">
  			  	select last_insert_id() as newID from company
  			  </cfquery>
          <cfset bmcompanyID = bmc.newID>
  			  <cfquery name="branches" datasource="#e.ds#">
  			  	select * from branch where company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#members.id#">
  			  </cfquery>
  			  <cfloop query="branches">
  			  	<cfquery name="branch" datasource="BMNet">
  				  	INSERT INTO branch
  					  (
  						   name,
  						   known_as,
  						   address1,
  						   address2,
  						   address3,
  						   town,
  						   county,
  						   postcode,
  						   tel,
  						   fax,
  						   email,
  						   maplong,
  						   maplat,
  						   product_types,
  						   web,
  						   siteID,
  						   company_id
  					   )
  					  VALUES
  					   (
  					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.name#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.known_as#">,
  			         <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.address1#">,
  					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.address2#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.address3#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.town#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.county#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.postcode#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.tel#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.fax#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.email#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.maplong#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.maplat#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.product_types#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#branches.web#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.siteID#">,
  							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#bmcompanyID#">
  					   )
  				  </cfquery>
  			  </cfloop>
  			<cfelse>
          <cfset bmcompanyID = companyExists.id>
          <!--- maybe update our company details? --->
          <cfquery name="update" datasource="BMNet">
            update company set
              name =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
              known_as = <cfqueryparam cfsqltype="cf_sql_varchar" value="#known_as#">,
              company_address_1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#address1#">,
              company_address_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#address2#">,
              company_address_3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#address3#">,
              company_address_4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#town#">,
              company_address_5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#county#">,
              company_postcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#postcode#">,
              company_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#switchboard#">,
              company_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#">,
              company_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
              company_website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#web#">,
              type_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
              eGroup_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
              eGroup_site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#e.ds#">,
              buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="#buildingVine#">,
              bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvsiteid#">
            WHERE
              id = <cfqueryparam cfsqltype="cf_sql_integer" value="#bmcompanyID#">
          </cfquery>
  			</cfif>
			  <!--- now get all the contacts --->
			  <cfquery name="contacts" datasource="#e.ds#">
			  	select * from contact where company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
			  </cfquery>
			  <cfloop query="contacts">
          <!--- check for a contact with us --->
          <cfquery name="contactExists" datasource="BMNet">
            select id from contact where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
            AND
            <cfif members.email neq "">
            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#members.email#">
            <cfelse>
            surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">
            AND
            first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#first_name#">
            </cfif>
          </cfquery>
          <cfif contactExists.recordCount eq 0>
  			  	<cfquery name="doContact" datasource="BMNet">
  				  	INSERT INTO contact
  					  (
  					   type_id,
  					   first_name,
  					   surname,
  					   tel,
  					   mobile,
  					   email,
  					   password,
  					   company_id,
  					   jobTitle,
  					   buildingVine,
  					   bvusername,
  					   bvpassword,
  					   eGroupUsername,
  					   eGroupPassword
  					  )
  					  VALUES (
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#type_id#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#first_name#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#tel#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#mobile#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#bmcompanyID#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#jobTitle#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#buildingVine#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvusername#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvpassword#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">
  					  )
  				  </cfquery>
  				  <cfquery name="c" datasource="BMNet">
  				  	select max(id) as newID from contact;
  				  </cfquery>
  				  <cfset cID = c.newID>
  				  <!--- add to quote group --->
  				  <cfquery name="adPerm" datasource="BMNet">
  				  	insert into contactGroupRelation
  					  (
  					   parentID,
  					   oType,
  					   oID)
  					  VALUES
  					  (
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="110">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
  					   <cfqueryparam cfsqltype="cf_sql_varchar" value="#c.newID#">
  					  )
  				  </cfquery>
  				<cfelse>
  				  <cfset cID = contactExists.id>
  				  <!--- maybe ensure they are attached to a company? --->
  				  <!--- also maybe update their details --->
  				  <cfquery name="up" datasource="BMNet">
              update contact set
                company_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bmcompanyID#">,
                first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#first_name#">,
                surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#surname#">,
                tel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tel#">,
                mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mobile#">,
                jobTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#jobTitle#">,
                eGroupUsername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                eGroupPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">
              where
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cID#">
            </cfquery>
  				</cfif>

          <cfif NOT TagService.hasTag("contact",cID,"#e.name#")>
            <cfset TagService.add("#e.name#","contact",cID)>
          </cfif>
          <cfif type_id eq 1>
            <cfset theType = "Merchant">
          <cfelse>
            <cfset theType = "Supplier">
          </cfif>
          <cfif NOT TagService.hasTag("contact",cID,"#theType#")>
            <cfset TagService.add("#theType#","contact",cID)>
          </cfif>
			  </cfloop>
		  </cfloop>
		</cfloop>
		<cfset event.noRender()>
  </cffunction>

  <cffunction name="hashEmails" returntype="void">
    <cfquery name="contacts" datasource="BMnet">
      select id, email from contact where siteID = 3
    </cfquery>
    <cfloop query="contacts">
      <cfquery name="u" datasource="BMnet">
        update contact
        set hashedEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(lcase(email),'MD5')#">,
        modified = modified
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    </cfloop>
  </cffunction>
</cfcomponent>