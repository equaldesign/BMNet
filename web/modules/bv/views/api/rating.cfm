<cfif rc.error>
  <cfdump var="#rc#">
<cfelse>
<cfcontent type="application/javascript">


<cfsavecontent variable="test">
<div id="disqus_thread"></div>
<script type="text/javascript">

    var disqus_shortname = 'buildingvine';
    <cfoutput>
    var disqus_identifier = "#ListLast(rc.productID,"/")#";
    var disqus_url = "http://www.buildingvine.com/products/productDetail?nodeRef=#ListLast(rc.productID,"/")#"
    </cfoutput>
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<!---
  <div id="fb-root"><iframe src="http://www.facebook.com/widgets/like.php?href=http://www.buildingvine.com/products/productDetail?nodeRef=#ListLast(rc.productID,"/")#" scrolling="no" frameborder="0" style="border:none; width:300px; height:50px"></iframe></div>
  <h2 class="rating">Ratings &amp; Reviews</h2>
  <div id="rating">
    <cfoutput>
    <input type="hidden" id="productID" value="#rc.productID#">
    <input #IIf(rc.ratings.data.nodeStatistics.fiveStarRatingScheme.averageRating eq 1,"'checked'","''")# class="star" type="radio" name="test-1-rating-2" value="1"/>
    <input #IIf(rc.ratings.data.nodeStatistics.fiveStarRatingScheme.averageRating eq 2,"'checked'","''")# class="star" type="radio" name="test-1-rating-2" value="2"/>
    <input #IIf(rc.ratings.data.nodeStatistics.fiveStarRatingScheme.averageRating eq 3,"'checked'","''")# class="star" type="radio" name="test-1-rating-2" value="3"/>
    <input #IIf(rc.ratings.data.nodeStatistics.fiveStarRatingScheme.averageRating eq 4,"'checked'","''")# class="star" type="radio" name="test-1-rating-2" value="4"/>
    <input #IIf(rc.ratings.data.nodeStatistics.fiveStarRatingScheme.averageRating eq 5,"'checked'","''")# class="star" type="radio" name="test-1-rating-2" value="5"/>
    </cfoutput>
  </div>
  <div id="bvreviews">
  <cfoutput>
  <cfloop array="#rc.comments.items#" index="comment">
  <div class="bvreview">
    <div class="reviewHeader">
      <cfif isDefined('rc.buildingVine.username') AND rc.buildingVine.username eq comment.author.username>
      <a href="##" class="deleteComment" rel="#Replace(comment.nodeRef,':/','','ALL')#"></a>
      </cfif>
      <div class="reviewImage">
        <a class="friendLink" href="https://www.buildingvine.com/profile?id=#urlEncrypt(comment.author.username)#"><img border="0" class="tooltip" title="#comment.author.firstName# #comment.author.lastName#" alt="#comment.author.firstName# #comment.author.lastName#" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(comment.author.username)))#?s=35&d=identicon" class="profileImageSmall"></a>
      </div>
      <div class="reviewAuthor">
        <h3>By #comment.author.firstName# #comment.author.lastName#</h3>
        <h4>On #dateFormatOrdinal(cdt2(comment.createdOn),"DDDD DD MMMM YYYY")#</h4>
      </div>
    </div>
    <br class="clear" />
    <div class="reviewBody">
      <h5>#comment.title#</h5>
      <p>#comment.content#</p>
    </div>
  </div>
  </cfloop>
  </cfoutput>
  </div>
  <cfif arrayLen(rc.comments.items) eq 0>
  <p>
    No reviews of this product. Why not be the first and <a href="##" class="submitReview">submit a review</a>?
  </p>
  <cfelse>
  <p>
    Add <a href="#" class="submitReview">your review</a> of this product
  </p>
  </cfif>
--->
</cfsavecontent>
<cfset rc.json  = serializeJSON(rc.nodeID)>
<cfoutput>#rc.jsoncallback#(#rc.json#)</cfoutput>
</cfif>