<cfset getMyPlugin(plugin="jQuery").getDepends("upload","","comment",false,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","extra","fuui",true)>
<cfoutput>
<div class="page">
  <i class="ticketicon"></i>
<div class="page-header">
  <cfif isUserInRole("ebiz")>
  <div class="buttons btn-group pull-right" style="padding-right: 15px">
    <a href="#bl('bugs.delete','id=#rc.bug.getid()#')#" class="btn btn-mini"><i class="icon-cross-circle-frame"></i>delete bug</a>
    <a href="#bl('bugs.edit','id=#rc.bug.getid()#')#" class="btn btn-mini"><i class="icon-pencil"></i>edit bug</a>
  </div>
  </cfif> 
  <h1>#rc.bug.gettitle()#</h1> 
</div>
<cfif NOT isUserLoggedIn()>
  <div class="alert">
    <h4 class="alert-heading">Not logged in</h4>
    <p>You are not logged in. This URL is not made public, so you can only view this ticket if you have the URL above.</p>
  </div>
</cfif>
<cfif rc.bug.getstatus() eq "closed">
<div class="alert alert-success">
  <h4 class="alert-heading">Resolved.</h4>
  <p>This issue is now resolved.</p>
  <p>It was marked fixed on #DateFormatOrdinal(rc.bug.getmodified(),"DDDD D MMMM YYYY")# at #TimeFormat(rc.bug.getmodified(),"HH:MM")#</p>
</div>
</cfif> 
<div class="accordion row-fluid">
  <div class="span6">
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
              <td>Ref</td>
              <td>#rc.bug.getticket()# <a target="_blank" href="http://help.ebiz.co.uk/bugs/bugs/detail?ticket=#rc.bug.getticket()#&key=#hash(rc.bug.getemail())#"><i class="icon-globe-share"></i></a></td>
            </tr>
            <tr>
              <td><i class="icon-calendar"></i></td>
              <td>Created</td>
              <td>#DateFormatOrdinal(rc.bug.getcreated(),"DDDD D MMMM YYYY")# @ #TimeFormat(rc.bug.getcreated(),"HH:MM")#</td>
            </tr>
            <tr>
              <td><i class="icon-calendar-blue"></i></td>
              <td>Modified</td>
              <td>#DateFormatOrdinal(rc.bug.getmodified(),"DDDD D MMMM YYYY")# @ #TimeFormat(rc.bug.getmodified(),"HH:MM")#</td>
            </tr>
            <cfif rc.bug.getstatus() eq "closed">
            <tr>
              <td><i class="icon-calendar-select-days"></i></td>
              <td>Resolution time</td>
              <td>
                <cfset dur = Duration2(rc.bug.getcreated(),rc.bug.getmodified())>
                <cfif dur.days neq 0>
                #dur.days# day<cfif dur.days neq 1>s</cfif>,
                </cfif>
                <cfif dur.hours neq 0>
                #dur.hours# hour<cfif dur.hours neq 1>s</cfif>,
                </cfif>
                #dur.minutes# minute<cfif dur.minutes neq 1>s</cfif>
                
               </td>
            </tr>
            </cfif>
            <tr> 
              <td><i class="icon-user"></i></td>
              <td>Reported by</td>
              <td><a href="mailto:#rc.bug.getemail()#">#rc.bug.getusername()#</a> 
                
              </td>
            </tr>
            <tr>
              <td>
                <cfswitch expression="#rc.bug.getstatus()#">
                  <cfcase value="open">
                    <i class="icon-exclamation-diamond-frame"></i>  
                  </cfcase>
                  <cfcase value="closed">
                    <i class="icon-tick-circle-frame"></i>  
                  </cfcase>
                  <cfcase value="pending">
                    <i class="icon-clock--exclamation"></i>  
                  </cfcase>
                  <cfcase value="reopened">
                    <i class="icon-arrow-circle-045-left"></i>  
                  </cfcase>
                </cfswitch>
                </td>
              <td>Status</td>
              <td>#rc.bug.getstatus()#</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
  </div>
  <div class="span6">
    <!--- is there a workflow item? --->
    <cfif rc.items.recordCount neq 0>
      <cfif isUserInRole("ebiz")>
        <a class="pull-right" href="/flo/item/detail?id=#rc.items.id#">view workflow item</a>
      </cfif>
      <!--- get the workflow item and list the tasks --->
      <cfset rc.item = rc.floTaskService.getTask(rc.items.id)>
      <cfoutput>#renderView(view="activity/list/embed",module="flo",args={showDates=false})#</cfoutput>
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
  <div class="span6">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" href="##Description">
          <h4>Description</h4>
        </a>
      </div>
      <div id="Description" class="accordion-body collapse in">
        #paragraphFormat2(rc.bug.getdescription())#
      </div>
    </div>
    <div class="accordion-group">
      <div class="accordion-heading"> 
        <a class="accordion-toggle" data-toggle="collapse" href="##attachments">
          <h4>Attachments</h4> 
        </a>
      </div> 
      <div id="attachments" class="accordion-body collapse in">
        <cfif isUserLoggedIn()>
        <div id="aholder" data-bugID="#rc.bug.getticket()#" class="pull-right"><div id="addattachment"></div></div>
        <div id="uploadQueue"></div>
        </cfif>
        <cfif rc.bug.attachments.recordCount neq 0>
          <ul class="thumbnails"> 
            <cfloop query="rc.bug.attachments">
              <li class="span3">
                <div class="thumbnail">
                  <a class="lightbox" href="https://www.buildingvine.com/api/i?fn=#URLEncodedFormat(fileName)#&size=850&crop=true">
                  <cfswitch expression="#ListLast(fileName,'.')#">
                    <cfcase value="jpg,jpeg,png,gif">
                      <img src="https://www.buildingvine.com/api/i?fn=#URLEncodedFormat(fileName)#&size=250&crop=true" />
                    </cfcase> 
                    <!--- jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx --->
                    <cfcase value="pdf,doc,docx,xls,xlsx">
                      <img src="http://automation.ebiz.co.uk/thumb.cfm?fn=#URLEncodedFormat(listLast(fileName,'/'))#" />
                    </cfcase>
                    <cfdefaultcase>
                      <img src="/modules/bv/includes/images/secure/documents/fileExtentions/#UCASE(ListLast(fileName,'.'))#.png" />
                    </cfdefaultcase>
                  </cfswitch>   
                  </a>
                  <h6>#left(listLast(filename,"/"),20)#</h6>
                  <a href="#bl('bugs.download','id=#id#')#" class="btn btn-mini"><i class="icon-disks"></i>download</a>
                </div>
              </li>
            </cfloop>        
          </ul>
        </cfif>
      </div>
    </div>
  </div>
  <div class="span6">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" href="##comments">
          
          <h4>Comments</h4>
        </a>
      </div>
      <div id="comments" class="accordion-body collapse in">
        <ul class="nav nav-tabs" id="CommentTabs">
          <li class="active"><a data-toggle="tab" href="##bugcomments">Bug Comments</a></li>
          <cfif rc.items.recordCount neq 0>
          <li><a data-toggle="tab" href="##workflowcomments">Workflow Comments</a></li>          
          </cfif>
        </ul>
        <div class="tab-content">
          <div class="tab-pane active" id="bugcomments">
            <cfloop query="rc.bug.comments">
              <cfif event.getCurrentModule() neq ""><cfset commentAuthor = getModel("contact").getContactByEmail(email)></cfif>
              <div class="commentBox clearfix">
                <div class="commentTitle clearfix">
                  <div class="commentSubject">#title#</div>
                  <div class="commentAuthorImage">
          
                    <cfoutput><img src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase('#email#')))#?size=45&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" alt=""  /></cfoutput>
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
    
            <form style="margin-top: 40px" action="#bl('bugs.createcomment','bugID=#rc.bug.getid()#')#" class="form form-horizotnal">
              <fieldset>
                <legend>Add comment</legend>
    
              <div class="controls-row">
                <textarea rows="10" class="span12" name="comment" richtext="true" toolbar="Basic"></textarea>
              </div>
              <div class="form-actions">
                <input name="submit" type="submit" class="btn btn-success" value="add comment" />
              </div>
              </fieldset>          
            </form>
            </cfif>
          </div>
          <cfif rc.items.recordCount neq 0>
          <div class="tab-pane" id="workflowcomments">
            <cfset rc.relationshipURL = "/flo/item/detail?id=#rc.item.task.id#">
            <cfset rc.comments = getModel("eunify.CommentService").getComments(rc.items.id,"floItem")>
            <cfoutput>#renderView(view="comment/list",module="eunify")#</cfoutput>
          </div>
          </cfif>
        </div>
      </div>
    </div>
  </div>
</div>
<ul class="nav nav-tabs" id="ErrorDetails">
  <li class="active"><a data-toggle="tab" href="##codecommits">Code Commits</a></li>
  <cfif rc.bug.getrequest() neq "">
  <li><a data-toggle="tab" href="##urlinfo">URL Information</a></li>
  <li><a data-toggle="tab" href="##errordetail">Error Detail</a></li>
  <li><a data-toggle="tab" href="##stacktrace">Stack Trace</a></li>
  <li><a data-toggle="tab" href="##usersettings">User Information</a></li>
  </cfif>

</ul>
<div class="tab-content">
  <div class="tab-pane active" id="codecommits">
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

  <cfif rc.bug.getrequest() neq "">
  <div class="tab-pane " id="urlinfo">
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
</div>

 

</cfoutput>



</div>