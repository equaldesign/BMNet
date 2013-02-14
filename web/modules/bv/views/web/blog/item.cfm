<cfset getMyPlugin(plugin="jQuery").getDepends("sharrre","secure/blog/item,secure/sharrre","")>
<cfsavecontent variable="g">
<cfoutput>
<meta name="twitter:card" content="summary">
<meta name="twitter:site" content="@buildingvine">
<meta name="twitter:creator" content="@buildingvine">
<meta name="twitter:url" content="http://www.buildingvine.com/blog/item?nodeRef=#rc.blog.url#&siteID=#request.bvsiteID#">
<meta name="twitter:title" content="#rc.blog.title#">
<meta name="twitter:description" content="#trim(Left(stripHTML(rc.blog.content),200))#">
<meta property="og:title" content="#rc.blog.title#"/>
<meta name="og:url" content="http://www.buildingvine.com/blog/item?nodeRef=#rc.blog.url#&siteID=#request.bvsiteID#">
<!---<meta property="og:site_name" content="#request.buildingVine.site.shortName#"/>--->
<meta property="og:description" content="#trim(Left(stripHTML(rc.blog.content),200))#"/>
<title>#rc.blog.title#</title>
</cfoutput>
</cfsavecontent>
<cfset showThumbnail = true>
<cfhtmlhead text="#g#">
<cfoutput>
  <cfif rc.blog.blogImage eq "">
    <cfset rc.blog.blogImage = "/includes/images/sites/14/homebg.jpg">
    <cfset showThumbnail = false>
  </cfif>
<div style="background: url('#rc.blog.blogImage#'); background-size:100%; margin-top:-20px">
  <div style="background: url('/includes/images/sites/14/pattern.png')">
    <div class="container blogItem">
      <div class="row-fluid">
        <div class="blogHeader span4">
          <div class="page-header">
            <h1>#rc.blog.title#</h1>
    		  </div>
          <cfif showThumbnail>
          <div class="img">
            <img src="#rc.blog.blogImage#" class="img-polaroid" /> 
          </div>
          </cfif>
          <div class="meta">
            <span class="pull-left authorImage">
        		  <img width="45" height="45" class="img-polaroid" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(rc.blog.author.username)))#?size=45&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
            </span>
            <span class="pull-left author">Created by <a href="#bl("contact.index","id=#urlencrypt(rc.blog.author.username)#")#">#rc.blog.author.firstName# #rc.blog.author.lastName#</a></span><span class="commentCount"><a class="scroll" href="##comments">#rc.blog.commentCount# comment<cfif rc.blog.commentCount neq 1>s</cfif></a></span>            
      	    <span class="datestamp">#rc.blog.releasedOn#</span>
            <div class="blogControls">
              <cfif isUserLoggedIn()>
                <cfif rc.blog.permissions.edit>
                  <a class="editBlog ajax" href="#bl("blog.edit","nodeRef=#rc.blog.url#")#">
                    <i class="icon-blog--pencil"></i>
                    edit post
                  </a>
                </cfif>
                <cfif rc.blog.permissions.delete>
              <!---
                <cfif NOT getModel("TwitterService").findTweet("blog/item?nodeRef=#rc.blog.url#")>
                  <a class="tweetThis ajax" href="#bl("marketing.twitter.tweet","shortName=#request.bvsiteID#&message=#rc.blog.title#&blogurl=blog/item?nodeRef=#rc.blog.url#")#">
                    <i class="icon-balloon-twitter-left"></i>
                    Tweet This!
                  </a>
                </cfif>
              --->
                <a class="deleteBlog" href="/alfresco/service/api/#rc.blog.url#?alf_ticket=#request.user_ticket#">
                  <i class="icon-blog--minus"></i>
                  delete post
                </a>
                <div class="reach">
                  <i class="icon-megaphone"></i>
                  Reach: #rc.reach# people
                </div>
                </cfif>

              </cfif>
              <div id="shareme" data-url="http://www.buildingvine.com/blog/item?nodeRef=#rc.blog.url#&siteID=#request.bvsiteID#" data-text="#rc.blog.title#" data-title="share"></div>
            </div>
      		</div>
        </div>        
        <div class="content span8">
          #rc.blog.content#
        </div>        
        
      </div>
    </div>
  </div>
</div>    
</cfoutput>
  <br /><br /><br />
  <cfset getMyPlugin(plugin="jQuery").getDepends("","secure/sharrre,secure/blog/item","secure/blog/item,jQuery/sharrre")>
  <cfoutput>
	<a name="comments"></a>
  <!---#renderView("web/comments/list")#--->
</cfoutput>
</div>
