<cfoutput>
<h1>Welcome #getModel("modules.eunify.model.ContactService").getContact(request.BMNet.contactID,3,request.siteID).first_name#</h1>
</cfoutput>
<div class="widget big-stats-container">
      
      <div class="widget-content">
        
        <div id="big_stats" class="cf">
      <div class="stat">                
        <h4>Pending Quotations</h4>
        <span class="value">12</span>               
      </div> <!-- .stat -->
      
      <div class="stat">                
        <h4>Completed Quotations</h4>
        <span class="value">23</span>               
      </div> <!-- .stat -->
      
      <div class="stat">                
        <h4>Returned Items Today</h4>
        <span class="value">2</span>                
      </div> <!-- .stat -->
      
      <div class="stat">                
        <h4>Something Else</h4>
        <span class="value">13</span>               
      </div> <!-- .stat -->
    </div>
  
  </div> <!-- /widget-content -->
  
</div>
<hr />
<div class="widget">
  <div class="widget-header">
    <i class="icon-quotelist"></i>
    <h3>Your last quotation request</h3>
  </div>
  <div class="widget-content">    
    <div class="stats">      
      <div class="stat">
        <span class="stat-value">12,386</span>                  
        Site Visits
      </div> <!-- /stat -->      
      <div class="stat">
        <span class="stat-value">9,249</span>                 
        Unique Visits
      </div> <!-- /stat -->      
      <div class="stat">
        <span class="stat-value">70%</span>                 
        New Visits
      </div> <!-- /stat -->      
    </div> <!-- /stats -->       
    <div id="chart-stats" class="stats">      
      <div class="stat stat-chart">             
        <div id="donut-chart" class="chart-holder" style="padding: 0px; position: relative; "><canvas class="base" width="264" height="100"></canvas><canvas class="overlay" width="264" height="100" style="position: absolute; left: 0px; top: 0px; "></canvas><div class="legend"><div style="position: absolute; width: 55px; height: 72px; top: 5px; right: 5px; background-color: rgb(255, 255, 255); opacity: 0.85; "> </div><table style="position:absolute;top:5px;right:5px;;font-size:smaller;color:#545454"><tbody><tr><td class="legendColorBox"><div style="border:1px solid #ccc;padding:1px"><div style="width:4px;height:0;border:5px solid rgb(255,153,0);overflow:hidden"></div></div></td><td class="legendLabel">Series 1</td></tr><tr><td class="legendColorBox"><div style="border:1px solid #ccc;padding:1px"><div style="width:4px;height:0;border:5px solid rgb(34,34,34);overflow:hidden"></div></div></td><td class="legendLabel">Series 2</td></tr><tr><td class="legendColorBox"><div style="border:1px solid #ccc;padding:1px"><div style="width:4px;height:0;border:5px solid rgb(119,119,119);overflow:hidden"></div></div></td><td class="legendLabel">Series 3</td></tr></tbody></table></div></div> <!-- #donut -->             
      </div> <!-- /substat -->      
      <div class="stat stat-time">                  
        <span class="stat-value">00:28:13</span>
        Average Time on Site
      </div> <!-- /substat -->      
    </div> <!-- /substats -->    
  </div>
</div>