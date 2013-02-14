<cfset tags = getModel("eunify.TagService").getTags(relationShip=args.relationship,id=args.id)>
  <cfoutput query="tags">
  <span>
    <a title="Find more #args.relationship#s tagged with #tag#"  href="#bl('tag.filter','relationship=#args.relationship#&tag=#tag#')#" class="btn btn-mini btn-success"><i class="icon-tag"></i>#tag#</a>
		<cfif isDefined("args.delete") AND args.delete>
    <a class="noAjax deleteTag" href="#bl('tag.delete','id=#id#')#"><i title="remove this tag" class="tooltip icon icon-bin"></i></a>
    </cfif>
  </span>
  </cfoutput>