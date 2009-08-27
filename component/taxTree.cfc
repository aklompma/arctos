<cfcomponent>
<cffunction name="getNodes" access="remote">
    <cfargument name="path" type="String" required="false" default=""/>
    <cfargument name="value" type="String" required="true" default=""/>
    <!--- set up return array --->
        <cfset var result= arrayNew(1)/>
        <cfset var s =""/>

        <!--- if arguments.value is empty the tree is being built for the first time --->
        <cfif arguments.value is "">
            	<cfquery name="qry" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
					select nvl(kingdom,'unknown') data from taxonomy group by kingdom order by kingdom
				</cfquery>
				<cfset y=0>
				<cfloop query="qry">
					<cfset y = y + 1/>
	                <cfset s = structNew()/>
	                <cfset s.value=#qry.data#>
	                <cfset s.display="#qry.data# (kingdom)">
	                <cfset s.leafnode=false/>
	                <cfset arrayAppend(result,s)/>
				</cfloop>
        <cfelse>
        <!--- arguments.value is not empty --->
        <!--- to keep it simple we will only make children nodes --->
        <cfset y = 0/>
            <cfloop from="1" to="#arguments.value#" index="q">
                <cfset y = y + 1/>
                <cfset s = structNew()/>
                <cfset s.value=#q#>
                <cfset s.display="Leaf #q#">
                <cfset s.leafnode=true/>
                <cfset arrayAppend(result,s)/>
            </cfloop>
        </cfif>
    <cfreturn result/>
</cffunction>
</cfcomponent>