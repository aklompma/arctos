<cfinclude template="/includes/alwaysInclude.cfm">
<div align="center">
	<span style="background-color:green;color:white; font-size:36px; font-weight:bold;">
		Fetching map data...
	</span>
</div>
<cfflush>
<cfif isdefined("session.roles") and listfindnocase(session.roles,"coldfusion_user")>
	<cfset flatTableName = "flat">
<cfelse>
	<cfset flatTableName = "filtered_flat">
</cfif>
<!----------------------------------------------------------------->
<cfif isdefined("action") and action IS "mapPoint">
<cfoutput>
	<!---- map a lat_long_id ---->
	<cfif not isdefined("lat_long_id") or len(lat_long_id) is 0>
		<div class="error">
			You can't map a point without a lat_long_id.
		</div>
		<cfabort>
	</cfif>	
	<cfquery name="getMapData" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		SELECT
			'All collections' Collection,
			0 collection_id,
			'000000' cat_num,
			'Lat Long ID: ' || lat_long_id scientific_name,
			'none' verbatim_date,
			'none' spec_locality,
			dec_lat,
			dec_long,
			to_meters(max_error_distance,max_error_units) max_error_meters,
			datum,
			'000000' collection_object_id
		FROM 
			lat_long 
		WHERE
			lat_long_id=#lat_long_id#
	</cfquery>
