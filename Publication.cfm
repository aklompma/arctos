<cfinclude template="includes/_header.cfm">
<cfset title = "Edit Publication">
<script>
	function pickThis (fld,idfld,display,aid) {
			console.log('fld: ' + fld);
			console.log('idfld: ' + idfld);
			document.getElementById(fld).value=display;
			document.getElementById(idfld).value=aid;
			removePick();
			console.log('spiffy');
		}
		
		
		function removePick() {
		if(document.getElementById('pickDiv')){
			jQuery('#pickDiv').remove();
		}
		removeBgDiv();
	}
	function addBGDiv(f){
		console.log('addBGDiv - f=' + f);
		var bgDiv = document.createElement('div');
		bgDiv.id = 'bgDiv';
		bgDiv.className = 'bgDiv';
		
		if(f==null || f.length==0){
			f="removeBgDiv()";
		}
		bgDiv.setAttribute('onclick',f);
		document.body.appendChild(bgDiv);
		viewport.init("#bgDiv");
	}
	function removeBgDiv () {
		if(document.getElementById('bgDiv')){
			jQuery('#bgDiv').remove();
		}
	}
	
	function get_AgentName(name,fld,idfld){
		addBGDiv('removePick()');
		console.log(name + ':' +  fld + ':' +  idfld);
		var theDiv = document.createElement('div');
		theDiv.id = 'pickDiv';
		theDiv.className = 'pickDiv';
		theDiv.innerHTML='<br>Loading...';
		document.body.appendChild(theDiv);
		var ptl="/picks/getAgentName.cfm";
			
			
		jQuery(pickDiv).load(ptl,{agentname: name, fld: fld, idfld: idfld},function(){
			viewport.init("#pickDiv");
			console.log('callback: viewport');
		});
		console.log('it loaded');
	}
</script>
<cfif action is "newPub">
	<cfquery name="ctpublication_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		select publication_type from ctpublication_type order by publication_type
	</cfquery>

	<cfoutput>
		<form name="newpub" method="post" action="Publication.cfm">
			The Basics:
			<input type="hidden" name="action" value="createPub">
			<label for="publication_title">Publication Title</label>
			<input type="text" name="publication_title" id="publication_title" class="reqdClr" size="80">
			<label for="publication_type">Publication Type</label>
			<select name="publication_type" id="publication_type" class="reqdClr">
				<cfloop query="ctpublication_type">
					<option value="#publication_type#">#publication_type#</option>
				</cfloop>
			</select>
			<label for="is_peer_reviewed_fg">Peer Reviewed?</label>
			<select name="is_peer_reviewed_fg" id="is_peer_reviewed_fg" class="reqdClr">
				<option value="1">yes</option>
				<option value="0">no</option>
			</select>			
			<label for="published_year">Published Year</label>
			<input type="text" name="published_year" id="published_year">
			<label for="publication_loc">Storage Location</label>
			<input type="text" name="publication_loc" id="publication_loc" size="80">
			<label for="publication_remarks">Remark</label>
			<input type="text" name="publication_remarks" id="publication_remarks" size="80">
			Authors:
			<table border>
				<tr>
					<th>Role</th>
					<th>Name</th>
				</tr>
				<tr id="authortr1">
					<td>
						<select name="author_role_1" id="author_role_1">
							<option value="author">author</option>
							<option value="editor">editor</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="author_id_1" id="author_id_1">
						<input type="text" name="author_name_1" id="author_name_1" class="reqdClr" 
							onchange="get_AgentName(this.value,this.id,'author_id_1');"
		 					onKeyPress="return noenter(event);">
		 				
					</td>
				</tr>
			</table>
			<!---
			<div id="authors" style="border:1px dashed red;">
				<cfset i=1>
				<cfif authors.recordcount is 0>
				<!--- seed --->
                <div id="seedMedia" style="display:none">
                    <input type="hidden" id="media_relations_id__0" name="media_relations_id__0">
					<cfset d="">
                    <select name="relationship__0" id="relationship__0" size="1"  onchange="pickedRelationship(this.id)">
						<option value="delete">delete</option>
						<cfloop query="ctmedia_relationship">
							<option <cfif #d# is #media_relationship#> selected="selected" </cfif>value="#media_relationship#">#media_relationship#</option>
						</cfloop>
					</select>:&nbsp;<input type="text" name="related_value__0" id="related_value__0" size="80">
					<input type="hidden" name="related_id__0" id="related_id__0">
                </div>
                </cfif>
                <cfloop query="relns">
					<cfset d=media_relationship>
					<input type="hidden" id="media_relations_id__#i#" name="media_relations_id__#i#" value="#media_relations_id#">
					<select name="relationship__#i#" id="relationship__#i#" size="1"  onchange="pickedRelationship(this.id)">
						<option value="delete">delete</option>
						<cfloop query="ctmedia_relationship">
							<option <cfif #d# is #media_relationship#> selected="selected" </cfif>value="#media_relationship#">#media_relationship#</option>
						</cfloop>
					</select>:&nbsp;<input type="text" name="related_value__#i#" id="related_value__#i#" size="80" value="#summary#">
					<input type="hidden" name="related_id__#i#" id="related_id__#i#" value="#related_primary_key#">
					<cfset i=i+1>
					<br>
				</cfloop>
				
				<br><span class="infoLink" id="addRelationship" onclick="addRelation(#i#)">Add Relationship</span>
			</div>
			--->
		</form>
	</cfoutput>
