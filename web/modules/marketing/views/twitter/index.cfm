<cfset includeUDF('modules/marketing/views/twitter/twitterHelper.cfm')>
<cfset getMyPlugin(plugin="jQuery").getDepends("","social/twitter/tweet","social/twitter")>
<cfoutput>
<div id="twitter" class="ajaxWindow">
<div class="row-fluid">
  <div class="span4">
    <div class="module mini-profile">    
      <div class="media flex-module profile-summary js-profile-summary">
        <a href="/marketing/twitter/profile?id=#rc.user.getScreenName()#" class="pull-left">
          <img class="media-object img-polaroid img-rounded" src="#rc.user.getProfileImageURL().toString()#">
        </a>
        <div class="media-body">
          <h4 class="media-heading"><a href="/marketing/twitter/profile?id=#rc.user.getScreenName()#">#rc.user.getName()#</a></h4>
          <p>View my profile page</p>
        </div>  
      </div>    
      <div class="js-mini-profile-stats-container">
        <ul class="stats js-mini-profile-stats" data-user-id="326169019">
          <li>
            <a class="js-nav" href="/BuildingVine" data-element-term="tweet_stats" data-nav="profile">  
              <strong>#rc.user.getStatusesCount()#</strong> Tweets
            </a>
          </li>
          <li>
            <a class="js-nav" href="/following" data-element-term="following_stats" data-nav="following">  
              <strong>#rc.user.getFriendsCount()#</strong> Following
            </a>
          </li>
          <li>
            <a class="js-nav" href="/followers" data-element-term="follower_stats" data-nav="followers">  
              <strong>#rc.user.getFollowersCount()#</strong> Followers
            </a>
          </li>
        </ul>
      </div>    
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
  <div class="span8">    
    <div class="content-main timeline">
      <div class="content-header">
        <div class="header-inner">
          <h2 class="js-timeline-title">Tweets</h2>
        </div>
      </div>
      <div class="stream-container">         
        #renderView("twitter/timeline")#        
      </div>
    </div>          
  </div>
</div>
</cfoutput>
</div>

<div class="modal hide fade" id="retweetDialog">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3 id="myModalLabel">Retweet to your followers?</h3>
  </div>
  <div class="modal-body">
    <p></p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
    <button class="btn btn-info">Retweet</button>
  </div>
</div>