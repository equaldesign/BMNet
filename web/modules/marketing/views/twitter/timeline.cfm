<cfoutput>
  <cfloop array="#rc.timeline#" index="tweet">
    <cfset theTweet = {}>
    <div class="stream-item">
      <div class="media tweet">
        <cfif tweet.isRetweet()>
          <cfset theTweet.profileImage = tweet.getRetweetedStatus().getUser().getProfileImageURL().toString()>
          <cfset theTweet.displayName = tweet.getRetweetedStatus().getUser().getName()>
          <cfset theTweet.screenName = tweet.getRetweetedStatus().getUser().getScreenName()>
        <cfelse>
          <cfset theTweet.profileImage = tweet.getUser().getProfileImageURL().toString()>
          <cfset theTweet.displayName = tweet.getUser().getName()>
          <cfset theTweet.screenName = tweet.getUser().getScreenName()>
        </cfif> 
        <a class="pull-left" href="##">
          <img class="media-object img-rounded img-polaroid" src="#theTweet.profileImage#">
        </a>
        <div class="media-body">
          <span class="pull-right">
            #DateFormat(tweet.getCreatedAt(),"DD MMM")#
          </span>
          <h4 class="media-heading"><a href="/marketing/twitter/profile?id=#theTweet.screenName#">#theTweet.displayName# <span class="username js-action-profile-name"><s>@</s><b>#theTweet.screenName#</b></span></a></h4>
          <p>#processText(tweet.getText(),tweet.getUserMentionEntities(),tweet.getURLEntities(),tweet.getHashtagEntities())#</p>   
          <p class="hide tweettext">#tweet.getText()#</p>             
          <div class="tweet-extra">                  
            <cfif isArray(tweet.getMediaEntities()) AND arrayLen(tweet.getMediaEntities()) gt 0>
              <a href="##" class="showImage"><i class="icon-picture"></i>view photo</a> 
              <div class="photo hide">
                <cfloop array="#tweet.getMediaEntities()#" index="media"> 
                  <img class="img-polaroid" src="#media.getMediaURL()#" />
                </cfloop>
              </div>
            </cfif>
            <cfif tweet.isRetweet() AND NOT tweet.isReTweetedByMe()>
              <div class="retweet pull-left">
                <i class="icon-balloon-twitter-retweet"></i>
                Retweeted by <a href="/marketing/twitter/profile?userName=#tweet.getUser().getScreenName()#">#tweet.getUser().getName()#</a>
              </div>
            </cfif> 
            <div class="extra pull-right hide">
              <div class="btn-group">
                <a href="##" class="btn btn-mini show-extra"><i class="icon-arrow-315"></i> Expand</a>
                <a href="##" class="btn btn-mini reply"><i class="icon-balloon-twitter-left"></i>reply</a>
                <cfif NOT tweet.isRetweetedByMe()>
                  <a href="##" class="btn btn-mini retweet"><i class="icon-balloon-twitter-retweet"></i>retweet</a>  
                </cfif>                      
                <a href="##" class="btn btn-mini favourite"><i class="icon-star"></i>favourite</a>
                <a href="##" class="btn btn-mini email"><i class="icon-mail"></i>email</a>
              </div>
            </div>
          </div>
          <div class="tweet-response hide"> 
            <div class="component tweet-box">
              <form class="form form-inline" id="newTweet">
                <div class="controls controls-row">
                  <input type="text" class="span12 tweetinput" placeholder="Compose new Tweet..." />
                  <div class="compose-tweet hidden">
                    <textarea class="span12 tweettextarea" name="tweet" rows="5"></textarea> 
                    <div class="row-fluid tweet-controls">
                      <a href="##" class="btn ttip" title="Add File" id="addFile"><i class="icon-camera"></i></a>
                      <a href="##" class="btn ttip" title="Add Location" id="addLocation"><i class="icon-marker"></i></a>
                      <button class="btn pull-right" id="doTweet">Tweet</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>          
  </cfloop>
</cfoutput>