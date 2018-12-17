
<!---------
for the first run get this from the temp table
needs rebuilt to something like this once that's done

--->

<cfquery name="d" datasource="uam_god">
	select
		taxon_name_id,
		term aphiaid ,
		sysdate-lastdate,
		lastdate
	from
		taxon_term
	where
		source='WoRMS (via Arctos)' and
		term_type='aphiaid' and
		sysdate-lastdate > 30
</cfquery>

<cfoutput>
<cfset tc = CreateObject("component","component.taxonomy")>

<cfloop query="d">
	<cfset x=tc.updateWormsArctosByAphiaID(aphiaid,taxon_name_id)>
	<cfif isdefined("x.STATUS") and x.STATUS is "success">
		success
		<cfset ps=1>
	<cfelse>
		fail
			<cfdump var=#x#>

		<cfset ps=0>
	</cfif>
	<cfquery name="g" datasource="uam_god">
		update temp_worms set init_pull=#ps# where taxon_name_id='#taxon_name_id#'
	</cfquery>
	<br><a target="_blank" href="/name/#scientificname###WoRMSviaArctos">#scientificname#</a>
	<!--- be nice, take a short nap --->
	<cfset sleep(5000)>

</cfloop>
</cfoutput>