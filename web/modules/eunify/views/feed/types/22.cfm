<cfoutput><cfset c = getModel("eunify.CompanyService").getCompany([source.company_id])>
<a href="#bl('contact.index','id=[source.id]')#">[source.first_name] [source.surname]</a> from
(<a href="#bl('company.index','id=#c.getid()#')#">#c.getknown_as()#</a>) edited the meeting
<a href="/calendar/detail/id/[target.id]">[target.name]</a></cfoutput>