<cfoutput query="rc.answerList" group="groupName">
  <h3 class="page-header">#groupName#</h3>
  <cfoutput group="label">
    <div>
      <h4 class="page-header">#label#</h4>
      <cfoutput>
        <div class="currentUser">
          <h5>#first_name# #surname# (#known_as#)</h5>
          <p>#value#</p>
        </div>
      </cfoutput>
    </div>
  </cfoutput>
</cfoutput>

