<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
 <cfproperty name="firstName" default=" " required="true">
 <cfproperty name="lastName" default=" " required="true">
 <cfproperty name="middleName" default=" " required="true">
 <cfproperty name="contactEmail" default=" " required="true">
 <cfproperty name="salutation" default=" " required="true">
 <cfproperty name="jobtitle" default=" " required="true">
 <cfproperty name="contactPhone" default=" " required="true">
 <cfproperty name="contactPhoneAlternate" default=" " required="true">
 <cfproperty name="contactMobile" default=" " required="true">
 <cfproperty name="contactFax" default=" " required="true">
 <cfproperty name="contactAddress1" default=" " required="true">
 <cfproperty name="contactAddress2" default=" " required="true">
 <cfproperty name="contactAddress3" default=" " required="true">
 <cfproperty name="contactTown" default=" " required="true">
 <cfproperty name="contactCounty" default=" " required="true">
 <cfproperty name="contactPostCode" default=" " required="true">
 <cfproperty name="contactCountry" default=" " required="true">
 <cfproperty name="contactAssistant" default=" " required="true">
 <cfproperty name="contactAssistantPhone" default=" " required="true">
 <cfproperty name="contactAssistantEmail" default=" " required="true">
 <cfproperty name="contactDOB" default=" " required="true">
  <cfproperty name="siteID" default=" " required="true">

  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="bvAddress" inject="coldbox:setting:bvAddress">

  <!--- methods --->


  <cffunction name="save" returntype="boolean" output="false">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfif this.getnodeRef() eq "">
      <cfset method="post">
    <cfelse>
      <cfset method="put">
    </cfif>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/company?alf_ticket=#ticket#" method="#method#" result="co">
      <cfhttpparam type="formfield" name="siteID" value="#this.getsiteID()#">
      <cfhttpparam type="formfield" name="nodeRef" value="#this.getnodeRef()#">
      <cfhttpparam type="formfield" name="bvCo_companyID" value="#this.getcompanyID()#">
      <cfhttpparam type="formfield" name="bvCo_name" value="#this.getname()#">
      <cfhttpparam type="formfield" name="bvCo_description" value="#this.getdescription()#">
      <cfhttpparam type="formfield" name="bvCo_industry" value="#this.getindustry()#">
      <cfhttpparam type="formfield" name="bvCo_annualRevenue" value="#this.getannualRevenue()#">
      <cfhttpparam type="formfield" name="bvCo_fax" value="#this.getfax()#">
      <cfhttpparam type="formfield" name="bvCo_phone" value="#this.getphone()#">
      <cfhttpparam type="formfield" name="bvCo_phoneAlternate" value="#this.getphoneAlternate()#">
      <cfhttpparam type="formfield" name="bvCo_billingName" value="#this.getbillingName()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress1" value="#this.getbillingAddress1()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress2" value="#this.getbillingAddress2()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress3" value="#this.getbillingAddress3()#">
      <cfhttpparam type="formfield" name="bvCo_billingTown" value="#this.getbillingTown()#">
      <cfhttpparam type="formfield" name="bvCo_billingCounty" value="#this.getbillingCounty()#">
      <cfhttpparam type="formfield" name="bvCo_billingPostCode" value="#this.getbillingPostCode()#">
      <cfhttpparam type="formfield" name="bvCo_billingCountry" value="#this.getbillingCountry()#">
      <cfhttpparam type="formfield" name="bvCo_website" value="#this.getwebsite()#">
      <cfhttpparam type="formfield" name="bvCo_companyEmail" value="#this.getcompanyEmail()#">
      <cfhttpparam type="formfield" name="bvCo_employees" value="#this.getemployees()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryName" value="#this.getdeliveryName()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress1" value="#this.getdeliveryAddress1()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress2" value="#this.getdeliveryAddress2()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress3" value="#this.getdeliveryAddress3()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressTown" value="#this.getdeliveryAddressTown()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressCounty" value="#this.getdeliveryAddressCounty()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressPostCode" value="#this.getdeliveryAddressPostCode()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressCountry" value="#this.getdeliveryAddressCountry()#">

    </cfhttp>
    <cfreturn true>
  </cffunction>

    <cffunction name="getContact" returntype="struct" output="false">
    <cfargument name="nodeRef" required="true" type="string">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp port="8080" result="contacts" url="http://46.51.188.170/alfresco/service/bv/contact?nodeRef=#nodeRef#&alf_ticket=#ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(contacts.fileContent)>
  </cffunction>

  <cffunction name="getCompanyContacts" returntype="struct" output="false">
    <cfargument name="nodeRef" required="true" type="string">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp result="contacts" url="http://46.51.188.170/alfresco/service/bv/company/contacts?nodeRef=#nodeRef#&alf_ticket=#ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(contacts.fileContent)>
  </cffunction>

  <cffunction name="doImport" returntype="any">
    <cfargument name="fileName">
    <cfargument name="siteID">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfset var x = 1>
    <cfquery name="fieldMappings" datasource="bvine">
      select fieldName, mapsTo from fieldDefinitions where site = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#siteID#"> and object = <cfqueryparam  cfsqltype="cf_sql_varchar" value="contact">
    </cfquery>
    <cfspreadsheet action="read" query="contact" src="/tmp/#fileName#" headerrow="1" excludeHeaderRow="true"></cfspreadsheet>

    <cfloop query="contact">
      <cfhttp result="newContacty" method="post" port="8080" url="http://46.51.188.170/alfresco/service/bv/contact?siteID=#lcase(siteID)#&alf_ticket=#ticket#">
        <cfloop query="fieldMappings">
          <cfhttpparam name="bvC_#fieldName#" value="#contact['#mapsTo#'][x]#" type="formfield">
          <cflog application="true" text="#contact['#mapsTo#'][x]#">
        </cfloop>
      </cfhttp>
      <cfset x++>
    </cfloop>
  </cffunction>

  <cffunction name="emailHistory" returntype="array">
    <cfargument name="nodeRef" required="true" type="string">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp port="8080" result="contacts" url="http://46.51.188.170/alfresco/service/bv/email/contact?nodeRef=#nodeRef#&alf_ticket=#ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(contacts.fileContent)>
    <!---<cfreturn arrayOfStructuresToQuery(gridA)> --->
  </cffunction>
<cfscript>
/**
 * Converts an array of structures to a CF Query Object.
 * 6-19-02: Minor revision by Rob Brooks-Bilson (rbils@amkor.com)
 *
 * Update to handle empty array passed in. Mod by Nathan Dintenfass. Also no longer using list func.
 *
 * @param Array      The array of structures to be converted to a query object.  Assumes each array element contains structure with same  (Required)
 * @return Returns a query object.
 * @author David Crawford (rbils@amkor.comdcrawford@acteksoft.com)
 * @version 2, March 19, 2003
 */
function arrayOfStructuresToQuery(theArray){
    var colNames = "";
    var theQuery = queryNew("");
    var i=0;
    var j=0;
    //if there's nothing in the array, return the empty query
    if(NOT arrayLen(theArray))
        return theQuery;
    //get the column names into an array =
    colNames = structKeyArray(theArray[1]);
    //build the query based on the colNames
    theQuery = queryNew(arrayToList(colNames));
    //add the right number of rows to the query
    queryAddRow(theQuery, arrayLen(theArray));
    //for each element in the array, loop through the columns, populating the query
    for(i=1; i LTE arrayLen(theArray); i=i+1){
        for(j=1; j LTE arrayLen(colNames); j=j+1){
            querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
        }
    }
    return theQuery;
}
</cfscript>
</cfcomponent>
