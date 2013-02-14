<cfset getMyPlugin(plugin="jQuery").getDepends("swfobject,upload","secure/products/documents/edit","secure/products/editdocuments,secure/documents/uploadify")>

<cfoutput>
<div class="t">
  <div class="trow">
    <div class="tcell" style="width:300">
      <div id="chosenDocuments">
       <div id="productDocument" class="documentSelection">
        <p>Documents</p>
        <cfloop array="#rc.product.detail.productDocuments#" index="doc">
          <cfif isDefined("doc.nodeRef")>
          <div class="chooseDocument left">
            <img id="#doc.nodeRef#" src="https://www.buildingvine.com/api/productImage?nodeRef=#doc.nodeRef#" width="50" title="#doc.title#" class="ttip glow smallImage" />						
            <div>
              <a target="_blank" class="icon magnify" href="/alfresco#doc.downloadUrl#?alf_ticket=#request.user_ticket#"></a>
              <a class="icon unchoose" href="##"></a>
            </div>
          </div>
          </cfif>
        </cfloop>
       </div>
       <div class="clear"></div>
     </div>
    </div>
    <div class="tcell">
      <h4>#rc.product.detail.attributes.title#</h4>
      <cfif StructKeyExists(rc.product.detail.attributes,"description")><p>#rc.product.detail.attributes.description#</p></cfif>
      <cfif ArrayLen(rc.product.detail.productDocuments) gte 1>
        <div class="alert alert-info">
        	<a href="##" class="close">&times;</a>          
            <h5>Official Documents</h5>
            <p> This product has associated documents.</p>
            <p>You can remove these documents, and then <!---either --->search for a new document to "attach" to this product<!---, or upload a new document--->.</p>          
        </div>
      <cfelse>
        <div class="alert alert-info">
          <a href="##" class="close">&times;</a>   
            <h5>No Documents</h5>
            <p>This product does not have any associated documents.</p>
            <p>If you'd like to add a document, you can <!---upload a new one or --->search Building Vine for a replacement.</p>          
        </div>
      </cfif>
      <div>
        <h5>Search for a replacement</h5>
        <div rel="#rc.product.detail.nodeRef#" class="rel" id="documentSearch">
          <form class="form-inline action="/bv/search/people" method="post" id="searchDocument">            
            <div class="input-append">      
              <input class="input-xlarge" placeholder="Enter a search term" size="40" type="text" name="documentQuery" id="docQ">
              <input  class="btn btn-success" type="submit" value="search" />
						</div>            
          </form>
        </div>
        <div id="uploadQueue"></div>
        <div id="documentResults"></div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
