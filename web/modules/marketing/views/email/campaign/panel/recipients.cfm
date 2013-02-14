<cfset getMyPlugin(plugin="jQuery").getDepends("","email/recipients","")>

<cfoutput>
<h3>Campaign Recipients</h3>
<div class="row-fluid">
  <div class="span4">
    <div class="accordion">
      <h5><a href="##">Group List</a></h5>
      <div>
        <div class="widget-box">
          <div class="widget-title">
            <h4>Group List</h4>
          </div>
          <div class="widget-content nopadding">
            <table id="groupList" class="table table-striped table-condensed table-hover">
              <thead>
                <tr>
                  <th>Name</th>
                  <th width="1%"></th>
                </tr>
              </thead>
              <tbody>

                <cfloop query="rc.groupList">
                <tr id="group_#id#" class="jstree-draggable">
                  <td>#name#</td>
                  <td><button data-type="group" data-id="#id#" class="btn btn-small btn-sucess addobject"><i class="icon-tick-circle-frame"></i></td>
                </tr>
                </cfloop>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <h5><a href="##">Query Builder</a></h5>
      <div>
        <form class="form form-inline" action="/marketing/email/recipient/query" method="post">
          <label class="control-label" for="pre-list">Pre-defined Queries</label>
          <select name="queryList" id="queryList">
            <option>--select</option>
            <cfloop query="rc.prequeries">
            <option value="#id#">#name#</option>
            </cfloop>
          </select>
          <button data-target="##queryDesigner" type="button" class="btn btn-mini" data-toggle="modal"><i class="icon-pencil"></i>New</button>
        </form>
        <div class="widget-box">
          <div class="widget-title">
            <h4>Query List</h4>
          </div>
          <div class="widget-content nopadding">
            <table id="queryListTable" class="table table-striped table-hover table-condensed">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Company</th>
                  <th width="1%"></th>
                </tr>
              </thead>
              <tbody>
              </tbody>
              <tfoot>
                <tr>
                  <th style="text-align: right" colspan="2">Add All</th>
                  <th><button data-type="all" data-id="#id#" class="btn btn-small btn-sucess addall"><i class="icon-exclamation-red-frame"></i></button></th>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="span8">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Recipient List</h5>
      </div>
      <div class="widget-content nopadding">
        <table id="recipientList" data-campaignID="#rc.campaign.id#" class="table table-striped table-hover table-condensed">
          <thead>
            <tr>
              <th>Name</th>
              <th>Company</th>
              <th width="1%"></th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
</cfoutput>
<cfif isUserInRole("ebiz")>
<div id="queryDesigner" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3 id="myModalLabel">Query Designer</h3>
  </div>
  <div class="modal-body">
    <form class="form form-horizontal">
      <fieldset>
        <div class="control-group">
          <label class="control-label" for="queryname">Name</label>
          <div class="controls">
            <input type="text" name="newqueryname" placeholder="name..." />
          </div>
        </div>
        <div class="control-group">
          <textarea style="width:97%; height: 100px;" name="q"></textarea>
        </div>
      </fieldset>
    </form>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-servers"></i> run query</button>
    <button class="btn btn-primary"><i class="icon-save"></i> save query</button>
  </div>
</div>

</cfif>
