
<cfset getMyPlugin(plugin="jQuery").getDepends("ratings,elastislide","secure/sites/browser","jQuery/jQuery.ratings,secure/sites/browser")>
<cfoutput>
<div class="btn-group" data-toggle="buttons-radio">
	<a class="btn btn-mini" href="/bv/sites">Full List</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=a">A</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=b">B</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=c">C</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=d">D</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=e">E</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=f">F</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=g">G</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=h">H</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=i">I</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=j">J</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=k">K</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=l">L</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=m">M</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=n">N</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=o">O</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=p">P</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=q">Q</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=r">R</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=s">S</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=t">T</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=u">U</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=v">V</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=w">W</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=x">X</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=y">Y</a>
	<a class="btn btn-mini" href="/bv/site/filter?type=#rc.type#&q=z">Z</a>
</div>
</cfoutput>
<div class="clear"></div>
<input type="hidden" id="filter" value="" />
<div class="page-header">
	<!-- filter and ordering options -->
	<h4>There are currently <cfoutput>#rc.numberOfSites#</cfoutput> sites available to you in Building Vine.</h4>

  <h3><small>Private (invitation only) sites are not displayed.</small></h3>
</div>

<div id="siteList">

	<cfoutput>#renderView("web/sites/viewletlist")#</cfoutput>
</div>
