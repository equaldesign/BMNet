<cfoutput>
<div class="branchDetail">
  <img class="companyDetailImage" src="#paramImage('company/#rc.branches["company_id"][rc.c]#_small.jpg','company/default_small.jpg')#" alt="#rc.branches["name"][rc.c]#" />
  <h2>#rc.branches["companyName"][rc.c]#</h2>
  <h3>#rc.branches["name"][rc.c]#</h3>
  <a class="otherBranches" href="##" onclick="showOtherBranches(this)" rel="#rc.branches['company_id'][rc.c]#">Show other branches &raquo;</a>
  <p>
    <b>Address:</b><br />
    <cfif rc.branches["address1"][rc.c] neq "">#rc.branches["address1"][rc.c]#<br /></cfif>
    <cfif rc.branches["address2"][rc.c] neq "">#rc.branches["address2"][rc.c]#<br /></cfif>
    <cfif rc.branches["address3"][rc.c] neq "">#rc.branches["address3"][rc.c]#<br /></cfif>
    <cfif rc.branches["town"][rc.c] neq "">#rc.branches["town"][rc.c]#<br /></cfif>
    <cfif rc.branches["county"][rc.c] neq "">#rc.branches["county"][rc.c]#<br /></cfif>
    <cfif rc.branches["postcode"][rc.c] neq "">#rc.branches["postcode"][rc.c]#<br /></cfif>
  </p>
  <cfif rc.branches["tel"][rc.c] neq ""><p class="tel">#rc.branches["tel"][rc.c]#</p></cfif>
  <cfif rc.branches["email"][rc.c] neq ""><p class="email"><a href="mailto:#rc.branches["email"][rc.c]#">#rc.branches["email"][rc.c]#</a></p></cfif>
  <cfif rc.branches["web"][rc.c] neq ""><p class="web">#checkForURL(rc.branches["web"][rc.c])#</p></cfif>
</div>
<br clear="all" />
</cfoutput>