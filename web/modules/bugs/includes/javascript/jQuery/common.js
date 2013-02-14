	function editNote(noteid) {
		window.open("/intranet/main/win.cfm?app=CA&action=editNote&noteid=" + noteid,"editNote","width=400, height=300, scrollbars=0, toolbar=0");
	}
	<cfoutput>
		function createnote() {
		window.open("/intranet/main/win.cfm?app=CA&psaID=#psaID#&notetypetype=arrangement&action=createnote","notes","width=300, height=400, scrollbars=0, resize=0, toolbars=0");
	}
	function jumpToAgreement(obj) {
		document.location.href = '/intranet/main/viewarrangement?psaID=' + obj.value;
	}
	function printAgreement(aid) {
		window.open("/intranet/main/win.cfm?printer=yes&app=CA&psaID=#psaID#&action=viewarrangement","printer","width=700, height=400, scrollbars=1, resize=0, toolbars=0");
	}
	</cfoutput>
	function deleteArrangement(id) {
	x = window.confirm("yes will delete this arrangement perminently?\nAre you sure you wish to continue?");
		if (x) {
			document.location.href = '/intranet/main/deletearrangement.do?psaID=' + id;
		}
	}