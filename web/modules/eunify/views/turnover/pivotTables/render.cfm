<cfsavecontent variable="pData">
<cfoutput>
<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>

<Workbook
xmlns="urn:schemas-microsoft-com:office:spreadsheet"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
xmlns:html="http://www.w3.org/TR/REC-html40">

<DocumentProperties
xmlns="urn:schemas-microsoft-com:office:office">
<Author>Ben Nadel</Author>
<Company>Kinky Solutions</Company>
</DocumentProperties>



<Worksheet ss:Name="Pivot Data">

<Table
ss:ExpandedColumnCount="#ListLen(rc.query.ColumnList)#"

<!---
We need a row for every query record
plus one for the header row. Again, if
this value does not match what is in the
document, the excel file will not
render properly.
--->
ss:ExpandedRowCount="#(rc.query.RecordCount + 1)#"

x:FullColumns="1"
x:FullRows="1">

<Row>
  <Cell>
    <Data ss:Type="String">Arrangement Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Team</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Category</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Input Stream</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Member Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Period</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Supplier Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Input Type</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Value</Data>
  </Cell>
</Row>

<cfloop query="rc.query">
<Row>
  <Cell>
    <Data ss:Type="String">#xmlFormat(arrangementName)#</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">#xmlFormat(parentCategory)#</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">#xmlFormat(category)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(INPUTNAME)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(MEMBER)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#DateFormat(PERIOD,"YYYY-MM-DD")#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(SUPPLIERNAME)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(TYPE)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="Number">#xmlFormat(VALUE)#</Data>
  </Cell>
</Row>

</cfloop>

</Table>

</Worksheet>

</Workbook>

</cfoutput>
</cfsavecontent>
<cffile action="write" file="#rc.app.appRoot#/dms/pivot_#rc.type#_#rc.sourceID#.xml" output="#pData#">
<cfcontent file="#rc.app.appRoot#/dms/pivot_#rc.type#_#rc.sourceID#.xml">