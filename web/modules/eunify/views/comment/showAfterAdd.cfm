<cfoutput>
  <div class="commentBox clearfix">
    <div class="commentTitle clearfix">
      <div class="commentSubject">#rc.title#</div>
      <div class="commentAuthorImage">
        <img width="30" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(getAuthUser())))#?size=75&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
        </div>
      <div class="commentMeta">
        <span class="commentDate">#DateFormatOrdinal(now(),"DDDD DD MMMM YYYY")# at #TimeFormat(now(),"HH:MM")#</span>
        <span class="commentAuthor"></span>
      </div>      
    </div>
    <div class="commentContent">#ParagraphFormat2(rc.comment)#</div>
  </div>
</cfoutput> 