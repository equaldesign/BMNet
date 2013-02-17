<cfset getMyPlugin(plugin="jQuery").getDepends("","","comment",false,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","extra",true)>
<cfoutput>
<div class="page">
  <i class="ticketicon"></i>
<div class="page-header">
  <h1>#rc.bug.gettitle()#</h1>
</div>
<cfif NOT isUserLoggedIn()>
  <div class="alert">
    <h4 class="alert-heading">Not logged in</h4>
    <p>You are not logged in. This URL is not made public, so you can only view this ticket if you have the URL above.</p>
  </div>
</cfif>
<div class="accordion row-fluid">
  <div class="span4">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" href="##Details">
          <h4>Information</h4>
        </a>
      </div>
      <div id="Details" class="accordion-body collapse in">
        <table class="table table-condensed">      
          <tbody>
            <tr>
              <td><i class="icon-ticket"></i></td>
              <td>#rc.bug.getticket()#</td>
            </tr>
            <tr>
              <td><i class="icon-calendar"></i></td>
              <td>#DateFormatOrdinal(rc.bug.getcreated(),"DDDD D MMMM YYYY")#</td>
            </tr>
            <tr>
              <td><i class="icon-user"></i></td>
              <td><a href="mailto:#rc.bug.getemail()#">#rc.bug.getusername()#</a></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
  </div>
  <div class="span8">
    <!--- is there a workflow item? --->
    <cfif rc.items.recordCount neq 0>
      <!--- get the workflow item and list the tasks --->
      <cfset rc.item = rc.floTaskService.getTask(rc.items.id)>
      <cfoutput>#renderView(view="activity/list/embed",module="flo")#</cfoutput>
      <cfif isUserInRole("ebiz")>
      <div class="accordion-group">
        <div class="accordion-heading">
          <a class="accordion-toggle" data-toggle="collapse" href="##collapseOne">
            <h4>New Task</h4>
          </a>
        </div>
        <div id="collapseOne" class="accordion-body collapse">
          <div class="accordion-inner">
            <cfoutput>#renderView(view="activity/new",module="flo",args={hasItem=true})#</cfoutput>
          </div>
        </div>
      </div>
      </cfif>
    <cfelse>
      <cfif isUserInRole("ebiz")>
        <!--- create a workflow item? --->
        <div class="accordion-group">
          <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" href="##newworkflow">
              <h4>Workflow</h4>
            </a>
          </div>
          <div id="newworkflow" class="accordion-body collapse in">
            <p>Confirm the validity of this issue by generating a workflow item</p>
            <form action="/flo/item/do" method="post">
              <!--- workflow details name --->
              <input type="hidden" name="name" value="#rc.bug.gettitle()#">
              <input type="hidden" name="itemType" value="8">
              <input type="hidden" name="status" value="active">
              <input type="hidden" name="stage" value="35">
              <input type="hidden" name="relationship[1].contact" value="#rc.bug.getcontactID()#" />
              <input type="hidden" name="relationship[1].type" value="contact" />
              <input type="hidden" name="relationship[1].system" value="#rc.bug.getsite()#" />
              <input type="hidden" name="relationship[2].bug" value="#rc.bug.getid()#" />
              <input type="hidden" name="relationship[2].type" value="bug" />
              <input type="hidden" name="relationship[2].system" value="bugs" />
              <input type="hidden" name="participant[1].contact" value="#request.bmnet.contactID#" />
              <input type="hidden" name="participant[1].type" value="contact" />
              <input type="hidden" name="participant[1].system" value="BMNet" />
              <input type="submit" class="btn btn-mini" value="create workflow item">
            </form>
          </div>
        </div>
      <cfelse>
        <p>The validity of this ticket has not yet been established, therefore no workflow items to resolve any issues have been generated.</p>
        <p>Once the validity of this ticket has been confirmed, new workflow items will be generated in order to resolve the issue. You can check back here for updates on this issue.</p>
        <p>You will also be notified via email once this ticket is resolved and closed.</p>
      </cfif>
    </cfif>
  </div>
</div>
<div class="accordion row-fluid">
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" href="##Description">
        <h4>Description</h4>
      </a>
    </div>
    <div id="Description" class="accordion-body collapse in">
      #paragraphFormat(rc.bug.getdescription())#
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" href="##attachments">
        <h4>Attachments</h4>
      </a>
    </div>
    <div id="attachments" class="accordion-body collapse in">
      <cfif rc.bug.attachments.recordCount neq 0>
        <ul class="thumbnails">
          <cfloop query="rc.bug.attachments">
          <li class="thumbnail"><a href="#bl('bugs.download','id=#id#')#">#listLast(filename,"/")#</a></li>
          </cfloop>        
        </ul>
      </cfif>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" href="##comments">
        <h4>Comments</h4>
      </a>
    </div>
    <div id="comments" class="accordion-body collapse in">
      <cfloop query="rc.bug.comments">
        <cfif event.getCurrentModule() neq ""><cfset commentAuthor = getModel("contact").getContactByEmail(email)></cfif>
        <div class="commentBox clearfix">
          <div class="commentTitle clearfix">
            <div class="commentSubject">#title#</div>
            <div class="commentAuthorImage">
    
              <cfoutput><img src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase('#email#')))#?size=25&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" alt=""  /></cfoutput>
              </div>
            <div class="commentMeta">
              <span class="commentDate">#DateFormatOrdinal(datestamp,"DDDD DD MMMM YYYY")# at #TimeFormat(datestamp,"HH:MM")#</span>
              <span class="commentAuthor"><cfif event.getCurrentModule() neq ""><a href="#bl('contact.index','id=#commentAuthor.id#')#">#username#</a><cfelse>#username#</cfif></span>
            </div>
          </div>
          <div class="commentContent">#ParagraphFormat2(stripOriginalMessage(comment))#</div>
        </div>
      </cfloop>
      <cfif isUserLoggedIn()>
      <form action="#bl('bugs.createcomment','bugID=#rc.bug.getid()#')#" class="form form-horizotnal">
        <div class="control-group">
          <textarea rows="10" class="input-xlarge" name="comment" richtext="true" toolbar="Basic"></textarea>
        </div>
        <div class="form-actions">
          <input name="submit" type="submit" class="btn btn-success" value="add comment" />
        </div>
      </form>
      </cfif>
    </div>
  </div>

