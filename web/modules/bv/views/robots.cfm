<cfoutput>
<cfcontent type="text/plain">
User-Agent: *
Disallow: /config/
Disallow: /handlers/
Disallow: /includes/
Disallow: /interceptors/
Disallow: /layouts/
Disallow: /logs/
Disallow: /model/
Disallow: /plugins/
Disallow: /views/
Disallow: /alfresco/
Disallow: /share/
Allow: /
SiteMap: http://#cgi.http_host#/#cgi.http_host#.sitmap.xml
</cfoutput>