

<!---- relies on table


drop table cf_temp_event_attrs;

CREATE TABLE cf_temp_event_attrs (
	KEY  NUMBER NOT NULL,
	STATUS VARCHAR2(4000),
	username VARCHAR2(255),
	collection_object_id NUMBER,
	collecting_event_id number,
	determined_by_agent_id number,
	guid VARCHAR2(60),
	event_name VARCHAR2(60),
 	event_attribute_type VARCHAR2(60),
 	event_attribute_value VARCHAR2(4000),
	event_attribute_units VARCHAR2(60),
	event_attribute_remark VARCHAR2(4000),
	event_determination_method VARCHAR2(4000),
	event_determined_date VARCHAR2(60),
	event_determiner VARCHAR2(60)
);




CREATE OR REPLACE TRIGGER trg_cf_temp_event_attrs before insert ON cf_temp_event_attrs for each row
    begin
    	:new.username:=sys_context('USERENV', 'SESSION_USER');
	    if :NEW.key is null then
    		select somerandomsequence.nextval into :new.key from dual;
    	end if;
    end;
/

create or replace public synonym cf_temp_event_attrs for cf_temp_event_attrs;
grant all on cf_temp_event_attrs to manage_collection;

---->
<cfinclude template="/includes/_header.cfm">


<cfset title="Bulkload Event Attributes">



<!------------------------------------------------------->
<cfif action is "template">
	<cfoutput>
		<cfset d="guid,event_name,event_attribute_type,event_attribute_value,event_attribute_units,event_attribute_remark,event_determination_method,event_determined_date,event_determiner">
		<cffile action = "write"
		    file = "#Application.webDirectory#/download/BulkloadEventAttrs.csv"
		   	output = "#d#"
		   	addNewLine = "no">
		<cflocation url="/download.cfm?file=BulkloadEventAttrs.csv" addtoken="false">
		<a href="/download/BulkloadEventAttrs.csv">Click here if your file does not automatically download.</a>
	</cfoutput>
</cfif>

