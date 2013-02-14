<cffunction name="renderUnits">
  <cfargument name="currentUnit">
  <cfargument name="Product_Code">
  <cfargument name="inputName">
  <cfoutput>
    <select class="iu" data-product_code="#Product_Code#" name="#arguments.inputName#">
      <option value="">--select--</option>
      <cfloop query="rc.unitTypes">
        <option value="#type#" #vm(type,currentUnit)#>#display#</option>
      </cfloop>
    </select>
  </cfoutput>
</cffunction>