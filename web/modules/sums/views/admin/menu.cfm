
<script type="text/javascript" src="/ckeditor4/ckeditor.js"></script>
<script>

    // This code is generally not necessary, but it is here to demonstrate
    // how to customize specific editor instances on the fly. This fits well
    // this demo because we have editable elements (like headers) that
    // require less features.

    // The "instanceCreated" event is fired for every editor instance created.
    CKEDITOR.on( 'instanceCreated', function( event ) {
      var editor = event.editor,
        element = editor.element;

      // Customize editors for headers and tag list.
      // These editors don't need features like smileys, templates, iframes etc.
      if ( element.is( 'h1', 'h2', 'h3' ) || element.getAttribute( 'id' ) == 'taglist' ) {
        // Customize the editor configurations on "configLoaded" event,
        // which is fired after the configuration file loading and
        // execution. This makes it possible to change the
        // configurations before the editor initialization takes place.
        editor.on( 'configLoaded', function() {

          // Remove unnecessary plugins to make the editor simpler.
          editor.config.removePlugins = 'colorbutton,find,flash,font,' +
            'forms,iframe,image,newpage,removeformat,scayt,' +
            'smiley,specialchar,stylescombo,templates,wsc';

          // Rearrange the layout of the toolbar.
          editor.config.toolbarGroups = [
            { name: 'editing',    groups: [ 'basicstyles', 'links' ] },
            { name: 'undo' },
            { name: 'clipboard',  groups: [ 'selection', 'clipboard' ] },
            { name: 'about' }
          ];
        });
      }
    });

  </script>
  <link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
  <link href='http://d25ke41d0c64z1.cloudfront.net/images/iconsets.css' rel='stylesheet' type='text/css'>

  <link href='/modules/eunify/includes/style/themes/classic/style.css' rel='stylesheet' type='text/css'>
<cfset getMyPlugin(plugin="jQuery").getDepends("livequery,upload,cookie,block,bbq,hoverIntent,json,jstree,slimScroll,filedrop","admin,links,emulator","form,admin,tree/style",false,"sums")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/documents/documents,secure/documents/uploadify",false,"bv")>
<cfset sumsAdminBar = getPLugin("CookieStorage").getVar("SUMSAdminBar","none")>
<cfoutput><input type="hidden" id="alf_ticket" value="#request.buildingVine.user_ticket#" />
    <input type="hidden" id="pageNodeRef" value="#paramValue('rc.requestData.page.nodeRef','')#">
