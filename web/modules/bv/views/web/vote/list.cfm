<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/vote/vote","")>
<form action="/bv/vote/do" class="form form-horizontal">
  <table class="table table-striped table-bordered table-condensed">
    <thead>
      <tr>      
        <th colspan="2">Supplier Name</th>
        <th><i class="icon-drill ttip" title="Product Data"></i></th>
        <th><i class="icon-money ttip" title="Price Lists"></i></th>
        <th><i class="icon-globe ttip" title="Web Content"></i></th>
        <th><i class="icon-document-pdf ttip" title="Documentation"></i></th>
        <th><i class="icon-hard-hat ttip" title="Health &amp; Safety Information"></i></th>
        <th><i class="icon-store ttip" title="Promotions"></i></th>
      </tr>
    </thead>
    <tbody>
    <cfoutput query="rc.siteList">
      <tr>
        <td>
          <input type="checkbox" name="#shortName#" value="true" class="" />
          <!---
          <a href="##" class="badge ttip" title="Click to request all data from #title#">#votes#</a>
          --->
        </td>
        <td>#title#</td>
        <td>
          <input type="checkbox" name="#shortName#.request_productData" class=" " value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Product Data">#productVotes#</a>--->
        </td>
        <td>
          <input type="checkbox" name="#shortName#.request_priceFile" class="" value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Price Lists">
            #priceVotes#
          </a>--->
        </td>
        <td>
          <input type="checkbox" name="#shortName#.request_webContent" class="" value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Web Content">
            #webVotes#
          </a>--->
        </td>
        <td>
          <input type="checkbox" name="#shortName#.request_documentation" class="" value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Documentation">
            #docVotes#
          </a>--->
        </td>
        <td>
          <input type="checkbox" name="#shortName#.request_healthAndSafety" class="" value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Health &amp; Safety Information">
            #healthVotes#
          </a>--->
        </td>
        <td>
          <input type="checkbox" name="#shortName#.request_promotions" class="" value="true" />
          <!---<a href="##" class="badge ttip" title="Click to request Promotions">
            #promoVotes#
          </a>--->
        </td>
      </tr>
    </cfoutput>
    </tbody>
  </table>
  <fieldset>
    <legend>Message and further info</legend>
    <div class="control-group">
      <label class="control-label">Title</label>
      <div class="controls">
        <input type="text" name="message.title">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Message</label>
      <div class="controls">
        <textarea name="message"></textarea>
      </div>
    </div>
  </fieldset>
  <div class="form-actions">
    <input type="submit" class="btn" value="vote!"/>
  </div>
</form>
