  <cfcomponent name="dmsService" output="true" cache="true" cacheTimeout="0" autowire="true">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="platform" inject="coldbox:setting:platform" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfscript>


  	function getextension(thefile){
  		f = ReFindNoCase("\.([^.]+)$",thefile,1,"True");
  		if (f.pos[1] NEQ 0){
  				return Mid(thefile,f.pos[2],f.len[2]);
  		} else {
  				return '';
  		}
  	}

  	function getFileTypeDescription(filetype) {
  		switch(filetype) {
  			case "pdf": {
  				return "Adobe Acrobat Document";
  				break;
        }
  			case "xls": case "xlsx": {
  				return "Microsoft Excel Spreadsheet";
  				break;
  			}
  			case "docx": case "doc": {
  				return "Microsoft Word Document";
  				break;
  			}
  			case "jpg": case "jpeg": case "gif": case "png": {
  				return "Image File";
  				break;
  			}
        default: {
  				return filetype;
  				break;
  			}
  		}
  	}

  	 function getFileSize(size) {
  	 	var sizeType = "b";
  	 	if (size gt 1024) {
  			size = numberformat(size / 1024, "999999999.99");
  			sizeType = "kb";
  		}
  		if (size gt 1024) {
  			size = numberformat(size / 1024, "99999999.99");
  			sizeType = "MB";
  		}
  		return "#size# #sizeType#";
  	 }

  	 function bhimginfo(imgfile) {
      var jFileIn = createObject("java","java.io.File").init(imgfile);
      var ImageObject = createObject("java","javax.imageio.ImageIO").read(jFileIn);
      var ImageInfo = StructNew();

      var imageFile = CreateObject("java", "java.io.File").init(imgfile);
      var sizeb = imageFile.length();
      var sizekb = numberformat(sizeb / 1024, "999999999.99");
      var sizemb = numberformat(sizekb / 1024, "99999999.99");
      var bhImageInfo = StructNew();

      bhImageInfo.ImgWidth = ImageObject.getWidth();
      bhImageInfo.ImgHeight = ImageObject.getHeight();
      bhImageInfo.SizeB = sizeb;
      bhImageInfo.SizeKB = sizekb;
      bhImageInfo.SizeMB = sizemb;

      return bhImageInfo;
  }
  function fileSize(pathToFile) {
      var fileInstance = createObject("java","java.io.File").init(toString(arguments.pathToFile));
      var fileList = "";
      var ii = 0;
      var totalSize = 0;

      //if this is a simple file, just return it's length
      if(fileInstance.isFile()){
       return fileInstance.length();
      }
      else if(fileInstance.isDirectory()) {
          fileList = fileInstance.listFiles();
          for(ii = 1; ii LTE arrayLen(fileList); ii = ii + 1){
           totalSize = totalSize + fileSize(fileList[ii]);
          }
          return totalSize;
      }
      else
          return 0;
  }
  </cfscript>

  <cffunction name="getCategory" returntype="query" access="public">
    <cfargument name="categoryID" required="yes" type="numeric" default="0">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfargument name="modifiedAfter" required="true" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var getCategoryQ = "">
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#">
  	    select dmsCategory.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsCategory
       LEFT JOIN dmsSecurity on (dmsCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
        	<cfif arguments.categoryID neq 0>
          AND
          dmsCategory.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryID#">
          <cfelseif arguments.categoryName neq "">
          AND
          dmsCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
          </cfif>
          <cfif considerTimeSensitive>
          AND
          (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          order by parentID, id
      </cfquery>
    <cfreturn getCategoryQ>
  </cffunction>


  <cffunction name="getParentCategoryDocuments" returntype="query" access="public">
    <cfargument name="categoryID" required="yes" type="numeric" default="">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfset var eGroup = request.eGroup>
     <cfset var getCategoryQ = "">
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
        select
  			  dmsCategory.name as categoryName,
  			  dmsCategory.id as categoryID,
  			  dmsCategory.description as categoryDescription,
  			  dmsCategory.validFrom as categoryValidFrom,
  			  dmsCategory.validTo as categoryValidTo,
  			  dmsSecurity.priviledge,
          parentCategory.relatedID as relID,
  			  dmsSecurity.securityAgainst,
  			  dmsDocument.* from
  	      dmsCategory,
  	      dmsCategory as parentCategory
          LEFT JOIN dmsSecurity on (parentCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">),
          dmsDocument LEFT JOIN dmsSecurity as docSecurity on (dmsDocument.id = docSecurity.relatedID AND docSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="document">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.groupID is NULL)
          AND
          (docSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR docSecurity.groupID is NULL)
          <cfif arguments.categoryID neq 0>
          AND
          parentCategory.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryID#">
          <cfelseif arguments.categoryName neq "">
          AND
          parentCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
          </cfif>
          AND
          dmsCategory.parentID = parentCategory.id
          <cfif considerTimeSensitive>
          AND
          (
            dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
            AND
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          AND
          dmsDocument.categoryID = dmsCategory.id
         <!--- TODO, check if group by is needed --->
          order by dmsCategory.id, dmsDocument.id
      </cfquery>
    <cfreturn getCategoryQ>
  </cffunction>

  <cffunction name="getCategoryWithin" returntype="query" access="public">
    <cfargument name="categoryID" required="yes" type="numeric" default="0">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfset var eGroup = request.eGroup>
     <cfset var getCategoryQ = "">
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#">
        select dmsCategory.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsCategory
        LEFT JOIN dmsSecurity on (dmsCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
          dmsCategory.parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryID#">
          AND
          dmsCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
          <cfif considerTimeSensitive>
          AND
          (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          order by parentID, id
      </cfquery>
    <cfreturn getCategoryQ>
  </cffunction>

  <cffunction name="ChangeRelatedID" returntype="boolean">
    <cfargument name="oldID" required="yes" type="numeric">
    <cfargument name="newID" required="yes" type="numeric">
    <cfset var update = "">
    <cfquery name="update" datasource="#dsn.getName()#">
      	update dmsCategory set relatedID = '#newID#' where id = '#oldID#';
      </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="getRelatedCategory" returntype="query">
    <cfargument name="relatedType" required="yes" type="string">
    <cfargument name="relatedID" required="yes" type="numeric" default="0">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfset var eGroup = request.eGroup>
    <cfset var getCategoryQ = "">
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#">
  	    select dmsCategory.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsCategory
        LEFT JOIN dmsSecurity on (dmsCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
        relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">
        	<cfif arguments.relatedID neq 0>
            AND dmsCategory.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
          </cfif>
          <cfif arguments.categoryName neq "">
          AND dmsCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
          </cfif>
          <cfif considerTimeSensitive>
          AND
          (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          order by id asc;
      </cfquery>
    <cfreturn getCategoryQ>
  </cffunction>

  <cffunction name="getRelatedCategoryDocuments" returntype="query">
    <cfargument name="relatedType" required="yes" type="string" default="">
    <cfargument name="relatedID" required="yes" type="numeric" default="0">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfargument name="modifiedAfter" required="true" default="">
    <cfargument name="pending" required="true" default="false" type="boolean">
    <cfset var eGroup = request.eGroup>
    <cfset var memberID = eGroup.companyID>
    <cfset var getCategoryQ = "">
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#">
  			select
  				dmsD.*,
  				dmsC.parentID,
  				dmsC.name as categoryName,
  				dmsC.description,
  				dmsC.id as categoryID,
  				dmsC.relatedID as categoryRelatedID,
  				dmsC.relatedType as categoryRelatedType,
  				dmsS.priviledge,
  				dmsS.securityAgainst
  			from
  				dmsCategory as dmsC
  				left join dmsDocument as dmsD on dmsD.categoryID = dmsC.id
  				left join dmsSecurity as dmsS on dmsS.relatedID = dmsD.id
  			WHERE
  				(
            dmsC.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#memberID#">)
            OR
            dmsC.memberID is null
          )
  				<cfif relatedID neq 0>
          AND
          dmsC.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">

          </cfif>
          <cfif categoryName neq "">
          AND
          dmsC.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryName#">

          </cfif>
  				AND
  				(dmsS.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true"  value="#eGroup.rolesids#">) OR dmsS.groupID is null)

  				<cfif relatedType neq "">
    		  AND
  				dmsC.relatedType = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#relatedType#">
  				</cfif>

          <cfif considerTimeSensitive>
          AND
          (<cfif arguments.pending>dmsD.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
           AND
		       <cfelse>
			   	   dmsD.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
		       </cfif>
            (

              dmsD.validFrom <cfif arguments.pending>><cfelse><=</cfif> <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsD.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          <cfif arguments.modifiedAfter neq "">
          AND
          dmsD.modified >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(arguments.modifiedAfter)#">
          </cfif>
  				order by modified desc;
      </cfquery>
    <cfreturn getCategoryQ>
  </cffunction>

  <cffunction name="getDocuments" returntype="query" access="public">
    <cfargument name="categoryID" required="yes" type="numeric" default="0">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfset var eGroup = request.eGroup>
    <cfset var getDocumentsQ = "">
    <cfquery name="getDocumentsQ" datasource="#dsn.getName(true)#">
  	    select dmsDocument.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsDocument
        LEFT JOIN dmsSecurity on (dmsDocument.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="document">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)

        	<cfif arguments.categoryID neq 0>
        	 AND
          dmsDocument.categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryID#">
          <cfelseif arguments.categoryName neq "">
          AND
          dmsDocument.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCategory(arguments.categoryName).id#">
          </cfif>
          <cfif considerTimeSensitive>
          AND
          (dmsDocument.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
            (
              dmsDocument.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsDocument.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
      </cfquery>
    <cfreturn getDocumentsQ>
  </cffunction>

  <cffunction name="getDocumentsFromList" returntype="query" access="public">
    <cfargument name="documentIDs" required="yes" type="any" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var getDocumentsQ = "">
    <cfquery name="getDocumentsQ" datasource="#dsn.getName(true)#">
        select dmsDocument.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsDocument
        LEFT JOIN dmsSecurity on (dmsDocument.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="document">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
          dmsDocument.id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#documentIDs#" list="true">)
      </cfquery>
    <cfreturn getDocumentsQ>
  </cffunction>

  <cffunction name="getRecursiveDocuments" returntype="query" access="public">
    <cfargument name="categoryID">
    <cfset var returnQuery = QueryNew("id,name,size,filetype,timeSensitive,validFrom,validTo")>
    <cfreturn recurseDocuments(categoryID,returnQuery)>
  </cffunction>

  <cffunction name="recurseDocuments" returntype="query" access="private">
    <cfargument name="categoryID">
    <cfargument name="q">
    <cfset var subCats = getCategoryWithin(categoryID)>
    <cfset var documents = getDocuments(categoryID)>
    <cfloop query="documents">
      <cfset QueryAddRow(q)>
      <cfset QuerySetCell(q,"id",id)>
      <cfset QuerySetCell(q,"name",name)>
      <cfset QuerySetCell(q,"size",size)>
      <cfset QuerySetCell(q,"filetype",filetype)>
      <cfset QuerySetCell(q,"timeSensitive",timeSensitive)>
      <cfset QuerySetCell(q,"validFrom",validFrom)>
      <cfset QuerySetCell(q,"validTo",validTo)>
    </cfloop>
    <cfloop query="subCats">
      <cfset recurseDocuments(id,q)>
    </cfloop>
    <cfreturn q>
  </cffunction>

  <cffunction name="getParentsUntil" returntype="any">
    <cfargument name="categoryID" required="true" hint="the current categoryID of the propogation">
    <cfargument name="categoryName" required="false" default="">
    <cfargument name="relatedType" required="false" default="">
    <cfargument name="relatedID" required="false" default="">
    <cfif categoryID eq 0>
      <cfreturn false>
    </cfif>
    <cfset thisCategory = getCategory(arguments.categoryID)>
    <cfif arguments.categoryName neq "" AND (thisCategory.name eq arguments.categoryName)>
      <cfreturn thisCategory>
    </cfif>
    <cfif arguments.relatedType neq "" AND (thisCategory.relatedType eq arguments.relatedType)>
      <cfreturn thisCategory>
    </cfif>
    <cfif arguments.relatedType neq "" AND (thisCategory.relatedType eq arguments.relatedType) AND arguments.relatedID neq "" AND (thisCategory.relatedID eq arguments.relatedID)>
      <cfreturn thisCategory>
    </cfif>
    <cfreturn getParentsUntil(thisCategory.parentID,arguments.categoryName,arguments.relatedType,arguments.relatedID)>
  </cffunction>

  <cffunction name="getCategories" returntype="query" access="public">
    <cfargument name="parentID" required="yes" type="numeric" default="0">
    <cfargument name="relatedType" required="yes" type="string" default="">
    <cfargument name="categoryName" required="yes" type="string" default="">
    <cfargument name="orderBy" required="yes" type="string" default="name">
    <cfargument name="orderDir" required="yes" type="string" default="asc">
    <cfargument name="considerTimeSensitive" required="true" default="false">
    <cfset var eGroup = request.eGroup>
    <cfset var getCategoriesQ = "">
    <cfset var me = "">
    <cfquery name="getCategoriesQ" datasource="#dsn.getName(true)#" result="me">
  	    select dmsCategory.*, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsCategory
        LEFT JOIN dmsSecurity on (dmsCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
        	parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentID#">
        	<cfif arguments.relatedType neq "">
          relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">
          </cfif>
          <cfif arguments.categoryName neq "">
          AND dmsCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
          </cfif>
          <cfif considerTimeSensitive>
          AND
          (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
           OR
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
          </cfif>
          order by #orderBy# #orderDir#;
      </cfquery>
    <cfreturn getCategoriesQ>
  </cffunction>

  <cffunction name="getDocument" returntype="query" access="public">
    <cfargument name="documentID" required="yes" type="numeric" default="0">
    <cfargument name="forceSecurity" required="yes" type="boolean" default="false">
    <cfset var eGroup = request.eGroup>
    <cfset var memberID = eGroup.companyID>
    <cfset var getDocumentQ = "">
    <cfquery name="getDocumentQ" datasource="#dsn.getName(true)#">
  			select
  				dmsD.*,
  				dmsC.name as categoryName,
  				dmsC.description as categoryDescription,
  				dmsC.id as categoryID,
  				dmsS.priviledge,
  				dmsS.securityAgainst
  			from
  				dmsCategory as dmsC
  				left join dmsDocument as dmsD on dmsD.categoryID = dmsC.id
  				left join dmsSecurity as dmsS on dmsS.relatedID = dmsD.id
  			WHERE
  				dmsD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#documentID#">
  				AND
          (dmsS.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true"  value="#eGroup.rolesids#">)
          <cfif NOT forceSecurity>
          OR dmsS.priviledge is null
          </cfif>)

  			order by modified desc;
  			</cfquery>
    <cfreturn getDocumentQ>
  </cffunction>

  <cffunction name="getDocumentByName" returntype="query" access="public">
    <cfargument name="name" required="yes" type="string" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var memberID = eGroup.companyID>
    <cfset var getDocumentQ = "">
    <cfquery name="getDocumentQ" datasource="#dsn.getName(true)#">
        select
          dmsD.*,
          dmsC.name as categoryName,
          dmsC.description as categoryDescription,
          dmsC.id as categoryID,
          dmsS.priviledge,
          dmsS.securityAgainst
        from
          dmsCategory as dmsC
          left join dmsDocument as dmsD on dmsD.categoryID = dmsC.id
          left join dmsSecurity as dmsS on dmsS.relatedID = dmsD.id
        WHERE
          dmsD.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
          AND
          (dmsS.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true"  value="#eGroup.rolesids#">)
          OR dmsS.priviledge is null)

        order by modified desc;
        </cfquery>
    <cfreturn getDocumentQ>
  </cffunction>

  <cffunction name="getDocumentNoAuth" returntype="query" access="public">
    <cfargument name="documentID" required="yes" type="numeric" default="0">
    <cfset var getDocumentQ = "">
    <cfquery name="getDocumentQ" datasource="#dsn.getName(true)#">
        select
          dmsD.id,
          dmsD.name,
          dmsD.size,
          dmsD.modified,
          dmsD.filetype,
          dmsD.categoryID
        from
          dmsDocument as dmsD
        WHERE
          dmsD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#documentID#">
        order by modified desc;
        </cfquery>
    <cfreturn getDocumentQ>
  </cffunction>

  <cffunction name="createDMSSecurity" returntype="any" access="public">
    <cfargument name="priv" required="yes">
    <cfargument name="gID" required="yes">
    <cfargument name="against">
    <cfargument name="rID">
    <cfset var createSec = "">
    <cfquery name="createSec" datasource="#dsn.getName()#">
      	insert into dmsSecurity
        (priviledge,groupID,securityAgainst,relatedID)
  			VALUES
        ('#priv#','#gID#','#against#','#rID#')
  		</cfquery>
  </cffunction>

  <cffunction name="updateDMSSecurity" returntype="any" access="public">
    <cfargument name="priv" required="yes">
    <cfargument name="gID" required="yes">
    <cfargument name="against" required="yes">
    <cfargument name="rID" required="yes">
    <cfset var g = "">
    <cfset var delCurrent = "">
    <cfset var createSec = "">
    <cfquery name="delCurrent" datasource="#dsn.getName()#">
        delete from dmsSecurity
        where securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="#against#">
        AND
        relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rID#">;
      </cfquery>
    <cfif gID neq 0>
      <cfloop list="#gID#" index="g">
        <cfset logger.debug("adding security for group #g# against #against#")>
        <cfquery name="createSec" datasource="#dsn.getName()#">
  	    	insert into dmsSecurity (groupID,securityAgainst,priviledge,relatedID)
  	    	VALUES
  	    	(
  	    	 <cfqueryparam cfsqltype="cf_sql_integer" value="#g#">,
  	    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#against#">,
  	    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#priv#">,
  	    	 <cfqueryparam cfsqltype="cf_sql_integer" value="#rID#">
  	    	)
  			</cfquery>
      </cfloop>
    </cfif>
  </cffunction>

  <cffunction name="createDMSDocument" returntype="numeric" access="public">
    <cfargument name="categoryID" required="yes" type="numeric" default="0">
    <cfargument name="documentName" required="yes" type="string" default="">
    <cfargument name="documentDescription" required="yes" type="string" default="">
    <cfargument name="relatedID" required="yes" type="numeric" default="0">
    <cfargument name="relatedType" required="yes" type="string" default="none">
    <cfargument name="fileSize" required="yes" type="string" default="0">
    <cfargument name="fileType" required="yes" type="string" default="none">
    <cfargument name="memberID" required="yes" type="numeric" default="0">
    <cfargument name="securityGroup" required="yes" type="numeric" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var g = "">
    <cfset var companyID = "">
    <cfset var insertDocument = "">
    <cfset var newDoc = "">
    <cfset var x = "">
    <cfquery name="insertDocument" datasource="#dsn.getName()#">
      	insert into dmsDocument (name,description,categoryID,relatedID,relatedType,size,filetype,memberID)
        VALUES
        ('#documentName#','#documentDescription#',#categoryID#,#relatedID#,'#relatedType#','#fileSize#','#filetype#',#memberID#)
      </cfquery>
    <cfquery name="newDoc" datasource="#dsn.getName()#">
      	select LAST_INSERT_ID() as id from dmsDocument;
      </cfquery>
    <cfif securityGroup neq 0>
      <cfset x = createDMSSecurity("view",securityGroup,"document",newDoc.id)>
      <cfelse>
      <cfset x = createDMSSecurity("view",groups.getGroupByName("view"),"document",newDoc.id)>
    </cfif>
    <cftry>
      <cfset feed.createFeedItem(so="contact",soID=eGroup.contactID,tO="company",tOID=eGroup.companyID,action="createDocument",ro="dmsDocument",roID=newDoc.id)>
      <cfcatch type="any">
        <cfset logger.debug("contactID: #eGroup.contactID#")>
        <cfset logger.debug("#cfcatch.Message#")>
      </cfcatch>
    </cftry>
    <cfreturn newDoc.id>
  </cffunction>

  <cffunction name="createDMSCategory" returntype="numeric" access="public">
    <cfargument name="categoryTitle" required="yes" type="string" default="undefined">
    <cfargument name="categoryDescription" required="yes" type="string" default="">
    <cfargument name="categoryRelationshipType" required="yes" type="string" default="none">
    <cfargument name="categoryRelationShipID" required="yes" type="numeric" default="0">
    <cfargument name="parentCategoryID" required="yes" type="numeric" default="0">
    <cfargument name="parentCategoryName" required="yes" type="string" default="">
    <cfargument name="memberID" required="yes" type="numeric" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var p = "">
    <cfset var parentID = "">
    <cfset var insertCategory = "">
    <cfset var newCat = "">
    <cfif memberID eq 0>
      <cfif NOT isUserInRole("egroup_edit")>
        <cfset memberID = eGroup.companyID>
      </cfif>
    </cfif>
    <cfif arguments.parentCategoryID neq 0>
      <cfset p = getCategory(arguments.parentCategoryID)>
      <cfelseif arguments.parentCategoryName neq "">
      <cfset p = getCategory(0,"#arguments.parentCategoryName#")>
    </cfif>
    <cfset parentID = p.id>
    <cfquery name="insertCategory" datasource="#dsn.getName()#">
      	insert into dmsCategory (parentID,name,description,relatedType,relatedID,memberID)
        VALUES
        (#parentID#,'#categoryTitle#','#categoryDescription#','#categoryRelationshipType#',#categoryRelationShipID#,#memberID#)
      </cfquery>
    <cfquery name="newCat" datasource="#dsn.getName()#">
      	select LAST_INSERT_ID() as id from dmsCategory;
      </cfquery>
    <cfreturn newCat.id>
  </cffunction>

  <cffunction name="relateDMSCategoryandDocuments" returntype="numeric" access="public">
    <cfargument name="dmsCategoryID" required="yes" type="numeric">
    <cfargument name="categoryTitle" required="yes" type="string">
    <cfargument name="categoryDescription" required="yes" type="string">
    <cfargument name="categoryRelationShipID" required="yes" type="numeric" default="0">
    <cfargument name="memberID" required="yes" type="numeric" default="0">
    <cfset var insertCategory = "">
    <cfset var documents = "">
    <cfif arguments.memberID eq 0>
      <cfif NOT isUserInRole("egroup_edit")>
        <cfset arguments.memberID = session.companyID>
      </cfif>
    </cfif>
    <cfquery name="insertCategory" datasource="#dsn.getName()#">
      	update dmsCategory
        	SET
        name = '#categoryTitle#',
        description = '#categoryDescription#',
        relatedID = #categoryRelationShipID#,
        memberID = #arguments.memberID#
        	WHERE
        id = #dmsCategoryID#
      </cfquery>
    <cfquery name="documents" datasource="#dsn.getName()#">
      	update dmsDocument
        	SET
        relatedID = #categoryRelationShipID#, memberID = #arguments.memberID#
        	WHERE
        categoryID = #dmsCategoryID#
      </cfquery>
    <cfreturn dmsCategoryID>
  </cffunction>

  <cffunction name="updateWithDocumentInfo" returntype="any" access="public">
    <cfargument name="documentID">
    <cfargument name="name">
    <cfargument name="fileType">
    <cfset var updateDoc = "">
    <cfquery name="updateDoc" datasource="#dsn.getName()#">
      	update dmsDocument set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">, size = '#fileSize#', filetype = '#fileType#' where id = '#documentID#';
      </cfquery>
  </cffunction>

  <cffunction name="updateDMSDocument" returntype="any" access="public">
    <cfargument name="documentID" required="true">
    <cfargument name="name" required="true">
    <cfargument name="description" required="true">
    <cfargument name="timeSensitive" required="true">
    <cfargument name="validFrom" required="true">
    <cfargument name="validTo" required="true">
    <cfargument name="securityGroup" required="true" default="0">
    <cfargument name="relatedType" required="true">
    <cfargument name="relatedID" required="true">
    <cfargument name="showThumbnail" required="true">
    <cfargument name="parentID" required="true">
    <cfset var updateDoc = "">
    <cfquery name="updateDoc" datasource="#dsn.getName()#">
      	update
      	 dmsDocument
      	set
      	 name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
      	 description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#description#">,
      	 timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(timeSensitive)#">,
      	 <cfif timeSensitive>
         validFrom =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(validFrom)#">,
         validTo =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(validTo)#">,
         </cfif>
         relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">,
         relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">,
         showThumbnail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(showThumbnail)#">,
         categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parentID#">
      	  where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#documentID#">;
      </cfquery>
    <cfset updateDMSSecurity("view",securityGroup,"document",documentID)>
  </cffunction>

  <cffunction name="updateDMSCategory" returntype="any" access="public">
    <cfargument name="categoryID" required="true">
    <cfargument name="name" required="true">
    <cfargument name="description" required="true">
    <cfargument name="timeSensitive" required="true">
    <cfargument name="validFrom" required="true">
    <cfargument name="validTo" required="true">
    <cfargument name="securityGroup" required="true" default="0">
    <cfargument name="relatedType" required="true">
    <cfargument name="relatedID" required="true">
    <cfargument name="parentID" required="true">
    <cfset var updateDoc = "">
    <cfquery name="updateDoc" datasource="#dsn.getName()#">
        update
         dmsCategory
        set
         name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
         description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#description#">,
         timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(timeSensitive)#">,
         <cfif timeSensitive>
         validFrom =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(validFrom)#">,
         validTo =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(validTo)#">,
         </cfif>
         relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">,
         relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">,
         parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parentID#">
          where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#categoryID#">;
      </cfquery>
    <cfset updateDMSSecurity("view",securityGroup,"category",categoryID)>
  </cffunction>

  <cffunction name="uploadFile" output="false" description="Uploads a file in the given folder" access="public" returntype="void">
    <cfargument name="filefield" required="true" />
    <cfargument name="path" required="false" type="string" default=""/>
    <cfargument name="filename" type="string" required="true" />
    <cfargument name="documentID" />
    <cfset var updateDoc = "">
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfset var eGroup = request.eGroup>
    <cffile action="rename" source="#path#/#cffile.serverFile#" destination="#appRoot#dms/documents/#documentID#.#cffile.serverFileExt#">
    <cfquery name="updateDoc" datasource="#dsn.getName()#">
     	update dmsDocument set filetype = '#cffile.serverFileExt#' where id = '#documentID#';
    </cfquery>

  </cffunction>

  <cffunction name="removeThumbnail" returntype="void">
    <cfargument name="documentID">
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfif fileExists("#appRoot#dms/documents/thumbnails/#arguments.documentID#_small.jpg")>
      <cffile action="delete" file="#appRoot#dms/documents/thumbnails/#arguments.documentID#_small.jpg">
      <cffile action="delete" file="#appRoot#dms/documents/thumbnails/#arguments.documentID#.jpg">
    </cfif>
  </cffunction>

  <cffunction name="createThumbnails" returntype="void">
    <cfargument name="documentID">
    <cfargument name="extension">
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfset var ext = replace(extension,".","")>
	  <cftry>
	  <cfset var theThread=cfthread["thumbnail_document_#arguments.documentID#"]>
	  <cfif ((theThread.Status IS "RUNNING") || (theThread.Status IS "NOT_STARTED"))>
	    <cfthread action="terminate" name="thumbnail_document_#arguments.documentID#" />
	    <cflog application="true" text="killed thread #arguments.documentID#">
    </cfif>
    <cfcatch type="any"></cfcatch>
	  </cftry>
	  <cftry>
    <cfthread logger="logger" action="run" name="thumbnail_document_#documentID#" ext="#ext#" appRoot="#appRoot#" documentID="#documentID#" extension="#extension#" priority="LOW">
      <cftry>
        <cfif ListFindNoCase("xls,xlsx,doc,docx,ppt,pptm,pptx",ext) gte 1>
          <cflog application="true" text="creating thumbnail for #attributes.documentID#.#ext#">
          <cfdocument
            localurl="true"
  			    format="pdf"
  			    srcfile="#attributes.appRoot#dms/documents/#attributes.documentID#.#ext#"
  			    filename="#attributes.appRoot#dms/documents/#attributes.documentID#_pdf.pdf"
  			    overwrite="true" />
          <!--- convert document to swf for online browsing --->
          <cfexecute name="/usr/local/bin/pdf2swf" arguments="#attributes.appRoot#dms/documents/#attributes.documentID#_pdf.pdf -o #attributes.appRoot#dms/documents/#attributes.documentID#_pdf.swf">
          </cfexecute>
          <cfpdf action="thumbnail"
  			         source="#attributes.appRoot#dms/documents/#attributes.documentID#_pdf.pdf"
  			         pages="1"
  			         overwrite="true"
  			         destination="#attributes.appRoot#dms/documents/thumbnails"
  			         imagePrefix="Cover"
  			         format="png"
  			         scale="100" resolution="high" />
          <cfimage action="resize" width="300" height="" overwrite="true" source="#attributes.appRoot#dms/documents/thumbnails/Cover_page_1.png" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#.jpg" />
          <cfimage action="resize" width="150" height="" overwrite="true" source="#attributes.appRoot#dms/documents/thumbnails/Cover_page_1.png" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#_small.jpg" />

        <cfelseif ListFindNoCase("pdf",ext) gte 1>
          <cftry>
            <cfpdf action="thumbnail"
                 source="#attributes.appRoot#dms/documents/#attributes.documentID#.pdf"
                 pages="1"
                 overwrite="true"
                 destination="#attributes.appRoot#dms/documents/thumbnails"
                 imagePrefix="Cover"
                 format="png"
                 scale="100" resolution="high" />
            <cfimage action="resize" width="300" height="" overwrite="true" source="#attributes.appRoot#dms/documents/thumbnails/Cover_page_1.png" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#.jpg" />
            <cfimage action="resize" width="150" height="" overwrite="true" source="#attributes.appRoot#dms/documents/thumbnails/Cover_page_1.png" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#_small.jpg" />
            <cfcatch type="any">
              <!--- probably permissions issue --->
            </cfcatch>
          </cftry>
        <cfelseif ListFindNoCase("jpg,jpeg,gif,png,bmp,tiff",ext) gte 1>
          <cfimage action="resize" overwrite="true" width="300" height="" source="#attributes.appRoot#dms/documents/#documentID#.#ext#" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#.jpg" />
          <cfimage action="resize" overwrite="true" width="150" height="" source="#attributes.appRoot#dms/documents/#documentID#.#ext#" destination="#attributes.appRoot#dms/documents/thumbnails/#attributes.documentID#_small.jpg" />
        </cfif>
        <cfcatch type="any">
          <cflog application="true" text="error #cfcatch.message#">
        </cfcatch>
      </cftry>
    </cfthread>
    <cfthread action="run" name="documentChecker_#documentID#" documentID="#documentID#">
		  <cflog application="true" text="checking for status of thread #attributes.documentID#">
		  <cfset sleep(20000)>
		  <cfset theThread=cfthread["thumbnail_document_#attributes.documentID#"]>
		  <cfif ((theThread.Status IS "RUNNING") || (theThread.Status IS "NOT_STARTED"))>
        <cfthread action="terminate" name="thumbnail_document_#attributes.documentID#" />
		    <cflog application="true" text="killed thread #attributes.documentID#">
    </cfif>
		</cfthread>
		<cfcatch type="any"></cfcatch>
		</cftry>
  </cffunction>

  <cffunction name="flexPaper" returntype="void">
    <cfargument name="documentID">
    <cfargument name="extension">
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfset var ext = replace(extension,".","")>
    <cfset var mess = "">
    <cfif NOT fileExists("#appRoot#dms/documents/#documentID#_pdf.swf")>
      <cfif ListFindNoCase("xls,xlsx,doc,docx,ppt,pptm,pptx",ext) gte 1>
        <cflog application="true" text="creating thumbnail for #documentID#.#ext#">
        <cfdocument
            localurl="true"
            format="pdf"
            srcfile="#appRoot#dms/documents/#documentID#.#ext#"
            filename="#appRoot#dms/documents/#documentID#_pdf.pdf"
            overwrite="true" />
        <!--- convert document to swf for online browsing --->
        <cfexecute timeout="90" name="/usr/local/bin/pdf2swf" arguments="#appRoot#dms/documents/#documentID#_pdf.pdf -o #appRoot#dms/documents/#documentID#_pdf.swf">
        </cfexecute>
        <cfelseif ListFindNoCase("pdf",ext) gte 1>
        <cfexecute variable="mess" timeout="90" name="/usr/local/bin/pdf2swf" arguments="#appRoot#dms/documents/#documentID#.pdf -s poly2bitmap -o #appRoot#dms/documents/#documentID#_pdf.swf">
        </cfexecute>
        <cfset logger.debug(mess)>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="deleteDocument" access="public">
    <cfargument name="documentID" required="yes">
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfset var d = getDocument(documentID)>
    <cfset var delDoc = "">
    <cfset var deal = "">
    <cfset var companyID = "">
    <cfquery name="delDoc" datasource="#dsn.getName()#">
      	delete from dmsDocument where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#documentID#">;
      </cfquery>
    <cffile action="delete" file="#appRoot#dms/documents/#Trim(documentID)#.#Trim(d.filetype)#">
    <cftry>
      <cfif d.relatedType eq "deal">
        <cfset deal = session.arrangement.getArrangement(d.relatedID)>
        <cfset companyID = deal.company_id>
        <cfelseif relatedType eq company>
        <cfset companyID = d.relatedID>
        <cfelse>
        <cfset companyID = 0>
      </cfif>
      <cfset application.feed.createFeedItem(
     							so = 'contact',
     							sOID = session.contactID,
     							tO = 'document',
     							tOID = documentID,
     							action = 'deleteDocument',
     							rO = '#d.relatedType#',
     							rOID = d.relatedID,
     							memberID = d.memberID,
     							companyID = companyID
     							)>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="dmsTree" returntype="array">
    <cfargument name="catID" required="true" type="numeric">
    <cfset var tree = ArrayNew(1)>
    <cfset var theTree = breadCrumb(catID,tree)>
    <cfreturn theTree>
  </cffunction>
  <cffunction name="breadcrumb" returntype="array" access="public" output="true">
    <cfargument name="catID" required="true" type="numeric">
    <cfargument name="tree" required="yes">
    <cfset var category = "">
    <cfset var x = "">
    <cfif catID neq 0>
      <cfset category = getCategory(catID)>
      <cfset x = StructNew()>
      <cfset x["id"] = category.id>
      <cfset x["name"] = category.name>
      <cfset Arrayprepend(arguments.tree,x)>
      <cfif isNumeric(category.parentID)>
        <cfreturn breadcrumb(category.parentID,arguments.tree)>
        <cfelse>
        <cfreturn tree>
      </cfif>
      <cfelse>
      <cfreturn tree>
    </cfif>
  </cffunction>

  <cffunction name="deleteCategory" access="public">
    <cfargument name="categoryID" required="yes" default="0">
    <cfargument name="relatedType" required="yes" type="string" default="">
    <cfargument name="relatedID" required="yes" default="0">
    <cfset var delCar = "">
    <cfquery name="delCar" datasource="#dsn.getName()#">
          delete from dmsCategory where
          <cfif categoryID neq 0>
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#categoryID#">
          <cfelse>
          relatedType = '#relatedType#' AND relatedID = '#relatedID#'
          </cfif>
      </cfquery>
  </cffunction>

  <cffunction name="getDocumentRelatedName" returntype="numeric">
    <cfargument name="documentName" required="yes" type="string" default="">
    <cfargument name="relatedID" required="yes" type="numeric" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var getDocumentQ = "">
    <cfquery name="getDocumentQ" datasource="#dsn.getName(true)#">
  	    select id, dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsDocument
        LEFT JOIN dmsSecurity on (dmsDocument.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="document">)
        WHERE
          (dmsSecurity.priviledge IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.roles#">) OR dmsSecurity.priviledge is NULL)
          AND
          name = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.documentName#">
          AND
          dmsDocument.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
      </cfquery>
    <cfif getDocumentQ.recordCount gte 1>
      <cfreturn getDocumentQ.id>
      <cfelse>
      <cfreturn 0>
    </cfif>
  </cffunction>

  <cffunction name="getAllRelatedDocuments" returntype="query">
    <cfargument name="relatedType" required="yes" type="string" default="">
    <cfargument name="relatedID" required="yes" type="numeric" default="0">
    <cfset var eGroup = request.eGroup>
    <cfset var getDocumentQ = "">
    <cfquery name="getDocumentQ" datasource="#dsn.getName(true)#">
  	    select
            dmsDocument.id,
            dmsDocument.name,
            dmsDocument.description,
            dmsDocument.categoryID,
            dmsDocument.relatedID,
            dmsDocument.relatedType,
            dmsDocument.size,
            dmsDocument.modified,
            dmsDocument.filetype,
            dmsDocument.memberID,
            dmsDocument.createdBy,
            dmsDocument.created,
            dmsDocument.timeSensitive,
            dmsDocument.validFrom,
            dmsDocument.validTo,
            dmsSecurity.priviledge, dmsSecurity.securityAgainst from
        dmsDocument,
        dmsCategory
        LEFT JOIN dmsSecurity on (dmsDocument.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">)
        WHERE
          (dmsSecurity.priviledge IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.roles#">) OR dmsSecurity.priviledge is NULL)
          AND
  				((dmsCategory.relatedType = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.relatedType#">
          AND
          dmsCategory.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">)
          AND
          dmsDocument.categoryID = dmsCategory.id);
      </cfquery>
    <cfreturn getDocumentQ>
  </cffunction>

  <cffunction name="getDMSSecurity" returntype="any" access="public">
    <cfargument name="against" required="true">
    <cfargument name="rID" required="true">
    <cfset var securityQ = "">
    <cfquery name="securityQ" datasource="#dsn.getName(true)#">
      	select * from dmsSecurity
        where
        securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="#against#">
        AND
        relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rID#">;
  		</cfquery>
    <cfreturn securityQ>
  </cffunction>

  <cffunction name="search" returntype="any" access="public">
  <cfargument name="str" required="yes">
  <cfargument name="site">
  <cfset var retQ = QueryNew("id,name,description,size,tree,fileext")>
  <cfset var dmsSearch = "">
  <cfset var docID = "">
  <cfset var doc = "">
  <cftry>
    <cfsearch collection="#site#dms" criteria="#str#" name="dmsSearch" maxrows="10" />
    <cfloop query="dmsSearch">
      <cfset docID = url>
      <cfset docID = replace(docID,"/","","ALL")>
      <cfset docID = ListGetAt(docID,1,".")>
      <cfif isNumeric(docID)>
        <cfset doc = getDocument(docID)>
        <cfif doc.recordCount neq 0>
          <cfset QueryAddRow(retQ)>
          <cfset QuerySetCell(retQ,"id",docID)>
          <cfset QuerySetCell(retQ,"name",doc.name)>
          <cfset QuerySetCell(retQ,"description",doc.description)>
          <cfset QuerySetCell(retQ,"size",size)>
          <cfset QuerySetCell(retQ,"tree",dmsTree(doc.categoryID))>
          <cfset QuerySetCell(retQ,"fileext",ListGetAt(url,2,"."))>
        </cfif>
      </cfif>
    </cfloop>
    <cfcatch type="any">
    </cfcatch>
  </cftry>
  <cfreturn retQ>
</cffunction>
</cfcomponent>