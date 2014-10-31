<!----


drop table cf_temp_agent_sort;

create table cf_temp_agent_sort (
	key number not null,
	agent_type varchar2(255),
	preferred_name varchar2(255),
	other_name_1  varchar2(255),
	other_name_type_1   varchar2(255),
	other_name_2  varchar2(255),
	other_name_type_2   varchar2(255),
	other_name_3  varchar2(255),
	other_name_type_3   varchar2(255),
	other_name_4  varchar2(255),
	other_name_type_4   varchar2(255),
	other_name_5  varchar2(255),
	other_name_type_5   varchar2(255),
	other_name_6  varchar2(255),
	other_name_type_6   varchar2(255),
	agent_remark varchar2(4000),
	agent_status_1 varchar2(255),
	agent_status_date_1 varchar2(255),
	agent_status_2 varchar2(255),
	agent_status_date_2 varchar2(255),
	 status varchar2(4000)
	);
	
	
	
	
	
	
create public synonym cf_temp_agent_sort for cf_temp_agent_sort;
grant all on cf_temp_agent_sort to coldfusion_user;

 CREATE OR REPLACE TRIGGER cf_temp_agent_sort_key                                         
 before insert  ON cf_temp_agent_sort
 for each row 
    begin     
    	select somerandomsequence.nextval into :new.key from dual;                                
    end;                                                                                            
/
sho err



	------>
	
