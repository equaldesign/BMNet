<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/includes/images/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/includes/images/apple-touch-icon-11-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/includes/images/apple-touch-icon-72-precomposed.png">
  <meta name="google-site-verification" content="Oq2H0oj1cZ5ObulpwZvVlujECpPN006ED_J8mVpf4Nk" />
  <link rel="apple-touch-icon-precomposed" href="/includes/images/apple-touch-icon-57-precomposed.png">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <cfoutput>
    <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","")#" />
    <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","")#" />
  </cfoutput>
  <link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
  <script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>  
  <link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800' rel='stylesheet' type='text/css'>
  <cfset getMyPlugin(plugin="jQuery").getDepends("bootstrap","","bootstrap,bootstrap-responsive.min,sites/14/bb",false)>
    
</head>

<body>
  <cfset brochures = getModel("bv.DocumentService").brochureBrowser()>
  <cfset site = getModel("bv.SiteService")>
  <cfset brochureQ = QueryNew("site,siteTitle,fileName,fileTitle,modified,size,nodeRef")>
  <cfloop array="#brochures#" index="b">
    <cfset QueryAddRow(brochureQ)>
    <cfset QuerySetCell(brochureQ,"site",b.site)>
    <cfset QuerySetCell(brochureQ,"fileName",b.name)>  
    <cfset QuerySetCell(brochureQ,"fileTitle",b.title)>  
    <cfset QuerySetCell(brochureQ,"modified",b.modifiedOn)>  
    <cfset QuerySetCell(brochureQ,"size",b.size)>    
    <cfset QuerySetCell(brochureQ,"siteTitle",site.siteDB(b.site).title)>  
    <cfset QuerySetCell(brochureQ,"nodeRef",b.nodeRef)>  
  </cfloop>  
  <cfquery name="qq" dbtype="query">
    select * from brochureQ order by site, fileTitle desc;
  </cfquery> 
  <div class="accordion" id="accordion2">
    <cfoutput query="qq" group="site">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion2" data-target="###site#" href="###site#"> 
          <cfset uImage = paramImage2("/modules/bv/includes/images/companies/#site#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>          
          <h3><img width="30" class="img-polaroid pull-left" style="margin-right: 10px" alt="#xmlFormat(siteTitle)#" src="#uImage#" />#siteTitle#</h3>
        </a>
        <br />
      </div>
      <div id="#site#" class="accordion-body collapse">
        <div class="accordion-inner">
          <cfoutput>
            <div class="media">
              <a class="pull-left" href="##">
                <img class="media-object img-polaroid" src="https://www.buildingvine.com/api/i?nodeRef=#nodeRef#&size=65">
              </a>
              <div class="media-body">
                <h4 class="media-heading"><cfif fileTitle neq "">#fileTitle#<cfelse>#fileName#</cfif></h4>
                <p>#modified#</p>
              </div>
            </div>
          </cfoutput>          
        </div>
      </div>
    </div>
    </cfoutput>    
  </div>
</body>
</html>
