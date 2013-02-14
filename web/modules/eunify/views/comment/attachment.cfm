<cfif fileExists("/fs/sites/ebiz/egroupautomation.ebiz.co.uk/attach/#rc.file#")>
  <cfheader name="Content-Disposition" value="attachment;filename=#rc.file#">
  <cfcontent file="/fs/sites/ebiz/egroupautomation.ebiz.co.uk/attach/#rc.file#" type="#getPageContext().getServletContext().getMimeType('/fs/sites/ebiz/egroupautomation.ebiz.co.uk/attach/#rc.file#')#">
</cfif>