<div id="content">
  <div class="wht">
    <div name="content" contenteditable="false" style="position: relative;">
      <a class="pull-left" href="#" style="display: inline !important;"><img class="media-object" src="http://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-64/Smiley_Sad.png" style="width: 64px; height: 64px; margin-right: 15px;"></a>
      <div class="media">
        <div class="media-body">
          <h2 class="media-heading">We're Sorry!</h2>
          <br />
          <p>We hope your weren't offended by our latest email. We're just trying to make a living!</p>
          <p>We'd really like to know why you want to be removed from our list, but you don't have to tell us if you're really busy - we get it.</p>        
          <form method="post" action="/marketing/email/recipient/doUnsubscribe" class="form form-horizontal">
            <fieldset>
              <legend>Tell us why!</legend>
              <div class="control-group">
                <label class="control-label">I want to be removed because...</label>
                <div class="controls">
                  <label class="radio">
                    <input type="radio" name="reason" value="nopermission"> 
                    You didn't have permission to email me
                  </label>
                  <label class="radio">
                    <input type="radio" name="reason" value="notinterested"> 
                    I'm not interested in the contents of the email
                  </label>
                  <label class="radio">
                    <input type="radio" name="reason" value="offensive"> 
                    The email offended me
                  </label>
                  <label class="radio">
                    <input type="radio" name="reason" checked="checked" value="toobusy"> 
                    I'm just too busy for this!
                  </label>
                  <label class="radio">
                    <input type="radio" name="reason" value="badenglish"> 
                    You're grammer, is, awfull.
                  </label>
                </div> 
              </div>
              <div class="control-group">
                <label class="control-label">Remove me from</label>
                <div class="controls">www
                  <label class="radio">
                    <input checked="checked" type="radio" name="removefrom" value="justthis"> 
                    Just emails like this
                  </label>
                  <label class="radio">
                    <input type="radio" name="removefrom" value="all"> 
                    All emails - I never want to hear from you again!
                  </label>                
                </div> 
              </div>
            </fieldset>
            <div class="form-actions">
              <button class="btn btn-danger" type="submit"><img src="http://d25ke41d0c64z1.cloudfront.net/images/icons/smiley-mad.png" style="width: 16px; height: 16px; margin-right: 5px;"> Remove me already!</button>
              <a class="btn btn-success" href="/marketing/email/recipient/changed"><img src="http://d25ke41d0c64z1.cloudfront.net/images/icons/smiley-lol.png" style="width: 16px; height: 16px; margin-right: 5px;">You guys aren't so bad, I've changed my mind!</a>
            </div>
            <cfoutput>
              <input type="hidden" name="userID" value="#urlencrypt(rc.id)#" />
              <input type="hidden" name="cID" value="#urlencrypt(rc.cID)#" />
            </cfoutput>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>