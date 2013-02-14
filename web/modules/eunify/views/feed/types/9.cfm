<cfoutput>
  <a href="#bl('contact.index','id=[source.id]')#">[source.first_name] [source.surname]</a>
  edited company
  <a href="#bl('company.index','id=[target.id]')#">[target.known_as]</a>
</cfoutput>