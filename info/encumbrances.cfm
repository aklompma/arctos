<cfinclude template="/includes/_header.cfm">
<cfquery name="d" datasource="uam_god">
	select
		encumbrance.encumbrance_id,
		getPreferredAgentName(ENCUMBERING_AGENT_ID) encumberer,
		EXPIRATION_DATE,
		EXPIRATION_EVENT,
		ENCUMBRANCE,
		MADE_DATE,
		REMARKS,
		ENCUMBRANCE_ACTION,
		collection,
		count(coll_object_encumbrance.COLLECTION_OBJECT_ID) numberSpecimens
	from
		encumbrance,
		coll_object_encumbrance,
		cataloged_item,
		collection
	where
		encumbrance.encumbrance_id=coll_object_encumbrance.encumbrance_id and
		coll_object_encumbrance.COLLECTION_OBJECT_ID=cataloged_item.COLLECTION_OBJECT_ID and
		cataloged_item.collection_id=collection.collection_id 
	group by
		encumbrance.encumbrance_id,
		getPreferredAgentName(ENCUMBERING_AGENT_ID),
		EXPIRATION_DATE,
		EXPIRATION_EVENT,
		ENCUMBRANCE,
		MADE_DATE,
		REMARKS,
		ENCUMBRANCE_ACTION,
		collection
</cfquery>

<cfquery name="encs" dbtype="query">
	select 
		encumbrance_id,
		encumberer,
		ENCUMBRANCE_ACTION,
		EXPIRATION_DATE,
		EXPIRATION_EVENT,
		ENCUMBRANCE,
		MADE_DATE,
		REMARKS		
	from
		d
	group by
		encumbrance_id,
		encumberer,
		ENCUMBRANCE_ACTION,
		EXPIRATION_DATE,
		EXPIRATION_EVENT,
		ENCUMBRANCE,
		MADE_DATE,
		REMARKS	
</cfquery>
<cfoutput>
	<table border>
		<tr>
			<th>Encumbering Agent</th>
			<th>Encumbrance Action</th>
			<th>Description</th>
			<th>Expiration Date</th>
			<th>Expiration Event</th>
			<th>Made Date</th>
			<th>Remarks</th>
			<th>Specimens</th>
		</tr>
		<cfloop query="encs">
			<tr>
				<td>#encumberer#</td>
				<td>#ENCUMBRANCE_ACTION#</td>
				<td>#ENCUMBRANCE#</td>
				<td>#EXPIRATION_DATE#</td>
				<td>#EXPIRATION_EVENT#</td>
				<td>#MADE_DATE#</td>
				<td>#REMARKS#</td>
				<cfquery name="cols" dbtype="query">
					select collection,numberSpecimens from d where encumbrance_id=#encumbrance_id#
				</cfquery>
				<td>
					<cfloop query="cols">
						<div>
							#collection#: #numberSpecimens#
						</div>
					</cfloop>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
<cfdump var=#d#>

<cfinclude template="/includes/_footer.cfm">