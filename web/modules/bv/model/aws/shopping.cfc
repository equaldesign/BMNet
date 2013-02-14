<cfcomponent>
  <cfproperty name="signer" inject="model:aws.amazonsig" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfset this.accesskey = "AKIAJ7KY7OTQMJ4QN24Q">
    <cfset this.secretkey = "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">
    <cfset this.AssociateTag = "builvine-21">

  <cffunction name="getItem" returntype="struct">
    <cfargument name="ASIN" required="true">
    <cfargument name="getRelated" required="true" type="boolean" default="false">
    <cfset var relatedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AssociateTag=#this.AssociateTag#&ItemId=#arguments.ASIN#&Operation=ItemLookup&ResponseGroup=Images,ItemAttributes,Offers,Large&AWSAccessKeyId=#this.accesskey#",this.secretKey)>
    <cfset var productDetails = {}>
    <cfhttp url="#relatedSig#" result="b"></cfhttp>
    <cfset content = Replace(b.fileContent,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com','all')>
    <cfset product = xmlParse(content)>
    <cfset productDetails["image"] = product.ItemLookupResponse.Items.item[1].SmallImage.URL.xmltext>
    <cfset productDetails["imageSet"] = product.ItemLookupResponse.Items.item[1].ImageSets>
    <cfset productDetails["OfferSummary"] = product.ItemLookupResponse.Items.item[1].OfferSummary>
    <cfset productDetails["mediumimage"] = product.ItemLookupResponse.Items.item[1].MediumImage.URL.xmltext>
    <cfset productDetails["largeimage"] = product.ItemLookupResponse.Items.item[1].LargeImage.URL.xmltext>
    <cfset productDetails["price"] = product.ItemLookupResponse.Items.item[1].OfferSummary.LowestNewPrice.formattedPrice.xmlText>
    <cfset productDetails["title"] = product.ItemLookupResponse.Items.item[1].ItemAttributes.Title.xmlText>
    <cfset productDetails["Attributes"] = product.ItemLookupResponse.Items.item[1].ItemAttributes>
    <cfset productDetails["Offers"] = product.ItemLookupResponse.Items.item[1].Offers>
    <cfset productDetails["ASIN"] = product.ItemLookupResponse.Items.item[1].ASIN.xmlText>
    <cfif getRelated>
      <cfset productDetails["relatedProducts"] = ArrayNew(1)>
      <cftry>
      <cfset similarProducts = product.ItemLookupResponse.Items.item[1].SimilarProducts.SimilarProduct>
      <cfloop array="#similarProducts#" index="p">
        <cfset arrayAppend(productDetails["relatedProducts"],getItem(p.ASIN.xmlText))>
      </cfloop>
      <cfcatch type="any"></cfcatch>
      </cftry>
    </cfif>
    <cfreturn productDetails>
  </cffunction>

  <cffunction name="amazonResults" returntype="Struct">
    <cfargument name="sString" required="true" type="string">
    <cfset var returnStruct = {}>
    <cfset var signedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AssociateTag=#this.AssociateTag#&Operation=ItemSearch&SearchIndex=All&Keywords=#arguments.sString#&ResponseGroup=Images,ItemAttributes,Large&AWSAccessKeyId=#this.accesskey#&Condition=New",this.secretKey)>
    <cfhttp url="#signedSig#" result="a"></cfhttp>
    <cfset returnStruct.mainProduct = xmlParse(a.fileContent)>
    <cfif isDefined("returnStruct.mainProduct.ItemSearchResponse.Items.item.ASIN")>
      <cfset returnStruct.relatedProducts = []>
      <cftry>
      <cfset similarProducts = returnStruct.mainProduct.ItemSearchResponse.Items.item[1].SimilarProducts.SimilarProduct>

      <cfloop array="#similarProducts#" index="p">
        <cfset arrayAppend(returnStruct.relatedProducts,getItem(p.ASIN.xmlText))>
      </cfloop>
      <cfset Accessories = returnStruct.mainProduct.ItemSearchResponse.Items.item[1].Accessories.Accessory>
      <cfcatch type="any"></cfcatch>
      </cftry>
    </cfif>
    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="amazonSearch" returntype="xml">
    <cfargument name="sString" required="true" type="string">
    <cfargument name="page" required="true" type="numeric">
    <cfset var returnStruct = {}>
    <cfset var signedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AssociateTag=#this.AssociateTag#&Operation=ItemSearch&SearchIndex=All&Keywords=#arguments.sString#&ResponseGroup=Images,ItemAttributes,Large&AWSAccessKeyId=#this.accesskey#&ItemPage=#arguments.page#&Condition=New&SearchIndex=HomeGarden",this.secretKey)>
    <cfhttp url="#signedSig#" result="a"></cfhttp>
    <cfset content = Replace(a.fileContent,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com','all')>
    <cfreturn xmlParse(content)>
  </cffunction>

  <cffunction name="addToBasket" returntype="void">
    <cfargument name="AIN" required="true" type="string">
    <cfargument name="quantity" required="true" type="numeric">
    <cfset var returnStruct = {}>
    <cfset var signedSig = "">
    <cfset var amazon = UserStorage.getVar("amazon")>
    <cfif amazon.basketID eq "">
      <cfset signedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=#this.accesskey#&AssociateTag=#this.AssociateTag#&Operation=CartCreate&Item.1.ASIN=#arguments.AIN#&Item.1.Quantity=#arguments.quantity#",this.secretKey)>
      <cfhttp url="#signedSig#" result="b"></cfhttp>
      <cfset basket = xmlParse(b.fileContent)>
      <cfset amazon.basketID = basket.CartCreateResponse.cart.cartId.xmlText>
      <cfset amazon.HMAC = basket.CartCreateResponse.cart.HMAC.xmlText>
      <cfset amazon.basketItems = ArrayLen(basket.CartCreateResponse.cart.CartItems.cartItem)>
      <cfset amazon.basketTotal = basket.CartCreateResponse.cart.CartItems.SubTotal.Amount.xmltext>
      <cfset UserStorage.setVar("amazon",amazon)>
    <cfelse>
      <cfset signedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=#this.accesskey#&AssociateTag=#this.AssociateTag#&Operation=CartAdd&CartId=#amazon.basketID#&Item.1.ASIN=#arguments.AIN#&Item.1.Quantity=#arguments.quantity#&HMAC=#urlEncodedFormat(amazon.HMAC)#",this.secretKey)>
      <cfhttp url="#signedSig#" result="b"></cfhttp>
      <cfset basket = xmlParse(b.fileContent)>
      <cfset amazon.basketItems = ArrayLen(basket.CartAddResponse.cart.CartItems.cartItem)>
      <cfset amazon.basketTotal = basket.CartAddResponse.cart.CartItems.SubTotal.Amount.xmltext>
      <cfset amazon.basketID = basket.CartAddResponse.cart.cartId.xmlText>
      <cfset amazon.HMAC = basket.CartAddResponse.cart.HMAC.xmlText>
    </cfif>
  </cffunction>
  <cffunction name="getBasket" returntype="struct">
    <cfset var returnStruct = {}>
    <cfset var signedSig = "">
    <cfset var amazon = UserStorage.getVar("amazon")>
    <cfset signedSig = signer.signrequest("http://ecs.amazonaws.co.uk/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=#this.accesskey#&AssociateTag=#this.AssociateTag#&Operation=CartGet&CartId=#amazon.basketID#&ResponseGroup=Cart,CartSimilarities&HMAC=#urlEncodedFormat(amazon.HMAC)#",this.secretKey)>
    <cfhttp url="#signedSig#" result="b"></cfhttp>
    <cfset returnStruct.basket = xmlParse(b.fileContent)>
    <cfset returnStruct.basketItems = []>
    <cfset returnStruct.similarItems = []>
    <cftry>
    <cfloop array="#returnStruct.basket.CartGetResponse.Cart.CartItems.CartItem#" index="p">
      <cfset cartItem = getItem(p.ASIN.xmlText)>
      <cfset cartItem.quotedPrice = p.Price.FormattedPrice.xmlText>
      <cfset cartItem.quantity = p.Quantity.xmlText>
      <cfset arrayAppend(returnStruct.basketItems,cartItem)>
    </cfloop>
    <cfloop array="#returnStruct.basket.CartGetResponse.Cart.SimilarViewedProducts.SimilarViewedProduct#" index="p">
      <cfset arrayAppend(returnStruct.similarItems,getItem(p.ASIN.xmlText))>
    </cfloop>
    <cfcatch type="any"></cfcatch>
    </cftry>
    <cfreturn returnStruct>
  </cffunction>

</cfcomponent>