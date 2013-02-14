<activityFeed xmlns="http://schemas.microsoft.com/office/outlook/2010/06/socialprovider.xsd">
  <network>BuildersMerchant</network>
  <activities>
  <cfoutput query="rc.feed">
    #renderView(view="feed/types/xml/#actionID#",args={data=rc.feed,currentRow=currentRow})#
  </cfoutput>
  </activities>
  <templates>
  <cfoutput query="rc.feed" group="actionID">
    #renderView(view="feed/types/xml/template/#actionID#",args={data=rc.feed,currentRow=currentRow})#
  </cfoutput>
  </templates>
</activityFeed>