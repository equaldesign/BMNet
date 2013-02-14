<h3>Recent viewed Agreements</h3>
<cfoutput query="rc.recentlyViewed">
  <div class="currentUser">
    <img width="25" class="gravatar" src="#paramImage('company/#id#_square.jpg','website/unknown.jpg')#" alt="#companyName#" />
    <a href="#bl('psa.index','psaid=#psaID#')#" class="ajax tooltip" title="#name#">#companyName#</a>
    <p>#name#</p>
  </div>
  </cfoutput>