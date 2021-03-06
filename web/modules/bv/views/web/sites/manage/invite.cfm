<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","secure/sites/invite","")>
<div class="page-header">
  <h1>Invite People <small>You can invite anyone you want, and they can sign-up for free</small></h1>
</div>
<cfoutput>
<div id="inviteAlert" class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
	<div id="inviteBody">
	  <h3>About Invitations</h3>
	  <p>You can invite <strong>anyone</strong> to start using Building Vine - and they can sign up for <strong>free!</strong></p>
	  <p>Anyone you invite will be automatically added to your site, and as soon as they've accepted your invitation, you can start allocating custom pricing, secure documents, and everything else that Building Vine offers.</p>
	</div>
</div>
<form class="form-horizontal" id="inviteNew" action="/signup/invite" method="post">
	<input type="hidden" name="siteID" id="siteID" value="#rc.siteID#" />
    <fieldset>
	   <legend>Site Invitation <small>for new users</small></legend>
	   <div class="control-group">
       <label class="control-label" for="name">First Name:</label>
			 <div class="controls">
         <input type="text" name="first_name" id="first_name" value="" />
			 </div>
	   </div>
		 <div class="control-group">
       <label class="control-label" for="name">Surname:</label>
       <div class="controls">
         <input type="text" name="surname" id="surname" value="" />
       </div>
     </div>
		 
	   <div class="control-group">
	     <label class="control-label" for="email">Email:</label> 
	     <div class="controls">
			   <input type="text" name="email" id="email" value="" />
			 </div>
	   </div> 
		 <div class="control-group">
       <label class="control-label" for="name">CC me?</label>
       <div class="controls">
          <label class="checkbox">
					  <input type="checkbox" name="CCUser" value="true">
					  Copy me on the invitation email
					</label>				 
       </div>
     </div>
	   <div class="control-group">
	     <label class="control-label" for="message">Message</label>
	     <div class="controls">
			   <div class="alert alert-success"><strong>Note, </strong>anything in [brackets] should not be removed, however, you can move these items around in the introduction email if you desire.</div>
				 <textarea name="message" class="input-xxlarge" rows="10" id="message">
Dear [name],

I would like you to join our site on Building Vine.

Building Vine is a website and system that gives you access to hundreds of thousands of products within the construction industry.
Signup is free, all you need to do is follow this link and enter some basic information. [signuplink].

Once you have registered, you will get access to customer specific pricing and access to all our products, documents and marketing material.

Thank you.

#rc.buildingVine.userProfile.firstName# #rc.buildingVine.userProfile.lastName#
		   </textarea>

			 </div>
	   </div>
    <div class="form-actions">
      <input type="submit" value="Invite User &raquo;" class="btn btn-success" />
    </div>
	</fieldset>
</form>
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