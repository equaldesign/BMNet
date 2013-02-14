<cfset getMyPlugin(plugin="jQuery").getDepends("UI.autocomplete,labelOver","secure/security/manage","secure/table,secure/security")>
<cfoutput>
<div id="security">
  <input type="hidden" id="securityNodeRef" value="#replace(rc.node,':/','')#" />
  <cfif rc.security.canReadInherited>
  <cfif rc.security.isInherited>
  <h2>Secure this resource</h2>
  <div class="alert alert-info">
  	<a class="close">&times;</a>
    <h4>How to...</h4>
    <p> By default, all resources in Building Vine are viewable for all users that have access to your site.
        You can change this on a resource level - be that a folder, document, product, product price, press
        release, promotion - you name it, you can secure it. Security by default "inherits" - in other words,
        if you secure a folder all documents within that folder are
        therefore also secured.
    </p>
    <p>To secure this resource - follow the simple steps below.</p>
  </div>
  <div class="steps">
    <a href="##" rel="currentUsers" class="noAjax show secureResource">Secure this resource?</a>
    <ul>
      <li>Check "Secure this resource" from the right.</li>
      <li>Select the permissions you want to assign to your site users/groups.</li>
      <li>Choose the users/groups you want to assign the permissions to, then click add.</li>
    </ul>
  </div>
  <cfelse>
  <h2>This resource is secure!</h2>
  <div class="alert alert-info">
  	<a class="close">&times;</a>
    <h4>How to...</h4>
    <p> To remove the security on this resource, simply click "Remove resource security".
    </p>
  </div>
  <div class="steps">
    <a href="##" rel="currentUsers" class="noAjax show unsecureResource">Remove resource security? <i class="icon-unlock"></i></a>
  </div>
  </cfif>
  </cfif>
  <br class="clear" clear="all" />
  <div id="usersandsecurity" class="#IIf(rc.security.isInherited,DE('hidden'),DE(''))#">
    <div id="currentUsers">
      <h3>Current Priviledges</h3>
      <table id="direct">
        <tbody>
        <cfloop array="#rc.security.direct#" index="authority">
          <tr class="userItem">
          <cfset auth = getAuthorityType(authority.authority.name,authority.authority.displayname)>
          <td class="authName authority_#auth.type#">#auth.display#</td>
          <td width="40%">#Replace(authority.role,"Site","")#</td>
          <td nowrap="nowrap"><a rev="#authority.role#" rel="#authority.authority.name#" href="##" class="removeUser"></a></td>
          </tr>
        </cfloop>
        </tbody>
      </table>
    </div>
    <div id="findUsers">      
      <form class="form-horizontal">
      	<div class="control-group">
	      	<label class="control-label">Users</label>
					<div class="input-append">
						<input type="text" id="userSearch" class="span2" placeholder="search..." />
						<span class="add-on"><i class="icon-search"></i></span>
					</div>
				</div>
      </form>			
      <form class="form-horizontal">
        <div class="control-group">
        	<label class="control-label">Groups</label>
	        <div class="input-append">
	          <input type="text" id="groupSearch" class="span2" placeholder="search..." />
	          <span class="add-on"><i class="icon-search"></i></span>
	        </div>
				</div>
      </form> 
			<h4>Permission</h4>
      <select id="newUserLevel">
        <option selected=selected value="Consumer">View only</option>
        <option value="Contributor">Add</option>
        <option value="Collaborator">Edit</option>
        <option value="Manager">Manage</option>
      </select>
      <div>
      </div>
    </div>
  </div>
</div>
</cfoutput>