<cfinclude template="/includes/_header.cfm">
<cfset title="Agent Preview Sorter Linker Thingee">
<cfif action is "deleteChecked">
	<cfquery name="killOld" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		delete from cf_temp_agent_sort where key in (#key#)
	</cfquery>
</cfif>
<!------------------------------------------------------->
<cfif action is "getCSV">
	<cfquery name="mine" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_temp_agent_sort
	</cfquery>
	<cfset  util = CreateObject("component","component.utilities")>
	<cfset csv = util.QueryToCSV2(Query=mine,Fields=mine.columnlist)>
	<cffile action = "write"
	    file = "#Application.webDirectory#/download/agentPreloads.csv"
    	output = "#csv#"
    	addNewLine = "no">
	<cflocation url="/download.cfm?file=agentPreloads.csv" addtoken="false">
</cfif>
<script src="/includes/sorttable.js"></script>

	<script type='text/javascript' language="javascript" src='/includes/jtable/jquery.jtable.min.js'></script>
	<link rel="stylesheet" title="lightcolor-blue"  href="/includes/jtable/themes/lightcolor/blue/jtable.min.css" type="text/css">
	
<script>
	 $(document).ready(function () {
        $('#jtdocdoc').jtable({
            title: 'Agents',       
			paging: true, //Enable paging
            pageSize: 100, //Set page size (default: 10)
            sorting: true, //Enable sorting
            defaultSorting: 'PREFERRED_NAME', //Set default sorting
			columnResizable: true,
			multiSorting: true,
			columnSelectable: false,
    		noDataAvailable: 'No data available!',
			actions: {
                listAction: '/component/agent.cfc?method=listAgentPreload',
				updateAction: '/component/agent.cfc?method=updateAgentPreload',
 				//createAction: '/component/agent.cfc?method=createDocDoc',
 				deleteAction: '/component/agent.cfc?method=deleteAgentPreload',
            },

            fields:  {
				 KEY: {
                    key: true,
                    create: false,
                    edit: false,
                    list: false
                },
				PREFERRED_NAME: {title: 'PREFERRED_NAME'},
				AGENT_TYPE: {title: 'AGENT_TYPE'},
				STATUS: {title: 'STATUS'},
				OTHER_NAME_1: {title: 'N1'},
				OTHER_NAME_2: {title: 'N2'},
				OTHER_NAME_3: {title: 'N3'},
				OTHER_NAME_4: {title: 'N4'},
				OTHER_NAME_5: {title: 'N5'},
				OTHER_NAME_6: {title: 'N6'},
/*,
				
				OTHER_NAME_TYPE_1: {title: 'NT1'},
				OTHER_NAME_2: {title: 'Nm2'},
				OTHER_NAME_TYPE_2: {title: 'NT2'},
				OTHER_NAME_3: {title: 'Nm3'},
				OTHER_NAME_TYPE_3: {title: 'NT3'},
				OTHER_NAME_4: {title: 'Nm4'},
				OTHER_NAME_TYPE_4: {title: 'NT4'},
				OTHER_NAME_5: {title: 'Nm5'},
				OTHER_NAME_TYPE_5: {title: 'NT5'},
				OTHER_NAME_6: {title: 'Nm6'},
				OTHER_NAME_TYPE_6: {title: 'NT6'},
				AGENT_STATUS_1: {title: 'S1'},
				AGENT_STATUS_DATE_1: {title: 'SD1'},
				AGENT_STATUS_2: {title: 'S2'},
				AGENT_STATUS_DATE_2: {title: 'SD2'},
				AGENT_REMARK: {title: 'Remk'}
* */
            }
        });

       $('#jtdocdoc').jtable('load');
    });
</script>




<cfoutput>
	<cfform name="atts" method="post" enctype="multipart/form-data">
		<input type="hidden" name="Action" value="getFile">
		<label for="FiletoUpload">Upload file from agent loader feedback; will overwrite existing</label>
		<input type="file" name="FiletoUpload" size="45" onchange="checkCSV(this);">
		<input type="submit" value="Upload this file" class="savBtn">
	</cfform>
	<cfif isdefined("FiletoUpload")>
	<!--- put this in a temp table --->
		<cfquery name="killOld" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			delete from cf_temp_agent_sort
		</cfquery>
		<cfquery name="cols" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select * from cf_temp_agent_sort
		</cfquery>
		<cffile action="READ" file="#FiletoUpload#" variable="fileContent">	
		<cfset  util = CreateObject("component","component.utilities")>
		<cfset q = util.CSVToQuery(CSV=fileContent)>

		<cfset colNames=q.columnList>
		<cfloop list="#colNames#" index="c">
			<cfif not listfindnocase(cols.columnlist,c)>
				<cfset colNames=listdeleteat(colNames,listfindnocase(colNames,c))>
			</cfif>
		</cfloop>
		<cfif listfindnocase(colNames,'key')>
			<cfset colNames=listdeleteat(colNames,listfindnocase(colNames,'key'))>
		</cfif>
		<cfquery name="qclean" dbtype="query">
			select #colnames# from q
		</cfquery>
		<!--- for some crazy reason this is slow, so bypass for now ---->
		<!----
		<cfset sql="insert all ">
		<cfloop query="qclean">		
			<cfset sql=sql & " into cf_temp_agent_sort (#colnames#) values (">
			<cfloop list="#colnames#" index="i">
				<cfset sql=sql & "'#escapeQuotes(evaluate("qClean." & i))#',">
			</cfloop>
			<cfset sql=sql & ")">
			<cfset sql=replace(sql,"',)","')","all")>
		</cfloop>
		<cfset sql=sql & "SELECT 1 FROM DUAL">
		<cfquery name="ins" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			#preserveSingleQuotes(sql)#
		</cfquery>
		---->
		<cfloop query="qclean">		
			<cfset sql="insert into cf_temp_agent_sort (#colnames#) values (">
			<cfloop list="#colnames#" index="i">
				<cfset sql=sql & "'#escapeQuotes(evaluate("qClean." & i))#',">
			</cfloop>
			<cfset sql=sql & ")">
			<cfset sql=replace(sql,"',)","')","all")>
			<cfquery name="ins" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				#preserveSingleQuotes(sql)#
			</cfquery>
		</cfloop>
		
		<cflocation url="agentPreload.cfm" addtoken="false">
	</cfif>
	
	<p>
	key:
	<br>N##=OTHER_NAME_## - use these for sorting
	</p>
	
	<a href="agentPreload.cfm?action=getCSV">CSV</a>
	


		
		<div id="jtdocdoc"></div>


<!--------
	
	<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_temp_agent_sort order by preferred_name
	</cfquery>
	<cfif d.recordcount is 0>
		Load a file to begin.
		<cfabort>
	</cfif>
	<cfquery name="ckother_name_1" dbtype="query">
		select count(*) as c from d where other_name_1 is not null
	</cfquery>
	<cfquery name="ckother_name_2" dbtype="query">
		select count(*) as c from d where other_name_2 is not null
	</cfquery>
	<cfquery name="ckother_name_3" dbtype="query">
		select count(*) as c from d where other_name_3 is not null
	</cfquery>
	<cfquery name="ckother_name_4" dbtype="query">
		select count(*) as c from d where other_name_4 is not null
	</cfquery>
	<cfquery name="ckother_name_5" dbtype="query">
		select count(*) as c from d where other_name_5 is not null
	</cfquery>
	<cfquery name="ckother_name_6" dbtype="query">
		select count(*) as c from d where other_name_6 is not null
	</cfquery>
	<cfquery name="ckagent_status_1" dbtype="query">
		select count(*) as c from d where agent_status_1 is not null
	</cfquery>
	<cfquery name="ckagent_status_2" dbtype="query">
		select count(*) as c from d where agent_status_2 is not null
	</cfquery>
	
	
	<p>
		Click headers to sort. Check and delete matches and mistakes. Download, change, re-load to alter. Delete will NOT work with over 1000 records at a time.
	</p>
	<form method="post" action="agentPreload.cfm">
		<input type="hidden" name="action" value="deleteChecked">
		<input type="submit" value="delete checked rows">
		<table border id="t" class="sortable">
			<tr>
				<th>delete</th>
				<th>preferred_name</th>
				<th>status</th>
				<th>agent_type</th>
				<cfif ckother_name_1.c gt 0>
					<th>n1</th>
					<th>t1</th>
				</cfif>
				<cfif ckother_name_2.c gt 0>
					<th>n2</th>
					<th>t2</th>
				</cfif>
				<cfif ckother_name_3.c gt 0>
					<th>n3</th>
					<th>t3</th>
				</cfif>
				<cfif ckother_name_4.c gt 0>
					<th>n4</th>
					<th>t4</th>
				</cfif>
				<cfif ckother_name_5.c gt 0>
					<th>n5</th>
					<th>t5</th>
				</cfif>
				<cfif ckother_name_6.c gt 0>
					<th>n6</th>
					<th>t6</th>
				</cfif>
				<cfif ckagent_status_1.c gt 0>
					<th>s1</th>
					<th>2d1</th>
				</cfif>
				<cfif ckagent_status_2.c gt 0>
					<th>s2</th>
					<th>2d2</th>
				</cfif>
			</tr>
			<cfloop query="d">
				<tr id="r#key#">
					<td>
						<input type="checkbox" name="key" value="#key#">
					</td>
					<td>#preferred_name#</td>
					<td>
						<cfset s=replace(status,';','<br>','all')>
						#s#
					</td>
					<td>#agent_type#</td>
					<cfif ckother_name_1.c gt 0>
						<td>#other_name_1#</td>
						<td>#other_name_type_1#</td>
					</cfif>
					<cfif ckother_name_2.c gt 0>
						<td>#other_name_2#</td>
						<td>#other_name_type_2#</td>
					</cfif>
					<cfif ckother_name_3.c gt 0>
						<td>#other_name_3#</td>
						<td>#other_name_type_3#</td>
					</cfif>
					<cfif ckother_name_4.c gt 0>
						<td>#other_name_4#</td>
						<td>#other_name_type_4#</td>
					</cfif>
					<cfif ckother_name_5.c gt 0>
						<td>#other_name_5#</td>
						<td>#other_name_type_5#</td>
					</cfif>
					<cfif ckother_name_6.c gt 0>
						<td>#other_name_6#</td>
						<td>#other_name_type_6#</td>
					</cfif>
					<cfif ckagent_status_1.c gt 0>
						<td>#agent_status_1#</td>
						<td>#agent_status_date_1#</td>
					</cfif>
					<cfif ckagent_status_1.c gt 0>
						<td>#agent_status_2#</td>
						<td>#agent_status_date_2#</td>
					</cfif>
				</tr>
			</cfloop>
		</table>
		<input type="submit" value="delete checked rows">
	</form>	
	
	
	
	
	--------->
</cfoutput>
<cfinclude template="/includes/_footer.cfm">