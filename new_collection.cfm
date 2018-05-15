<cfinclude template="/includes/_header.cfm">
<cfset title="New Collection Portal">

<!----
	create table pre_new_collection (
		ncid number,
		user_pwd VARCHAR2(255),
		COLLECTION_CDE varchar2(5),
		INSTITUTION_ACRONYM VARCHAR2(20),
		DESCR VARCHAR2(4000),
		COLLECTION VARCHAR2(50),
		WEB_LINK  VARCHAR2(4000),
		WEB_LINK_TEXT  VARCHAR2(50),
		LOAN_POLICY_URL VARCHAR2(255),
		INSTITUTION VARCHAR2(255),
		GUID_PREFIX VARCHAR2(20),
		PREFERRED_TAXONOMY_SOURCE VARCHAR2(255),
		CATALOG_NUMBER_FORMAT  VARCHAR2(21),
		mentor varchar2(4000),
		mentor_contact varchar2(4000),
		admin_username VARCHAR2(255),
		status varchar2(255),
		insert_date date
	);

	alter table pre_new_collection add use_license_id number;

	create public synonym pre_new_collection for pre_new_collection;

	grant select, insert, update on pre_new_collection to public;

	drop index ix_u_pnc_GUID_PREFIX;

	create unique index ix_u_pnc_GUID_PREFIX_u on pre_new_collection(upper(GUID_PREFIX)) tablespace uam_idx_1;
---->
<cfif action is "default">
	denied<cfabort>
</cfif>
<cfif len(session.username) is 0>
	You must log in to use this form.
	<cfabort>
</cfif>

<cfif action is "nothing">

	<p>
		This form facilitates new collection creation in Arctos. This is a request only; you cannot create a collection with this form.
	</p>
	<h2>Request a new collection</h2>
	If this is a new request, first
	<a href="http://handbook.arctosdb.org/documentation/catalog.html#guid-prefix">CAREFULLY review the GUID_prefix documentation</a>,
	enter your desired guid_prefix and a temporary password in the form below, and click "create collection request."
	This password is NOT secure and should be used nowhere except in this form. The password must be at least one character in length.
	DO NOT re-use your password to any site, including Arctos. (It's fine to re-use
	the temporary password when requesting multiple collections.) This password provides light obfuscation of the collection creation process,
	but is no guarantee of security. Do not provide any
	confidential information in this form. Discuss any concerns with your Mentor.

	<h2>Mange an existing request</h2>
	If you have created a request, fill in the form with the password and GUID_Prefix you used in the initial request and click
	"manage existing request."
	<p>
	<form name="f" id="f" method="post" action="new_collection.cfm">
		<input type="hidden" name="action" value="default">
		<label for="guid_prefix">GUID Prefix</label>
		<input type="text" name="guid_prefix" id="guid_prefix" class="reqdClr" required>
		<label for="pwd">Password</label>
		<input type="text" name="pwd" id="pwd" class="reqdClr" required>
		<br><input type="button" class="insBtn" onclick="document.f.action.value='newCollectionRequest';document.f.submit();" value="create collection request">
		<br><input type="button" class="lnkBtn" onclick="document.f.action.value='mgCollectionRequest';document.f.submit();" value="manage existing request">
	</form>

	<cfif isdefined("session.roles") and session.roles contains "global_admin">
	you are admin; manage existing
	<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from pre_new_collection order by insert_date desc
	</cfquery>
	<cfoutput>
		<table border>
			<tr>
				<th>GUID Prefix</th>
				<th>CreateDate</th>
				<th>Status</th>
				<th>Manage</th>
			</tr>
			<cfloop query="d">
				<tr>
					<td>#GUID_PREFIX#</td>
					<td>#dateformat(insert_date,'yyyy-mm-dd')#</td>
					<td>#status#</td>
					<td><a href="new_collection.cfm?action=mgCollectionRequest&pwhash=#hash(user_pwd)#&GUID_PREFIX=#GUID_PREFIX#">clicky</a></td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</cfif>

</cfif>
<cfif action is "newCollectionRequest">
	<cfquery name="mkr" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		insert into pre_new_collection (
			ncid,
			user_pwd,
			GUID_PREFIX,
			status,
			insert_date
		) values (
			someRandomSequence.nextval,
			'#escapeQuotes(pwd)#',
			'#escapeQuotes(guid_prefix)#',
			'new',
			sysdate
		)
	</cfquery>
	<cflocation url="new_collection.cfm?action=mgCollectionRequest&pwhash=#hash(pwd)#&GUID_PREFIX=#GUID_PREFIX#">
</cfif>

