<cfset rptprd=10>
<cfset mincount=1>
<cfoutput>
	<cfquery name="d" datasource="uam_god">
			SELECT
			regexp_replace(ip,'^([0-9]{1,3}\.[0-9]{1,3})\..*$','\1') subnet,
			count(*) attempts
		from
			blacklisted_entry_attempt
			where
			to_char(timestamp,'yyyy-mm-dd') >= sysdate-#rptprd#
		having
			count(*) > #mincount#
		group by
			regexp_replace(ip,'^([0-9]{1,3}\.[0-9]{1,3})\..*$','\1')
		 order by
		 	count(*) DESC
	</cfquery>

	<cfquery name="ma" dbtype="query">
		select max(attempts) as mat from d
	</cfquery>


	<cfquery name="sa" dbtype="query">
		select sum(attempts) as sat from d
	</cfquery>

	<cfmail subject="blacklisted entry attempt report (#ma.mat#: #sa.sat#)" to="dustymc@gmail.com" from="blacklistreport@#application.fromEmail#" type="html">
		<p>
			blacklisted_entry_attempt for the last #rptprd# day(s), containing only those subnets originating > #mincount# attempts
		</p>
		<p>
			More info at <a href="#Application.serverRootURL#/info/blacklistattempt.cfm">#Application.serverRootURL#/info/blacklistattempt.cfm</a>
		</p>
		<cfloop query="d">
			<br>#subnet# (attempts: #attempts#)
		</cfloop>
	</cfmail>
</cfoutput>