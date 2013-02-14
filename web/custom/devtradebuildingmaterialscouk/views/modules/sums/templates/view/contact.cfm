<div class="row">
  <div class="span8">        
		<iframe width="100%" height="180" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.ca/maps?f=q&source=s_q&hl=en&geocode=&q=TW18 4AX&ie=UTF8&hq=&hnear=New+York,+United+States&ll=40.714867,-74.005537&spn=0.019517,0.018797&z=14&iwloc=near&output=embed"></iframe>
    <hr />
		<p>We want to hear from you! Just enter your name, email address, and message into the form below and send away.</p>
    <hr />
		<h2>Send a Message</h2>
    <cfoutput>
      <form action="/sums/contact" method="post">
        <input type="hidden" name="formNodeRef" id="formNodeRef" value="#paramValue('rc.requestData.page.nodeRef','')#" />
        #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.formcontent)#
      </form>
    </cfoutput>
  </div>
	<div class="span4">
		<div class="alert alert-success">
			<h3 class="alert-heading">More Information</h3>
			<p>TradeBuild is a website operated by Buidling Vine Limited.</p>
		</div>
	</div>
</div>
