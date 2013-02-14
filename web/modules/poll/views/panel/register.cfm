<cfset getMyPlugin(plugin="jQuery").getDepends("stepper,validate","poll/register")>
<cfoutput>
<h2>#rc.pollData.name#</h2>
<cfif rc.completed>
<div class="Aristo ui-widget">
  <div id="formError" style="margin: 10px 0px; padding: 0pt 0.7em;" class="hidden ui-state-highlight ui-corner-all">
    <p>
    <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>You have already completed this questionnaire. You can complete it again if you wish, but your original answers will be overwritten.
    </p>
  </div>
</div>
</cfif>
</cfoutput>
<cfoutput>
<form class="form form-horizontal" id="register" method="post" action="#bl('poll.doSubmit')#">
</cfoutput>
  <cfif rc.pollData.description neq "">
    <fieldset>
    <legend>Information</legend>
      <div class="alert alert">
        <cfoutput>#rc.pollData.description#</cfoutput>
      </div>
    </fieldset>
  </cfif>
  <!--- get the registration groups --->
  <cfset metaData = rc.poll.getPollGroups(rc.id)>
  <cfoutput query="metaData">
    <fieldset>
      <legend>#name#</legend>
      <cfif description neq "">
      <div class="alert alert-info">
        #description#
      </div>
      </cfif>
      <cfset fields = rc.poll.getPollFields(metaData.id)>
      <cfloop query="fields">
        <cfswitch expression="#_type#">
          <cfcase value="radio">
            <div class="control-group">
              <label class="control-label" for="field_#fields.id#">#fields.label#<cfif _required><em>*</em></cfif></label>
              <div class="controls">
                <cfset optionCount = 1>
                <cfset fieldOptions = rc.poll.getPollFieldOptions(fields.id)>
                <cfloop query="fieldOptions">
                <label class="radio">
                  <input class="<cfif fields._required>required</cfif>" #vm(optionCount,1,"checkbox")# type="radio" name="field_#fields.id#" value="#fieldOptions.id#" />
                  #fieldOptions.label#
                </label>
                <cfset optionCount++>
                </cfloop>
                <cfif fields.name neq "">
                <span class="help-inline">#fields.name#</span>
                </cfif>
              </div>
            </div>
          </cfcase>
          <cfcase value="stepper">
            <div class="control-group">
              <label class="control-label" for="field_#fields.id#">#fields.label#<cfif _required><em>*</em></cfif></label>
              <div class="controls">
                <span class="input-append">
                  <input type="text" name="field_#fields.id#" size="2" autocomplete="off" class="disabled ui-stepper-textbox input-mini" data-increments="#fields._increments#" data-max="#fields._max#" />
                </span>
                <span class="label label-success stepper_value" data-price="#fields.name#">&pound;0</span>&nbsp;<span>Guide Price &pound;#fields.name# per unit.</span>
              </div>
            </div>
          </cfcase>
          <cfcase value="checkbox">
            <div class="control-group">
              <label class="control-label" for="field_#fields.id#">#fields.label#<cfif _required><em>*</em></cfif></label>
              <div class="controls">
                <label class="radio">
                  <input type="checkbox" name="field_#fields.id#"  class="<cfif _required>required</cfif> field_#metaData.id#" value="true" />
                  #label#
                </label>
              </div>
            </div>
          </cfcase>
          <cfcase value="text">
            <div class="control-group">
              <label class="control-label" for="#fields.name#">#label#<cfif _required><em>*</em></cfif></label>
              <div class="controls">
                <input class="<cfif requirenumeric>requirenumeric</cfif> <cfif _required>required</cfif>" type="text" id="field_#fields.id#" size="#_length#" name="field_#fields.id#" value="" />
              </div>
            </div>
          </cfcase>
          <cfcase value="textarea">
            <div class="control-group">
              <label class="control-label" for="#fields.name#">#label#<cfif _required><em>*</em></cfif></label>
              <div class="controls">
                <textarea class="<cfif _required>required</cfif>" id="field_#fields.id#" name="field_#fields.id#" value=""></textarea>
              </div>
            </div>
          </cfcase>
        </cfswitch>
      </cfloop>
    </fieldset>
  </cfoutput>
  <fieldset id="stepperTotal" class="hidden">
    <legend>Running Total</legend>
    <div class="alert alert-error">
      <a class="close" data-dismiss="alert">&times</a>
      <h3 class="alert-heading">About the total</h3>
      <p>The amount above is a running total of the guide price for your potential commitment to this BBO. Please note that the actual total may differ at the time of the order placement as circumstances dictate. For more information see the additional information at the top of this screen, or contact the BBO administrator.</p>
    </div>
  </fieldset>
  <cfoutput>
    <input type="hidden" id="pollID" name="pollID" value="#rc.id#">
  <input type="hidden" id="contactID" name="contactID" value="#rc.sess.eGroup.contactID#">
  </cfoutput>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Finish &raquo;" />
  </div>
</form>
