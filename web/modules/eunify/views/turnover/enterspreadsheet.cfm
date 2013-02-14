<cfheader name="Content-Disposition" value="attachment;filename=spreadsheet.xls">
<cfcontent file="#rc.fileName#" type="#getPageContext().getServletContext().getMimeType('#rc.fileName#')#">