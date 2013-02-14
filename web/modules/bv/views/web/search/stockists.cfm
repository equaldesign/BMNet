<cfoutput>
<div class="alert alert-info">
  <h4 class="alert-heading">Results</h4>
  <p>We found <span class="label label-danger">#rc.stockists.recordCount#</span> Merchants within 20 miles of your location that likely stock this product</p>
</div>
</cfoutput>
<cfoutput query="rc.stockists">
  <cfswitch expression="#buyingGroup#">
    <cfcase value="eGroup_cemco">
      <cfset logo = "http://www.cemco.co.uk/includes/images/sites/cemco/company/#companyID#_square.jpg">
    </cfcase>
    <cfcase value="eGroup_cbagroup">
      <cfset logo = "http://www.cbagroup.co.uk/includes/images/sites/cbagroup/company/#companyID#_square.jpg">
    </cfcase>
    <cfcase value="eGroup_nbg">
      <cfset logo = "http://www.nbgpartner.com/includes/images/sites/nbg/company/#companyID#_square.jpg">
    </cfcase>
    <cfcase value="eGroup_handbgroup">
      <cfset logo = "http://www.handbgroup.com/includes/images/sites/handbgroup/company/#companyID#_square.jpg">
    </cfcase>
  </cfswitch>
  <div class="media">
    <a class="pull-left" href="##">
      <img class="media-object img-polaroid" src="http://maps.googleapis.com/maps/api/staticmap?center=#branchLat#,#branchLong#&zoom=11&size=100x100&markers=color:green%7C#branchLat#,#branchLong#&sensor=false" />      
    </a>
    <div class="media-body">
      <div class="media">
        <a class="pull-left" href="##">
          <img class="media-object img-polaroid" src="#logo#">
        </a>
        <div class="media-body">
          <h4 class="media-heading">#companyName#</h4>
          <h5>Distance from you: #DecimalFormat(distance)# Miles.</h5>
          <p>
            <address>#branchAddress1#<br />#branchTown# <br/>#branchPostcode#</address>
          </p>
          <p>Tel: #branchTel#</p>
        </div>
      </div>    
    </div>
  </div>
</cfoutput>