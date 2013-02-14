<cfoutput>
 <a class="resultEntry">
  <img width="20" class="gravatar" src="#paramImage('company/#rc.branches["company_id"][rc.c]#_square.jpg','website/unknown.jpg')#" alt="#rc.branches["name"][rc.c]#" />
  <b>#rc.branches["companyName"][rc.c]#</b> (#trim(numberformat(rc.branches["distance"][rc.c],"999.9"))# miles)
  <br class="clear" />
 </a>
</cfoutput>