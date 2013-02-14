<div class="page-header">
  <h1>Checkout</h1>
</div>
<cfoutput>
<div id="checkOutStage">
  <ul class="breadcrumb">
    <li class="#IIf(request.mxtra.order.stage gte 1,"'active'","''")#"><a href="/mxtra/shop/checkout?stage=0">1. Sign in</a><span class="divider">/</span></li>
    <li class="#IIf(request.mxtra.order.stage gte 2,"'active'","''")#"><cfif request.mxtra.order.stage gte 2><a href="/mxtra/shop/checkout?stage=1"></cfif>2. Billing<cfif request.mxtra.order.stage gte 2></a></cfif></a><span class="divider">/</span></li>
    <li class="#IIf(request.mxtra.order.stage gte 3,"'active'","''")#"><cfif request.mxtra.order.stage gte 3><a href="/mxtra/shop/checkout?stage=2"></cfif>3. Delivery<cfif request.mxtra.order.stage gte 3></a></cfif><span class="divider">/</span></li>
    <li class="#IIf(request.mxtra.order.stage gte 4,"'active'","''")#"><cfif request.mxtra.order.stage gte 4><a href="/mxtra/shop/checkout?stage=3"></cfif>4. Payment Information<cfif request.mxtra.order.stage gte 4></a></cfif><span class="divider">/</span></li>
    <li class="#IIf(request.mxtra.order.stage gte 5,"'active'","''")#"><cfif request.mxtra.order.stage gte 5><a href="/mxtra/shop/checkout?stage=4"></cfif>5. Confirmation<cfif request.mxtra.order.stage gte 5></a></cfif></li>
  </ul>
</div>
</cfoutput>
<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <strong>Required fields</strong> are denoted by <em>*</em>.
</div>