<!--- no security --->
<cfinclude template="../includes/_pickHeader.cfm">
<cfif action is "nothing">

<script>

	 function fileSelected() {
        var file = document.getElementById('fileToUpload').files[0];
        if (file) {
          var fileSize = 0;
          if (file.size > 1024 * 1024)
            fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
          else
            fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

          document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
          document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
          document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
        }
      }

      function uploadFile() {
        var fd = new FormData();
        fd.append("fileToUpload", document.getElementById('fileToUpload').files[0]);
        var xhr = new XMLHttpRequest();
        xhr.upload.addEventListener("progress", uploadProgress, false);
        xhr.addEventListener("load", uploadComplete, false);
        xhr.addEventListener("error", uploadFailed, false);
        xhr.addEventListener("abort", uploadCanceled, false);
        xhr.open("POST", "/component/utilities.cfc?method=loadFile&returnFormat=json");
        xhr.send(fd);
      }

      function uploadProgress(evt) {
        if (evt.lengthComputable) {
          var percentComplete = Math.round(evt.loaded * 100 / evt.total);
          document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
        }
        else {
          document.getElementById('progressNumber').innerHTML = 'unable to compute';
        }
      }

      function uploadComplete(evt) {
        /* This event is raised when the server send back a response */
		console.log(evt.target.responseText);


		var result = JSON.parse(evt.target.responseText);

		console.log(result);

        if (result.STATUSCODE=='200'){
        	$("#uploadmediaform").hide();
        	var h='<form name="nm" method="post" action="specimenMedia.cfm">';
        	h+='<label for="media_uri">Media URI</label>';
        	h+='<input type="text" name="media_uri" class="reqdClr" id="media_uri" size="80" value="' + result.MEDIA_URI + '">';
        	h+='<a href="' + result.MEDIA_URI + '" target="_blank" class="external">open</a>';
        	h+='<label for="preview_uri">Preview URI</label>';
        	h+='<input type="text" name="preview_uri" id="preview_uri" size="80" value="' + result.PREVIEW_URI + '">';
        	h+='<a href="' + result.PREVIEW_URI + '" target="_blank" class="external">open</a>';

        	h+='<label for="media_license_id">License</label>';
        	h+='<select name="media_license_id" id="media_license_id"></select>';

			h+='<label for="mime_type">MIME Type</label>';
        	h+='<select name="mime_type" id="mime_type" class="reqdClr"></select>';


			h+='<label for="media_type">Media Type</label>';
        	h+='<select name="media_type" id="media_type" class="reqdClr"></select>';


        	h+='<label for="creator">Created By</label>';
        	h+='<input type="hidden" name="created_agent_id" id="created_agent_id">';

        	h+='<input type="text" name="creator" id="creator"';
			h+='onchange="pickAgentModal(\'creator\',this.id,this.value); return false;"';
			h+='onKeyPress="return noenter(event);" placeholder="pick creator" class="minput">';

			h+='<label for="description">Description</label>';
        	h+='<input type="text" name="description" id="description" size="80">';


			h+='<label for="made_date">Made Date</label>';
        	h+='<input type="text" name="made_date" id="made_date">';





			h+='<br><input type="submit" value="create media">';
			h+='</form>';




			$("#newMediaUpBack").html(h);




			$('#ctmedia_license').find('option').clone().appendTo('#media_license_id');
			$('#ctmime_type').find('option').clone().appendTo('#mime_type');
			$('#ctmedia_type').find('option').clone().appendTo('#media_type');

			$("#made_date").datepicker();

        } else {
        	alert('ERROR: ' + result.MSG);
        }
      }

      function uploadFailed(evt) {
        alert("There was an error attempting to upload the file.");
      }

      function uploadCanceled(evt) {
        alert("The upload has been canceled by the user or the browser dropped the connection.");
      }



</script>

<cfoutput>
	<cfquery name="ctmedia_license" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from ctmedia_license order by DISPLAY
	</cfquery>
	<cfquery name="ctmime_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from ctmime_type order by mime_type
	</cfquery>
	<cfquery name="ctmedia_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from ctmedia_type order by media_type
	</cfquery>
	<div style="display:none">
		<!--- easy way to get stuff for new media - just clone from here ---->
		<select name="ctmedia_type" id="ctmedia_type">
			<option></option>
			<cfloop query="ctmedia_type">
				<option value="#media_type#">#media_type#</option>
			</cfloop>
		</select>
		<select name="ctmedia_license" id="ctmedia_license">
			<option></option>
			<cfloop query="ctmedia_license">
				<option value="#MEDIA_LICENSE_ID#">#DISPLAY#</option>
			</cfloop>
		</select>
		<select name="ctmime_type" id="ctmime_type">
			<option></option>
			<cfloop query="ctmime_type">
				<option value="#mime_type#">#mime_type#</option>
			</cfloop>
		</select>
	</div>


