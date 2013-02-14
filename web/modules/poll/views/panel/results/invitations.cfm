
<cfif rc.invitees.recordCount gte 1>
    <table cellpadding=="5" style="width: 100%;">
    <cfoutput query="rc.invitees">
        <tr>
          <td width="20"><img width="20" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=20&d=http://#cgi.HTTP_HOST#/#paramImage('company/#company_id#_square.jpg','website/unknown.jpg')#" /></td>
          <td><a href="/contact/index/id/#contactID#">#first_name# #surname#</a></td>
          <td><a href="#bl('company.index','id=#company_id#')#">#known_as#</a></td>
          <td width="16"><span class="poll_icon_#completed#"></span></td>
          <td width="16"><a href="/poll/regsitrant/registrantID/#contactID#/pollID/#rc.id#" rev="further_#contactID#" class="noAjax dialog"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/information.png"  /></a></td>
        </tr>
    </cfoutput>
    </table>
</cfif>
