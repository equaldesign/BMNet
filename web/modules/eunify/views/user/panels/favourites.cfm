<h1>Favourites</h1>
<cfif rc.favourites.recordCount eq 0>
	<div class="Aristo ui-widget">
			<div style="margin-top: 20px; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
				<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
				This contact does not have any favourites</p>
			</div>
	</div>
<cfelse>
	<div class="favs">
		<cfoutput query="rc.favourites">
		  <div class="favourite">
		    <a href="#bl('company.index','id=#id#')#">
				<img class="tooltip fav" src="#paramImage('company/#id#_square.jpg','company/default_small.jpg')#" title="#capFirstTitle(known_as)#" />
				</a>
				<p>
				  <cfif buildingVine><img src="/images/icons/buildingvine.png" /></cfif>
					<cfif web neq ""><a href="#web#" target="_blank"><img border="0" src="/images/icons/globe-network-ethernet.png" /></a></cfif>
					<cfif email neq ""><a href="mailto:#lcase(email)#" target="_blank"><img border="0" src="/images/icons/mail-send-receive.png" /></a></cfif>
					 </p>
			</div>
		<cfif currentRow MOD(9) eq 0>
		  <br class="clear" clear="all" />
		</cfif>
		</cfoutput>
	</div>
</cfif>
<br class="clear" clear="all" />