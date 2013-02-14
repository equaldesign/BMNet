<cfset getMyPlugin(plugin="jQuery").getDepends("validate","psa/dealnotification")>
<cfoutput>
<div class="form-signUp">
  <h2>Notify members</h2>
  <form class="form" id="dealNotification" method="post" action="#bl('psa.notifymembersDo')#">
  <input type="hidden" name="psaid" value="#rc.psaID#">
  <p>Required fields are are denoted by <em>*</em></p>
  <div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    A blog post will also be created that links to this agreement</p>
  </div>
    <fieldset>
      <legend>Update details</legend>
      <div>
        <label for="title" class="o">Title <em>*</em></label>
        <input size="30" type="text" name="title" id="title" value="" />
      </div>
      <div>
        <label for="importance" class="o">Notification Type<em>*</em></label>
        <select name="importance" multiple="multiple">
          <option value="1">1 Very Important</option>
          <option value="2">2 Important</option>
          <option value="3">3 Price Lists</option>
          <option value="4">4 Promotions and Offers</option>
          <option value="5">5 Minor Adjustments</option>
        </select>
      </div>
      <div>
        <label for="message" class="o">Message</label>
        <textarea name="message" id="message"></textarea>
      </div>

    </fieldset>
    <div class="rightControlSet">
      <div>
      <input class="doIt" type="submit" value="Notify members &raquo;" />
      </div>
    </div>
  </form>
</div>
</cfoutput>