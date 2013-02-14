<cfoutput>
<div class="form">
<form id="brochureBuilder" action="/products/brochureDo" method="post">
  <div>
    <h2>Welcome to the brochure-o-matic!</h2>
  </div>
  <fieldset>
    <legend>Core Information</legend>
    <div>
      <label for="title">Brochure Style</label>
      <select name="style">
        <option value="standard">Standard</option>
        <option value="compact">Compact</option>
        <option value="supercompact">Super-Compact</option>
      </select>
    </div>
    <div>
      <label for="title">Title</label>
      <input type="text" name="title" id="title"  />
    </div>
    <div>
      <label for="intro">Introduction</label>
      <textarea name="introduction" id="introduction"></textarea>
    </div>
    <div>
      <label for="name">Send to (name)</label>
      <input type="text" name="name" id="name"  />
    </div>
    <div>
      <label for="email">Send to (email)</label>
      <input type="text" name="email" id="email"  />
    </div>
    <div>
      <label for="subject">Email Subject</label>
      <input type="text" name="subject" id="subject"  />
    </div>
    <div class="buttonRow">
      <input type="submit" value="Build it!" class="doIt" />
    </div>
  </fieldset>
</form>
</div>
</cfoutput>