</cfoutput>
<div class=" navbar navbar-fixed-top" id="adminBar" style="display:<cfoutput>#sumsAdminBar#</cfoutput>">
  <cfoutput>
  <input type="hidden" id="siteID" value="#rc.siteID#">
  
  <div class="navbar-inner">    
    <div>
      <ul class="hidden-phone nav">
        <cfif event.getCurrentModule() eq "sums">
          <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit>
            <li class="dropdown">
              <a id="newPage" class="dropdown-toggle" data-toggle="dropdown" href="/sums/admin/newpage?parentNoderef=#rc.requestData.page.nodeRef#"><i class="icon-document--plus"></i>New Page <b class="caret"></b></a>
              <div class="dropdown-menu">
                <ul id="newPageSelector"></ul>
              </div>
            </li>
          </cfif>
          <li class="dropdown">
            <a id="pageListSelector" class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-documents-stack"></i>Pages <b class="caret"></b></a>
            <ul class="dropdown-menu" id="pageList">
              <li>
                <ul id="pageTree" class="jstree-classic"> </ul>
              </li>
            </ul>
          </li>
          <li id="saveButton" class="hidden"><a id="savePage" href="/sums/page/#paramValue("rc.requestData.page.name","")#" class="hidden adminLink"><i class="icon-disk"></i>Save</a></li>
          <cfif isDefined("rc.requestData.page.nodeRef")>
            <li class="dropdown">
              <a id="pageLinks"  class="dropdown-toggle" data-toggle="dropdown" href="/sums/admin/links?page=#rc.requestData.page.nodeRef#" ><i class="icon-chain--plus"></i>Links <b class="caret"></b></a>
              <ul class="dropdown-menu" id="linkSelector"></ul>
            </li>
          </cfif>
          <cfif isDefined("rc.requestData.page.versionHistory")>
            <li class="dropdown">
              <a id="pageVersions"  class="dropdown-toggle" data-toggle="dropdown" href="##" ><i class="icon-cards-stack"></i>Page History <b class="caret"></b></a>
              <ul style="margin:0" class="dropdown-menu">
                <li>
                  <ul style="margin:0" id="pageHistory">
                    <cfloop array="#rc.requestData.page.versionHistory#" index="n">
                      <li><a href="/sums/page/a?nodeRef=#n.nodeRef#">Version: #n.versionLabel# Saved on: #n.createdDate#</a></li>
                    </cfloop>
                  </ul>
                </li>
              </ul>
            </li>
          </cfif>
          <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.publish AND isDefined("rc.requestData.page.isWorkingCopy") AND rc.requestData.page.isWorkingCopy>
            <li><a href="/sums/admin/publish?nodeRef=#rc.requestData.page.nodeRef#"><i class="icon-disk-share"></i>Publish</a></li>
            <li><a href="/sums/page/cancelcheckout/a?nodeRef=#rc.requestData.page.nodeRef#"><i class="icon-cross-shield"></i>Cancel Changes</a></li>
          </cfif>
          <cfif isDefined("rc.requestData.page.checkedOut") AND rc.requestData.page.checkedOut>
            <li><a href="/sums/page/a?nodeRef=#rc.requestData.page.workingCopy.nodeRef#" title="#rc.requestData.page.workingCopy.owner# has a working copy of this page"><i class="icon-lock-unlock"></i>View working copy</a></li>
          </cfif>
          <cfif (isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit) OR isDefined("rc.parentNodeRef")>
            <li><a href="##pageAttributes" data-toggle="modal"><i class="icon-blog--pencil"></i>Properties</a></li>
          </cfif>
          <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit>
            <li><a class="deletepage" href="/sums/page/a?nodeRef=#rc.requestData.page.nodeRef#" title="Delete this page"><i class="icon-cross-circle-frame"></i>Delete</a></li>
          </cfif>
          <li><a name="Browse Web Media" href="/bv/documents/getFolder?siteID=#rc.siteID#&folder=web/media" class="doDialog"><i class="icon-folder-open-image"></i>Media</a></li>

        </cfif>
       </ul>
       <ul class="nav pull-right" style="margin-right: 60px;">
        <li class="dropdown">
          <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-hammer-screwdriver"></i>Tools <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li class="dropdown-submenu">
              <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-tools"></i>Emulation <b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a class="emulate" data-emulation="iphone" data-orientation="vertical" href="##"><i class="icon-media-player-phone"></i> iPhone</a></li>
                <li><a class="emulate" data-emulation="iphone" data-orientation="horizontal" href="##"><i class="icon-media-player-phone-horizontal"></i> iPhone Sideways</a></li>
              </ul>
            </li>
            </li>
            <li><a href="/login/logout"><i class="icon-arrow"></i>Logout</a></li>
            <li><a class="off" href="/eunify/contact/layoutMode?layoutmode=intranet"><i class="icon-lock"></i>Intranet</a></li>
            <li><a href="##" class="editable" id="disableInlineEditing"><i class="icon-lock-unlock"></i><span>Inline editing enabled</span></a></li>

          </ul>
        </li>
      </ul>
    </div>
  </div>
  </cfoutput>
</div>
<a href="##" id="BMNetAdmin"></a>
<cfif isUserInAnyRole("staff,ebiz")>
<cfoutput>
    <div class="modal hide fade-in" id="pageAttributes" tabindex="-1" role="dialog" data-show="#IIF(rc.initialDialog,"'show'","'hide'")#">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3 id="myModalLabel">Page Attributes</h3>
      </div>
      <div class="modal-body"><cfoutput>#renderView(view="templates/edit/attributes/index",module="sums")#</cfoutput></div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
        <button class="btn btn-primary save_settings">Save changes</button>
      </div>
    </div>
</cfoutput>
</cfif>
