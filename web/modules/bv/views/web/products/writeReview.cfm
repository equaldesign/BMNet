    <link href="https://www.buildingvine.com/includes/styles/fonts.css" rel="stylesheet" type="text/css"></link>
    <link href="https://www.buildingvine.com/includes/styles/public/external.css" rel="stylesheet" type="text/css"></link>
    <link href="https://www.buildingvine.com/includes/styles/jQuery/jQueryUI-Aristo.css" rel="stylesheet" type="text/css"></link>
    <div class="ui-widget">
      <div style="padding: 0pt 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
        <p>
          <span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"/bv/></span>
          Product reviews should be related specifically to the product, not your exprience with a particular merchant.
          Reviews that related to a particular Merchant or Retailer may be removed.
        </p>
      </div>
    </div>
    <div class=" form-signUp">
    <form action="/bv/products/createReview" method="post">
      <cfoutput><input type="hidden" name="productID" value="#rc.productID#"></cfoutput>
      <fieldset>
        <legend>Write a review of this product</legend>
        <div>
          <label class="s">Title <em>*</em></label>
          <input size="45" type="text" name="title" />
        </div>
        <div>
          <label class="s">Review <em>*</em></label>
          <textarea rows="10" cols="25"  name="comment"></textarea>
        </div>
        <div class="controlset">
          <div>
          <input class="doIt" type="submit" value="Add your review &raquo;" />
          </div>
        </div>
      </fieldset>
    </form>
  </div>