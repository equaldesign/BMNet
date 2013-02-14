<cfset rc.baseCats = getMyPLugin("mxtra/shop/category").getSubs(0)>
    <cfoutput query="rc.baseCats">
      <h3><a href="##">#capFirstTitle(name)#</a></h3>
      <div>
        <ul>
          <cfset childCats = getMyPLugin("mxtra/shop/category").getSubs(id)>
          <cfloop query="childCats">
            <li class="heading">#capFirstTitle(name)#&nbsp;</li>
            <cfset cCats = getMyPLugin("mxtra/shop/category").getSubs(id)>
            <ul>
            <cfloop query="cCats">
              <li><a href="/mxtra/shop/category?categoryID=#id#">#capFirstTitle(name)#&nbsp;(#productCount#)</a></li>
            </cfloop>
            </ul>
          </cfloop>
        </ul>
      </div>
    </cfoutput>
    <cfoutput>
    <img vspace="10" alt="" src="/includes/images/sites/11/#Lcase(DateFormat(now(),"mmmyy"))#.jpg" />
    </cfoutput>