<hr>Upload Media Files

	<div id="uploadmediaform">
		<form id="form1" enctype="multipart/form-data" method="post" action="">
			<div class="row">
			<label for="fileToUpload">Select a File to Upload</label>
			<input type="file" name="fileToUpload" id="fileToUpload" onchange="fileSelected();"/>
			</div>
			<div id="fileName"></div>
			<div id="fileSize"></div>
			<div id="fileType"></div>
			<div class="row">
			<input type="button" onclick="uploadFile()" value="Upload" />
			</div>
			<div id="progressNumber"></div>
		</form>
	</div>
	<div id="newMediaUpBack"></div>

	<hr>Link specimen to existing Arctos Media
	<span class="likeLink" onclick="findMedia('p_media_uri','p_media_id');">Click here to pick</span>
	<form id="picklink" method="post" action="specimenMedia.cfm">
		<input type="hidden" name="action" value="linkpicked">
		<input type="hidden" name="collection_object_id" value="#collection_object_id#">
		<input type="text" name="p_media_id" id="p_media_id">
		<input type="text" size="80" name="p_media_uri" id="p_media_uri">
		<br><input type="submit" value="link specimen to picked media">
	</form>


	<hr>
	Existing Media for this specimen


	<cfquery name="smed" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select distinct
			media.media_id,
			media.MEDIA_URI,
			media.MIME_TYPE,
			media.MEDIA_TYPE,
			media.PREVIEW_URI,
			media.MEDIA_LICENSE_ID,
			media.MEDIA_URI,
			ctmedia_license.DISPLAY,
			ctmedia_license.DESCRIPTION,
			ctmedia_license.URI
		from
			media_relations,
			media,
			ctmedia_license
		where
			media_relations.media_relationship='shows cataloged_item' and
			media_relations.related_primary_key=#collection_object_id# and
			media_relations.media_id=media.media_id and
			media.MEDIA_LICENSE_ID=ctmedia_license.MEDIA_LICENSE_ID (+)
		order by
			media_id
	</cfquery>
	<cfset  func = CreateObject("component","component.functions")>
	<cfloop query="smed">
		<cfset relns=func.getMediaRelations(media_id=#media_id#)>
		<div>
			<cfset mp = func.getMediaPreview(preview_uri="#preview_uri#",media_type="#media_type#")>
			<img src="#mp#" style="max-width:150px;max-height:150px;">
			<br>
			<a href="/media.cfm?action=edit&media_id=#media_id#">Edit Media</a> to edit things which are not available here.
			<br>MEDIA_URI: #MEDIA_URI#
			<br>MIME_TYPE: #MIME_TYPE#
			<br>MEDIA_TYPE: #MEDIA_TYPE#
			<br>PREVIEW_URI: #PREVIEW_URI#
			<br>MEDIA_LICENSE_ID: #MEDIA_LICENSE_ID#
			<br>MEDIA_URI: #MEDIA_URI#
			<br>License: <a href="#media_id#" class="external" target="_blank">#DISPLAY# (#DESCRIPTION#)</a>
			<cfloop query="relns">
				<br>#MEDIA_RELATIONSHIP# #SUMMARY# (#LINK#)
			</cfloop>
			<cfquery name="lbl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
				select MEDIA_LABEL,LABEL_VALUE from media_labels where media_id=#media_id# order by media_label,label_value
			</cfquery>
			<cfloop query="lbl">
				<br>#MEDIA_LABEL#: #LABEL_VALUE#
			</cfloop>
		</div>
	</cfloop>

</cfoutput>
</cfif>
<cfif action is "linkpicked">
	<cfoutput>
		<cfquery name="linkpicked" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			insert into media_relations (
				MEDIA_ID,
				MEDIA_RELATIONSHIP,
				CREATED_BY_AGENT_ID,
				RELATED_PRIMARY_KEY
			) values (
				#p_media_id#,
				'shows cataloged_item',
				#session.myAgentId#,
				#collection_object_id#
			)
		</cfquery>
		<cflocation url="specimenMedia.cfm?collection_object_id=#collection_object_id#">
	</cfoutput>
</cfif>






<!----
<form action="/component/utilities.cfc?method=loadFile&returnFormat=json" class="dropzone" id="demo-upload">

  <div class="dz-message">
    Drop files here or click to upload.<br />
    <span class="note">(This is just a demo dropzone. Selected files are <strong>not</strong> actually uploaded.)</span>
  </div>

</form>

<form name="m">
	<input type="text" name="media_uri" id="media_uri">
	<input type="text" name="media_id" id="media_id">
</form>
---->
</p>

<cfinclude template="../includes/_pickFooter.cfm">