<!----------------------------------------->
<cfif action is "nothing">

	<cfoutput>
		<cfquery name="mine" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#'
		</cfquery>
		<p>
			<a href="BulkloadEventAttrs.cfm?action=managemystuff">Manage your existing #mine.recordcount# records</a>
		</p>
	</cfoutput>

	<p>
		¡CUIDADO!
	</p>
	<P>
		This form has two modes: add to existing named events, or fork events and add to them. It is exceptionally important
		that you understand this in detail before proceeding.
		<h4>Add to Named Event</h4>
		<p>
			If you provide event_name, Event Attributes here will be added to an existing event, and therefore inherited by anything using that event.
			The event will not be affected (other than by the addition of the attributes you load here), and the name
			will be preserved.
		</p>
		<h4>Fork Events</h4>
		<p>
			Fork-Edit mode is available only for specimens with exactly one specimen-event.
			If you provide a GUID, the following will happen:
			<ol>
				<li>
					A new collecting_event will be created from the specimen's existing collecting event. It will not have a name, even
					if the source did.
				</li>
				<li>The new collecting_event will reuse the old locality</li>
				<li>
					Any collecting event attributes will be copied from the source event to the new event.
				</li>
				<li>
					The specimen-event will be moved to the new event.
				</li>
				<li>
					The collecting event attribute data you load here will be added to the new event
				</li>
			</ol>
			This will result in a new collecting_event with exactly one specimen in it. The merger scripts may eventually recombine events; they
			currently run 30 days after events are created. Old events may be deleted, if your actions here result in all specimens being removed from them.
		</p>
	</P>
	<p>
		Please file an Issue if this is unclear in any way. This form is new as of 2019-06-27; proceed with great caution.
	</p>
	<p>
		/¡CUIDADO!
	</p>


	Step 1: Upload a comma-delimited text file including column headings. (<a href="BulkloadEventAttrs.cfm?action=template">download BulkloadEventAttrs.csv template</a>)
	<table border>
		<tr>
			<th>Column</th>
			<th>Required?</th>
			<th>Description</th>
			<th>Links</th>
		</tr>
		<tr>
			<td>guid</td>
			<td>conditionally</td>
			<td>
				You must provide specimen GUID _or_ event_name. You may not provide both, and you must be consistent throughout a single load.
				GUID will work ONLY for specimens with a single specimen-event. Locality and collecting event will be duplicated, and may
				eventually be reconciled by the merger scripts.
				<br>Note that existing event names will not survive this process for specimens in this file.
			</td>
			<td></td>
		</tr>
		<tr>
			<td>event_name</td>
			<td>conditionally</td>
			<td>You must provide specimen GUID _or_ event_name. You may not provide both, and you must be consistent throughout a single load.</td>
			<td><a href="/info/ctDocumentation.cfm?table=CTCOLL_OTHER_ID_TYPE">CTCOLL_OTHER_ID_TYPE</a></td>
		</tr>
		<tr>
			<td>event_attribute_type</td>
			<td>yes</td>
			<td>event_attribute_type</td>
			<td><a href="/info/ctDocumentation.cfm?table=CTCOLL_EVENT_ATTR_TYPE">CTCOLL_EVENT_ATTR_TYPE</a></td>
		</tr>
		<tr>
			<td>event_attribute_value</td>
			<td>yes</td>
			<td>Some are controlled - follow the links in the code-table-code-table</td>
			<td><a href="/info/ctDocumentation.cfm?table=CTCOLL_EVENT_ATT_ATT">CTCOLL_EVENT_ATT_ATT</a></td>
		</tr>
		<tr>
			<td>event_attribute_units</td>
			<td>conditionally</td>
			<td>Follow the links in the code-table-code-table</td>
			<td><a href="/info/ctDocumentation.cfm?table=CTCOLL_EVENT_ATT_ATT">CTCOLL_EVENT_ATT_ATT</a></td>
		</tr>
		<tr>
			<td>event_attribute_remark</td>
			<td>no</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td>event_determination_method</td>
			<td>no</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td>event_determined_date</td>
			<td>no</td>
			<td>ISO8601</td>
			<td></td>
		</tr>

		<tr>
			<td>event_determiner</td>
			<td>no</td>
			<td>unique agent name</td>
			<td></td>
		</tr>
	</table>

	<div class="importantNotification">
	   This form will happily create duplicates. Make sure you aren't creating duplicates.
	</div>

	<cfform name="atts" method="post" enctype="multipart/form-data" action="BulkloadEventAttrs.cfm">
		<input type="hidden" name="action" value="getFile">
		<input type="file" name="FiletoUpload" size="45" onchange="checkCSV(this);">
		<input type="submit" value="Upload this file" class="savBtn">
	</cfform>
</cfif>


<!------------------------------------------------------->
<cfif action is "getCSV">
	<cfquery name="mine" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#'
	</cfquery>
	<cfset  util = CreateObject("component","component.utilities")>
	<cfset csv = util.QueryToCSV2(Query=mine,Fields=mine.columnlist)>
	<cffile action = "write"
	    file = "#Application.webDirectory#/download/BulkloadEventAttrsData.csv"
    	output = "#csv#"
    	addNewLine = "no">
	<cflocation url="/download.cfm?file=BulkloadEventAttrsData.csv" addtoken="false">
