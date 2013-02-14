<cfset getMyPlugin(plugin="jQuery").getDepends("block,scroll,validate,form","psa/inputStreams")>
<h1>2. Capturing Supplier Figures</h1>
<div class="form-signUp">
	<cfoutput>
	<form id="inputS" class="form" action="/psa/figuresEntry/psaID/#rc.panelData.psa.id#" method="post">
	<input type="hidden" id="psaID" name="psaID" value="#rc.panelData.psa.ID#" />
	<div class="Aristo ui-widget">
    <div style="margin-top: 20px; padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">

      <p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-info"></span><strong>Notice</strong></p>
      <p>In the following section, please ensure you are capturing all the turnover required for this agreeement. If you are capturing a certain product line, all the capture streams should <strong>not</strong> exceed the total turnover.</p>
      <p>For example, the following is <strong>WRONG</strong> (as 1+2+3 is greater than the total turnover):</p>
      <ol>
       <li>Power Tools</li>
       <li>Hand Tools</li>
       <li>All turnover</li>
      </ol>
      <p>But this is <strong>CORRECT</strong> (as 1+2+3 <strong>IS</strong> equal to the total turnover):</p>
      <ol>
       <li>Power Tools</li>
       <li>Hand Tools</li>
       <li>All other turnover</li>
      </ol>
    </div>
  </div>
	<div id="streamList">#renderView("psa/panel/edit/inputStreamList")#</div>
  <fieldset id="inputStream">
	#renderView("psa/panel/edit/inputStreamNew")#
	</fieldset>
  </form>
  <form id="inputChains" class="form" action="/psa/addChain/psaID/#rc.panelData.psa.id#" method="post">
  <div style="margin-top: 20px; padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">

      <p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-info"></span><strong>Chaining Agreements</strong></p>
      <p>The following section allows you to "chain" agreements to this agreement, exposing the input streams from the other agreements.</p>
      <p>This enables you to create agreements in the vein of a "top hat" agreement, by allowing you to create rebate elements that use turnover from other agreeemtns, either current or historic</p>
    </div>
  <div id="chainList">#renderView("psa/panel/edit/chainList")#</div>
  <fieldset id="chains">
    #renderView("psa/panel/edit/chainNew")#
  </fieldset>
  </form>
	</cfoutput>
</div>