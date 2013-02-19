<table class="table table-bordered table-condensed table-striped table-hover">
  <thead>
    <th>Item</th>
    <th>Activity</th>
    <th>Time running</th>
  </thead>
  <tbody>
    <cfoutput query="rc.openItems">
    <tr>
      <td><a href="/flo/item/detail/id/#id#">#name#</a></td>
      <td><a href="/flo/item/detail/id/#id#">#activityName#</a></td>      
      <td>#running# hrs.</td>      
    </tr>
    </cfoutput>
  </tbody>
</table>
 