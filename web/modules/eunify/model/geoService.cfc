<cfcomponent name="geoService" cache="true">
  <cffunction name="getAddressFromIp" returntype="struct">
    <cfargument name="ipaddress">
    <cfset var returnObject = {}>
    <cfhttp url="http://freegeoip.net/json/#arguments.ipaddress#" result="res"></cfhttp>
    <cftry>
      <cfset returnObject = DeSerializejson(res.fileContent)>
      <cfcatch type="any">
        <cfset returnObject  = {
          city = "",
          zipcode  = "",
          longitude  = "",
          latitude  = "",
          country_code  = "",
          country_name  = "",
          region_name  = "",
        }>
      </cfcatch>
    </cftry>
    <cfif returnObject.zipcode eq "">
      <!--- try google to get the postcode instead --->

    </cfif>
    <cfreturn returnObject>
  </cffunction>
  <cfscript>
function getDistance(lat1, lon1, lat2, lon2, units = 'miles')
{
    // earth's radius. Default is miles.
    var radius = 3959;
    if (arguments.units EQ 'kilometers' )
        radius = 6371;
    else if (arguments.units EQ 'feet')
        radius = 20903520;

    var toRad = pi() / 180;
    var dLat = (lat2-lat1) * toRad;
    var dLon = (lon2-lon1) * toRad;
    var a = sin(dLat/2)^2 + cos(lat1 * toRad) * cos(lat2 * toRad) * sin(dLon/2)^2;
    var c = 2 * createObject("java","java.lang.Math").atan2(sqr(a), sqr(1-a));

    return radius * c;
}
</cfscript>
</cfcomponent>