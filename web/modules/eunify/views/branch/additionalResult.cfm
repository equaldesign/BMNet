<cfoutput>
 <a class="resultEntry">
  <img width="50" class="gravatar" src="#paramImage('company/#rc.branches["company_id"][rc.c]#_square.jpg','website/unknown.jpg')#" alt="#rc.branches["name"][rc.c]#" />
  <b>#rc.branches["name"][rc.c]#</b><br />
  <cfif rc.branches["address1"][rc.c] neq "">#rc.branches["address1"][rc.c]#<br /></cfif>
  <cfif rc.branches["town"][rc.c] neq "">#rc.branches["town"][rc.c]#</cfif>
  <br class="clear" />
 </a>
</cfoutput>