<cfquery name="d" datasource="uam_god">
		SELECT dbms_metadata.get_ddl('TABLE', 'ATTRIBUTES') x FROM DUAL
</cfquery>

<cfoutput>
	#d.x#
</cfoutput>
<CFDUMP VAR=#D#>

