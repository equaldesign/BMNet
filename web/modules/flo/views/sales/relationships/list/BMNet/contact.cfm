<cfoutput>
<div class="span3">
  <a href="/eunify/company/detail/id/#args.company_id#" class="thumbnail ttip" title="#args.first_name# #args.surname# (#args.name#)">
    <img width="64" class="" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(args.email)))#?size=64&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" />
  </a>
</div>

</cfoutput>
