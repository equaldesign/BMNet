<cfset getMyPlugin(plugin="jQuery").getDepends(",","home/tour","public/home/homepage,public/home/mainmenu,public/home/tour")>
<cfoutput>
<div class="menu">
<ul>
  <li class="mm"><a class="#IIf(ListFirst(rc.section,'/') eq 'index',"'active'","''")# ajax hidesubsections main" href="/tour">Overview<span></span></a></li>
  <li class="mm"><a rel="Products" class="#IIf(ListFirst(rc.section,'/') eq 'products',"'active'","''")# main showsubsection" href="##">Product Storage<span></span></a>
    <ul class="subsection #IIf(ListFirst(rc.section,'/') eq 'products',"''","'hidden'")#" id="Products">
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'unlimited',"'active'","''")# products ajax" href="/tour?section=products/unlimited">Unlimited Products</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'images',"'active'","''")# images ajax" href="/tour?section=products/images">Image association</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'documents',"'active'","''")# documents ajax" href="/tour?section=products/documents">Document association</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'reviews',"'active'","''")# reviews ajax" href="/tour?section=products/reviews">Reviews &amp; Ratings</a></li>
    </ul>
  </li>
  <li class="mm"><a rel="Files" class="#IIf(ListFirst(rc.section,'/') eq 'documents',"'active'","''")# main showsubsection" href="##">Files &amp; Documents<span></span></a>
    <ul class="subsection #IIf(ListFirst(rc.section,'/') eq 'documents',"''","'hidden'")#" id="Files">
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'specifications',"'active'","''")# specifications ajax" href="/tour?section=documents/specifications">Specifications</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'userguides',"'active'","''")# userguides ajax" href="/tour?section=documents/userguides">User Guides</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'brochures',"'active'","''")# brochures ajax" href="/tour?section=documents/brochures">Brochures</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'cad',"'active'","''")# cad ajax" href="/tour?section=documents/cad">CAD files</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'access',"'active'","''")# desktop ajax" href="/tour?section=documents/access">Platform Access</a></li>
    </ul>
  </li>
  <li class="mm"><a rel="extend"  class="#IIf(ListFirst(rc.section,'/') eq 'extend',"'active'","''")# main showsubsection" href="##">Extendibility<span></span></a>
    <ul class="subsection #IIf(ListFirst(rc.section,'/') eq 'extend',"''","'hidden'")#" id="extend">
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'ecommerce',"'active'","''")# ecommerce ajax" href="/tour?section=extend/ecommerce">E-Commerce</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'erm',"'active'","''")# erm ajax" href="/tour?section=extend/erm">ERM Systems</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'mobile',"'active'","''")# mobile ajax" href="/tour?section=extend/mobile">Mobile</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'website',"'active'","''")# website ajax" href="/tour?section=extend/website">Website</a></li>
    </ul>
  </li>
  <li class="mm"><a rel="marketing"  class="#IIf(ListFirst(rc.section,'/') eq 'marketing',"'active'","''")# main showsubsection" href="##">Marketing<span></span></a>
    <ul class="subsection #IIf(ListFirst(rc.section,'/') eq 'marketing',"''","'hidden'")#" id="marketing">
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'press',"'active'","''")# press ajax" href="/tour?section=marketing/press">Press releases</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'email',"'active'","''")# email ajax" href="/tour?section=marketing/email">Email Marketing</a></li>

    </ul>
  </li>
  <li class="mm"><a rel="why"  class="#IIf(ListFirst(rc.section,'/') eq 'why',"'active'","''")# main showsubsection" href="##">What makes us different<span></span></a>
    <ul class="subsection #IIf(ListFirst(rc.section,'/') eq 'why',"''","'hidden'")#" id="why">
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'opensrouce',"'active'","''")# opensource ajax" href="/tour?section=why/opensource">Open source</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'pricing',"'active'","''")# pricing ajax" href="/tour?section=why/pricing">Transparent Pricing</a></li>
      <li><a class="section #IIf(ListLast(rc.section,'/') eq 'future',"'active'","''")# future ajax" href="/tour?section=why/future">Forward Thinking</a></li>
    </ul>
  </li>
</ul>
</div>
</cfoutput>
