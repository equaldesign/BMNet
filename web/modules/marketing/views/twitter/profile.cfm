<cfoutput>
<div class="row-fluid">
  <div class="span4">
    <div class="module profile-nav">
      <ul class="nav nav-list">
        <li class="active">
          <a class="list-link js-nav" href="/hootsuite" data-nav="profile">Tweets<i class="chev-right"></i></a>
        </li>
        <li class="">
          <a class="list-link js-nav" href="/hootsuite/following" data-nav="following">Following<i class="chev-right"></i></a>
        </li>
        <li class="">
          <a class="list-link js-nav" href="/hootsuite/followers" data-nav="followers">Followers<i class="chev-right"></i></a>
        </li>
        <li class="">
          <a class="list-link js-nav" href="/hootsuite/favorites" data-nav="favorites"> 
            Favorites<i class="chev-right"></i>
          </a>
        </li>
        <li class="">
          <a class="list-link js-nav" href="/hootsuite/lists" data-nav="all_lists">Lists<i class="chev-right"></i></a>
        </li>
      </ul>
    </div>
  </div>
  <div class="span8">
    <div class="profile-card module profile-header">
      <div class="profile-header-inner flex-module clearfix" style="background-image: url(#rc.user.getProfileBannerRetinaURL()#)">
        <!--- profile picture --->        
        <cfset profileImage = rc.user.getBiggerProfileImageURL()>
        <br />
        <img class="img-rounded img-polaroid" src="#profileImage.toString()#">
          <h3>#rc.user.getName()#</h3>
          <h4>#rc.user.getScreenName()#</h4>
          <p>#rc.user.getDescription()#</p>
          <p>#rc.user.getLocation()# - #rc.user.getURL()#</p>
      </div>
      <div class="flex-module profile-banner-footer clearfix">
        <ul class="stats js-mini-profile-stats" data-user-id="326169019">
          <li>
            <a class="js-nav" href="/BuildingVine" data-element-term="tweet_stats" data-nav="profile">  
              <strong>#rc.user.getStatusesCount()#</strong> Tweets
            </a>
          </li>
          <li>
            <a class="js-nav" href="/BuildingVine/following" data-element-term="following_stats" data-nav="following">
              <strong>#rc.user.getFriendsCount()#</strong> Following
            </a>
          </li>
          <li>
            <a class="js-nav" href="/BuildingVine/followers" data-element-term="follower_stats" data-nav="followers">
              <strong>#rc.user.getFollowersCount()#</strong> Followers
            </a>
          </li>
        </ul>
        <div class="user-actions btn-group not-following " data-user-id="326169019" data-screen-name="BuildingVine" data-name="Building Vine" data-protected="false">
          <cfset isFollowing = rc.twitterService.getTwitter().showFriendship(rc.twitterService.getTwitter().verifyCredentials().getScreenName(),rc.user.getScreenName()).isSourceFollowingTarget()> 
          <a href="##" class="following following-#isFollowing# btn #IIf(isFollowing,"'btn-info'","''")#"> 
            <cfif isFollowing>              
              Following              
            <cfelse>
              <span class="button-text follow-text"><i class="icon-twitter-follow"></i> Follow</span>               
            </cfif>
          </a>
        </div>
      </div>            
    </div>

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
<cfdump var="#rc.user#">