<cfif action is "mgCollectionRequest">
	<style>
		.infoDiv{
			border:2px solid green;
			font-size:smaller;
			padding:.5em;
			margin:1em;
			background-color:#e3ede5;
		}
	</style>

	<cfquery name="CTMEDIA_LICENSE" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select MEDIA_LICENSE_ID,DISPLAY from CTMEDIA_LICENSE order by DISPLAY
	</cfquery>

	<cfquery name="cttaxonomy_source" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select source from cttaxonomy_source group by source order by source
	</cfquery>
	<cfquery name="ctcollection_cde" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select collection_cde from ctcollection_cde  order by collection_cde
	</cfquery>

	<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from pre_new_collection where guid_prefix='#guid_prefix#' and
		<cfif isdefined('pwd') and len('pwd') gt 0>
			user_pwd='#escapeQuotes(pwd)#'
		<cfelseif isdefined('pwhash') and len('pwhash') gt 0>
			dbms_obfuscation_toolkit.md5(input => UTL_RAW.cast_to_raw(user_pwd)) ='#pwhash#'
		<cfelse>
			1=2
		</cfif>
	</cfquery>
	<cfoutput>
		<h2>New Collection Request</h2>
		<p>
			<ul>
				<li>Request Date: #dateformat(d.insert_date,'yyyy-mm-dd')#</li>
				<li>Status: #d.status#</li>
				<li>Password: #d.user_pwd#</li>
				<li>
					Sharable link to this form. CAUTION: This provides edit access to anyone with an Arcto account.
					<br>
					<code>
						#application.serverRootURL#/new_collection.cfm?action=mgCollectionRequest&pwhash=#hash(d.user_pwd)#&GUID_PREFIX=#d.GUID_PREFIX#
					</code>
				</li>
			</ul>
		</p>
		<p>
			Useful Links:
			<ul>
				<li><a target="_blank" class="external" href="https://arctosdb.org/faq/">Arctos FAQ </a></li>
				<li>
					<a target="_blank" class="external" href="https://www.tacc.utexas.edu/">TACC</a>
					handles all of our data storage and security on their
					<a target="_blank" class="external" href="https://www.tacc.utexas.edu/systems/corral">Corral</a> system.
				</li>
				<li><a target="_blank" class="external" href="https://arctosdb.org/join-arctos/costs/">current pricing structure</a></li>
				<li><a target="_blank" class="external" href="https://arctosdb.org/learn/webinars/">webinars</a></li>
				<li><a target="_blank" class="external" href="http://handbook.arctosdb.org">Arctos Handbook</a></li>
				<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/how_to/How-to-Manage-a-Collection-in-Arctos.html">How-To: Manage Collection</a></li>
			</ul>
		</p>
		<p>
			Make sure to save if you change anything!
		</p>

		<form name="f" id="f" action="new_collection.cfm" method="post">

			<br><input type="submit" class="savBtn" value="save changes">

			<input type="hidden" name="action" value="saveEdits">
			<input type="hidden" name="user_pwd" value="#d.user_pwd#">
			<!----
			<div class="infoDiv">
				This password is NOT secure and comes with no restrictions. DO NOT re-use your password to any site, including Arctos.
				This prevents public browsing of these data, but is no guarantee of security. You will need this password to
				edit or finalize your request. Do not provide any
				confidential information in this form. Discuss any concerns with your Mentor.
				<label for="user_pwd">Password</label>
				<input type="text" name="user_pwd" id="user_pwd" class="reqdClr" required value="#d.user_pwd#">

			</div>

			<div class="infoDiv">
				Status of this request
				<ul>
					<li>new: unreviewed request</li>
					<li>submit for review: request is ready for consideration by Arctos staff</li>
					<li>ready to create: request is approved by Arctos staff and ready for DBA action</li>
					<li>created: collection is created and ready for use</li>
				</ul>
				<label for="status">status</label>
					<select name="status" id="status" class="reqdClr" required >
					<option <cfif d.status is "new">selected="selected" </cfif>value="new">new</option>
					<option <cfif d.status is "submit for review">selected="selected" </cfif>value="submit for review">submit for review</option>
					<option <cfif d.status is "ready to create">selected="selected" </cfif>value="ready to create">ready to create</option>
					<option <cfif d.status is "created">selected="selected" </cfif>value="created">created</option>

					<option <cfif d.catalog_number_format is "prefix-integer-suffix">selected="selected" </cfif>value="prefix-integer-suffix">prefix-integer-suffix</option>
					<option <cfif d.catalog_number_format is "string">selected="selected" </cfif>value="string">string</option>
				</select>
			</div>
			---->

			<div class="infoDiv">
				GUID_Prefix is the core of the primary specimen identifier. It is combined with catalog number and Arctos' URL to
				produce a resolvable globally-unique specimen identifier. This must be unique across all Arctos collections.
				The format MUST be {string}:{string}. GUID_Prefix cannot be changed without breaking all links to specimens; choose carefully.
				The traditional format is {institution_acronym}:{collection_cde}, but this is not a requirement. Maximum length is 20 characters.
				You may wish to register your collection in <a href="http://grbio.org" target="_blank" class="external">GRBIO</a>.
				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##guid-prefix">Documentation</a></li>
				</ul>
				<label for="GUID_PREFIX">GUID_Prefix</label>
				<input type="text" name="GUID_PREFIX" id="GUID_PREFIX" class="reqdClr" required value="#d.GUID_PREFIX#">
			</div>


			<div class="infoDiv">
				Collection Code controls which code tables your collection will use.
				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##collection-code">Documentation</a></li>
					<li><a target="_blank" class="external" href="http://arctos.database.museum/info/ctDocumentation.cfm?table=CTCOLLECTION_CDE">Code Table</a></li>
				</ul>

				<label for="COLLECTION_CDE">Collection Code</label>
				<select name="COLLECTION_CDE" id="COLLECTION_CDE" class="reqdClr" required>
					<cfloop query="ctcollection_cde">
						<option	<cfif d.collection_cde is ctcollection_cde.collection_cde> selected="selected" </cfif>
							value="#collection_cde#">#collection_cde#</option>
					</cfloop>
				</select>
			</div>


			<div class="infoDiv">
				Institution Acronym is typically the first component of GUID_Prefix. Maximum length is 20 characters.

				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##institution-acronym">Documentation</a></li>
				</ul>

				<label for="INSTITUTION_ACRONYM">Institution Acronym</label>
				<input type="text" name="INSTITUTION_ACRONYM" id="INSTITUTION_ACRONYM" class="reqdClr" required value="#d.INSTITUTION_ACRONYM#">

			</div>

			<div class="infoDiv">
				Institution is displayed as "section header" in the Collection search box on SpecimenSearch. It should be the same for all collections in
				an institution, and end with Institution Acronym in parentheses. Examples:
				<ul>
					<li>Chicago Academy of Sciences (CHAS)</li>
					<li>Museum of Southwestern Biology (MSB)</li>
				</ul>

				<label for="INSTITUTION">Institution</label>
				<input type="text" name="INSTITUTION" id="INSTITUTION" class="reqdClr" required value="#d.INSTITUTION#" size="80">
			</div>

			<div class="infoDiv">
				Collection is displayed as a child of institution in the Collection search box on SpecimenSearch.
				It should be the same for all collections of similar type across institutions. Examples:

				<ul>
					<li>Amphibian and reptile specimens</li>
					<li>Insect specimens</li>
					<li>Mammal observations</li>
				</ul>



				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##collection">Documentation</a></li>
				</ul>

				<label for="COLLECTION">Collection</label>
				<input type="text" name="COLLECTION" id="COLLECTION" class="reqdClr" required value="#d.COLLECTION#" size="80">
			</div>




			<div class="infoDiv">
				Description of the collection. Maximum length is 4000 characters.
				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##description">Documentation</a></li>
				</ul>

				<label for="DESCR">Description</label>
				<textarea class="hugetextarea reqdClr" name="DESCR" id="DESCR" required >#d.DESCR#</textarea>
			</div>

			<div class="infoDiv">
				URL to collection's loan policy. A loan policy is required; the contents of the loan policy are entirely up to the data owners.
				File an Issue for assistance in creating or hosting a loan policy.

				<label for="LOAN_POLICY_URL">Loan Policy URL</label>
				<input type="text" name="LOAN_POLICY_URL" id="LOAN_POLICY_URL" class="reqdClr" required value="#d.LOAN_POLICY_URL#" size="80">
			</div>


			<div class="infoDiv">
				Taxonomy Source is "your" classification. Choose an existing source, or file an Issue to import data or use an external
				source through GlobalNames.org.
				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/taxonomy.html##source-arctos">Documentation</a></li>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/how_to/How-to-manage-taxonomic-classifications.html">How-To</a></li>
				</ul>

				<label for="PREFERRED_TAXONOMY_SOURCE">Taxonomy Source</label>
				<select name="preferred_taxonomy_source" id="preferred_taxonomy_source" class="reqdClr" required>
					<cfloop query="cttaxonomy_source">
						<option	<cfif d.preferred_taxonomy_source is cttaxonomy_source.source> selected="selected" </cfif>
							value="#source#">#source#</option>
					</cfloop>
				</select>

			</div>



			<div class="infoDiv">
				Allowable format of catalog number. Integer provides more functionality and is preferred. Please discuss with your Mentor
				if you are considering anything else.

				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/catalog.html##catalog-number">Documentation</a></li>
				</ul>
				<label for="CATALOG_NUMBER_FORMAT">Catalog Number Format</label>
				<select name="catalog_number_format" id="catalog_number_format" class="reqdClr" required >
					<option <cfif d.catalog_number_format is "integer">selected="selected" </cfif>value="integer">integer</option>
					<option <cfif d.catalog_number_format is "prefix-integer-suffix">selected="selected" </cfif>value="prefix-integer-suffix">prefix-integer-suffix</option>
					<option <cfif d.catalog_number_format is "string">selected="selected" </cfif>value="string">string</option>
				</select>

			</div>



			<div class="infoDiv">
				License to govern the usage of your data in Arctos. File an Issue if you need a new license. Note that data shared via DWC
				may be licensed differently, and Media are individually licensed.

				<ul>
					<li><a target="_blank" class="external" href="/info/ctDocumentation.cfm?table=CTMEDIA_LICENSE">Code Table</a></li>
				</ul>
				<label for="USE_LICENSE_ID">License</label>
				<select name="use_license_id" id="use_license_id" >
					<option value="NULL">-none-</option>
					<cfloop query="CTMEDIA_LICENSE">
						<option	<cfif d.use_license_id is MEDIA_LICENSE_ID> selected="selected" </cfif>
							value="#MEDIA_LICENSE_ID#">#DISPLAY#</option>
					</cfloop>
				</select>
			</div>



			<div class="infoDiv">
				URL to more information, such as the collection's home page.
				<label for="WEB_LINK">Web Link</label>
				<input type="text" name="WEB_LINK" id="WEB_LINK"  value="#d.WEB_LINK#" size="80">
			</div>

			<div class="infoDiv">
				Clickable text to display with web link.
				<label for="WEB_LINK_TEXT">Web Link Text</label>
				<input type="text" name="WEB_LINK_TEXT" id="WEB_LINK_TEXT" value="#d.WEB_LINK_TEXT#" size="80">
			</div>


			<div class="infoDiv">
				If you do not yet have a Mentor, you should discuss mentoring with a volunteer from
				<a href="/info/mentor.cfm">the list</a>.
				<label for="mentor">mentor</label>
				<input type="text" name="mentor" id="mentor"  value="#d.mentor#" size="80">
			</div>


			<div class="infoDiv">
				Mentor's email. This helps us keep them in the loop.
				<label for="mentor_contact">mentor_contact</label>
				<input type="text" name="mentor_contact" id="mentor_contact" value="#d.mentor_contact#" size="80">
			</div>


			<div class="infoDiv">
				Arctos username(s) who will receive initial manage_collection access. Comma-separated list OK. These Operators can
				create and manage other collection users. Anyone listed here should already have an Arctos account; contact your Mentor
				for an invitation.

				<ul>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/documentation/users.html">Documentation</a></li>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/how_to/How-to-Create-a-New-User-Account-for-Operators.html">How-To</a></li>
					<li><a target="_blank" class="external" href="http://handbook.arctosdb.org/how_to/How-to-Invite-an-Operator.html">How-To</a></li>
				</ul>
				<label for="admin_username">admin_username</label>
				<input type="text" name="admin_username" id="admin_username"  value="#d.admin_username#" size="80">
			</div>

			<br><input type="submit" class="savBtn" value="save changes">

		</form>
	</cfoutput>
