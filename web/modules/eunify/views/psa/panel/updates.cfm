<h2>Updates &amp; Activity</h2>
<cfoutput query="rc.panelData.feed">
  <div class="article articlestyle_#catName#">
    <div class="newstitle">

    #details# <span class="timestamp">(#DateFormat(tstamp,"DD MMM YY")# @ #TimeFormat(tstamp,"HH:MM")#)</span>
    </div>
  </div>
  </cfoutput>