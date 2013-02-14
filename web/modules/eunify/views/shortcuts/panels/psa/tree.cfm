<cfoutput query="rc.subCats">
	<li class="jstree-closed" id="#oID#"><a href="##">#name#</a></li>
</cfoutput>
<cfoutput query="rc.deals">
	<li class="#IIF(memberID eq rc.sess.eGroup.memberID,"'memberdeal'","'jstree-leaf'")#" id="#id#"><a href="##">#name#</a></li>
</cfoutput>