</cfif>
<cfif action is "saveEdits">
	<cfoutput>
		<cfquery name="u" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			update pre_new_collection set
				COLLECTION_CDE='#COLLECTION_CDE#',
				INSTITUTION_ACRONYM='#INSTITUTION_ACRONYM#',
				DESCR='#escapeQuotes(DESCR)#',
				COLLECTION='#COLLECTION#',
				LOAN_POLICY_URL='#LOAN_POLICY_URL#',
				INSTITUTION='#INSTITUTION#',
				PREFERRED_TAXONOMY_SOURCE='#PREFERRED_TAXONOMY_SOURCE#',
				CATALOG_NUMBER_FORMAT='#CATALOG_NUMBER_FORMAT#',
				USE_LICENSE_ID=<cfif len(USE_LICENSE_ID) gt 0>#USE_LICENSE_ID#<cfelse>null</cfif>,
				WEB_LINK='#WEB_LINK#',
				WEB_LINK_TEXT='#WEB_LINK_TEXT#',
				mentor='#mentor#',
				mentor_contact='#mentor_contact#',
				admin_username='#admin_username#'
			where
				GUID_PREFIX='#GUID_PREFIX#'
		</cfquery>
		<cflocation url="new_collection.cfm?action=mgCollectionRequest&pwhash=#hash(user_pwd)#&GUID_PREFIX=#GUID_PREFIX#">

	</cfoutput>





</cfif>
<cfinclude template="/includes/_footer.cfm">
