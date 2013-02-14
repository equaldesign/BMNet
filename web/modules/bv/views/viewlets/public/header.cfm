<div class="Logo floatleft"><img src="/includes/images/public/bvlogo.png" alt="Building Vine"/></div>

  <!---<h3 style="padding-right: 20px; color: #FFF !important">We're currently performing maintainance</h3>
  <h5 style="padding-right: 20px; color: #CDE0B1 !important">Login's will be suspended between Friday 7th @ 6AM GMT until Monday 10th @ 6AM GMT whilst we add some cool new features. We apologise for any inconvenience this may cause.</h5>--->
  <cfset CS = getPlugin("cookiestorage")>
  <cfset CS.setEncryption(true)>
  <cfset login = CS.getVar("username","")>
  <cfset password = CS.getVar("password","")>
  <cfset r = CS.getVar("rememberMe","")>
    <form class="pull-right form-inline" action="https://www.buildingvine.com/login/doLogin" method="post">
      <input placeholder="email address" type="text" class="input-small" name="username" />
      <input placeholder="password" type="password" class="input-small" name="password" />
      <input type="submit" class="btn btn-success" value="LOGIN" />			
    </form>            
    <ul class="nav">
      <li><a class="n-home" href="/">home</a></li>
      <li><a class="n-signup" href="https://www.buildingvine.com/signup">register</a></li>
      <li><a class="n-blog" href="/blog">blog</a></li>
      <li><a class="n-tour" href="/tour">take the tour</a></li>
      <li><a class="n-contact" href="/pages/contact">Contact</a></li>
    </ul>
