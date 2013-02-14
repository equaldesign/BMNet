<cfoutput query="rc.resultList" group="name">
  
  <cfoutput group="label">
    
	<h4>#label#</h4>
    <table border="0" cellpadding="0" cellspacing="0">
   <tr> 
   <td valign="top" width="50%">
    <cfchart format="jpg" seriesplacement="default" labelformat="number" 
        show3d="true" tipstyle="mouseOver" pieslicestyle="solid" >
        <cfchartseries type="pie">
        <cfoutput>
		      <cfchartdata item="#optionLabel#" value="#optionCount#">
        </cfoutput>
        </cfchartseries>
    </cfchart>
    </td>
	<td valign="top">
	   <h4>Answers</h4>
	   <table border="0" cellspacing="0" cellpadding="0" class="table table-condensed table-striped table-rounded">
	     <thead>
		   <tr>
		      <th>Name</th>
		      <th>Company</th>
		      <th>Answer</th>
		   </tr>
		 </thead>
		 <tbody>
		<cfset answerList = getModel("poll").getQuestionResponses(id)>
		   <cfloop query="answerList">
			 <tr>
			   <td>#first_name# #surname#</td>
			   <td>#known_as#</td>
			   <td>#optionLabel#</td>
			 </tr>
		   </cfloop>
		 </tbody>
	   </table>
	</td>
	</tr>
  </table>
  </cfoutput>

</cfoutput>