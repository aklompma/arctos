
	<cfquery name="one" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from locality where locality_remarks like '%{"UTM":"%';
	</cfquery>

	<cfdump var=#one#>


<cfoutput>
<cfloop query="one">
	<br>#locality_remarks#

	<cfset lremk=mid(locality_remarks,find(locality_remarks,'{',1),find(locality_remarks,'}',1))>
	<br>lremk:#lremk#

</cfloop>



</cfoutput>
