<h1>Marketing</h1>
<cfoutput>
<cfif StructKeyExists(rc.panelData.xml.arrangement,"marketing") AND ArrayLen(rc.panelData.xml.arrangement.marketing.XmlChildren) gte 1>
<dl class="dlNice">
		
	<cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.marketing.component)#" index="c">   
	  <cfset curr = rc.panelData.xml.arrangement.marketing.component>
	  <cfif curr[c].details.XmlText neq "">
	  <dt>#curr[c].title.XmlText#</dt>
	  <dd>#curr[c].details.XmlText#</dd>
	  </cfif>
	</cfloop>
</dl>
<br clear="all" class="clear" />
</cfif>
</cfoutput>