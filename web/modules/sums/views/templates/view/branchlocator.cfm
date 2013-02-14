<cfset rc.branches = rc.templateModel.getBranches(rc.requestdata.page.attributes.customproperties.eGroupMemberID,"eGroup_cemco")>
<div class="row">
	<div class="span6">
		<ul class="thumbnails">
		<cfoutput query="rc.branches">
		  <li class="span2">
		  	<a href="http://" class="thumbnail">
          <img width="200" src="http://maps.googleapis.com/maps/api/staticmap?center=#address1#,#address2#,#town#,#county#,#postcode#&zoom=13&size=350x250&markers=color:green%7C#address1#,#address2#,#town#,#county#,#postcode#&sensor=false" alt="">
        </a>
		  </li>
			<li class="span4">
				<address>
					<strong>#name#</strong><br />
					<cfif address1 neq "">#address1#<br /></cfif>
          <cfif address2 neq "">#address2#<br /></cfif>
          <cfif address3 neq "">#address3#<br /></cfif>
          <cfif town neq "">#town#<br /></cfif>
          <cfif county neq "">#county#<br /></cfif>
          <cfif postcode neq "">#postcode#<br /></cfif>
          <cfif tel neq "">#tel#</cfif>

					<br /><br /><br />
				</address>
			</li>
		</cfoutput>
		</ul>
	</div>
</div>