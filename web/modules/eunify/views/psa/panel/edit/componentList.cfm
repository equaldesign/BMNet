<cfoutput>
<h1>3. Deal Components</h1>
<cfloop array="#rc.panelData.xml.arrangement.xmlChildren#" index="section">
    <h2>#section.xmlAttributes.title#</h2>
    <div id="#section.xmlName#_list" class="comp">
    <cfif StructKeyExists(section,"component")>
      <cfloop array="#section.component#" index="element">
        <cfif canView(element)>
            <cfset rc.component = element>
            <cfoutput>#renderView("psa/element/edit/component")#</cfoutput>
         </cfif>
      </cfloop>
    </cfif>
    <div class="clearer"></div>
    </div>
    <br class="clear" />
  <div class="addComponentDiv">
    <ul>
      <li><a href="##" class="tooltip addComponent" rel="meta" title="Add a general element to the #section.xmlAttributes.title# section"  rev="#section.xmlName#">add general element</a></li>
      <cfif section.xmlName eq "rebate">
      <li><a href="##" class="addComponent rebate tooltip" title="Add a new rebate element" rel="rebate" rev="#section.xmlName#">add rebate element</a></li>
      </cfif>
    </ul>
  </div>
  <br class="clear" />
</cfloop>
</cfoutput>