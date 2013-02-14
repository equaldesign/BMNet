<cfoutput>
<h1>#rc.requestData.page.title#</h1>
  <form class="form form-horizontal" action="/sums/signup" method="post">
    <div name="formcontent" #isE()#>
    #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.formcontent",""))#
    </div>
  </form>
</cfoutput>