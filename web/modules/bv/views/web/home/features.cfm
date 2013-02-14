<div id="signUpMobile">
  <div class="mobile"></div>
  <div class="mobdesc">

    <h3>Got a smartphone?</h3>
    <p>Scan barcodes on your mobile and get product information at your fingertips.</p>
    <cfoutput>
    <a href="http://m.buildingvine.com" title="Building Vine Mobile"><img border="0" id="qCode" alt="scan this with your mobile" src="https://chart.googleapis.com/chart?chs=82x82&amp;cht=qr&amp;chl=#URLEncodedFormat("http://m.buildingvine.com")#" align="right" /></a>
    </cfoutput>
  </div>
  <div class="clear"></div>
</div>
<cfoutput>
<h2 class="roundCorners productCount">
  <cfquery name="p" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">select count(*) as productCount from alf_node where type_qname_id = 258
    AND store_id = 6 AND node_deleted = '';
  </cfquery>
  <cfquery name="tm" datasource="alfresco" cachedwithin="#CreateTimeSpan(1,0,1,0)#">
  select count(*) as productCount from alf_node where type_qname_id = 258
  AND store_id = 6 AND node_deleted = '' AND audit_created > DATE_ADD(now(), INTERVAL -1 MONTH)
  </cfquery>
  #NumberFormat(p.productCount+99854,"9,999,999")# products and counting...
</h2>
<p>We've added #NumberFormat(p.productCount+99854,"9,999,999")# products to Building Vine&trade; since Jan 1st 2011, and #NumberFormat(tm.productCount,"9,999,999")# in
  #DateFormat(now(),"MMMM")# alone. If you are a supplier or manufacturer, <a href="/signup">register now</a> to add your products and company to Building Vine&trade;</p>
</cfoutput>
<h2 class="roundCorners features"><a class="showthematrix" href="##">Pricing and feature comparison matrix</a></h2>
<div id="featuresBox">
  <div id="featureList">
    <ul>
      <li><a class="tooltip webaccess" href="##" title="Unlimited Access through the Building Vine website">Web Access</a></li>
      <li><a class="tooltip desktopaccess" href="##" title="Access Building Vine directly from the Desktop">Desktop</a></li>
      <li><a class="tooltip emailaccess" href="##" title="Query Building Vine via email">Email Access</a></li>
      <li><a class="tooltip websync" href="##" title="Syncronise your website with the Building Vine Product Repository for remote images and associated files">Web Sync</a></li>
      <li><a class="tooltip ermsync" href="##" title="Syncronise the Building Vine Product Repository with your internal ERM &amp; Counter Sales System">ERM Sync</a></li>
      <li><a class="tooltip addproducts" href="##" title="Upload and manage your products on Building Vine">Products</a></li>
      <li><a class="tooltip addproducts" href="##" title="Integration into your intranet">Intranet</a></li>
      <li><a class="tooltip managefiles" href="##" title="Manage and store company and personal files on Building Vine">Files</a></li>
      <li class="last"><h4>Price</h4></li>
    </ul>
  </div>
  <div id="featuresFree" class="roundCorners glow">
    <h3>Basic</h3>
    <p>For Consumers</p>
    <ul>
      <li class="yes"></li>
      <li class="yes"></li>
      <li class="no"></li>
      <li class="no"></li>
      <li class="no"></li>
      <li class="no"></li>
      <li class="no"></li>
      <li class="no"></li>
      <li class="last"><h4>Free</h4></li>
    </ul>
  </div>
  <div id="featuresPaid" class="roundCorners glow">
    <h3>Business</h3>
    <div id="forMerchants">
      <p>For Merchants</p>
      <ul>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="no"></li>
        <li class="last"><h4>&pound;990</h4></li>
      </ul>
    </div>
    <div id="forSuppliers">
      <p>For Suppliers</p>
      <ul>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="yes"></li>
        <li class="no"></li>
        <li class="yes"></li>
        <li class="no"></li>
        <li class="yes"></li>
        <li class="last"><h4>&pound;990</h4></li>
      </ul>
    </div>
    <br class="clear" />
  </div>
  <br class="clear" />
</div>
<div id="supporters" class="glow roundCorners">
  <div class="supporters_tag"></div>
  <div class="supporterCycle">
    <div class="supporter">
      <img class="supporter_logo" alt="CEMCO Merchant Network" src="/includes/images/public/friends/cemco.png" />
      <p>We're lucky enough to be supported by CEMCO, the most dynamic and forward thinking Buying Group in the UK. </p>
      <p>With over 150 branches across the UK, CEMCO are helping drive and shape the future of Building Vine&trade; for our Merchant customers.</p>
    </div>
    <div class="supporter">
      <img class="supporter_logo" alt="Alfresco Enterprise Content Management" src="/includes/images/public/friends/alfresco.png" />
      <p>Building Vine&trade; is proudly powered by the open source ECM system Alfresco. </p>
      <p>Alfresco is the leading open source ECM provider - which is used by companies such as NASA, Fox, EA and others.</p>
    </div>
    <div class="supporter">
      <img class="supporter_logo" alt="Amazon Web Services" src="/includes/images/public/friends/amazon.png" />
      <p>Building Vine&trade;  runs on Amazon's award winning Elastic Cloud Infrastructure.</p>
      <p>We ultilise Amazon EC2, Amazon RDS, Amazon S3, and Amazon Cloud Front.</p>
    </div>
  </div>



</div>

<div id="downloadBrochure" class="glow roundCorners" >

  <h2>Need more information?</h2>
  <p>Stay up to date with developments by joining our mailing list.</p>
  <div class="l form-signUp">
    <form action="http://ebizuk.createsend.com/t/r/s/phlurl/">
      <label for="cm-phlurl-phlurl" class="s">Your Email<em>*</em>:</label>
      <input type="text" size="15" id="cm-phlurl-phlurl" name="cm-phlurl-phlurl" value="" />
      <input type="submit" class="dl" name="d" value="keep informed!" />
    </form>
  </div>
  <br class="clear" />
  <p class="small bold">We will never spam you,
    sell your email address, or share it with anyone.
  </p>
</div>