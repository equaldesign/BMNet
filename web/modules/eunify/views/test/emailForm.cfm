<cfset getMyPlugin(plugin="jQuery").getDepends("","","form",true,"eGroup")>
<div class="form-container">
  <form action="/eunify/email/fastFile" method="post" enctype="multipart/form-data">
    <fieldset>
      <legend>Test Form upload</legend>
      <div>
        <label>Username</label>
        <input type="text" name="username" id="username" />
      </div>
      <div>
        <label>Password</label>
        <input type="password" name="password" id="password" />
      </div>
      <div>
        <label>.eml attachment</label>
        <input type="file" name="emailattach" id="emailattach" />
      </div>
      <div>
        <input type="submit">
      </div>
    </fieldset>
  </form>
</div>