<cfsetting requesttimeout="180">
<cfset maxLength = dateDiff("m",rc.psa.period_from,rc.psa.period_to)>

<cfscript>
    Title = StructNew();
    Title.font="Century Gothic";
    Title.fontsize="14";
    Title.color="white;";
    Title.bold="true";
    Title.alignment="left";
    Title.textwrap="false";
    Title.fgcolor="white";
    Title.verticalalignment = "vertical_center";
    Title.bottombordercolor="black";

		Header = StructNew();
    Header.font="Century Gothic";
    Header.fontsize="11";
    Header.color="white;";
    Header.bold="true";
    Header.alignment="left";
    Header.textwrap="false";
    Header.fgcolor="light_turquoise";
    Header.bottomborder="thick";
    Header.verticalalignment = "vertical_center";
    Header.bottombordercolor="black";
    Member = StructNew();
    Member.font="Century Gothic";
    Member.fontsize="10";
    Member.color="grey_80_percent;";
    Member.bold="true";
    Member.alignment="left";
    Member.textwrap="false";
    Member.bottomborder = "thin";
    Member.rightborder = "thin";
    Member.bottombordercolor = "grey_50_percent";
    Member.rightbordercolor = "grey_50_percent";
    Member.fgcolor="grey_25_percent";
		YearToDate = StructNew();
    YearToDate.font="Tahoma";
    YearToDate.fontsize="10";
		YearToDate.bold="true";
    YearToDate.color="grey_80_percent;";
    YearToDate.bottomborder = "thin";
    YearToDate.rightborder = "thin";
    YearToDate.bottombordercolor = "grey_50_percent";
    YearToDate.rightbordercolor = "grey_50_percent";
    YearToDate.alignment="right";
    YearToDate.textwrap="false";
    YearToDate.fgcolor="white";
    YearToDate.dataformat = "##,##0.00";
    Standard = StructNew();
    Standard.font="Tahoma";
    Standard.fontsize="10";
    Standard.color="grey_80_percent;";
    Standard.bottomborder = "thin";
    Standard.rightborder = "thin";
    Standard.bottombordercolor = "grey_50_percent";
    Standard.rightbordercolor = "grey_50_percent";
    Standard.alignment="right";
    Standard.textwrap="false";
    Standard.fgcolor="white";
    Standard.dataformat = "##,##0.00";
    SFooter = StructNew();
    SFooter.font="Tahoma";
    SFooter.fontsize="11";
    SFooter.color="white;";
    Footer.bold="true";
    SFooter.alignment="right";
    SFooter.textwrap="false";
    SFooter.bold="true";
    SFooter.topborder="thick";
    SFooter.topbordercolor="black";
    SFooter.dataformat = "##,##0.00";