</cfif>
<!------------------------------------------------------->
<cfif action is "getFile">
<cfoutput>

	<cffile action="READ" file="#FiletoUpload#" variable="fileContent">
	<cfset fileContent=replace(fileContent,"'","''","all")>
	<cfset arrResult = CSVToArray(CSV = fileContent.Trim()) />
	<cfset colNames="">
	<cfloop from="1" to ="#ArrayLen(arrResult)#" index="o">
		<cfset colVals="">
			<cfloop from="1"  to ="#ArrayLen(arrResult[o])#" index="i">
				<cfset thisBit=arrResult[o][i]>
				<cfif o is 1>
					<cfset colNames="#colNames#,#thisBit#">
				<cfelse>
					<cfset colVals="#colVals#,'#thisBit#'">
				</cfif>
			</cfloop>
		<cfif o is 1>
			<cfset colNames=replace(colNames,",","","first")>
		</cfif>
		<cfif len(colVals) gt 1>
			<cfset colVals=replace(colVals,",","","first")>
			<cfquery name="ins" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				insert into cf_temp_event_attrs (#colNames#) values (#preservesinglequotes(colVals)#)
			</cfquery>
		</cfif>
	</cfloop>
	<cflocation url="BulkloadEventAttrs.cfm?action=managemystuff" addtoken="false">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------------------>
<cfif action is "deleteMine">
	<cfquery name="data" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		delete from cf_temp_event_attrs  where upper(username)='#ucase(session.username)#'
	</cfquery>
	<cflocation url="BulkloadEventAttrs.cfm" addtoken="false">
</cfif>
<!---------------------------------------------------------------------------->
<cfif action is "managemystuff">
	<script src="/includes/sorttable.js"></script>
	<cfoutput>
		<cfquery name="mine" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#'
		</cfquery>



		<!----
		<cfset clist=mine.columnlist>
		<cfset clist=listdeleteat(clist,listfind(clist,'STATUS'))>
		<cfset clist=listdeleteat(clist,listfind(clist,'KEY'))>
		----->

		<p>
			You have #mine.recordcount# records in the staging table.
		</p>
		<p>
			<a href="BulkloadEventAttrs.cfm">Load more records to this app</a>
		</p>
		<p>
			<a href="BulkloadEventAttrs.cfm?action=validate">validate records</a>
		</p>

		<p>
			<a href="BulkloadEventAttrs.cfm?action=deleteMine">delete all of your data from the staging table</a>
		</p>
		<p>
			<a href="BulkloadEventAttrs.cfm?action=getCSV">Download your data as CSV</a>
		</p>
		<cfquery name="willload" dbtype="query">
			select count(*) c from mine where status = 'valid'
		</cfquery>
		<cfif willload.c eq mine.recordcount>
			<p>
				The data should load. Check them one more time, then <a href="BulkloadEventAttrs.cfm?action=loadToDb">proceed to load</a>
			</p>
		<cfelse>
			<p>
				Load isn't available until all records validate.
			</p>

		</cfif>

		<cfdump var=#mine#>

	</cfoutput>
</cfif>



<!------------------------------------------------------->
<cfif action is "validate">
<cfoutput>
	<cfquery name="bads" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			status = NULL
		where
			status != 'loaded' and
			upper(username)='#ucase(session.username)#'
	</cfquery>

	<cfquery name="ckc" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select count(*) c from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and
		(guid is not null and event_name is not null) or
		(guid is null and event_name is null)
	</cfquery>
	<cfif ckc.c gt 0>
		Exaactly one of guid or event_name is required<cfabort>
	</cfif>
	<cfquery name="ckg" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select count(*) c from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and
			guid is not null
	</cfquery>
	<cfquery name="cke" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select count(*) c from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and
			event_name is not null
	</cfquery>
	<cfif ckg.c gt 0 and cke.c gt 0>
		 You cannot mix guid and event_name<cfabort>
	</cfif>

	<cfquery name="upCID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			collection_object_id = (select collection_object_id from flat where flat.guid = cf_temp_event_attrs.guid)
		where
			upper(username)='#ucase(session.username)#' and
			guid is not null
	</cfquery>

	<cfquery name="upCIDF" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			status='specimen not found' where
			collection_object_id is null and
			guid is not null and
			upper(username)='#ucase(session.username)#'
	</cfquery>



	<cfquery name="upCLID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" >
		update
			cf_temp_event_attrs
		set
			status='event not found'
		where
			status is null and
			upper(username)='#ucase(session.username)#' and
			event_name is not null and
			event_name not in (select COLLECTING_EVENT_NAME from COLLECTING_EVENT  where COLLECTING_EVENT_NAME is not null)
	</cfquery>


	<cfquery name="cat" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			status='attribute not found'
		where
			status is null and
			upper(username)='#ucase(session.username)#' and
			event_attribute_type not in (select event_attribute_type from CTCOLL_EVENT_ATTR_TYPE)
	</cfquery>
	<cfquery name="dat" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select distinct (event_attribute_type) event_attribute_type from cf_temp_event_attrs where status is null and
			upper(username)='#ucase(session.username)#'
	</cfquery>
	<cfloop query="dat">
		<cfquery name="isctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select * from CTCOLL_EVENT_ATT_ATT where EVENT_ATTRIBUTE_TYPE='#EVENT_ATTRIBUTE_TYPE#'
		</cfquery>
		<cfif len(isctl.UNIT_CODE_TABLE) gt 0>
			<cfquery name="uc" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				select * from #isctl.UNIT_CODE_TABLE# where 1=2
			</cfquery>
			<cfset cl=uc.columnlist>
			<cfif listcontains(cl,'COLLECTION_CDE')>
				<CFSET CL=LISTDELETEAT(CL,LISTFIND(CL,'COLLECTION_CDE'))>
			</cfif>
			<cfif listcontains(cl,'DESCRIPTION')>
				<CFSET CL=LISTDELETEAT(CL,LISTFIND(CL,'DESCRIPTION'))>
			</cfif>
			<cfquery name="nctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				update
					cf_temp_event_attrs
				set
					status='units not found'
				where
					status is null and
					upper(username)='#ucase(session.username)#' and
					event_attribute_type='#EVENT_ATTRIBUTE_TYPE#' and
					event_attribute_units not in (select #CL# from  #isctl.UNIT_CODE_TABLE#)
			</cfquery>
			<cfquery name="nctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				update
					cf_temp_event_attrs
				set
					status='non numeric'
				where
					status is null and
					upper(username)='#ucase(session.username)#' and
					event_attribute_type='#EVENT_ATTRIBUTE_TYPE#' and
					is_number(event_attribute_value)=0
			</cfquery>
		<cfelseif  len(isctl.VALUE_CODE_TABLE) gt 0>
			<cfquery name="nctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				update
					cf_temp_event_attrs
				set
					status='units not allowed here'
				where
					status is null and
					upper(username)='#ucase(session.username)#' and
					event_attribute_type='#EVENT_ATTRIBUTE_TYPE#' and
					event_attribute_units is not null
			</cfquery>
			<cfquery name="uc" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				select * from #isctl.VALUE_CODE_TABLE# where 1=2
			</cfquery>
			<cfset cl=uc.columnlist>
			<cfif listcontains(cl,'COLLECTION_CDE')>
				<CFSET CL=LISTDELETEAT(CL,LISTFIND(CL,'COLLECTION_CDE'))>
			</cfif>
			<cfif listcontains(cl,'DESCRIPTION')>
				<CFSET CL=LISTDELETEAT(CL,LISTFIND(CL,'DESCRIPTION'))>
			</cfif>
			<cfquery name="nctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				update
					cf_temp_event_attrs
				set
					status='value not found'
				where
					status is null and
					upper(username)='#ucase(session.username)#' and
					event_attribute_type='#EVENT_ATTRIBUTE_TYPE#' and
					event_attribute_value not in (select #CL# from  #isctl.VALUE_CODE_TABLE#)
			</cfquery>
		<cfelse>
			<cfquery name="nctl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				update
					cf_temp_event_attrs
				set
					status='free-text attributes cannot have units'
				where
					status is null and
					upper(username)='#ucase(session.username)#' and
					event_attribute_type='#EVENT_ATTRIBUTE_TYPE#' and
					event_attribute_units is not null
			</cfquery>
		</cfif>
	</cfloop>
	<cfquery name="upCID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			determined_by_agent_id = (select agent_id from agent_name where agent_name.agent_name = cf_temp_event_attrs.event_determiner)
		where
			upper(username)='#ucase(session.username)#' and
			event_determiner is not null
	</cfquery>

	<cfquery name="upCIDF" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			status='determiner not found' where
			determined_by_agent_id is null and
			event_determiner is not null and
			upper(username)='#ucase(session.username)#'
	</cfquery>

	<cfquery name="upCIDF" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update
			cf_temp_event_attrs
		set
			status='not one event'
		where
			status is null and
			upper(username)='#ucase(session.username)#' and
			collection_object_id is not null and
			(select count(*) from specimen_event where specimen_event.collection_object_id=cf_temp_event_attrs.collection_object_id) != 1
	</cfquery>



	<cfquery name="bads" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			update
				cf_temp_event_attrs
			set
				status = 'valid'
			where
				upper(username)='#ucase(session.username)#' and
				status is null
		</cfquery>
				<cflocation url="BulkloadEventAttrs.cfm?action=manageMyStuff" addtoken="false">


		<!----

		---->
</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------->
<cfif action is "loadToDb">
<cfoutput>
	<p>
		Timeout errors? Just reload....
	</p>
	<cfflush>


	<cfquery name="getTempData_g" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and collection_object_id is not null
	</cfquery>
	<cfquery name="getTempData_c" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and event_name is not null
	</cfquery>
	<cfif getTempData_g.recordcount gt 1 and  getTempData_c.recordcount gt 1 >
		mix<cfabort>
	</cfif>
	<cfif getTempData_g.recordcount gt 1>
		<br>guid
		<cfquery name="d_s" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select distinct collection_object_id from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and collection_object_id is not null
		</cfquery>
		<cfloop query="d_s">
			<cftransaction>
				<!--- always make a new event ---->
				<cfquery name="cid" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select sq_collecting_event_id.nextval cid from dual
				</cfquery>
				<cfquery name="teid" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select collecting_event_id,specimen_event_id from specimen_event where collection_object_id=#collection_object_id#
				</cfquery>
				<cfif teid.recordcount is not 1>
					not one event<cfabort>
				</cfif>
				<cfquery name="eevt" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select * from collecting_event where collecting_event_id = #teid.collecting_event_id#
				</cfquery>
				<!---
					new event
					use old locality
					no name is possible here
				---->
				<cfquery name="nevt" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					insert into collecting_event (
						COLLECTING_EVENT_ID,
						LOCALITY_ID,
						VERBATIM_DATE,
						VERBATIM_LOCALITY,
						COLL_EVENT_REMARKS,
						BEGAN_DATE,
						ENDED_DATE,
						VERBATIM_COORDINATES,
						DATUM
			   	 	) values (
			   	 		#cid.cid#,
			   	 		#eevt.locality_id#,
			   	 		'#escapeQuotes(eevt.VERBATIM_DATE)#',
			   	 		'#escapeQuotes(eevt.VERBATIM_LOCALITY)#',
			   	 		'#escapeQuotes(eevt.COLL_EVENT_REMARKS)#',
			   	 		'#eevt.BEGAN_DATE#',
			   	 		'#eevt.ENDED_DATE#',
			   	 		'#eevt.VERBATIM_COORDINATES#',
			   	 		'#eevt.DATUM#'
			   	 	)
				</cfquery>
				<!--- bring over any existing event attributes ---->
				<cfquery name="eevtas" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select * from collecting_event_attributes where COLLECTING_EVENT_ID=#teid.collecting_event_id#
				</cfquery>
				<cfloop query="eevtas">
					<cfquery name="insCollAttr" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collecting_event_attributes (
							collecting_event_attribute_id,
							collecting_event_id,
							determined_by_agent_id,
							event_attribute_type,
							event_attribute_value,
							event_attribute_units,
							event_attribute_remark,
							event_determination_method,
							event_determined_date
						) values (
							sq_coll_event_attribute_id.nextval,
							#cid.cid#,
							<cfif len(eevtas.determined_by_agent_id) gt 0>#eevtas.determined_by_agent_id#<cfelse>NULL</cfif>,
							'#escapeQuotes(eevtas.event_attribute_type)#',
							'#escapeQuotes(eevtas.event_attribute_value)#',
							'#escapeQuotes(eevtas.event_attribute_units)#',
							'#escapeQuotes(eevtas.event_attribute_remark)#',
							'#escapeQuotes(eevtas.event_determination_method)#',
							'#escapeQuotes(eevtas.event_determined_date)#'
						)
					</cfquery>
				</cfloop>
				<!--- move the specimen_event to use the collecting_event we just made--->
				<cfquery name="upse" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update specimen_event set collecting_event_id=#cid.cid# where specimen_event_id=#teid.specimen_event_id#
				</cfquery>
				<!--- now get all attributes for this specimen.... ---->
				<cfquery name="tsarrts" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and collection_object_id = #collection_object_id#
				</cfquery>
				<!--- .... and add them to the event --->
				<cfloop query="tsarrts">
					<cfquery name="insCollAttr" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collecting_event_attributes (
							collecting_event_attribute_id,
							collecting_event_id,
							determined_by_agent_id,
							event_attribute_type,
							event_attribute_value,
							event_attribute_units,
							event_attribute_remark,
							event_determination_method,
							event_determined_date
						) values (
							sq_coll_event_attribute_id.nextval,
							#cid.cid#,
							<cfif len(tsarrts.determined_by_agent_id) gt 0>#tsarrts.determined_by_agent_id#<cfelse>NULL</cfif>,
							'#escapeQuotes(tsarrts.event_attribute_type)#',
							'#escapeQuotes(tsarrts.event_attribute_value)#',
							'#escapeQuotes(tsarrts.event_attribute_units)#',
							'#escapeQuotes(tsarrts.event_attribute_remark)#',
							'#escapeQuotes(tsarrts.event_determination_method)#',
							'#escapeQuotes(tsarrts.event_determined_date)#'
						)
					</cfquery>
				</cfloop>
				<cfquery name="tsarrts" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update cf_temp_event_attrs set status='loaded' where upper(username)='#ucase(session.username)#' and status='valid' and collection_object_id = #collection_object_id#
				</cfquery>
			</cftransaction>
			<br>collection_object_id::#collection_object_id#
		</cfloop>
	</cfif>

	<cfif getTempData_c.recordcount gt 1>
		<!--- just adding attributes to existing events ---->
		<cfquery name="devts" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			select distinct event_name from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and event_name is not null
		</cfquery>
		<cfloop query="devts">
			<br>loading for #devts.event_name#
			<cftransaction>
				<cfquery name="cid" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select collecting_event_id cid from collecting_event where collecting_event_name='#devts.event_name#'
				</cfquery>
				<cfquery name="tsarrts" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select * from cf_temp_event_attrs where upper(username)='#ucase(session.username)#' and status='valid' and event_name = '#devts.event_name#'
				</cfquery>
				<cfloop query="tsarrts">
					<cfquery name="insCollAttr" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collecting_event_attributes (
							collecting_event_attribute_id,
							collecting_event_id,
							determined_by_agent_id,
							event_attribute_type,
							event_attribute_value,
							event_attribute_units,
							event_attribute_remark,
							event_determination_method,
							event_determined_date
						) values (
							sq_coll_event_attribute_id.nextval,
							#cid.cid#,
							<cfif len(tsarrts.determined_by_agent_id) gt 0>#tsarrts.determined_by_agent_id#<cfelse>NULL</cfif>,
							'#escapeQuotes(tsarrts.event_attribute_type)#',
							'#escapeQuotes(tsarrts.event_attribute_value)#',
							'#escapeQuotes(tsarrts.event_attribute_units)#',
							'#escapeQuotes(tsarrts.event_attribute_remark)#',
							'#escapeQuotes(tsarrts.event_determination_method)#',
							'#escapeQuotes(tsarrts.event_determined_date)#'
						)
					</cfquery>
				</cfloop>
				<cfquery name="tsarrts" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update cf_temp_event_attrs set status='loaded' where upper(username)='#ucase(session.username)#' and status='valid' and  event_name = '#devts.event_name#'
				</cfquery>
			</cftransaction>
		</cfloop>

	</cfif>

<p>
	If you're seeing this and no errors, the load probably worked.

	<a href="BulkloadEventAttrs.cfm?action=manageMyStuff">Return to the splashpage</a> and confirm that all of your records have status=loaded.
	Carefully check the specimens to make sure everything worked. Then delete data from this app so
	you don't find a way to make duplicates!
</p>

	<cfabort>
	<!----
		OPTIONS;
			1) guid
				make new event-stack, load attributes to new event
			2) event
				load attributes to existing event




		Big load? Use this:




	---->
		<cfloop query="getTempData">
		<cftransaction>
			<cfif len(use_part_id) is 0 AND len(parent_container_id) gt 0><!--- 1 ---->
				<!--- new part, add container --->
				<cfquery name="NEXTID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select sq_collection_object_id.nextval NEXTID from dual
				</cfquery>
				<cfset thisPartID=NEXTID.NEXTID>
				<cfquery name="updateColl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					INSERT INTO coll_object (
						COLLECTION_OBJECT_ID,
						COLL_OBJECT_TYPE,
						ENTERED_PERSON_ID,
						COLL_OBJECT_ENTERED_DATE,
						LAST_EDITED_PERSON_ID,
						COLL_OBJ_DISPOSITION,
						LOT_COUNT,
						CONDITION,
						FLAGS )
					VALUES (
						#thisPartID#,
						'SP',
						#session.myagentid#,
						sysdate,
						#session.myagentid#,
						'#DISPOSITION#',
						#lot_count#,
						'#condition#',
						0 )
				</cfquery>
				<cfquery name="newTiss" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					INSERT INTO specimen_part (
						COLLECTION_OBJECT_ID,
						PART_NAME,
						DERIVED_FROM_cat_item
					) VALUES (
						#thisPartID#,
						'#PART_NAME#',
						#collection_object_id#
					)
				</cfquery>
				<cfif len(remarks) gt 0>
					<!---- new remark --->
					<cfquery name="newCollRem" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						INSERT INTO coll_object_remark (collection_object_id, coll_object_remarks)
						VALUES (#thisPartID#, '#remarks#')
					</cfquery>
				</cfif>
				<!--- only got here if we have a container ---->
				<cfstoredproc procedure="movePartToContainer" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					<cfprocparam cfsqltype="CF_SQL_FLOAT" value="#thisPartId#"><!---- v_collection_object_id ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value=""><!---- v_barcode ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value="#parent_container_id#"><!---- v_container_id ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value="#change_container_type#"><!---- v_parent_container_type ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value="#change_container_label#"><!---- v_parent_container_label ---->
				</cfstoredproc>


			<!----
				<cfquery name="part_container_id" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select
						container_id
					from
						coll_obj_cont_hist
					where
						collection_object_id = #thisPartID#
				</cfquery>
				<cfquery name="upPart" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update container set parent_container_id=#parent_container_id#
					where container_id = #part_container_id.container_id#
				</cfquery>
				<cfif len(change_container_type) gt 0>
					<cfquery name="upPart" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						update container set
						container_type='#change_container_type#'
						where container_id=#parent_container_id#
					</cfquery>
				</cfif>
				---->
			<cfelseif len(parent_container_id) gt 0 and len(use_part_id) gt 0> <!---- 2 ----->
			<!--- there is an existing matching container that is not in a parent_container;
				all we need to do is move the container to a parent IF it exists and is specified, or nothing otherwise --->
				<cfset thisPartID=use_part_id>
				<cfstoredproc procedure="movePartToContainer" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					<cfprocparam cfsqltype="CF_SQL_FLOAT" value="#thisPartId#"><!---- v_collection_object_id ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value=""><!---- v_barcode ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value="#parent_container_id#"><!---- v_container_id ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value=""><!---- v_parent_container_type ---->
					<cfprocparam cfsqltype="cf_sql_varchar" value="#change_container_label#"><!---- v_parent_container_label ---->
				</cfstoredproc>
				<!----
				<cfquery name="upPart" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update
						container
					set
						parent_container_id=#parent_container_id#
					where
						container_id = (select container_id from coll_obj_cont_hist where collection_object_id = #thisPartID#)
				</cfquery>
				---->
			<cfelseif len(parent_container_id) is 0 and len(use_part_id) is 0><!--- 3 ---->
				<!--- new part, no container --->
				<cfquery name="NEXTID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select sq_collection_object_id.nextval NEXTID from dual
				</cfquery>
				<cfset thisPartID=NEXTID.NEXTID>
				<cfquery name="updateColl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					INSERT INTO coll_object (
						COLLECTION_OBJECT_ID,
						COLL_OBJECT_TYPE,
						ENTERED_PERSON_ID,
						COLL_OBJECT_ENTERED_DATE,
						LAST_EDITED_PERSON_ID,
						COLL_OBJ_DISPOSITION,
						LOT_COUNT,
						CONDITION,
						FLAGS )
					VALUES (
						#thisPartID#,
						'SP',
						#session.myagentid#,
						sysdate,
						#session.myagentid#,
						'#DISPOSITION#',
						#lot_count#,
						'#condition#',
						0 )
				</cfquery>
				<cfquery name="newTiss" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					INSERT INTO specimen_part (
						COLLECTION_OBJECT_ID,
						PART_NAME,
						DERIVED_FROM_cat_item
					) VALUES (
						#thisPartID#,
						'#PART_NAME#',
						#collection_object_id#
					)
				</cfquery>
				<cfif len(remarks) gt 0>
					<!---- new remark --->
					<cfquery name="newCollRem" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						INSERT INTO coll_object_remark (collection_object_id, coll_object_remarks)
						VALUES (#thisPartID#, '#remarks#')
					</cfquery>
				</cfif>
			<cfelse>
				oops - no handler for that combination!
				<cfabort>
			</cfif>
			<cfloop from="1" to="#numPartAttrs#" index="i">
				<cfset thisAttr=evaluate("PART_ATTRIBUTE_TYPE_" & i)>
				<cfif len(thisAttr) gt 0>
					<cfset thisAttrVal=evaluate("PART_ATTRIBUTE_VALUE_" & i)>
					<cfset thisAttrUnit=evaluate("PART_ATTRIBUTE_UNITS_" & i)>
					<cfset thisAttrDate=evaluate("PART_ATTRIBUTE_DATE_" & i)>
					<cfset thisAttrDetr=evaluate("PART_ATTRIBUTE_DETERMINER_" & i)>
					<cfset thisAttrRem=evaluate("PART_ATTRIBUTE_REMARK_" & i)>
					<cfquery name="nattr" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					 	insert into specimen_part_attribute (
					 		PART_ATTRIBUTE_ID,
					 		COLLECTION_OBJECT_ID,
					 		ATTRIBUTE_TYPE ,
					 		ATTRIBUTE_VALUE,
					 		ATTRIBUTE_UNITS,
					 		DETERMINED_DATE,
					 		DETERMINED_BY_AGENT_ID,
					 		ATTRIBUTE_REMARK
					 	) values (
					 		sq_PART_ATTRIBUTE_ID.nextval,
					 		#thisPartID#,
					 		'#thisAttr#',
					 		'#thisAttrVal#',
					 		'#thisAttrUnit#',
					 		<cfif len(thisAttrDate) gt 0>
					 			'#dateformat(thisAttrDate,'YYYY-MM-DD')#',
					 		<cfelse>
					 			NULL,
					 		</cfif>
					 		<cfif len(thisAttrDetr) gt 0>
					 			getAgentID('#thisAttrDetr#'),
					 		<cfelse>
					 			NULL,
					 		</cfif>
					 		'#escapeQuotes(thisAttrRem)#'
					 	)
					</cfquery>
				</cfif>

				<cfquery name="cleanup" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update cf_temp_parts set status='loaded' where key=#key#
				</cfquery>


			</cfloop>

			</cftransaction>
		</cfloop>
		<!--- clean up ---->


	Spiffy, all done.
	<a href="/SpecimenResults.cfm?collection_object_id=#valuelist(getTempData.collection_object_id)#">
		See in Specimen Results
	</a>

	<p>

	<a href="BulkloadParts.cfm?action=deletemyloaded">
		clean up the stuff that just loaded
	</a>


	</p>
</cfoutput>
</cfif>
<cfif action is "deletemyloaded">
	<cfquery name="cleanup" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		delete from cf_temp_parts where  status='loaded' and upper(username)='#ucase(session.username)#'
	</cfquery>
</cfif>
<cfinclude template="/includes/_footer.cfm">