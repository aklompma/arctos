
<!--------------
Documentation: http://n2t.net/ezid/doc/apidoc.html

	Username: apitest

	Pword: apitest


		 A client manipulates an identifier by performing HTTP operations on its EZID URL: PUT to create the identifier, GET to view it,
		 and POST to modify it.

		 If a request comes in with an HTTP Accept header that expresses a preference for any form of HTML or XML,
		 the UI is invoked; otherwise, the API is invoked.

		c.setRequestProperty("Accept", "text/plain");


		r.add_header("Authorization", "Basic " + base64.b64encode("username:password"))

	<cfset title=URLEncodedFormat('ALA V122164: Draba palanderiana Kjellman')>
	<cfset creator=URLEncodedFormat('this is a test')>

	<cfset publisher=URLEncodedFormat('MVZ')>
	<cfset pyear=	URLEncodedFormat('2013')>
	<cfset dURL=URLEncodedFormat('http://arctos-test.tacc.utexas.edu/media/56925')>
	<cfset params='{
		url = "https://n2t.net/",
		method = "PUT",
		password = "apitest",
		path = "ezid/id/",
		username = "apitest",
		title="#title#",
		creator="#creator#",
		publisher="#publisher#",
		publication year="#pyear#",
		url="#dURL#"
	}'>

		<cfhttp attributecollection="#params#"></cfhttp>



			method="get"
			path="ezid/id/"
			username="apitest"
			password="apitest"
				port="443">
			<cfhttpparam
			    type = "header"
			    name = "Accept"
			    value = "text/plain">

				<cfhttpparam
							    type = "header"
							    name = "ark"
							    value = "/99999/fk4cz3dh0">




			<cfhttpparam type = "formField" name = "datacite.creator" value = "Arctos">
			<cfhttpparam type = "formField" name = "datacite.title" value = "this is a title">
			<cfhttpparam type = "formField" name = "datacite.publisher" value = "this is hte publisher">
			<cfhttpparam type = "formField" name = "datacite.publicationyear" value = "1842">
			<cfhttpparam type = "formField" name = "datacite.resourcetype" value = "Image">

		-------------->
https://n2t.net/ezid/id/

<cfset x="creator: Arctos,
		title: this is a title,
		publisher: this is hte publisher,
		publicationyear: 1842,
		resourcetype: Image">


		<cfhttp username="apitest" password="apitest" method="POST" url="https://n2t.net/ezid/shoulder/doi:10.5072/FK2">
			<cfhttpparam type = "header" name = "Accept" value = "text/plain">
			<cfhttpparam type = "header" name = "Content-Type" value = "text/plain; charset=UTF-8">




			<cfhttpparam type = "BODY"  value = "#x#">
			<cfhttpparam type = "header" name = "_target" value = "http://arctos-test.tacc.utexas.edu/media/10219911">
		</cfhttp>




		<cfdump var=#cfhttp#>