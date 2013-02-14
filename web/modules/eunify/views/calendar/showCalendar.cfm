<cfset getMyPlugin(plugin="jQuery").getDepends("","calendar/index")>
<div class="widget-box widget-calendar">
  <div class="widget-title">
    <span class="icon"><i class="icon-calendar"></i></span>
    <h5>Calendar</h5>
    <div class="buttons">
      <a id="add-event" data-toggle="modal" href="/eunify/calendar/edit" class="btn btn-success btn-mini"><i class="icon-calendar--plus"></i> Add new event</a>
    </div>
  </div>
  <div class="widget-content nopadding">
    <div class="panel-left">
      <div id="calendar" class="fc"></div>
    </div>
    <div id="external-events" class="panel-right">
      <div class="panel-title"><h5>Events</h5></div>
      <div class="panel-content" id="eventList">
        <cfoutput>
          <div class="calendar-address" data-url="/eunify/calendar/appointmentList" data-bgcolor="##000000" data-textcolor="##FFFFF"></div>
          <div class="calendar-address" data-url="#getModel('eunify.ContactService').getContact(request.bmnet.contactID).gcalendar_address#" data-bgcolor="##000000" data-textcolor="##FFFFF"></div>
        </cfoutput>
      </div>
    </div>
  </div>
</div>
<div id="calendar"></div>