<cfinclude template="../includes/_pickHeader.cfm">

<cfoutput>
	<form name="p" method="post" action="findProject.cfm">
		<input type="hidden" name="formName" value="#formName#">
		<input type="hidden" name="projIdFld" value="#projIdFld#">
		<input type="hidden" name="projNameFld" value="#projNameFld#">
		<label for="project_name">Project Name</label>
		<input type="text" name="project_name" id="project_name">
		<input type="submit" value="search" class="lnkBtn">
	</form>
	<!--- make sure we're searching for something --->
	<cfif len(#project_name#) is 0 or project_name is "undefined">
		<cfabort>
	</cfif>
	<cfquery name="getProj" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		SELECT
      project.project_name,
      project.project_id
    from
      project,
      project_agent,
      agent,
      agent_name
    where
      project.project_id=project_agent.project_id (+) and
      project_agent.agent_id=agent.agent_id (+) and
      agent.agent_id=agent_name.agent_id (+) and (
        UPPER(project_name) LIKE '%#ucase(project_name)#%' or
        UPPER(agent.preferred_agent_name) LIKE '%#ucase(project_name)#%'or
        UPPER(agent_name.agent_name) LIKE '%#ucase(project_name)#%'
	)
	</cfquery>
	<cfif getProj.recordcount is 0>
			Nothing matched #project_name#.
	<cfelse>
		<cfloop query="getProj">
			<br>
			<a href="##" onClick="javascript: opener.document.#formName#.#projIdFld#.value='#project_id#';
				opener.document.#formName#.#projNameFld#.value='#jsescape(getProj.project_name)#';opener.document.#formName#.#projNameFld#.className='goodPick';self.close();">#project_name# (#project_id#)</a>
		</cfloop>
	</cfif>
</cfoutput>
<cfinclude template="../includes/_pickFooter.cfm">