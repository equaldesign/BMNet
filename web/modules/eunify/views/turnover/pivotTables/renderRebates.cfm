<cfsetting requesttimeout="900">
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
   <Data ss:Type="String">Rebate Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Member Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Rebate Period From</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Rebate Period To</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Arrangement Period From</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Arrangement Period To</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Supplier Name</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Turnover</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Rebate Value</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Rebate Amount</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Rebate Payable</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Payable To</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">Paid</Data>
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
   <Data ss:Type="String">#xmlFormat(rebateName)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(MEMBER)#</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">#DateFormat(PERIODFrom,"YYYY-MM-DD")#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#DateFormat(PERIODTo,"YYYY-MM-DD")#</Data>
  </Cell>
  <Cell>
   <Data ss:Type="String">#DateFormat(PERIOD_From,"YYYY-MM-DD")#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#DateFormat(PERIOD_To,"YYYY-MM-DD")#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(SUPPLIERNAME)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="Number">#xmlFormat(throughPut)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="Number">#xmlFormat(rebateValue)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="Number">#xmlFormat(rebateAmount)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="Number">#xmlFormat(rebatePayable)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(payableTo)#</Data>
  </Cell>
   <Cell>
   <Data ss:Type="String">#xmlFormat(paid)#</Data>
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