</cfif>















<!----------------------------------------------------------------------------->
<cfif #Action# is "editBookSection">
	<!--- get the book data and relocate to editBook --->
	
	<cfquery name="getBook" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		select book_id from book_section where publication_id=#publication_id#
	</cfquery>
	<cfoutput>
		<cflocation url="editBook.cfm?publication_id=#getBook.book_id#">
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------------->


<cfif #action# is "nothing">
	<cfoutput>
		<cfif isdefined("publication_id") and len(publication_id) gt 0>
			<!--- passing this form only a publication_id redirects to editing --->
			<cfquery name="getPub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
				select PUBLICATION_TYPE from publication where publication_id=#publication_id#
			</cfquery>
			<cfif getPub.recordcount is not 1>
				<cfthrow detail="publication ID #publication_id# not found at Publication.cfm" errorcode="9000" message="Publication Not Found">
			<cfelse>
				<cfif getPub.PUBLICATION_TYPE is "journal article">
					<cflocation url="Publication.cfm?publication_id=#publication_id#&action=editJournalArt" addtoken="false">
				<cfelseif getPub.PUBLICATION_TYPE is "journal">
					<cflocation url="Publication.cfm?journal_id=#publication_id#&action=editJournal" addtoken="false">
				<cfelseif getPub.PUBLICATION_TYPE is "book">
					<cflocation url="Publication.cfm?publication_id=#publication_id#&action=editBook" addtoken="false">
				<cfelseif getPub.PUBLICATION_TYPE is "book section">
					<cfquery name="getPub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
						select BOOK_ID from book_section where publication_id=#publication_id#
					</cfquery>
					<cflocation url="Publication.cfm?publication_id=#getPub.BOOK_ID#" addtoken="false">
				<cfelse>
				<cfthrow detail="publication ID #publication_id# is type #getPub.PUBLICATION_TYPE#" 
					errorcode="9000" 
					message="I have no idea what to do with a #getPub.PUBLICATION_TYPE#.">
				</cfif>
			</cfif>
		</cfif>
<cfset title="Find Journals">
<h2>Find Journal</h2>
<form name="findJournal" method="post" action="Publication.cfm">
	<input type="hidden" name="Action" value="findJournal">
		<label for="journal_name">Journal Name</label>
		<input type="text" name="journal_name" id="journal_name">
		<label for="journal_abbreviation">Journal Abbreviation</label>
		<input type="text" name="journal_abbreviation" id="journal_abbreviation">
		<label for="journal_abbreviation">Publisher</label>
		<input type="text" name="publisher_name" id="publisher_name">
		<br>
		<input type="submit" 
			value="Find Journal" 
			class="schBtn">	
		<input type="reset" 
			value="Clear Form" 
			class="clrBtn">
	</form>
	</cfoutput>
	</cfif>
<!---------------------------------------------------------------------------->
<cfif #Action# is "newJournalArt">
<cfoutput>
<cfset title="Create Journal Article">
	<h2>Create Journal Article</h2>
	<form name="newJournalArt" method="post" action="Publication.cfm">
		<input type="hidden" name="Action" value="makeJournalArticle">
		<label for="publication_title"><a href="javascript:getDocs('publication','title');" onClick="getDocs('publication','title')">Title:</a></label>
		<input type="text" name="publication_title" id="publication_title" size="70" class="reqdClr">
		<label for="journal_name">Journal Name</label>
		<input type="text" name="journal_name" id="journal_name" size="60"
				onchange="findJournal('journal_id','journal_name','newJournalArt',this.value);">
		<input type="hidden" name="journal_id">
		<label for="begins_page_number">Begin Page</label>
		<input type="text" name="begins_page_number" id="begins_page_number" size="4">
		<label for="ends_page_number">End Page</label>
		<input type="text" name="ends_page_number" id="ends_page_number" size="4">
		<label for="volume_number">Volume</label>
		<input type="text" name="volume_number" id="volume_number" size="4">
		<label for="issue_number">Issue</label>
		<input type="text" name="issue_number" id="issue_number" size="4">
		<label for="published_year"><a href="javascript:getDocs('publication','year')" onClick="getDocs('publication','year')">Year:</a></label>
		<input type="text" name="published_year" id="published_year" size="4">
		<label for="publication_remarks">Remarks</label>
		<input type="text" name="publication_remarks" id="publication_remarks" size="70">
		<br>
		<input type="submit" 
			value="Create Journal Article" 
			class="insBtn">
		<input type="button"
				value="Quit"
				class="qutBtn"
				onClick="document.location='Publication.cfm';">
	</form>
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "newJournal">
<CFSET title="Create Journal">
<cfoutput>
	<table class="newRec">
		<form name="newJournal" method="post" action="Publication.cfm">
		<input type="hidden" name="Action" value="makeJournal">
		<input type="hidden" name="publication_id" >
		<tr>
			<td colspan="2">
				<strong>Create Journal:</strong>
			</td>
		</tr>
		<tr>
			<td align="right">
				Name:
			</td>
			<td>
				<input type="text" name="journal_name" size="70" class="reqdClr">
			</td>
		</tr>
		<tr>
			<td align="right">
				Abbreviation:
			</td>
			<td>
				<input type="text" name="journal_abbreviation" size="70" class="reqdClr">
			</td>
		</tr>
		<tr>
			<td align="right">
				Publisher:
			</td>
			<td>
				<input type="text" name="publisher_name" size="70">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" 
						value="Create Journal" 
						class="insBtn"
						onmouseover="this.className='insBtn btnhov'" 
						onmouseout="this.className='insBtn'">	
				<input type="button"
						value="Quit"
						class="qutBtn"
						onmouseover="this.className='qutBtn btnhov'"
						onmouseout="this.className='qutBtn'"
						onClick="document.location='Publication.cfm';">
			</td>
		</tr>
	</form>
	</table>
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->

