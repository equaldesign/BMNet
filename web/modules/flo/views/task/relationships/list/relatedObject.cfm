<cfoutput>
<cfswitch expression="#args.type#">
  <cfcase value="contact">
    <cfswitch expression="#args.system#">
      <cfcase value="eGroup_cemco,eGroup_cbagroup,eGroup_handbgroup,eGroup_nbg">
        <tr>
          <td><img width="20" class="thumbnail gravatar pull-left" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(args.object.email)))#?size=20&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" /></td>
          <td>
            <a class="clearfix" href="/eunify/contact/index/id/#args.object.id#">#args.object.first_name# #args.object.surname#</a>
          </td>
          <td><a href="/flo/item/detail/id/#rc.id#?key=#UrlEncrypt(args.object.email)#"><i class="icon-globe-share"></i></a></td>
        </tr> 
      </cfcase>
      <cfcase value="BMNet">
        <tr>
          <td><img width="20" class="thumbnail gravatar pull-left" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(args.object.email)))#?size=50&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" /></td>
          <td>
            <a class="clearfix" href="/eunify/contact/index/id/#args.object.id#">#args.object.first_name# #args.object.surname#</a>
            <br /><small><a href="/eunify/company/detail/id/#args.object.company_id#">#args.object.name#</a></small>
          </td>
          <td><a href="/flo/item/detail/id/#rc.id#?key=#UrlEncrypt(args.object.email)#"><i class="icon-globe-share"></i></a></td>
        </tr>
      </cfcase>
    </cfswitch>
  </cfcase>
  <cfcase value="bug">
    <cfset bug = getModel("bugs.BugService").getBug(args.object.id)>
    <tr>
      <td><i class="icon-bug"></i></td>
      <td><a class="clearfix" href="/bugs/bugs/detail?id=#args.object.id#">#bug.gettitle()#</a></p></td>
      <td></td>
    </tr>
  </cfcase>
</cfswitch>
</cfoutput>