<table class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>id</th>
			<th>Name</th>
			<th>Subject</th>
			<th>Sent</th>
			<th>Sent to</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="rc.campaigns">
			<tr>
				<td><a href="/email/detail/id/#id#">#id#</a></td>
				<td><a href="/email/detail/id/#id#">#name#</a></td>
				<td><a href="/email/detail/id/#id#">#subject#</a></td>
				<td><a href="/email/detail/id/#id#">#sent#</a></td>
				<td><a href="/email/detail/id/#id#">#sentto#</a></td>
			</tr>
		</cfoutput>
	</tbody>
</table>