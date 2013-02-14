<friends xmlns="http://schemas.microsoft.com/office/outlook/2010/06/socialprovider.xsd">
  <cfoutput query="rc.contact">
  <person>
    <userID>#rc.contact.id#</userID>
    <firstName>#xmlFormat(rc.contact.first_name)#</firstName>
    <lastName>#xmlFormat(rc.contact.surname)#</lastName>
    <nickname></nickname>
    <pictureUrl>#xmlFormat("http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.email)))#?size=200&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg")#</pictureUrl>
    <fileAs>#xmlFormat(rc.contact.surname)#, #xmlFormat(rc.contact.first_name)# (#XMLFormat(rc.company.known_as)#)</fileAs>
    <company>#xmlFormat(rc.company.name)#</company>
    <title>#xmlFormat(rc.contact.jobTitle)#</title>
    <emailAddress>#rc.contact.email#</emailAddress>
    <emailAddress2>#rc.contact.email_2#</emailAddress2>    
    <emailAddress3>#rc.contact.email_2#</emailAddress3>        
    <webProfilePage>http://#cgi.http_host#/eunify/contact/index/id/#rc.contact.id#</webProfilePage>
    <phone>#rc.contact.tel#</phone>
    <cell>#rc.contact.mobile#</cell>
    <workPhone>#rc.company.company_phone#</workPhone>
    <creationTime>2011-01-01T00:00:00</creationTime>
    <lastModificationTime>#DateFormat(rc.contact.modified,'YYYY-MM-DD')#T#TimeFormat(rc.contact.modified,"HH:MM:SS")#</lastModificationTime>
    <expirationTime>#DateFormat(DateAdd("d",1,now()),'YYYY-MM-DD')#T#TimeFormat(now(),"HH:MM:SS")#</expirationTime>
  </person>
  </cfoutput>
</friends>