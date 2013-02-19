<cfoutput>
  <tr>
    <td><img width="20" class="thumbnail gravatar pull-left" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(args.email)))#?size=50&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" /></td>
    <td>
      <a class="clearfix" href="/eunify/contact/index/id/#args.id#">#args.first_name# #args.surname#</a>
    </td>
    <td><a href="/flo/item/detail/id/#rc.id#?key=#UrlEncrypt(args.email)#"></td>
  </tr>
</cfoutput>
