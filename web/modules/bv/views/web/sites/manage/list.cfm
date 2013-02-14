<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/sites/manage","secure/sites/manage")>
<div class="page-header">
<h1>Site Members</h1>
</div>
<div class="alert alert-block">
  <a class="close" data-dismiss="alert">&times;</a>
  <h4 class="alert-heading">Your current users</h4>
  The list below shows all users/groups who have access to your site in Building Vine&trade;.
</div>
<div id="tabs">
	<ul>
		<li><a href="/bv/site/listUsers?role=SiteConsumer"><span>Users</span></a></li>
		<li><a href="/bv/site/listUsers?role=SiteManager"><span>Managers</span></a></li>
	</ul>
</div>