</cfscript>
<cfloop from="1" to="#ArrayLen(rc.series)#" index="series"><!--- loop through the series --->
	<cfloop from="0" to="#maxLength#" index="y" step="12"><!--- loop through the years --->
    <cfset theYear = DateAdd("m",y,rc.psa.period_from)>
    <cfset theYearFormat = DateFormat(theYear,"YYYY")>
		<cfset theSheet = SpreadSheetNew()>
		<cfset SpreadSheetAddFreezePane(theSheet,2,2)>
    <cfset QueryTitle = "#rc.company.getknown_as()# (#YEAR(rc.psa.period_from)#-#rc.psaID#) #rc.series[series]['type'][2]# (#rc.series[series]['type'][1]#)">
		<cfset QueryLabels = "#getSetting('groupName')# Member, YTD">
		<cfset row =3>
		<cfset Q = 2>
		<cfloop from="0" to="11" index="period"><!--- loop through the months --->
			<cfset periodDate = DateAdd("m",period,theYear)>
			<cfset periodName = DateFormat(periodDate,"MMM YYYY")>
			<cfset QueryLabels = "#QueryLabels#,#periodName#">
			<cfset q = q +1>
		</cfloop>
		<cfset cbaData = rc.series[series]["q"]>
		<cfset label = rc.series[series]["type"]>
    <cfset SpreadSheetAddRow(theSheet,QueryTitle)>
  	<cfset SpreadSheetAddRow(theSheet,QueryLabels)>

 		<cfset SpreadSheetSetRowHeight(theSheet,1,20)>

		<cfoutput query="cbaData" group="memberID">
			<cfset SpreadSheetSetCellValue(theSheet,known_as,row,1)>
		 	<cfset SpreadSheetSetRowHeight(theSheet,row,15)>
			<cfset SpreadSheetFormatCell(theSheet,Member,row,1)>
			<cfset column = 3>
			<cfloop from="0" to="11" index="m"><!--- loop through the months --->


				<cfset dateFrom = DateAdd("m",m,theYear)>
				<cfset dateTo = DateAdd("m",m+1,DateAdd("d",-1,theYear))>
				<cfquery name="YTD" dbtype="query">
					select
						sum(total) as total
					from
						CBAData
					where
						memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">
					and
						period
					BETWEEN
						<cfqueryparam cfsqltype="cf_sql_date" value="#dateFrom#">
						AND
						<cfqueryparam cfsqltype="cf_sql_date" value="#dateTo#">
				</cfquery>
				<Cfset SpreadSheetSetCellValue(theSheet,YTD.total,row,column)>
				<cfset SpreadSheetFormatCell(theSheet,Standard,row,column)>
				<cfset column = column + 1>
			</cfloop>
			<cfset SpreadsheetSetCellFormula(theSheet,"SUM(#convertToColumnRef(row,3)#:#convertToColumnRef(row,14)#)",row,2)>
			<cfset row = row + 1>
		</cfoutput>
  	<cfset SpreadSheetSetRowHeight(theSheet,row,15)>
		<cfset z = 2>
			<cfset SpreadSheetSetCellValue(theSheet,"Total",row,1)>
		<cfloop from="0" to="12" index="p">
			<cfset SpreadsheetSetCellFormula(theSheet,"SUM(#convertToColumnRef(3,z)#:#convertToColumnRef(row-1,z)#)",row,z)>
			<cfset z = z + 1>
		</cfloop>
		<cfset SpreadSheetFormatColumn(theSheet,YearToDate,2)>
    <cfset SpreadSheetFormatRow(theSheet,Title,1)>
		<cfset SpreadSheetFormatRow(theSheet,SFooter,row)>
    <cfset SpreadSheetFormatRow(theSheet,Header,2)>
		<cfset z = 3>
		<cfloop from="0" to="11" index="p">
			<cfset SpreadSheetSetColumnWidth(theSheet,1,45)>
			<cfset SpreadSheetSetColumnWidth(theSheet,2,20)>
			<cfset SpreadSheetSetColumnWidth(theSheet,z,17)>
			<cfset z = z + 1>
		</cfloop>
		<cfif series eq 1 AND y eq 0>
			<cfspreadsheet action="write" overwrite="true" filename="/tmp/#rc.fileName#" name="theSheet" sheetname="#theYearFormat# #friendlyUrl(label[2])# (#label[1]#)" />
		<cfelse>
        <cftry>
				<cfspreadsheet action="update" filename="/tmp/#rc.fileName#" name="theSheet" sheetname="#theYearFormat#  #friendlyUrl(label[2])# (#label[1]#) " />
        <cfcatch type="any">
          <cftry>
            <cfspreadsheet action="update" filename="/tmp/#rc.fileName#" name="theSheet" sheetname="#theYearFormat#  #friendlyUrl(label[2])# (#label[1]#) #y# #series# " />
            <cfcatch type="any">
              <cflog application="true" text="#cfcatch.message#">
            </cfcatch>
          </cftry>
        </cfcatch>
        </cftry>
		</cfif>
	</cfloop>
</cfloop>
	<cfheader name="Content-Disposition" value="attachment;filename=#rc.company.getknown_as()# (#YEAR(rc.psa.period_from)#-#rc.psaID#).xls">
<cfcontent deletefile="true" reset="true" file="/tmp/#rc.fileName#" type="#getPageContext().getServletContext().getMimeType('/tmp/#rc.fileName#')#">