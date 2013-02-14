
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
<cfset getMyPlugin(plugin="jQuery").getDepends("upload,cookie,block,bbq,hoverIntent,json,jstree,slimScroll,filedrop","admin","form,admin,tree/style",false,"sums")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/documents/documents,secure/documents/uploadify",false,"bv")>
<cfset sumsAdminBar = getPLugin("CookieStorage").getVar("SUMSAdminBar","none")>
<cfoutput>
    <input type="hidden" id="alf_ticket" value="#request.user_ticket#" />
    <input type="hidden" id="pageNodeRef" value="#paramValue('rc.requestData.page.nodeRef','')#">
</cfoutput>
<div id="adminBar" style="display:<cfoutput>#sumsAdminBar#</cfoutput>">
  <cfoutput>
  <input type="hidden" id="siteID" value="#rc.siteID#">
  <ul>
    <cfif event.getCurrentModule() eq "sums">
    <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit>
      <li class="adminLink"><a id="newPage" href="/sums/admin/newpage?parentNoderef=#rc.requestData.page.nodeRef#" class="adminLink new_page">New Page</a>
      <div class="dropdown" id="newPageSelector">

      </div>
      </li>

    </cfif>
    <li class="adminLink"><a href="##" id="pageList" class="adminLink pages">Pages</a>
    <div class="dropdown" id="pageListSelector">
      <ul id="pageTree" class="jstree-classic"></ul>
    </div>
    </li>
    <li id="saveButton" class="hidden adminLink"><a href="/sums/page/#paramValue("rc.requestData.page.name","")#" class="adminLink save_page">Save</a></li>
    <cftry>
   <cfif isDefined("rc.requestData.page.nodeRef")>
    <li class="adminLink"><a id="pageLinks" href="/sums/admin/links?page=#rc.requestData.page.nodeRef#" class="adminLink page_links">Links</a>
      <div class="dropdown" id="linkSelector">

      </div>
    </li>
    </cfif>
    <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.publish AND isDefined("rc.requestData.page.isWorkingCopy") AND rc.requestData.page.isWorkingCopy>
      <li class="adminLink"><a href="/sums/page/checkin/a?nodeRef=#rc.requestData.page.nodeRef#" class="adminLink publish_page">Publish</a></li>
      <li class="adminLink"><a href="/sums/page/cancelcheckout/a?nodeRef=#rc.requestData.page.nodeRef#" class="adminLink cancel_checkout">Cancel Changes</a></li>
    </cfif>
    <cfif isDefined("rc.requestData.page.checkedOut") AND rc.requestData.page.checkedOut>
      <li class="adminLink"><a href="/sums/page/a?nodeRef=#rc.requestData.page.workingCopy.nodeRef#" class="adminLink working_copy" title="#rc.requestData.page.workingCopy.owner# has a working copy of this page">View working copy</a></li>
    </cfif>
    <cfif (isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit) OR isDefined("rc.parentNodeRef")>
      <li class="adminLink"><a href="##pageAttributes" data-toggle="modal" class="adminLink page_attributes">Properties</a></li>
    </cfif>
    <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit>
      <li class="adminLink"><a href="/sums/page/a?nodeRef=#rc.requestData.page.nodeRef#" class="adminLink delete_page" title="Delete this page">Delete</a></li>
    </cfif>
    <!---<cfif isDefined("rc.requestData.page.nodeRef")>
      <li class="adminLink"><a href="/sums/page/versions/#rc.name#" class="adminLink page_versions">Versions</a></li>
    </cfif>--->
    <cfcatch type="any"><!--- first page? ---></cfcatch>
    </cftry>
    </cfif>
    <li class="adminLink"><a name="Browse Web Media" href="/bv/documents/getFolder?siteID=#rc.siteID#&folder=web/media" class="doDialog adminLink media_library">Media</a></li>
    <li class="adminLink backtointranet"><a href="/eunify/contact/layoutMode?layoutMode=intranet" class="adminLink backtointranet">Back to Intranet</a></li>
  </ul>
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
      <div class="modal-body"><cfoutput>#renderView(view="templates/edit/attributes",module="sums")#</cfoutput></div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
        <button class="btn btn-primary save_page">Save changes</button>
      </div>
    </div>
</cfoutput>
</cfif>