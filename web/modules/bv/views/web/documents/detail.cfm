<cfset getMyPlugin(plugin="jQuery").getDepends("flexpaper","secure/permissions,secure/comments/comments,secure/documents/detail,secure/documents/upload","secure/form/form,secure/documents/documents,secure/documents/uploadify")>
<cfoutput>
	<input type="hidden" id="alf_ticket" value="#request.user_ticket#" />
<cfset document = rc.document>

<div class="row-fluid">
  <div class="span6">
    
    <img class="img-polaroid" src="https://www.buildingvine.com/api/productImage?nodeRef=#document.properties.guid#&size=650" />    
    <br />
    <div class="accordion" id="imageOptions">      
      <div class="accordion-group"> 
        <div class="accordion-heading">
          <a class="noAjax accordion-toggle" data-toggle="collapse" data-parent="##imageOptions" href="##collapseOne">
            Use this image <i class="icon-toolbox pull-right"></i>
          </a>
        </div>
        <div id="collapseOne" class="accordion-body collapse">
          <div class="accordion-inner">
            <form action="" class="form form-horizontal">
              <input type="hidden" id="imageNodeID" value="#document.properties.guid#">
              <input type="hidden" id="imageDownloadURL" value="http://www.buildingvine.com/alfresco#document.properties.downloadURL#?guest=true">
              <fieldset>
                <div class="control-group">
                  <label class="control-label">Width</label>
                  <div class="controls">
                    <div class="input-append">
                      <input id="bv_imageWidth" type="text" class="input-mini" placeholder="150" value="150">
                      <span class="add-on">pixels</span>
                    </div>
                  </div>
                </div>
                <div class="control-group">
                  <label class="control-label">Crop?</label>
                  <div class="controls">
                    <label class="checkbox">
                      <input id="bv_imageCrop" type="checkbox" value="true" >
                      If you select crop but don't enter an aspect ratio, it will assume 4:3
                    </label>
                  </div>
                </div>
                <div class="control-group">
                  <label class="control-label">Aspect Ratio</label>
                  <div class="controls">
                    <input type="text" id="bv_imageCropAspect" class="input-mini" placeholder="4:3" value="4:3">
                  </div>
                </div>
                <div class="control-group">
                  <label class="control-label">Style</label>
                  <div class="controls">
                    <select id="bv_imageStyle">
                      <option value="">--none--</option>
                      <option value="img-polaroid">Polaroid</option>
                      <option value="img-circle">Circle</option>
                      <option value="img-rounded">Rounded</option>
                    </select>
                  </div>
                </div>
              </fieldset>
              <div class="form-actions">
                <button class="btn getImageURL" id="bv_insertImage" type="button">Use Image</button>
                <button class="hidden btn createLink" id="bv_insertImageANDLink" type="button">Create URL and link</button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="accordion-group">
        <div class="accordion-heading">
          <a class="noAjax accordion-toggle" data-toggle="collapse" data-parent="##imageOptions" href="##collapseTwo">
            Get Download URL <i class="icon-toolbox pull-right"></i>
          </a>
        </div>
        <div id="collapseTwo" class="accordion-body collapse">
          <div class="accordion-inner">
            <form class="form form-horizontal">
              <div class="control-group">
                <label class="control-label">URL</label>
                <div class="controls">
                  <input type="text" value="http://www.buildingvine.com/alfresco#document.properties.downloadURL#?guest=true">
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="span6">
    <div class="page-header">
      <h1><cfif document.properties.title neq "">#document.properties.title#<cfelse>#document.properties.name#</cfif></h1>
    </div>
    <div id="uploadQueue"></div>
    <div class="row-fluid">
      <div class="span3">
        <img width="75" class="fileExt" src="/includes/images/secure/documents/fileExtentions/#uCase(getextension(document.properties.name))#.png" border="0" />
      </div>
      <div class="span9">
        <h2><a class="fileDownload" href="http://www.buildingvine.com/alfresco#document.properties.downloadURL#?ticket=#request.user_ticket#">download</a></h2>
        <h4>#fncFileSize(stripAllNum(document.properties.size))#</h4>
      </div>
			<div class="row-fluid">
				<div class="span12">
		      <dl class="dl-horizontal">
		        <dt>Updated:</dt>
		          <dd>#document.properties.modified#</dd>
		        <dt>Created:</dt>
		          <dd>#document.properties.created#</dd>
		        <dt>Modifed By:</dt>
		          <dd><a href="/bv/profile/index?id=#urlEncrypt(document.properties.modifier)#">#document.properties.modifier#</a></dd>
		        <dt>Created By:</dt>
		          <dd><a href="/bv/profile/index?id=#urlEncrypt(document.properties.creator)#">#document.properties.creator#</a></dd>
		      </dl>
				</div>
			</div>
    </div>
    <cfif isUserLoggedIn()>
    <div id="documentAccordion">
      <h3><a href="##">Document Actions</a></h3>
      <div>
        <ul id="documentActions">
          <!-- <li><a class="view" href="##">View in Browser</a></li> -->
          <cfif document.permissions.edit>
            <!-- <li><a class="edit" href="##">Edit MetaData</a></li> -->
            <li><a class="upload" href="##">Upload New Version<span id="upnv"></span></a></li>
            <cfif document.properties.status eq "ok">
              <li><a class="checkout" rel="#document.docnodeRef#" href="##">Edit Offline (Checkout)</a></li>
              <!-- <li><a class="copy" href="##">Copy to...</a></li>
              <li><a class="move" href="##">Move to...</a></li> -->
              <cfif document.permissions.delete>
                <li><a rel="#document.docnodeRef#" rev="#document.parent#" class="delete" href="##">Delete Document</a></li>
                <li><a class="permissions" href="#bl("security.getSecurity","node=#document.docnodeRef#")#">Manage Permissions</a></li>
              </cfif>
            <cfelse>
              <li><a class="vieworiginal" rel="#document.docnodeRef#" href="##">View Original Document</a></li>
              <cfif document.properties.status eq "lockedBySelf">
                <li><a class="cancelcheckout" rel="#document.docnodeRef#" rev="#document.parent#" href="##">Cancel Editing</a></li>
              </cfif>
            </cfif>
          </cfif>
          <cfif isDefined("request.buildingVine.sitesManaged") AND arrayLen(request.buildingVine.sitesManaged) gte 1>
            <li><a class="setAsSiteBanner" data-siteID="#request.buildingVine.siteDB.title#" data-nodeRef="#document.docnodeRef#" href="##">Set as banner for #request.buildingVine.siteDB.title#</a></li>
          </cfif>
        </ul>
      </div>
      <cfif document.permissions.edit AND ListFind("jpg,jpeg,gif,png,bmp,tiff",getextension(document.properties.name)) gte 1>      
      <h3><a href="##">Product Image Relationships</a></h3>
      <div>
        <cfoutput>#renderView("web/products/images/associate")#</cfoutput>
      </div>
      </cfif>
      <cfif document.permissions.edit AND ListFind("jpg,jpeg,gif,png,bmp,tiff",getextension(document.properties.name)) eq 0>
      <h3><a href="##">Product Document Relationships</a></h3>
      <div>
        <cfoutput>#renderView("web/products/documents/associate")#</cfoutput>
      </div>
      </cfif>
      <h3><a href="##">Versions</a></h3>
      <div>
        <cfif document.properties.versions.versioningEnabled eq "false">
        <div class="bubbleInfo">N/A
          <a href="#bl("documents.enableVersioning","node=#document.docNodeRef#")#" rel="/bv/documents/enableVersioning?node=#document.docNodeRef#" class="ajaxMain" id="makeversionable">(enable?)</a>
        </div>
        <cfelse>
          <ul>
          <cfloop array="#document.properties.versions.versions#" index="version">
            <li><a href="http://www.buildingvine.com/alfresco/d/a/versionStore/version2Store/#version.nodeRef#/#document.properties.name#?ticket=#request.user_ticket#">#version.versionNumber#</a><br /> (#DateFormat(version.date,"DD/MM/YY")# #TimeFormat(version.date,"HH:MM")#)</li>
          </cfloop>
          </ul>
        </cfif>
      </div>
      <h3><a href="##">Document Tasks</a></h3>
      <div>
        <cfif arrayLen(document.properties.workflows) gte 1>
          <ol>
          <cfloop array="#document.properties.workflows#" index="task">
            <li><a class="ajax" href="#bl("tasks.viewworkflow","id=#task.id#")#">#task.name# (#task.active#)</a></li>
          </cfloop>
          </ol>
        <cfelse>
          <h5>No tasks associated with this document</h5>
        </cfif>
      </div>
    </div>
    </cfif>
  </div>
</div>
  #renderView("web/comments/list")#
</cfoutput>