<ul class="nav nav-tabs" id="ErrorDetails">
  <cfif rc.bug.getrequest() neq "">
  <li class="active"><a data-toggle="tab" href="##urlinfo">URL Information</a></li>
  <li><a data-toggle="tab" href="##errordetail">Error Detail</a></li>
  <li><a data-toggle="tab" href="##stacktrace">Stack Trace</a></li>
  <li><a data-toggle="tab" href="##usersettings">User Information</a></li>
  </cfif>
  <li><a data-toggle="tab" href="##codecommits">Code Commits</a></li>
</ul>
<div class="tab-content">
  <cfif rc.bug.getrequest() neq "">
  <div class="tab-pane active" id="urlinfo">
    <cfset testURL = rc.bug.geturl()>
    <cfset URLStruct = DeSerializeJSON(rc.bug.geturlVars())>
    <cfloop collection="#URLStruct#" item="k">
    <cfset testURL = "#testURL#/#k#/#URLStruct[k]#">
    </cfloop> 
    <a href="#testURL#" target="_blank">#testURL#</a>
    <h4>Form Fields Submitted</h4>
    <table class="table">
      <thead>
        <tr>
          <th>Field</th>
          <th>Value</th>
        </tr>
      </thead>
      <tbody>
      <cfset formFields = DeSerializeJSON(rc.bug.getformVars())>
      <cfloop collection="#formFields#" item="f">
      <tr>
        <td>#f#</td>
        <td>#formFields[f]#</td>
      </tr>
      </cfloop>
      </tbody>
    </table>

  </div>
  <div class="tab-pane" id="errordetail">
    #rc.bug.getrequest()#
  </div>
  <div class="tab-pane" id="stacktrace">
    #rc.bug.getreproduce()#
  </div>
  <div class="tab-pane" id="usersettings">
    #rc.bug.getbrowser()#

  </div>
  </cfif>
  <div class="tab-pane" id="codecommits">
    <cfloop query="rc.bug.commits">
      <cfset commitStruct = DeSerializejson(commitJSON)>
      <div class="commentBox clearfix">
        <div class="commentTitle clearfix">
          <div class="commentSubject">#commitStruct.commit.message#</div>
          <div class="commentAuthorImage">
  
            <cfoutput><img src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase('#commitStruct.commit.committer.email#')))#?size=25&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" alt=""  /></cfoutput>
            </div>
          <div class="commentMeta">
            <span class="commentDate">#DateFormatOrdinal(cdt6(commitStruct.commit.committer.date),"DDDD DD MMMM YYYY")# at #TimeFormat(cdt6(commitStruct.commit.committer.date),"HH:MM")#</span>
            <span class="commentAuthor">#commitStruct.commit.committer.name#</span>
          </div>
        </div>
        <div class="commentContent">
          <cfloop array="#commitStruct.files#" index="f">
          <pre class="prettyprint linenums languague-html">
            #htmlEditFormat(f.patch)#
          </pre>
          </cfloop>
        </div>
      </div>
    </cfloop>
    
  </div>
</div>

 

</cfoutput>



</div>
