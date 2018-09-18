<cfif not isdefined("doi") or len(doi) is 0>
	DOI is required
</cfif>
<cfoutput>
	<cfhttp method="get" url="https://api.crossref.org/v1/works/http://dx.doi.org/#doi#">
		<cfhttpparam type = "header" name = "User-Agent" value = "Arctos (https://arctos.database.museum; mailto:dustymc@gmail.com)">
	</cfhttp>
	<cfif not isjson(cfhttp.Filecontent)>
		invalid return
		<cfdump var=#cfhttp#>
		<cfabort>
	</cfif>

	<cfset x=DeserializeJSON(cfhttp.Filecontent)>

	<cfif structKeyExists(x.message,"title")>
		<cfset tar=x.message["title"]>
		<p>
				<cfdump var=#tar[0]#>
		</p>

	</cfif>

	<cfif structKeyExists(x.message,"reference")>
		<cfdump var=#x.message.reference#>
		<cfloop array="#x.message.reference#" index="idx">
		   <cfdump var="#idx#">
		    <cfset rfs="">
		    <cfif StructKeyExists(idx, "author")>
				<cfset rfs=rfs & idx["author"]>
			</cfif>
		    <cfif StructKeyExists(idx, "year")>
				<cfset rfs=rfs & ' ' & idx["year"] & '. '>
			</cfif>
		   <cfif StructKeyExists(idx, "article-title")>
			   <cfset rfs=rfs & idx["article-title"]>
			<cfelseif StructKeyExists(idx, "volume-title")>
			   <cfset rfs=rfs & idx["volume-title"]>
					journal-title
			</cfif>
		   <cfif StructKeyExists(idx, "doi")>
				<cfset rfs=rfs & '. <a class="external" target="_blank" href="http://dx.doi.org/#idx["doi"]#">http://dx.doi.org/#idx["doi"]#</a>'>
			</cfif>
			<br>#rfs#
		</cfloop>
	</cfif>


							<cfdump var=#cfhttp#>

	<cfdump var=#x#>


</cfoutput>