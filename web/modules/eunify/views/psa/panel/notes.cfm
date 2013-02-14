<h1>Notes &amp; Updates</h1>
<cfoutput>
<div class="accordion">
<cfif StructKeyExists(PSA.arrangement,"notes") AND ArrayLen(psa.arrangement.marketing.XmlChildren) gte 1>
	<cfloop from="1" to="#ArrayLen(PSA.arrangement.notes.component)#" index="c">
	  <cfset curr = psa.arrangement.notes.component>
	  <cfif curr[c].details.XmlText neq "">
	  <h5><a href="##">#curr[c].title.XmlText#</a></h5>
	  <div>#paragraphFormat(curr[c].details.XmlText)#</div>
	  </cfif>
	</cfloop>
</cfif>
</div>
</cfoutput>