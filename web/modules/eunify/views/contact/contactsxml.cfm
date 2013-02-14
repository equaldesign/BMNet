<friends xmlns="http://schemas.microsoft.com/office/outlook/2010/06/socialprovider.xsd">
  <cfoutput query="rc.contacts">
  <person>
    <userID>#contactID#</userID>
    <firstName>#xmlFormat(first_name)#</firstName>
    <lastName>#xmlFormat(surname)#</lastName>
    <nickname></nickname>
    <pictureUrl>#xmlFormat("http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=200&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg")#"</pictureUrl>
    <fileAs>#xmlFormat(surname)#, #xmlFormat(first_name)# (#XMLFormat(known_as)#)</fileAs>
    <company>#xmlFormat(known_as)#</company>
    <title>#xmlFormat(jobTitle)#</title>
    <emailAddress>#email#</emailAddress>
    <webProfilePage>http://#cgi.http_host#/eunify/contact/index/id/#contactID#</webProfilePage>
    <phone>#tel#</phone>
    <cell>#mobile#</cell>
    <workPhone>#company_phone#</workPhone>
    <creationTime>2011-01-01T00:00:00</creationTime>
    <lastModificationTime>#DateFormat(modified,'YYYY-MM-DD')#T#TimeFormat(modified,"HH:MM:SS")#</lastModificationTime>
    <expirationTime>#DateFormat(DateAdd("d",1,now()),'YYYY-MM-DD')#T#TimeFormat(now(),"HH:MM:SS")#</expirationTime>
  </person>
  </cfoutput>
</friends>