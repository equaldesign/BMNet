
<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'></cfhtmlhead>
<cfoutput>
	#getMyPlugin(plugin="jQuery").getDepends("faqs","sites/4/faqs","")#
	#HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#</cfoutput>
