<cfoutput><form class="form form-horizontal" action="/admin/cbbo/id/#rc.id#" method="post">
  <fieldset>
    <legend>Create new Bulk Buying Opportunity (BBO)</legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input name="name" type="text" /><span class="help-inline">The name for this BBO</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Notes</label>
      <div class="controls">
        <textarea name="description" rows="8">Notes: Edit to add any useful notes here.</textarea>
      </div>
    </div>
    <div class="control-group">
      <label for="organiserID" class="control-label">Administrator</label>
      <cfset memberContacts = getModel("contact").getCompanyTypeContacts("1,3")>
      <cfset orgID = rc.sess.eGroup.contactID>
      <div class="controls">
        <select name="organiserID" id="organiserID">
          <cfloop query="memberContacts">
          <option value="#id#" #vm(orgID,"#id#","select")#>#first_name# #surname# (#name#)</option>
          </cfloop>
        </select>
        <span class="help-inline">Negotiator and/or lead negotiator</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="categoryID">Category</label>
      <div class="controls">
        <select multiple="true" name="categoryID" id="categoryID">
         <!--- TODO <cfset buyingTeam = arrangement.getBuyingTeam('building')> --->
          <option value="">-- choose a Category --</option>
          <cfset groups = getModel("groupService")>
          <cfset bTeams = groups.getCommittees(true)>
          <cfloop query="bTeams">
            <cfif IsUserInAnyRole("egroup_admin,egroup_edit,egroup_#name#")>
              <option value="#id#">#name#</option>
            </cfif>
          </cfloop>
        </select>
      </div>
    </div>
  </fieldset>
  <div class="alert alert-info">
    <a href="##" class="close" data-dismiss="alert">&times;</a>
    <h3 class="alert-heading">Adding products</h3>
    <p>You can enter up to 10 products below. Only fill in the fields you need.</p>
  </div>
  <fieldset>
    <legend>Product 1</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[1].name" placeholder="Product 1 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[1].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[1].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[1].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 2</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[2].name" placeholder="Product 2 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[2].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[2].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[2].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 3</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[3].name" placeholder="Product 3 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[3].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[3].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[3].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 4</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[4].name" placeholder="Product 4 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[4].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[4].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[4].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 5</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[5].name" placeholder="Product 5 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[5].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[5].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[5].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 6</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[6].name" placeholder="Product 6 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[6].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[6].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[6].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 7</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[7].name" placeholder="Product 7 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[7].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[7].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[7].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 8</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[8].name" placeholder="Product 8 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[8].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[8].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[8].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 9</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[9].name" placeholder="Product 9 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[9].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[9].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[9].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Product 10</legend>
    <div class="control-group">
      <label class="control-label">Product Name</label>
      <div class="controls">
        <input type="text" name="product[10].name" placeholder="Product 10 name" />
        <p class="help-inline">Enter the name of the product</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Order multiple</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[10].multiple" placeholder="1" value="1" />
        <p class="help-inline">Leave default as 1, or restrict order by pack size/quantity?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Max Order size</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[10].maxordersize" placeholder="1" value="10000" />
        <p class="help-inline">Limit maximum quantity of order?</p>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Guide Price per unit</label>
      <div class="controls">
        <input class="input-mini" type="text" name="product[10].guideprice" placeholder="1" value="0" />
         <p class="help-inline">Guide price per unit (leave as zero if unknown)</p>
      </div>
    </div>
  </fieldset>
  <!---
  <div class="alert">
    <a href="##" class="close" data-dismiss="alert">&times;</a>
    <h3 class="alert-heading">Upload DCQ documents</h3>
    <p>If you need to upload documents relating to this DCQ, you can do this once you've created the DCQ from within the Documents tab</p>
  </div>--->
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Create new BBO" />
  </div>
</form>
</cfoutput>