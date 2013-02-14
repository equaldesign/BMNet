<cfset getMyPLugin("jQuery").getDepends("","tag/search")>
<cfset getMyPlugin(plugin="jQuery").getDepends("validate","branch/edit")>

<cfoutput>
  <cfif rc.branch.id eq ""><h2>Create new branch</h2></cfif>
  <form class="form form-horizontal" enctype="multipart/form-data" id="editBranch" method="post" action="#bl('branch.doEdit')#">
  <input type="hidden" name="id" value="#rc.branch.id#">
  <p>Required fields are are denoted by <em>*</em></p>
    <fieldset>
      <legend>&nbsp; Branch Information &nbsp;</legend>
      <div class="control-group">
        <label for="name"class="control-label">Name <em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="name" id="name" value="#rc.branch.name#" />
        </div>
      </div>
      <div class="control-group">
        <label for="known_as"class="control-label">Known As <em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="known_as" id="known_as" value="#rc.branch.known_as#" />
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Tags</legend>
      <div class="control-group">
        <label class="control-label">Add a tag</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on"><i class="icon-search"></i></span>
            <input class="input-medium tagSearch" />
            <input type="hidden" name="newTags" id="newTags" value="" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <div class="controls" id="tags">
          #renderView(view="tags/list",args={relationship="branch",id="#rc.id#",delete=true})#
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>&nbsp; Location &nbsp;</legend>
      <div class="control-group">
        <label for="address1"class="control-label">Address1</label>
        <div class="controls">
          <input size="50"  type="text" name="address1" id="address1" value="#rc.branch.address1#" />
        </div>
      </div>
      <div class="control-group">
        <label for="address2"class="control-label">Address2</label>
        <div class="controls">
          <input size="50"  type="text" name="address2" id="address2" value="#rc.branch.address2#" />
        </div>
      </div>
      <div class="control-group">
        <label for="address3"class="control-label">Address3</label>
        <div class="controls">
          <input size="50"  type="text" name="address3" id="address3" value="#rc.branch.address3#" />
        </div>
      </div>
      <div class="control-group">
        <label for="town"class="control-label">Town</label>
        <div class="controls">
          <input size="50"  type="text" name="town" id="town" value="#rc.branch.town#" />
        </div>
      </div>
      <div class="control-group">
        <label for="county"class="control-label">County</label>
        <div class="controls">
          <input size="50"  type="text" name="county" id="county" value="#rc.branch.county#" />
        </div>
      </div>
      <div class="control-group">
        <label for="postcode"class="control-label">Postcode</label>
        <div class="controls">
          <input type="text" name="postcode" id="postcode" value="#rc.branch.postcode#" />
          <a class="btn btn-info" id="CoOrdinates" href="##"><i class="icon-cog icon-white"></i>get co-ordinates</a>
        </div>
      </div>
      <div class="control-group">
        <label for="maplat"class="control-label">Latitude</label>
        <div class="controls">
          <input type="text" name="maplat" id="maplat" value="#rc.branch.maplat#" />
        </div>
      </div>
      <div class="control-group">
        <label for="maplong"class="control-label">Longitude</label>
        <div class="controls">
          <input type="text" name="maplong" id="maplong" value="#rc.branch.maplong#" />
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>&nbsp; Google Map &nbsp;</legend>
      <div><p id="addressInfo">&nbsp;</p></div>
      <div id="googleMap" style="height: 300px; width: 100%;">
      </div>
    </fieldset>
    <fieldset>
      <legend>&nbsp; Branch Contact Details &nbsp;</legend>
      <div class="control-group">
        <label for="tel"class="control-label">Telephone</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/telephone.png" /></span>
            <input type="text" name="tel" id="tel" value="#rc.branch.tel#" class="input-small" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="fax"class="control-label">Fax</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/fax.png" /></span>
            <input type="text" name="fax" id="fax" value="#rc.branch.fax#" class="input-small" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="email"class="control-label">Email</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/mail.png" /></span>
            <input size="50"  type="text" name="email" id="email" value="#rc.branch.email#" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="web"class="control-label">URL</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/earth.png" /></span>
            <input size="50"  type="text" name="web" id="web" value="#rc.branch.web#" />
          </div>
        </div>
      </div>
    </fieldset>
    <div class="form-actions">
      <input class="btn btn-success" type="submit" value="#IIF(rc.branch.id eq "", "'Create Branch'","'Save Branch'")# &raquo;" />
    </div>
      <cfif rc.companyID neq 0>
      <input type="hidden" name="company_id" value="#rc.companyID#" />
      <cfelse>
      <input type="hidden" name="company_id" value="#rc.branch.company_id#" />
      </cfif>
  </form>
</cfoutput>
