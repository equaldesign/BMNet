<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","secure/sites/invite","")>
<div class="page-header">
  <h1>Invite Building Vine Users</h1>
</div>
<cfoutput>
<div id="inviteAlert" class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <div id="inviteBody">
    <h3>Existing Users</h3>
    <p>You can invite <strong>anyone</strong> to start using Building Vine - and they can sign up for <strong>free!</strong></p>
    <p>Anyone you invite will be automatically added to your site, and as soon as they've accepted your invitation, you can start allocating custom pricing, secure documents, and everything else that Building Vine offers.</p>
  </div>
</div>
<form class="form-horizontal" id="invite" action="/bv/sites/addUser" method="post">
  <fieldset>
     <legend>Add user/group without invitation <small>for existing Building Vine users only</small></legend>
     <div class="control-group">
      <label class="control-label" for="sType">Type</label>
      <div class="controls">
        <select name="sType" id="sType">
          <option value="user">user</option>
          <option value="group">group</option>
          <option value="site">sub site (advanced use only)</option>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="sQ">Name:</label>
      <div class="controls">
        <input type="text" name="sQ" id="sQ" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="userList">List</label>
      <div class="controls">
        <select id="userList" name="userList" multiple="true"></select>
      </div>
    </div>  
    <div class="control-group">
      <label class="control-label" for="siteRole">Role:</label>
      <div class="controls">
        <select name="siteRole" id="siteRole">
            <option value="SiteConsumer">Consumer (View)</option>
            <option value="SiteContributor">Contributor (Add)</option>
            <option value="SiteCollaborator">Collaborator (Edit)</option>
            <option value="SiteManager">Manager (Manage)</option>
         </select>
       </div>
     </div>
    <div class="form-actions">
       <input type="submit" value="Add Users/Groups &raquo;" class="btn btn-success" />
    </div>
  </fieldset>
</form>

</cfoutput>