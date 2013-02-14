<!---
Amazon Product Advertising API Signature Generator

http://amazonsig.riaforge.org

Copyright (c) 2009 Tim Dawe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--->

<cfcomponent hint="Amazon Product Advertising API Signature Generator">

	<cffunction name="signRequest" returntype="string" output="false"
		hint="Sign a request">

		<cfargument name="request" required="yes" type="string">
		<cfargument name="secretKey" required="yes" type="string">

		<!--- "Local" variable scope --->
		<cfset var lc = structnew()>

		<!--- Extract the URL part of the request and strip the protocol --->
		<cfset lc.requesturl = listfirst(arguments.request, "?")>
		<cfset lc.requesturl = replacenocase(lc.requesturl, "http://", "")>

		<!--- Split into host and path --->
		<cfset lc.host = listfirst(lc.requesturl, "/")>
		<cfset lc.path = right(lc.requesturl, len(lc.requesturl) - len(lc.host))>

		<!--- Process the query string parameters into a structure --->
		<cfset lc.querystring = listlast(arguments.request, "?")>
		<cfset lc.strParams = structnew()>
		<cfloop list="#lc.querystring#" index="i" delimiters="&">
			<cfset lc.strParams[listfirst(i, "=")] = urldecode(listlast(i, "="))>
		</cfloop>

		<!--- Add the timestamp --->
		<cfif not StructKeyExists(lc.strParams, "Timestamp")>
			<cfset lc.utcdate = dateconvert("local2Utc", now())>
			<cfset lc.timestamp = dateformat(lc.utcdate, 'yyyy-mm-dd') & "T" & timeformat(lc.utcdate, 'HH:mm:ss') & "Z">
			<cfset lc.strParams["Timestamp"] = lc.timestamp>
		</cfif>

		<!--- Sort the parameters --->
		<cfset lc.keys = listsort(structkeylist(lc.strParams), "text")>

		<!--- Generate a new query string including timestamp, with parameters in the correct order, encoding as we go --->
		<cfset lc.qs = "">
		<cfloop list="#lc.keys#" index="i">
			<cfset lc.qs = lc.qs & rfc3986EncodedFormat(i) & "=" & rfc3986EncodedFormat(lc.strParams[i]) & "&">
		</cfloop>

		<!--- Strip off the last & --->
		<cfset lc.qs = left(lc.qs, len(lc.qs)-1)>

		<!--- Build the string to sign --->
		<cfset lc.stringToSign = "GET" & chr(10)>
		<cfset lc.stringToSign = lc.stringToSign & lc.host & chr(10)>
		<cfset lc.stringToSign = lc.stringToSign & lc.path & chr(10)>
		<cfset lc.stringToSign = lc.stringToSign & lc.qs>

		<!--- Create the signature --->
		<cfset lc.binaryMsg = JavaCast("string",lc.stringToSign).getBytes("iso-8859-1")>
		<cfset lc.binaryKey = JavaCast("string",arguments.secretKey).getBytes("iso-8859-1")>
		<cfset lc.key = createObject("java","javax.crypto.spec.SecretKeySpec")>
		<cfset lc.key.init(lc.binaryKey,"HmacSHA256")>
		<cfset lc.hmac = createObject("java","javax.crypto.Mac")>
		<cfset lc.hmac = lc.hmac.getInstance("HmacSHA256")>
		<cfset lc.hmac.init(lc.key)>
		<cfset lc.hmac.update(lc.binaryMsg)>
		<cfset lc.signature = lc.hmac.doFinal()>

		<!--- Return the new request URL --->
		<cfreturn "http://" & lc.host & lc.path & "?" & lc.qs & "&Signature=" & urlencodedformat(tobase64(lc.signature))>

	</cffunction>

 	<cffunction name="rfc3986EncodedFormat" returntype="string" output="false"
		hint="Perform some character encoding">

		<cfargument name="text" required="yes" type="string">

		<!--- "Local" variable scope --->
		<cfset var lc = structnew()>

		<cfset lc.objNet = createObject("java","java.net.URLEncoder")>
		<cfset lc.encodedText = lc.objNet.encode(arguments.text, 'utf-8').replace("+", "%20").replace("*", "%2A").replace("%7E", "~")>

		<cfreturn lc.encodedText>

	</cffunction>

</cfcomponent>
