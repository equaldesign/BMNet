<cfset getMyPlugin(plugin="jQuery").getDepends("upload,swfobject","figures/enter")>
<cfif NOT IsUserInRole("figures") AND NOT isUserInRole("figuresEntry")>
	Not engough privildges
	<cfabort>
</cfif>
<cfif rc.turnoverElements.recordCount gte 1>
<cfoutput>
<h1>Turnover for #YEAR(rc.psa.getperiod_from())#-#rc.psa.getid()#</h1>
<input type="hidden" id="psaID" value="#rc.psa.getid()#">
<h2><a href="#bl('psa.index','psaID=#rc.psa.getid()#')#">#rc.psa.getname()# (#rc.company.getknown_as()#)</a></h2>
	<cfif rc.monthsRequired gte 1>
	<div class="Aristo">
	<div class="ui-widget">
		<div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all">
			<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
			<cfif rc.turnoverElements.recordCount gte 8>
			<strong>Figures required - but too many elements!</strong>
			There are too many rebate elements (#rc.turnoverElements.recordCount#) to realistically show on the screen.
			</p>
			<cfelse>
			<strong>Figures required!</strong> You need to enter #rc.monthsRequired# month<cfif rc.monthsRequired gte 2>s</cfif> of figures</p>
			</cfif>
		</div>
	</div>
	</div>
	</cfif>

<div class="accordionopen2 Aristo">
	<h5><a href="##">Work offline in Excel&reg;</a></h5>
	<div>
  <cfif rc.monthsRequired gte 1 OR isUserInRole("admin")>
    <cfif rc.monthsRequired lte 0>
    <div class="Aristo">
    <div class="Aristo ui-widget">
      <div style="padding: 0pt 0.7em;" class="ui-state-error ui-corner-all">
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        <strong>You are an administrator</strong>
        <p>The spreadsheet you download will include months that have already been input.</p>
        <p>It will also include months that may NOT have been input.</p>
        <p>The turnover previously input will NOT show on this spreadsheet.</p>
        <p>When the spreadsheet imports, it will check for existing figures. If the column in the spreadsheet has zeros - and an existing figure exists, it will IGNORE it and continue.</p>
        <p>If the column has zeros, and an exiting figure doesn't already exist - it will be INSERTED.</p>
        <p>Therefore, it is IMPERATIVE you delete the worksheets that still need to be input.</p>
        <p>Use this feature with EXTREME care. If in doubt, consult an administrator before proceeding, as errors could corrupt an entire years worth of figures and may not be easily restored.</p>
        <p><strong>YOU HAVE BEEN WARNED!</strong></p>
      </div>
    </div>
    </div>
    </cfif>
		<div class="Aristo">
		<div class="Aristo ui-widget">
			<div style="padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
				<p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"></span>
				 <strong>If you'd prefer to work offline, you can.</strong></p>
				<ol>
					<li>Download the spreadsheet from below, and save it to your computer.<cfif rc.monthsRequired gte 2>
					<br />Seeing as you have more than one months worth of turnover to enter, each month required will be a seperate sheet in the workbook</cfif>

					</li>
					<li>Open it, enter the figures as required, and save it somewhere on your PC.</li>
					<li>Once you have entered figures into the spreadsheet, save the file  (you can just overwrite the file if you'd like)</li>
					<li>Click "Upload spreadsheet" from below, and choose the file you just saved.</li>
					<li>The system will upload the file and import your turnover figures</li>
				</ol>
			</div>
		</div>
		</div>
		<p><a class="noAjax" id="downloadExcel" target="_blank" href="#bl('figures.returnsSpreadsheetDownload','psaID=#rc.psaID#')#"><img src="/includes/images/figures/download.jpg" border="0"/></a></p>
		<div id="uploadExcel"></div>
		<div id="completeMessage"></div>
  <cfelse>

	  <div class="Aristo">
	  <div class="ui-widget">
	    <div style="padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
	      <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
	      <strong>No figures required.</strong>
	      This deal is all up to date.
	      </p>
	    </div>
	  </div>
	  </div>
  </cfif>
  </div>
  <cfif rc.monthsRequired gte 1 OR isUserInRole("edit")>
	<h5><a href="##">Enter figures manually</a></h5>
	<div>
	<cfif rc.turnoverElements.recordCount gte 8>
		<h2>Too many rebate elements</h2>
		<p>There are too many rebate elements (#rc.turnoverElements.recordCount#) to realistically show on the screen.</p>
		<p>If you want to enter figures, you will have to choose the "Work offline in Excel&reg;" section above.</p>
	<cfelse>
		<h2><cfif rc.editable>Enter<cfelse>View</cfif> Figures for #DateFormat(rc.date,"MMMM YYYY")#</h2>

		<table cellpadding="4" cellspacing="1">
		  <tr>
		    <td>Period Select</td>
		    <td>
		      <select rel="#rc.psa.getid()#" id="changePeriod" name="period">
		        <cfset curD = rc.psa.getperiod_from()>
		        <cfloop from="1" to="#rc.monthsinperiod+1#" index="i">
		        <cfset thisdNice = DateFormat(curD,"mmm yyyy")>
		        <cfset periodNic = DateFormat(rc.date,"mmm yyyy")>
		        <option value="#DateFormat(curD,'YYYY-MM-DD')#" #vm(thisdNice,periodNic)#>#thisdNice#</option>
		        <cfset curD = DateAdd("m",i,rc.psa.getperiod_from())>
		        </cfloop>
		      </select>
		    </td>
		  </tr>
		</table>

		<cfif IsUserInRole("admin")>
		<form action="#bl('figures.wipe')#" name="wipeFigures" method="post">
			<input type="hidden" id="psaID" name="psaID" value="#rc.psaID#" />
		  <input type="hidden" name="period" value="#DateFormat(rc.date,'YYYY-MM-DD')#" />
			<input type="hidden" id="urltoken" value="#URLEncodedFormat(session.urltoken)#" />
		</form>
		</cfif>
		<form name="confirmFigures" action="#bl('figures.doReturns')#" method="post">
			<input type="hidden" name="psaID" value="#rc.psaID#" />
		  <input type="hidden" name="period" value="#DateFormat(rc.date,'YYYY-MM-DD')#" />
		<table class="tableCloth v">
		  <thead>
				<tr>
			  	<th>Member</th>
			  	<cfloop query="rc.turnoverElements">
			    <th class="column" rel="#id#"><a href="##" class="void tooltip" title="#description#">#inputName#</a></th>
			    </cfloop>
			  </tr>
			</thead>
			<tfoot>
			 	<tr>
			  	<th>TOTAL</th>
			    <cfloop query="rc.turnoverElements">
			    <th><div id="rebate_total_#id#"></div></th>
			    </cfloop>
			  </tr>
			</tfoot>
		  <cfloop query="rc.participants">
		  <tr>
		  	<td  class="tl">#known_as#</td>
		    <cfloop query="rc.turnoverElements">
		    	<td nowrap="nowrap">
		    	<cfif rc.editable>
		      	<cftry>#getUnitType2(inputtypeID).name#<cfcatch type="any"></cfcatch></cftry><input class="i helptip" title="#inputName# for #rc.participants.known_as#" type="text" size="7" onchange="checkNumber(this)" name="rebate_#rc.participants.id#_#id#" value="#getFigure(id,rc.participants.id)#" />
		      <cfelse>
            <span class="i" name="rebate_#rc.participants.id#_#id#">#getFigure(id,rc.participants.id)#</span>
		      	<!--- get the amount --->
					</cfif>
		      </td>
		    </cfloop>
			</tr>
		  </cfloop>
		 	  <cfif rc.editable>
			  <tr>
			  	<td></td>
			    <td colspan="#rc.turnoverElements.recordCount#"><input class="Aristo button" type="button" onclick="confFigures();" value="confirm figures &raquo;" /><cfif IsUserInRole("admin")><input class="Aristo button" type="button" onclick="clearFigures()" value="wipe this months figures &raquo;" /></cfif></td>
			  </tr>
			  </cfif>

		</table>
		</form>
</cfif>
	</div>
  </cfif>
</div>

</cfoutput>
		<cfelse>
			<h2>Figures Cannot be entered</h2>
		  <p>This PSA does not have any rebate modules to enter turnover figures against.</p>
		</cfif>
<cffunction name="getFigure" returnType="Numeric">
  <cfargument name="figureID">
	<cfargument name="companyID">
	<cfif isDefined('rc.figures')>
	<cfquery name="f" dbtype="query">
	 select amount from rc.figures where memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
	 and
	 figuresID = <cfqueryparam cfsqltype="cf_sql_integer" value="#figureID#">
	</cfquery>
	<cfif isNumeric(f.amount)>
	 <cfreturn f.amount>
	<cfelse>
	 <cfreturn 0>
	</cfif>
	<cfelse>
	<cfreturn 0>
	</cfif>


</cffunction>