<!---------------------------------------------------------------------------->
<cfif #Action# is "makeJournalArticle">
<cfoutput>

<cfquery name="nextPub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	select sq_publication_id.nextval nextID from dual
</cfquery>
<cfset thisID = #nextPub.nextID#>
<cftransaction>
	<cfquery name="newJAP" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
INSERT INTO publication (
PUBLICATION_ID,
PUBLICATION_TYPE
<cfif len(#PUBLISHED_YEAR#) gt 0>
	,PUBLISHED_YEAR
</cfif>
,publication_title
<cfif len(#PUBLICATION_REMARKS#) gt 0>
	,PUBLICATION_REMARKS
</cfif>
)
values (
#thisID#,
'Journal Article'
<cfif len(#PUBLISHED_YEAR#) gt 0>
	,#PUBLISHED_YEAR#
</cfif>
,'#publication_title#'
<cfif len(#PUBLICATION_REMARKS#) gt 0>
	,'#PUBLICATION_REMARKS#'
</cfif>
)
</cfquery>
<cfquery name="newJA" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
INSERT INTO journal_article (
PUBLICATION_ID ,
JOURNAL_ID
<cfif len(#BEGINS_PAGE_NUMBER#) gt 0>
	,BEGINS_PAGE_NUMBER
</cfif>
<cfif len(#ENDS_PAGE_NUMBER#) gt 0>
	,ENDS_PAGE_NUMBER
</cfif>
<cfif len(#VOLUME_NUMBER#) gt 0>
	,VOLUME_NUMBER
</cfif>
<cfif len(#ISSUE_NUMBER#) gt 0>
	,ISSUE_NUMBER
</cfif> )
 VALUES (
#thisID# ,
#journal_id#
<cfif len(#BEGINS_PAGE_NUMBER#) gt 0>
	,#BEGINS_PAGE_NUMBER#
</cfif>
<cfif len(#ENDS_PAGE_NUMBER#) gt 0>
	,#ENDS_PAGE_NUMBER#
</cfif>
<cfif len(#VOLUME_NUMBER#) gt 0>
	,#VOLUME_NUMBER#
</cfif>
<cfif len(#ISSUE_NUMBER#) gt 0>
	,#ISSUE_NUMBER#
</cfif>
)
</cfquery>

</cftransaction>

<cflocation url="Publication.cfm?Action=editJournalArt&publication_id=#thisID#">
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "makeJournal">
<cfoutput>
	<cfquery name="nextJID" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		select sq_journal_id.nextval nextid from dual
	</cfquery>
	<cfquery name="newJ" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	INSERT INTO journal (
	 JOURNAL_ID,
	 JOURNAL_ABBREVIATION,
	 JOURNAL_NAME 
	 <cfif len(#PUBLISHER_NAME#) gt 0>
	 	,PUBLISHER_NAME 
	 </cfif>   
	 )	VALUES (
		#nextJID.nextid#,
	 '#JOURNAL_ABBREVIATION#',
	 '#JOURNAL_NAME#'
	 <cfif len(#PUBLISHER_NAME#) gt 0>
	 	,'#PUBLISHER_NAME#'
	 </cfif> )  
	 </cfquery>
	 <cflocation url="Publication.cfm?Action=editJournal&JOURNAL_ID=#nextJID.nextid#">
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "newBook">
<cfset title="Create Book">
<cfoutput>
	
	<cfform name="newBook" method="post" action="Publication.cfm">
		<input type="hidden" name="Action" value="makeBook1">
		<input type="hidden" name="publication_id" >
		Create Book:
			
			<br>Title:<input type="text" name="publication_title">
			<br>Volume:<input type="text" name="Volume_number">
			<br>Pages:<input type="text" name="Page_total">
			<br>Publisher:<input type="text" name="Publisher_name">
			<br>Remarks:<input type="text" name="publication_Remarks">
			<br>Year:<input type="text" name="published_year">
			<br>Edited:<select name="Edited_work_fg" size="1">
			<option value="1">yes</option>
			<option value="0">no</option>
		</select>
			<input type="submit" 
				value="Save Book" 
				class="insBtn"
				onmouseover="this.className='insBtn btnhov'" 
				onmouseout="this.className='insBtn'">
			<input type="button"
				value="Quit"
				class="qutBtn"
				onmouseover="this.className='qutBtn btnhov'"
				onmouseout="this.className='qutBtn'"
				onClick="document.location='Publication.cfm';">
		
		</cfform>
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "makeBook1">
<cfoutput>

<cfquery name="nextPub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	select sq_publication_id.nextval nextID from dual
</cfquery>
<cftransaction>
<cfquery name="nextBP" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
INSERT INTO publication (
PUBLICATION_ID,
PUBLICATION_TYPE
<cfif len(#PUBLISHED_YEAR#) gt 0>
	,PUBLISHED_YEAR
</cfif>
<cfif len(#PUBLICATION_REMARKS#) gt 0>
	,PUBLICATION_REMARKS
</cfif>
,publication_title
)
values (
#nextPub.nextID#,
'Book'
<cfif len(#PUBLISHED_YEAR#) gt 0>
	,#PUBLISHED_YEAR#
</cfif>
<cfif len(#PUBLICATION_REMARKS#) gt 0>
	,'#PUBLICATION_REMARKS#'
</cfif>
,'#publication_title#'
)
</cfquery>

<cfquery name="nextB" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
INSERT INTO book (
PUBLICATION_ID ,
EDITED_WORK_FG
<cfif len(#VOLUME_NUMBER#) gt 0>
	,VOLUME_NUMBER
</cfif>
<cfif len(#PAGE_TOTAL#) gt 0>
	,PAGE_TOTAL
</cfif>
<cfif len(#PUBLISHER_NAME#) gt 0>
	,PUBLISHER_NAME
</cfif>
)
VALUES (
#nextPub.nextID# ,
#EDITED_WORK_FG#
<cfif len(#VOLUME_NUMBER#) gt 0>
	,#VOLUME_NUMBER#
</cfif>
<cfif len(#PAGE_TOTAL#) gt 0>
	,'#PAGE_TOTAL#'
</cfif>
<cfif len(#PUBLISHER_NAME#) gt 0>
	,'#PUBLISHER_NAME#'
</cfif>
)
</cfquery>
</cftransaction>

<cflocation url="Publication.cfm?Action=editBook&publication_id=#nextPub.nextID#">
</cfoutput>

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "editBook">
<cfoutput>
	<cflocation url="editBook.cfm?publication_id=#publication_id#" addtoken="false">
</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->

<!---------------------------------------------------------------------------->
<cfif #Action# is "findJournal">
	<cfoutput>
		<cfset sql = "SELECT * from journal where journal_id > 0">
		<cfif len(#journal_name#) gt 0>
			<cfset sql = "#sql# AND upper(journal_name) like '%#ucase(journal_name)#%'">
		</cfif>
		<cfif len(#journal_abbreviation#) gt 0>
			<cfset sql = "#sql# AND upper(journal_abbreviation) like '%#ucase(journal_abbreviation)#%'">
		</cfif>
		<cfif len(#publisher_name#) gt 0>
			<cfset sql = "#sql# AND upper(publisher_name) LIKE '%#ucase(publisher_name)#%'">
		</cfif>
		<cfquery name="getJournal" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			#preservesinglequotes(sql)#
		</cfquery>
		</cfoutput>	
		<table border="1">
			<tr>
				<th>Journal Name</th>
				<th>Abbreviation</th>
				<th>Publisher</th>
				<th>&nbsp;</th>
			</tr>
			<cfoutput query="getJournal">
				<tr>
					<td>#journal_name#</td>
					<td><#journal_abbreviation#/td>
					<td>#publisher_name#</td>
					<td><a href="Publication.cfm?Action=editJournal&journal_id=#journal_id#">Edit</a></td>
				</tr>
			</cfoutput>
		</table>	
</cfif>
<!---------------------------------------------------------------------------->


<!---------------------------------------------------------------------------->
<cfif #Action# is "editJournal">
<cfset title="Edit Journal">
	<cfoutput>
		<cfquery name="jdet" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select * from journal where journal_id=#journal_id#
		</cfquery>
	</cfoutput>
	<cfoutput query="jdet">
		<cfform name="journal" method="post" action="Publication.cfm">
			<input type="hidden" name="Action" value="saveJourEdit">
			<input type="hidden" name="journal_id" value="#journal_id#">
			<label for="journal_name">Journal Name</label>
			<input type="text" name="journal_name" id="journal_name" value="#journal_name#" class="reqdClr" size="50">
			<label for="journal_abbreviation">Journal Abbreviation</label>
			<input type="text" name="journal_abbreviation" id="journal_abbreviation" value="#journal_abbreviation#" class="reqdClr">
			<label for="journal_abbreviation">Publisher</label>
			<input type="text" name="publisher_name" id="publisher_name" value="#publisher_name#" size="50">
			<br>	
			<input type="submit"
				value="Save"
				class="savBtn">			
			<input type="button"
				value="Quit"
				class="qutBtn"
				onClick="document.location='Publication.cfm';">				
		</cfform>
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->


<!---------------------------------------------------------------------------->
<cfif #Action# is "editJournalArt">
<cfset title="Edit Journal Article">
	<cfoutput>
		<cfquery name="getJournalArt" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			SELECT 
				journal_article.PUBLICATION_ID,
			 	journal_article.JOURNAL_ID,
			 	journal_article.BEGINS_PAGE_NUMBER,
			 	journal_article.ENDS_PAGE_NUMBER,
			 	journal_article.VOLUME_NUMBER,
			 	journal_article.ISSUE_NUMBER,
			 	journal.journal_name journal,
			 	publication.PUBLISHED_YEAR,
			 	publication.PUBLICATION_TITLE,
			 	publication.PUBLICATION_REMARKS,
			 	publication_url.DESCRIPTION,
			 	publication_url.PUBLICATION_URL_ID,
			 	publication_url.LINK,
			 	publication_author_name.author_position,
			 	agent_name.agent_name,
			 	agent_name.agent_name_id
			 from 
			 	journal_article, 
			 	journal,
			 	publication,
			 	publication_author_name,
			 	agent_name,
			 	publication_url
			 where 
			 	journal_article.publication_id=publication.publication_id and
			 	journal_article.journal_id=journal.journal_id and
			 	publication.publication_id = publication_url.publication_id (+) and
			 	publication.publication_id = publication_author_name.publication_id (+) and
			 	publication_author_name.agent_name_id = agent_name.agent_name_id (+) and 
			 	publication.publication_id=#publication_id#
		</cfquery>		
		<cfquery name="distJourArt" dbtype="query">
			select 
				published_year,
				publication_id,
				publication_title, 
				journal,
				begins_page_number,
				ends_page_number,
				volume_number,
				issue_number,
				publication_remarks
			 from 
			 	getJournalArt 
			 group  by
				published_year, 
				publication_id, 
				publication_title, 
				journal,
				begins_page_number,
				ends_page_number,
				volume_number,
				issue_number,
				publication_remarks
		</cfquery>
		<cfquery name="distUrl" dbtype="query">
			select publication_id, link, description,publication_url_id from getJournalArt 
			GROUP BY publication_id, link, description,publication_url_id
		</cfquery>
		<cfquery name="journArtAuth" dbtype="query">
			select agent_name, author_position, agent_name_id from getJournalArt 
			group by agent_name, author_position, agent_name_id
			order by author_position
		</cfquery>
		<table width="90%">
			<tr>
				<td width="50%">
					<span style="font-size:2em;font-weight:bold;">
						Edit Journal Article
					</span>
				</td>
				<td align="right">
					<span class="likeLink" onClick="getDocs('publication')">Help</span>
					<br>
					<a href="/Citation.cfm?publication_id=#distJourArt.publication_id#">Manage Citations</a>
				</td>
			</tr>
		</table>
		
		<cfform name="journArtDet" method="post" action="Publication.cfm" id="journArtDet">
			<input type="hidden" name="Action" value="SaveJournArtChanges">
			<input type="hidden" name="publication_id" value="#distJourArt.publication_id#">
			<label for="journal">Journal Name</label>
			<input type="text" 
				name="journal"
				id="journal"
				value="#distJourArt.journal#" 
				class="reqdClr"
				size="80"
				onchange="findJournal('journal_id','journal','journArtDet',this.value); return false;"
				onKeyPress="return noenter(event);">
			<input type="hidden" name="journal_id" id="journal_id" class="reqdClr">
			<label for="publication_title" class="likeLink" onClick="getDocs('publication','title')">Title</label>
			<textarea name="publication_title" id="publication_title" class="reqdClr" rows="3" cols="70">#distJourArt.publication_title#</textarea>
			<table>
				<tr>
					<td>
						<label for="begins_page_number">Begin Page</label>
						<input type="text" name="begins_page_number" id="begins_page_number" value="#distJourArt.begins_page_number#" size="6">
					</td>
					<td>
						<label for="ends_page_number">End Page</label>
						<input type="text" name="ends_page_number" id="ends_page_number" value="#distJourArt.ends_page_number#" size="6">
					</td>
					<td>
						<label for="volume_number">Volume</label>
						<input type="text" name="volume_number" id="volume_number" value="#distJourArt.volume_number#" size="6">
					</td>
					<td>
						<label for="issue_number">Issue</label>
						<input type="text" name="issue_number" id="issue_number" value="#distJourArt.issue_number#" size="6">
					</td>
					<td>
						<label for="published_year">Year</label>
						<input type="text" name="published_year" id="published_year" value="#distJourArt.published_year#" size="6">
					</td>
				</tr>
			</table>
			<label for="remarks">Remarks</label>
			<input type="text" name="remarks" id="remarks" size="80" value="#distJourArt.publication_remarks#">
			<br>		
			<input type="submit" value="Save Edits" class="savBtn">	
			<input type="button" value="Quit" class="qutBtn" onClick="document.location='Publication.cfm';">
			<input type="button" value="Delete" class="delBtn" 
				onClick="document.location='Publication.cfm?action=killJournalArticle&publication_id=#distJourArt.publication_id#';">
		</cfform>
		<label for="authsT" class="likeLink" onClick="getDocs('publication','author')">Authors</label>
		<table id="authsT">
			<tr>
				<th>Author Position</th>
				<th>Author Name</th>
				<th>&nbsp;</th>
			</tr>
		<cfset i=1>
		<cfloop query="journArtAuth">
			<cfif len(#journArtAuth.agent_name_id#) gt 0>
				<form name="author#i#" id="author#i#" method="post" action="Publication.cfm">
					<input type="hidden" name="Action" value="changePubAuth">
					<input type="hidden" name="publication_id" value="#distJourArt.publication_id#">
					<input type="hidden" name="caller" value="#Action#">
					<tr>
						<td>
							<select name="author_position">
								<cfloop from="1" to="25" index="num">
									<option <cfif #num# is "#journArtAuth.author_position#"> selected </cfif>value="#num#">#num#</option>
									<cfset num=#num#+1>
								</cfloop>
							</select>
						</td>
						<td>
							<input type="text" name="authorName" value="#journArtAuth.agent_name#" class="reqdClr" 
								onchange="findAgentName('newagent_name_id','authorName','author#i#',this.value); return false;"
		 						onKeyPress="return noenter(event);">
		 					<input type="hidden" name="agent_name_id" value="#journArtAuth.agent_name_id#">
							<input type="hidden" name="newagent_name_id">
						</td>
						<td>
							<input type="submit" value="Save" class="savBtn">
							<input type="button" value="Delete" class="delBtn"
								onClick="author#i#.Action.value='delPubAuth';submit();">	
						</td>
						<cfset i = #i#+1>
					</tr>
				</form>
			</cfif>
		</cfloop>
	</table>
			<table class="newRec"><tr><td>
			<cfform name="newAuthor"  method="post" action="Publication.cfm">
			<input type="hidden" name="Action" value="newPubAuth">
				<input type="hidden" name="publication_id" value="#distJourArt.publication_id#">
				<input type="hidden" name="caller" value="#Action#">
			<cftry>
			<cfquery name="nextAuth" dbtype="query">
				select max(author_position) + 1 as nextPos from getJournalArt
			</cfquery>
			<cfcatch>
				<!--- returned null --->
				<cfset nextPos = 1>
			</cfcatch>
			</cftry>
			<cfif isdefined("nextAuth.recordcount") AND #nextAuth.recordcount# gt 0>
				<cfset nextPos = #nextAuth.nextPos#>
				<cfelse>
					<cfset nextPos = 1>
			</cfif>
			<br>Add Author: ##<select name="author_position">
					<cfset num = 1>
					<cfloop condition="#num# lt 26">
						<option 
							<cfif #num# is "#nextPos#"> selected </cfif>value="#num#">#num#</option>
						<cfset num=#num#+1>
					</cfloop>
						</select>
						
						
				<input type="text" name="newAuth"  class="reqdClr" 
		onchange="findAgentName('newAuthId','newAuth','newAuthor',this.value); return false;"
		 onKeyPress="return noenter(event);">
		 
		 
				<input type="hidden" name="newAuthId">
				
				<input type="submit" value="Save" class="savBtn"
   					onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'">	
				
			</cfform>
			</td></tr></table>		
					

	</cfoutput>
	</td></tr>
	<tr>
		<td>
			Links:
		</td>
		<td>
				<table>
				<tr>
					<td>
					<a href="javascript:void(0);" onClick="getDocs('publication','description')">Description</a>
					</td>
					<td><a href="javascript:void(0);" onClick="getDocs('publication','url')">URL</a></td>
					<td>&nbsp;</td>
				</tr>
				
						<cfset i=1>
						<cfif len(#distUrl.link#) gt 0>
						<cfoutput query="distUrl">
						<tr>
					
							<form name="pubLink#i#" method="post" action="Publication.cfm">
								<input type="hidden" name="action" value="">
								<input type="hidden" name="publication_url_id" value="#publication_url_id#">
								<input type="hidden" name="publication_id" value="#publication_id#">
								<td><input type="text" name="description" value="#description#"></td>
								<td><input type="text" name="link" value="#link#" size="60"></td>
								<td nowrap><input type="button" value="Save" class="savBtn"
   					onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'"
					onclick="pubLink#i#.action.value='updateLink';submit();">
					
					<input type="button" value="Delete" class="delBtn"
   					onmouseover="this.className='delBtn btnhov'" onmouseout="this.className='delBtn'"
					onclick="pubLink#i#.action.value='deleteLink';submit();">
					
					</td>
								
								
							</form>
							
							<cfset i=#i#+1>
							</tr>
						</cfoutput>
						</cfif>
												
					
				
				<tr class="newRec">
					<cfoutput>
						<form name="newLink" method="post" action="Publication.cfm">
								<input type="hidden" name="action" value="newLink">
								<input type="hidden" name="publication_id" value="#distUrl.publication_id#">
								<td><input type="text" name="description"></td>
								<td><input type="text" name="link" size="60"></td>
								<td><input type="submit" value="Insert" class="insBtn"
   					onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	</td>
								
								
							</form>
					</cfoutput>
				</tr>
			</table>
		</td>
	</tr>
	</table>
</cfif>

<!---------------------------------------------------------------------------->
<cfif #Action# is "deleteLink">
	
	<cfoutput>
	<cfquery name="newLink" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		DELETE FROM publication_url
		WHERE
		publication_url_id = #publication_url_id#
	</cfquery>
	
	
	<cflocation url="Publication.cfm?Action=editJournalArt&publication_id=#publication_id#">
	
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "updateLink">
	<cfoutput>
	<cfquery name="newLink" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		UPDATE publication_url SET
		link = '#link#',
		description = '#description#'
		WHERE
		publication_url_id = #publication_url_id#
	</cfquery>
	
	
	<cflocation url="Publication.cfm?Action=editJournalArt&publication_id=#publication_id#">
	
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "newLink">
	<cfoutput>
	<cfquery name="newLink" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		INSERT INTO publication_url (
		publication_url_id,
		publication_id,
		link,
		description)
		values (
		sq_publication_url_id.nextval,
		#publication_id#,
		'#link#',
		'#description#'
		)
	</cfquery>	
	<cflocation url="Publication.cfm?Action=editJournalArt&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "SaveJournArtChanges">
	<cfoutput>
	<cftransaction>
	<cfquery name="uJ" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE journal_article SET publication_id=#publication_id#
		<cfif len(journal_id) gt 0>
			,journal_id=#journal_id#
		</cfif>
		<cfif len(begins_page_number) gt 0>
			,begins_page_number='#begins_page_number#'
		</cfif>
		<cfif len(ends_page_number) gt 0>
			,ends_page_number='#ends_page_number#'
		</cfif>
		<cfif len(volume_number) gt 0>
			,volume_number='#volume_number#'
			<cfelse>
			,volume_number = null
		</cfif>
		<cfif len(issue_number) gt 0>
			,issue_number='#issue_number#'
		<cfelse>
			,issue_number = null
		</cfif>
		where publication_id=#publication_id#
		</cfquery>
		
		<cfquery name="uJP" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE publication SET publication_id=#publication_id#
		<cfif len(#Remarks#) gt 0>
			,publication_remarks='#Remarks#'
		<cfelse>
			,publication_remarks=NULL
		</cfif>
		,publication_title = '#publication_title#'
	where publication_id=#publication_id#
	</cfquery>
	PDATE publication SET publication_id=#publication_id#
		<cfif len(#Remarks#) gt 0>
			,publication_remarks='#Remarks#'
		<cfelse>
			,publication_remarks=NULL
		</cfif>
		,publication_title = '#publication_title#'
	where publication_id=#publication_id#
	
	
	</cftransaction>
	<cflocation url="Publication.cfm?Action=editJournalArt&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "saveJourEdit">
	<cfoutput>
	<cfquery name="uJ" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE journal SET  
	journal_name = '#journal_name#'
	<cfif len(#journal_abbreviation#) gt 0>
		,journal_abbreviation='#journal_abbreviation#'
	</cfif>
	<cfif len(#publisher_name#) gt 0>
		,publisher_name='#publisher_name#'
	</cfif>
	where journal_id=#journal_id#
	</cfquery>
	<cflocation url="Publication.cfm?Action=editJournal&journal_id=#journal_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "delPubAuth">
	<cfoutput>
	<cfquery name="dp" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	delete from publication_author_name where publication_id=#publication_id# and
	agent_name_id = #agent_name_id#
	</cfquery>
	<cflocation url="Publication.cfm?Action=#caller#&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "SaveBookChanges">
	<cfoutput>
	<cftransaction>
	<cfquery name="ub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE book SET publication_id=#publication_id#
		<cfif len(Volume) gt 0>
			,volume_number='#Volume#'
		</cfif>
		<cfif len(Pages) gt 0>
			,page_total='#Pages#'
		</cfif>
		<cfif len(Publisher) gt 0>
			,publisher_name='#Publisher#'
		</cfif>
		<cfif len(Edited) gt 0>
			,edited_work_fg='#Edited#'
		</cfif>
		where publication_id=#publication_id#
		</cfquery>
	<cfquery name="ubp" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE publication SET publication_id=#publication_id#
		<cfif len(Remarks) gt 0>
			,publication_remarks='#Remarks#'
		</cfif>
		,publication_title = '#publication_title#'
	where publication_id=#publication_id#
		</cfquery>
	</cftransaction>
		<cflocation url="Publication.cfm?Action=editBook&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "saveSectionEdits">
	<cfoutput>
	<cftransaction>
	<cfquery name="ubs" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE book_section SET publication_id=#publication_id#
		<cfif len(book_section_type) gt 0>
			,book_section_type='#book_section_type#'
		</cfif>
		<cfif len(begins_page_number) gt 0>
			,begins_page_number='#begins_page_number#'
		</cfif>
		<cfif len(ends_page_number) gt 0>
			,ends_page_number='#ends_page_number#'
		</cfif>
		<cfif len(book_section_order) gt 0>
			,book_section_order='#book_section_order#'
		</cfif>
		where publication_id=#publication_id#
		</cfquery>
		<cfquery name="ubsp" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			
	
	UPDATE publication SET publication_id=#publication_id#
		<cfif len(published_year) gt 0>
			,published_year='#published_year#'
		  <cfelse>
		  ,published_year=null
		  </cfif>
		
		<cfif len(Remarks) gt 0>
			,publication_remarks='#Remarks#'
		<cfelse>
			,publication_remarks=null
		</cfif>
		<cfif len(publication_title) gt 0>
			,publication_title='#publication_title#'
		<cfelse>
			,publication_title=null
		</cfif>
	where publication_id=#publication_id#
	</cfquery>
	</cftransaction>
		<cflocation url="Publication.cfm?Action=editBookSection&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "newbooksec">
	<cfoutput>
	<cftransaction>
		<cfquery name="nextPub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select sq_publication_id.nextval nextID from dual
		</cfquery>
	
	<cfquery name="nbsP" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			INSERT INTO publication (
				publication_id
				,publication_type
				,publication_title
				<cfif len(#published_year#) gt 0>
					,published_year
				</cfif>
				<cfif len(#publication_remarks#) gt 0>
					,publication_remarks
				</cfif>)
			VALUES (
				#nextPub.nextID#
				,'Book Section'
				,'#publication_title#'
				<cfif len(#published_year#) gt 0>
					,#published_year#
				</cfif>
				<cfif len(#publication_remarks#) gt 0>
					,'#publication_remarks#'
				</cfif>)

	</cfquery>
	<cfquery name="nbs" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	INSERT INTO book_section (
		PUBLICATION_ID,
		book_id,
		book_section_type
		<cfif len(#begins_page_number#) gt 0>
			,begins_page_number
		</cfif>
		<cfif len(#ends_page_number#) gt 0>
			,ends_page_number
		</cfif>
		<cfif len(#book_section_order#) gt 0>
			,book_section_order
		</cfif>
		)
	VALUES (
		#nextPub.nextID#,
		#book_id#,
		'chapter'
		<cfif len(#begins_page_number#) gt 0>
			,#begins_page_number#
		</cfif>
		<cfif len(#ends_page_number#) gt 0>
			,#ends_page_number#
		</cfif>
		<cfif len(#book_section_order#) gt 0>
			,#book_section_order#
		</cfif>
		)
	</cfquery>
	</cftransaction>
		<cflocation url="Publication.cfm?Action=editBookSection&publication_id=#nextPub.nextID#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->

<!---------------------------------------------------------------------------->
<cfif #Action# is "changePubAuth">
	<cfoutput>
	<cfquery name="upa" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	UPDATE publication_author_name SET 
	<cfif len(#newagent_name_id#) gt 0>
		agent_name_id=#newagent_name_id#,
	</cfif>author_position=#author_position# where
	publication_id=#publication_id# and agent_name_id=#agent_name_id#
	</cfquery>
	
	<cflocation url="Publication.cfm?Action=#caller#&publication_id=#publication_id#">
	</cfoutput>
	

</cfif>
<!---------------------------------------------------------------------------->

<!---------------------------------------------------------------------------->
<cfif #Action# is "killJournalArticle">
	<cfoutput>
	<cftransaction>
		<cfquery name="killja" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			delete from journal_article where publication_id = #publication_id#
		</cfquery>
		<cfquery name="killpub" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			delete from publication where publication_id = #publication_id#
		</cfquery>
		<cfquery name="killpubauth" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			delete from publication_author_name where publication_id = #publication_id#
		</cfquery>
	</cftransaction>
	
	
	<cflocation url="PublicationSearch.cfm">
	</cfoutput>
	

</cfif>
<!---------------------------------------------------------------------------->
<!---------------------------------------------------------------------------->
<cfif #Action# is "newPubAuth">
	<cfoutput>
	<cfquery name="npa" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
	INSERT INTO  publication_author_name (publication_id,agent_name_id,author_position)
		VALUES (#publication_id#,#newAuthId#,#author_position#)
	</cfquery>
	<cflocation url="Publication.cfm?Action=#caller#&publication_id=#publication_id#">
	</cfoutput>
</cfif>
<!---------------------------------------------------------------------------->
<cfinclude template="includes/_footer.cfm">
