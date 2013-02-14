<!---
LICENSE
Copyright 2007 Brian Kotek

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<!---
********************************************************************************************
Modified to work as a ColdBox 3 iterceptor
********************************************************************************************
Usage:
  In the ColdBox.xml.cfm file add:
  <Interceptor class="path.to.cfc.FormUtilities" />

Options:
  The interceptor can be configured as such:
  <Interceptor class="path.to.cfc.FormUtilities">
    <Property name="cleanCollection">true|false</Property>
    <Property name="trimFields">true|false</Property>
  </Interceptor>

Defaults:
  cleanCollection = true
  trimFields = false

The FormUtilities Interceptor adds keys to the request collection
For example:

  <input name="foo.bar"> becomes rc.foo.bar
  <input name="foo[1]"> becomes rc.foo[1]

If you set the cleanCollection property to true, then the Interceptor
removes any fields that have been converted. This is the default
behaviour.

The trimFields property, simply calls Trim() for each value. By default
this is set to false.
********************************************************************************************
--->

<cfcomponent extends="coldbox.system.interceptor" output="false">
  <cffunction name="configure" access="public" returntype="void" output="false">
    <cfscript>
      if( not propertyExists('cleanCollection') or not isBoolean(getProperty('cleanCollection')) )
      {
        setProperty('cleanCollection',true);
      }
      if( not propertyExists('trimFields') or not isBoolean(getProperty('trimFields')) )
      {
        setProperty('trimFields',false);
      }
    </cfscript>
  </cffunction>

  <cffunction name="preEvent" access="public" returntype="void" output="false" >
    <!--- ************************************************************* --->
    <cfargument name="event" required="true" type="coldbox.system.web.context.RequestContext" hint="The event object.">
    <cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
    <!--- ************************************************************* --->
    <cfscript>
      if ( arguments.event.getHttpMethod() eq "POST")
      {
        // we have a post event and the formfields value exists so process
        buildFormCollections( arguments.event );
      }
    </cfscript>
  </cffunction>

  <cffunction name="buildFormCollections" access="private" returntype="void" output="false" hint="">
    <!--- ************************************************************* --->
    <cfargument name="event" required="true" type="coldbox.system.web.context.RequestContext" hint="The event object.">
    <!--- ************************************************************* --->

    <cfset var local = StructNew() />

    <cfset var formScope = arguments.event.getCollection()>

    <cfset local.tempStruct = StructNew() />
    <cfset local.tempStruct['formCollectionsList'] = "" />

    <!--- Loop over the form scope. --->
    <cfloop collection="#formScope#" item="local.thisField">
      <cfset local.thisField = Trim(local.thisField) />

      <!--- If the field has a dot or a bracket... --->
      <cfif hasFormCollectionSyntax(local.thisField)>

        <!--- Add collection to list if not present. --->
        <cfset local.tempStruct['formCollectionsList'] = addCollectionNameToCollectionList(local.tempStruct['formCollectionsList'], local.thisField) />

        <cfset local.currentElement = local.tempStruct />

        <!--- Loop over the field using . as the delimiter. --->
        <cfset local.delimiterCounter = 1 />
        <cfloop list="#local.thisField#" delimiters="." index="local.thisElement">
          <cfset local.tempElement = local.thisElement />
          <cfset local.tempIndex = 0 />

          <!--- If the current piece of the field has a bracket, determine the index and the element name. --->
          <cfif local.tempElement contains "[">
            <cfset local.tempIndex = ReReplaceNoCase(local.tempElement, '.+\[|\]', '', 'all') />
            <cfset local.tempElement = ReReplaceNoCase(local.tempElement, '\[.+\]', '', 'all') />
          </cfif>

          <!--- If there is a temp element defined, means this field is an array or struct. --->
          <cfif not StructKeyExists(local.currentElement, local.tempElement)>

            <!--- If tempIndex is 0, it's a Struct, otherwise an Array. --->
            <cfif local.tempIndex eq 0>
              <cfset local.currentElement[local.tempElement] = StructNew() />
            <cfelse>
              <cfset local.currentElement[local.tempElement] = ArrayNew(1) />
            </cfif>
          </cfif>

          <!--- If this is the last element defined by dots in the form field name, assign the form field value to the variable. --->
          <cfif local.delimiterCounter eq ListLen(local.thisField, '.')>
            <cfif getProperty('trimFields') AND isSimpleValue(formScope[local.thisField])>
              <cfset local.thisValue = Trim(formScope[local.thisField])>
            <cfelse>
              <cfset local.thisValue = formScope[local.thisField]>
            </cfif>

            <cfif local.tempIndex eq 0>
              <cfset local.currentElement[local.tempElement] = local.thisValue />
            <cfelse>
              <cfset local.currentElement[local.tempElement][local.tempIndex] = local.thisValue />
            </cfif>

          <!--- Otherwise, keep going through the field name looking for more structs or arrays. --->
          <cfelse>

            <!--- If this field was a Struct, make the next element the current element for the next loop iteration. --->
            <cfif local.tempIndex eq 0>
              <cfset local.currentElement = local.currentElement[local.tempElement] />
            <cfelse>

              <!--- Otherwise it's an Array, so we have to catch array element undefined errors and set them to new Structs. --->
              <cftry>
                <cfset local.currentElement[local.tempElement][local.tempIndex] />
                <cfcatch type="any">
                  <cfset local.currentElement[local.tempElement][local.tempIndex] = StructNew() />
                </cfcatch>
              </cftry>

              <!--- Make the next element the current element for the next loop iteration. --->
              <cfset local.currentElement = local.currentElement[local.tempElement][local.tempIndex] />

            </cfif>
            <cfset local.delimiterCounter = local.delimiterCounter + 1 />
          </cfif>
        </cfloop>

        <!--- delete "special" syntax field from the event request collection --->
        <cfif getProperty('cleanCollection')>
          <cfset arguments.event.removeValue(local.thisField)>
        </cfif>
      </cfif>
    </cfloop>

    <!--- Done looping. Update the form scope, append the created form collections to the form scope. --->
    <cfset StructAppend(formScope, local.tempStruct) />
  </cffunction>

  <cffunction name="hasFormCollectionSyntax" access="private" returntype="boolean" output="false" hint="I determine if the field has the form collection syntax, meaning it contains a dot or a bracket.">
    <cfargument name="fieldName" type="any" required="true" />
    <cfreturn arguments.fieldName contains "." or arguments.fieldName contains "[" />
  </cffunction>

  <cffunction name="addCollectionNameToCollectionList" access="private" returntype="string" output="false" hint="I add the collection name to the list of collection names if it isn't already there.">
    <cfargument name="formCollectionsList" type="string" required="true" />
    <cfargument name="fieldName" type="string" required="true" />
    <cfif not ListFindNoCase(arguments.formCollectionsList, ReReplaceNoCase(arguments.fieldName, '(\.|\[).+', ''))>
      <cfset arguments.formCollectionsList = ListAppend(arguments.formCollectionsList, ReReplaceNoCase(arguments.fieldName, '(\.|\[).+', '')) />
    </cfif>
    <cfreturn arguments.formCollectionsList />
  </cffunction>
</cfcomponent>