</cfoutput>
<cfelse><!--- regular mapping routine ---->
	<cfif isdefined("collection_object_id") and len(collection_object_id) gt 0>
		<cfset ShowObservations = "true">
	</cfif>
	<cfset basSelect = "SELECT DISTINCT 
		#flatTableName#.collection,
		#flatTableName#.collection_id,
		#flatTableName#.cat_num,
		#flatTableName#.scientific_name,
		#flatTableName#.verbatim_date,
		#flatTableName#.spec_locality,
		#flatTableName#.dec_lat,
		#flatTableName#.dec_long,
		#flatTableName#.COORDINATEUNCERTAINTYINMETERS,
		#flatTableName#.datum,
		#flatTableName#.collection_object_id">
	<cfset basFrom = "	FROM #flatTableName#">
	<cfset basJoin = " INNER JOIN cataloged_item ON (#flatTableName#.collection_object_id =cataloged_item.collection_object_id)
		INNER JOIN collecting_event flatCollEvent ON (#flatTableName#.collecting_event_id = flatCollEvent.collecting_event_id)">	
	<cfset basWhere = " WHERE 
		dec_lat is not null AND
		dec_long is not null AND
		flatCollEvent.collecting_source = 'wild caught' ">			
	<cfset basQual = "">
	<cfif not isdefined("basJoin")>
		<cfset basJoin = "">
	</cfif>
	<cfinclude template="/includes/SearchSql.cfm">
	<cfset SqlString = "#basSelect# #basFrom# #basJoin# #basWhere# #basQual#">	
	<cfquery name="getMapData" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		#preserveSingleQuotes(SqlString)#
	</cfquery>
	<cfoutput>
		<cf_getSearchTerms>
		<cfset log.query_string=returnURL>
		<cfset log.reported_count = #getMapData.RecordCount#>
		<cfinclude template="/includes/activityLog.cfm">
	</cfoutput>
</cfif><!--- end point map option --->
<cfif getMapData.recordcount is 0>
	<div class="error">
		Oops! We didn't find anything mappable. Only wild caught specimens with coordintes will map.
		File a <a href='/info/bugs.cfm'>bug report</a> if you think this message is in error.
	</div>
	<cfabort>
</cfif>
<!---- write an XML config file specific to the critters they're mapping --->
<cfoutput>
	<cfset thisFileName = "BNHM#cftoken#.xml">
	<cfset thisFile = "#Application.webDirectory#/bnhmMaps/tabfiles/#thisFileName#">
	<cfset variables.XMLFile = "#Application.serverRootUrl#/bnhmMaps/tabfiles/#thisFileName#">
	<cfset variables.encoding="UTF-8">
	<cfquery name="collID" dbtype="query">
		select collection_id from getMapData group by collection_id
	</cfquery>
	<cfset thisAddress = #Application.DataProblemReportEmail#>
	<cfif len(valuelist(collID.collection_id)) gt 0>
		<cfquery name="whatEmails" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select address from
				electronic_address,
				collection_contacts
			WHERE
				electronic_address.agent_id = collection_contacts.contact_agent_id AND
				collection_contacts.collection_id IN (#valuelist(collID.collection_id)#) AND
				address_type='e-mail' AND
				contact_role='data quality'
			GROUP BY address
		</cfquery>
		<cfloop query="whatEmails">
			<cfset thisAddress = listappend(thisAddress,address)>
		</cfloop>
	</cfif>	
	<cfscript>
		variables.joFileWriter = createObject('Component', '/component.FileWriter').init(variables.XMLFile, variables.encoding, 32768);
		/*
		a='<bnhmmaps>' & chr(10) & 
			chr(9) & '<metadata>' & chr(10) & 
			chr(9) & chr(9) & '<name>BerkeleyMapper Configuration File</name>' & chr(10) & 
			chr(9) & chr(9) & '<relatedinformation>#Application.serverRootUrl#</relatedinformation>' & chr(10) & 
			chr(9) & chr(9) & '<abstract>GIS configuration file for specimen query interface</abstract>' & chr(10) & 
			chr(9) & chr(9) & '<mapkeyword keyword="specimens"/>' & chr(10) & 
			chr(9) & chr(9) & '<header location="#Application.mapHeaderUrl#"/>' & chr(10) & 
			chr(9) & chr(9) & '<linkbackheader location="#Application.serverRootUrl#"/>' & chr(10) & 
			chr(9) & chr(9) & '<footer location="#Application.mapFooterUrl#"/>' & chr(10) & 
			chr(9) &'</metadata>';
		variables.joFileWriter.writeLine(a);
		*/
	</cfscript>
	<cfquery name="whatColls" dbtype="query">
		select Collection from getMapData group by Collection
	</cfquery>
	<cfset theseColls = valuelist(whatColls.Collection)>
	<cfscript>
		a=chr(9) & '<colors method="field" fieldname="darwin:collectioncode" label="Collection">' & chr(10) &
			chr(9) & chr(9) & '<dominantcolor webcolor="9999cc"/>' & chr(10) & 
			chr(9) & chr(9) & '<subdominantcolor webcolor="9999cc"/>';
		variables.joFileWriter.writeLine(a);
		for (intRow=1;intRow LTE whatColls.RecordCount;intRow=(intRow+1)){
			a=chr(9) & chr(9) & 
				'<color key="#collection#" red="#randRange(0,255)#" green="#randRange(0,255)#" blue="#randRange(0,255)#" symbol="1" label="#collection#"/>';
			variables.joFileWriter.writeLine(a);	
		}
		a=chr(9) & chr(9) &
			'<color key="default" red="255" green="0" blue="0" symbol="2" label="Unspecified Collection"/>' & chr(10) & 
			chr(9) & '</colors>';
		variables.joFileWriter.writeLine(a);
		a=chr(9) & '<settings>' & chr(10) & 
			chr(9) & chr(9) & '<setting name="landsat" show="0"></setting>' & chr(10) & 
			chr(9) & chr(9) & '<setting name="maxerrorinmeters" show="1"></setting>' & chr(10) & 
			chr(9) & '</settings>';
		variables.joFileWriter.writeLine(a);
		a=chr(9) & '<recordlinkback>' & chr(10) & 
			chr(9) & chr(9) & '<linkback method="entireurl" linkurl="Related Information" fieldname="More Information (opens in new window)"/>' & chr(10) & 
			chr(9) & '</recordlinkback>';
		variables.joFileWriter.writeLine(a);
		a=chr(9) & '<annotation show="1">' & chr(10) & 
			chr(9) & chr(9) & '<annotation_replyto_email value="#thisAddress#" />' & chr(10) & 
			chr(9) & '</annotation>';		
		variables.joFileWriter.writeLine(a);
		a=chr(9) & '<concepts>' & chr(10) & 
			chr(9) & '<concept order="1" viewlist="0" colorlist="0" datatype="darwin:relatedinformation"  alias="Related Information" />' & chr(10) & 
			chr(9) & chr(9) & '<concept order="2" viewlist="1" colorlist="1" datatype="darwin:scientificname" alias="Scientific Name"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="3" viewlist="1" colorlist="0" datatype="char120_1" alias="Verbatim Date"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="4" viewlist="1" colorlist="0" datatype="darwin:locality" alias="Specific Locality"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="5" viewlist="0" colorlist="0" datatype="darwin:decimallatitude" alias="Decimal Latitude"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="6" viewlist="0" colorlist="0" datatype="darwin:decimallongitude" alias="Decimal Longitude"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="7" viewlist="1" colorlist="0" datatype="darwin:coordinateuncertaintyinmeters" alias="Coordinate Uncertainty In Meters"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="8" viewlist="1" colorlist="0" datatype="darwin:horizontaldatum" alias="Horizontal Datum"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="9" viewlist="0" colorlist="0" datatype="darwin:collectioncode" alias="Collection Code"/>' & chr(10) & 
			chr(9) & chr(9) & '<concept order="10" viewlist="1" colorlist="0" datatype="darwin:catalognumbertext" alias="Catalog Number"/>' & chr(10) & 
			chr(9) & '</concepts>';		
		variables.joFileWriter.writeLine(a);
	</cfscript>
	<cfif isdefined("showRangeMaps") and showRangeMaps is true>
		<cfquery name="species" dbtype="query">
			select distinct(scientific_name) from getMapData
		</cfquery>
		<cfquery name="getClass" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select phylclass,genus || ' ' || species scientific_name from taxonomy where scientific_name in
			 (#ListQualify(valuelist(species.scientific_name), "'")#)
		</cfquery>
		<cfscript>
			a=chr(9) & '<gisdata>';
			variables.joFileWriter.writeLine(a);
			for (intRow=1;intRow LTE getClass.RecordCount;intRow=(intRow+1)){
				name='';
				if (phylclass=='Amphibia') {
					name='gaa';
				} else if ( phylclass=='Mammalia' ) {
					name='mamm';
				} else if (phylclass=='Aves') {
					name='birds';
				}
				if (len(name) gt 0) {
					a=chr(9) & chr(9) &	'<layer title="#scientific_name#" name="#name#" location="#scientific_name#" legend="#i#" active="1" url=""/>';
					variables.joFileWriter.writeLine(a);
				}
			}
			a=chr(9) & '</gisdata>';
			variables.joFileWriter.writeLine(a);
		</cfscript>
	</cfif>
	<cfscript>
		a='</bnhmmaps>';
		variables.joFileWriter.writeLine(a);
		variables.joFileWriter.close();
	</cfscript>
</cfoutput>

<!-------------------------------------------->


<cfset dlPath = "#Application.webDirectory#/bnhmMaps/tabfiles/">
<cfset dlFile = "tabfile#cfid##cftoken#.txt">
<cffile action="write" file="#dlPath##dlFile#" addnewline="no" output="" nameconflict="overwrite">

<cfoutput query="getMapData">
	<cfset catalogNumber="#collection# #cat_num#">
	<cfset relInfo='<a href="#Application.serverRootUrl#/SpecimenDetail.cfm?collection_object_id=#collection_object_id#" target="_blank">#collection#&nbsp;#cat_num#</a>'>
	<cfset oneLine="#relInfo##chr(9)##scientific_name##chr(9)##verbatim_date##chr(9)##spec_locality##chr(9)##dec_lat##chr(9)##dec_long##chr(9)##COORDINATEUNCERTAINTYINMETERS##chr(9)##datum##chr(9)##collection##chr(9)##catalogNumber#">
		
		
	<cfset oneLine=trim(oneLine)>
	<cffile action="append" file="#dlPath##dlFile#" addnewline="yes" output="#oneLine#">
</cfoutput>
<cfoutput>
<cfquery name="distColl" dbtype="query">
	select collection from getMapData group by collection
	order by collection
</cfquery>
<cfset collList="">
<cfloop query="distColl">
	<cfif len(#collList#) is 0>
		<cfset collList="#collection#">
	<cfelse>
		<cfset CollList="#collList#, #collection#">
	</cfif>
</cfloop>
<cfset listColl=reverse(CollList)>
<cfset listColl=replace(listColl,",","dna ,","first")>
<cfset CollList=reverse(listColl)>
<cfset CollList="#CollList# data.">


	<cfset bnhmUrl="http://berkeleymapper.berkeley.edu/run.php?ViewResults=tab&tabfile=#Application.serverRootUrl#/bnhmMaps/tabfiles/#dlFile#&configfile=#XMLFile#&sourcename=#collList#&queryerrorcircles=1">
	
	<script type="text/javascript" language="javascript">
		document.location='#bnhmUrl#';
	</script>
</cfoutput>