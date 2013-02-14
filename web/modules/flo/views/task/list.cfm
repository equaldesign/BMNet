<div class="row-fluid">
  <div class="span4">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-clipboard-task"></i></span>
        <h5>Active Items</h5>
      </div>
      <div class="widget-content nopadding">
        <table class="table table-striped table-hover table-rounded">
          <thead>
            <tr>
              <th>Name</th>
              <th>Type</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="rc.taskList">
              <tr>
                <td><a rev="previewPane" title="#description#" class="ttip" href="#bl('item.detail','id=#id#')#">#name#</a></td>
                <td><span class="label label-warning">#itemname#</span> <cfif stagename neq ""><span class="label label-info">#stagename#</span></cfif></td>
              </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
    </div>

  </div>
  <div class="span8 ajaxWindow" id="previewPane">

  </div>
</div>
