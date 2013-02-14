<cfoutput>
<div class="clearfix" style="margin-bottom: 4px;">
  <img width="50" class="thumbnail gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(args.email)))#?size=50&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" />
  <p><a href="/eunify/company/detail/id/#args.company_id#">#args.name#</a><br />
  <a class="clearfix" href="/eunify/contact/index/id/#args.id#">#args.first_name# #args.surname#</a></p>
</div>

</cfoutput>
