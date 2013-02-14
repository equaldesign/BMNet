<cfset getMyPlugin(plugin="jQuery").getDepends("","calendar/detail","")>
<cfoutput>
<div class="row-fluid">
  <div class="span4">
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-map"></i></a></span>
        <h5>Location Map</h5>
      </div>
      <div class="widget-content">
        <div id="mapOverview"  style="height:400px; width:100%"></div>
      </div>
    </div>
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-direction"></i></a></span>
        <h5>Directions from #rc.company.company_postcode#</h5>
        <div class="buttons"><a href="##" class="showRoute btn btn-mini"><i class="icon-marker"></i> Show on Map</a></div>
      </div>
      <div class="widget-content">
        <div id="overview"></div>
        <ol id="instructions" class="hide">
        </ol>
        <div class="form form-inline">
          <div class="input-aappend">
            <label class="m">Origin</label>
            <input type="text" id="u_address" size="20" value="#rc.company.company_address_1#,#rc.company.company_address_4#,#rc.company.company_postcode#" /><input id="recalc" type="button" class="btn" value="update &raquo;" />
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="span8">
    <h2><cfif rc.appointment.createdBy eq rc.sess.eGroup.contactID or isUserInAnyRole("egroup_admin,egroup_edit")>
        <a class="deleteIcon tooltip confirm" href="/calendar/delete/id/#rc.id#" title="delete this event"></a>
        <a class="editPencil tooltip" title="Edit this event" href="/calendar/edit/id/#rc.id#"></a>
      </cfif>
      #rc.appointment.name#

    </h2>
    <p><a class="returnToDay" href="#bl('calendar.day','date=#rc.appointment.startDate#')#">Back to day (#DateFormat(rc.appointment.startDate,"long")#)</a>
    <p>#rc.appointment.description#</p>

    <dl class="dl-horizontal">
      <dt>Start Time</dt>
      <dd>#TimeFormat(rc.appointment.startDate,"HH:MM")#</dd>
      <dt>Finish Time</dt>
      <dd>#TimeFormat(rc.appointment.endDate,"HH:MM")#</dd>
      <dt>Address</dt>
      <dd>#rc.appointment.address#</dd>
      <dt>Post Code</dt>
      <dd>#rc.appointment.postCode#</dd>
    </dl>
    <cfif rc.appointment.requireRegistration AND (rc.appointment.createdBy eq rc.sess.eGroup.contactID or isUserInAnyRole("egroup_admin,egroup_edit"))>
      <h4>This appointment requires registration <cfif rc.appointment.createdBy eq rc.sess.eGroup.contactID or isUserInAnyRole("egroup_admin,egroup_edit")><a name="Edit Registration Fields" title="Edit Registration Fields" href="/calendar/editRegistration/id/#rc.appointment.ID#" class="tooltip editPencil"></a></cfif></h4>

    </cfif>
    <h3>Related Documents  <cfif rc.appointment.createdBy eq rc.sess.eGroup.contactID or isUserInAnyRole("egroup_admin,egroup_edit")><a name="Manage related documents" title="Edit documents relating to this event" href="/documents/relatedCategories/relatedID/#rc.appointment.ID#/type/appointment" class="tooltip editPencil"></a></cfif></h3>
    <div class="psa_priceLists">
   <!---
   <cfloop query="rc.docs">
     <cftry>
      <cfif showThumbnail>
          <div class="image">
            <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#_small.jpg")>
              <a href="/documents/download/id/#id#" tar="_blank">
              <img border="0" align="left" class="priceListFile glow" width="80" src="/includes/images/thumbnails/#Setting('siteName')#/#id#_small.jpg" />
              </a>
            <cfelse>
              <cfset Model("dms").createThumbnails(id,filetype)>
            </cfif>
          </div>

          <div class="desc">
          <cfelse>
          <div>
          </cfif>
            <a href="/documents/download/id/#id#" tar="_blank"><h4 class="#fileType#">#ListAt(name,1,".")#</h4></a>
            <cfif timeSensitive>
              <cfset expiryDays = DateDiff("d",now,validTo)>
              <cfif expiryDays LT 60>
                <p class="expiry">Expires in <strong>#expiryDays# days</strong></p>
              </cfif>
            </cfif>
          </div>
          <br class="clear" />
          <cfcatch type="any"></cfcatch>
          </cftry>
      </cfloop>--->
      </div>

      <cfif rc.invited>
        <cfif rc.status eq "attending">
          <h3>You are attending this meeting</h3>
          <p><a href="#bl('calendar.confirm','canatten=false&id=#rc.id#')#">Change your mind</a></p>
        <cfelseif rc.status eq "declined">
          <h3>You declined to attend this meeting</h3>
          <p><a href="#bl('calendar.confirm','canattend=true&id=#rc.id#')#">Change your mind</a></p>
        <cfelse>
          <h3>You have not responded.</h3>
          <p><a href="#bl('calendar.confirm','canattend=true&id=#rc.id#')#">Agree to attend?</a> or <a href="#bl('calendar.confirm','canattend=false&id=#rc.id#')#">Decline to attend?</a> </p>
        </cfif>
      <cfelse>
      <h3>You have not been invited to this meeting</h3>
      </cfif>
    <input type="hidden" id="a_address" value="#rc.appointment.postCode#" />
    <div class="widget-box">
      <div class="widget-title">
        <span class="icon"><i class="icon-users"></i></span>
        <h5>Attendee List</h5>
        <cfif rc.appointment.createdBy eq request.bmnet.contactID or isUserInAnyRole("staff,admin,edit")>
          <div class="buttons">
            <a title="Invite more people to this event" href="#bl('calendar.editList','id=#rc.appointment.ID#')#" class="ttip btn btn-mini"><i class="icon-user--pencil"></i> Edit Invitees</a>
          </div>
        </cfif>
      </div>
      <div class="widget-content nopadding">
        <table data-campaignID="#rc.appointment.id#" class="table table-striped table-condensed table-hover" id="recipientList">
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
<div>
<cfset rc.comments = getModel("CommentService").getComments(rc.appointment.id,"calendar")>
<cfset rc.relatedID = rc.appointment.id>
<cfset rc.relatedType ="calendar">
<cfset rc.commentLink = "/comment/add/t/calendar/tID/#rc.appointment.id#">
<cfoutput>#renderView("comment/list")#</cfoutput>
</div>