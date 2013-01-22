<cfinclude template="/includes/_header.cfm">
<cfoutput>
	<cfquery name="d" datasource="uam_god">
		select
			collection.collection_id,
			collection.collection,
			collection.descr,
			collection.citation,
			collection.web_link,
			display,
			uri
		from
			collection,
			ctmedia_license
		where
			collection.USE_LICENSE_ID=ctmedia_license.media_license_id (+)
			and collection_id=29
	</cfquery>
<cfdump var=#d#>
<cfloop query="d">
	<br>collection: #collection#
	<br>descr: #descr#
	<br>citation: #citation#
	<br>web_link: #web_link#
	<br>display: #display#
	<br>uri: #uri#
	<cfquery name="gc" datasource="uam_god">
		select continent_ocean from flat where collection_id=#collection_id# group by continent_ocean
	</cfquery>
	<br>Geographic  Coverage: #valuelist(gc.continent_ocean)#
	<cfquery name="tc" datasource="uam_god">
		select phylclass from flat where collection_id=#collection_id# group by phylclass
	</cfquery>
	<br>taxonomic  Coverage: #valuelist(tc.phylclass)#

	<cfquery name="tec" datasource="uam_god">
		select min(began_date) earliest, max(ended_date) latest from flat where collection_id=#collection_id#
	</cfquery>
	<br>temporal  Coverage: #tec.earliest# to #tec.latest#


	<br>
</cfloop>
<cfabort>
	</cfoutput>

		    - new text field in Collection


			why wouldn't this come from the data?

	    Description* - new text field for Collection (general description about the collection)


	 collection.description - we've always had this


	    Resource Contact*


	all from collection contacts - we may need some new roles, and new types of agent address etc. (I suspect some Curators aren't going to want all of their contact information published)

	http://arctos.database.museum/info/ctDocumentation.cfm?table=CTCOLL_CONTACT_ROLE
	http://arctos.database.museum/info/ctDocumentation.cfm?table=CTADDR_TYPE
	http://arctos.database.museum/info/ctDocumentation.cfm?table=CTELECTRONIC_ADDR_TYPE

	This may affect http://code.google.com/p/arctos/issues/detail?id=499 - I added a comment to the Issue.



	    -- First Name  ===> Parsed from Agents/Preferred Name


	 person.first_name


	    -- Last Name ===> Parsed from Agents/Preferred Name


	person.last_name

	    -- Position ===> Agents/Job Title
	    -- Organisation ===> Agent Address/Institution
	    -- Address ===> Agent Address
	    -- City ===> Agent Address
	    -- State/Prov ===> Agent Address
	    -- Country ===> Agent Address
	    -- Postal Code ===> Agent Address
	    -- Phone ===> Agent Address
	    -- Email ===> Agent Address
	    -- Home Page ===> Collection/Web Link


	or agent's electronic_address?


	    Resource Creator* - can be same as Resource Contact (or could be Laura or John who create the resource?)


	or just another collection_contact_role


	    Metadata Provider*  - can be same as Resource Contact


	or just another collection_contact_role




	    Taxonomic Coverage - new text field in Collection


	why wouldn't this come from the data?


	    Temporal Coverage - new text field in Collection


	why wouldn't this come from the data?


	    Associated Parties - by default, we would add Laura Russell, Dave Bloom, and John Wieczorek; we could also add other resource contacts (e.g., curatorial staff in addition to main resource contact)


	more collection_contact_roles - we shouldn't need a programmer to change this when one of those folks gets a new email address or something.



	    Citations - new text field in Collection (how resource should be cited in publications, e.g., Museum of Vertebrate Zoology, University of California, Berkeley)


	Not quite sure I get this. What is it that you'd like cited with your example? Should this say something about citing specimens, or ????


	    Additional Metadata: IP Rights - new text field in Collection, statement about data licensing and use (we require this for VN)


	new field in collection, foreign key to http://arctos.database.museum/info/ctDocumentation.cfm?table=CTMEDIA_LICENSE (which just became poorly-named)




