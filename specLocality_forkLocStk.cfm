<cfinclude template="/includes/alwaysInclude.cfm">
<cfif not listfindnocase(session.roles,'manage_specimens')>
	<div class="error">
		not authorized
	</div>
	<cfabort>
</cfif>
<style type="text/css">
	#map-canvas { height: 300px;width:500px; }
</style>

<cfset obj = CreateObject("component","component.functions")>
	<cfset murl=obj.googleSignURL(urlPath="/maps/api/js",urlParams="libraries=geometry")>
	<cfoutput>
		<cfhtmlhead text='<script src="#murl#" type="text/javascript"></script>'>
	</cfoutput>



<script language="javascript" type="text/javascript">
	jQuery(document).ready(function() {
		$("#began_date").datepicker();
		$("#ended_date").datepicker();
		$(":input[id^='geo_att_determined_date']").each(function(e){
			$("#" + this.id).datepicker();
		});
		$("select[id^='geology_attribute_']").each(function(e){
			populateGeology(this.id);
		});
		if (window.addEventListener) {
			window.addEventListener("message", getGeolocate, false);
		} else {
			window.attachEvent("onmessage", getGeolocate);
		}
	});
	function populateGeology(id) {
		if (id.indexOf('__') > -1) {
			var idNum=id.replace('geology_attribute__','');
			var thisValue=$("#geology_attribute__" + idNum).val();;
			var dataValue=$("#geo_att_value__" + idNum).val();
			var theSelect="geo_att_value__";
			if (thisValue == ''){
				return false;
			}
		} else {
			// new geol attribute
			var idNum='';
			var thisValue=$("#geology_attribute").val();
			var dataValue=$("#geo_att_value").val();
			var theSelect="geo_att_value";
		}
		jQuery.getJSON("/component/functions.cfc",
			{
				method : "getGeologyValues",
				attribute : thisValue,
				returnformat : "json",
				queryformat : 'column'
			},
			function (r) {
				var s='';
				for (i=0; i<r.ROWCOUNT; ++i) {
					s+='<option value="' + r.DATA.ATTRIBUTE_VALUE[i] + '"';
					if (r.DATA.ATTRIBUTE_VALUE[i]==dataValue) {
						s+=' selected="selected"';
					}
					s+='>' + r.DATA.ATTRIBUTE_VALUE[i] + '</option>';
				}
				$("select#" + theSelect + idNum).html(s);
			}
		);
	}

	function verifByMe(i,u){
		$("#verified_by_agent_name").val(u);
		$("#verified_by_agent_id").val(i);
		$("#verified_date").val(getFormattedDate());
	}

</script>
<span class="helpLink" data-helplink="specimen_event">Page Help</span>
<script>
	function showLLFormat(orig_units) {
		//alert(orig_units);
		var llMeta = document.getElementById('llMeta');
		var decdeg = document.getElementById('decdeg');
		var utm = document.getElementById('utm');
		var ddm = document.getElementById('ddm');
		var dms = document.getElementById('dms');
		llMeta.style.display='none';
		decdeg.style.display='none';
		utm.style.display='none';
		ddm.style.display='none';
		dms.style.display='none';
		//alert('everything off');
		if (orig_units.length > 0) {
			//alert('got soemthing');
			$("#orig_lat_long_units").val(orig_units);
			llMeta.style.display='';
			if (orig_units == 'decimal degrees') {
				decdeg.style.display='';
			}
			else if (orig_units == 'UTM') {
				//alert(utm.style.display);
				utm.style.display='';
				//alert(utm.style.display);
			}
			else if (orig_units == 'degrees dec. minutes') {
				ddm.style.display='';
			}
			else if (orig_units == 'deg. min. sec.') {
				dms.style.display='';
			}
			else {
				alert('I have no idea what to do with ' + orig_units);
			}
		}
	}
	function geolocate(method) {
		//alert('This opens a map. There is a help link at the top. Use it. The save button will create a new determination.');
		var guri='https://www.geo-locate.org/web/WebGeoreflight.aspx?georef=run';
		if (method=='adjust'){
			guri+="&tab=result&points=" + $("#dec_lat").val() + "|" + $("#dec_long").val() + "|||" + $("#error_in_meters").val();
		} else {
			guri+="&state=" + $("#state_prov").val();
			guri+="&country="+$("#country").val();
			guri+="&county="+$("#county").val().replace(" County", "");
			guri+="&locality="+$("#spec_locality").val();
		}
		var bgDiv = document.createElement('div');
		bgDiv.id = 'bgDiv';
		bgDiv.className = 'bgDiv';
		bgDiv.setAttribute('onclick','closeGeoLocate("clicked closed")');
		document.body.appendChild(bgDiv);
		var popDiv=document.createElement('div');
		popDiv.id = 'popDiv';
		popDiv.className = 'editAppBox';
		document.body.appendChild(popDiv);
		var cDiv=document.createElement('div');
		cDiv.className = 'fancybox-close';
		cDiv.id='cDiv';
		cDiv.setAttribute('onclick','closeGeoLocate("clicked closed")');
		$("#popDiv").append(cDiv);
		var hDiv=document.createElement('div');
		hDiv.className = 'fancybox-help';
		hDiv.id='hDiv';
		//hDiv.innerHTML='<a href="https://arctosdb.wordpress.com/how-to/create/data-entry/geolocate/" target="blank">[ help ]</a>';
		//hDiv.innerHTML='<span class="helpLink" id="geolocate">[ help ]</span>';

		$("#popDiv").append(hDiv);
		$("#popDiv").append('<img src="/images/loadingAnimation.gif" class="centeredImage">');
		var theFrame = document.createElement('iFrame');
		theFrame.id='theFrame';
		theFrame.className = 'editFrame';
		theFrame.src=guri;
		$("#popDiv").append(theFrame);
	}
	function getGeolocate(evt) {
		var message;
		if (evt.origin !== "https://www.geo-locate.org") {
	    	alert( "iframe url does not have permision to interact with me" );
	        closeGeoLocate('intruder alert');
	    }
	    else {
	    	var breakdown = evt.data.split("|");
			if (breakdown.length == 4) {
			    var glat=breakdown[0];
			    var glon=breakdown[1];
			    var gerr=breakdown[2];
			    useGL(glat,glon,gerr)
			} else {
				alert( "Whoa - that's not supposed to happen. " +  breakdown.length);
				closeGeoLocate('ERROR - breakdown length');
	 		}
	    }
	}
	function closeGeoLocate(msg) {
		$('#bgDiv').remove();
		$('#bgDiv', window.parent.document).remove();
		$('#popDiv').remove();
		$('#popDiv', window.parent.document).remove();
		$('#cDiv').remove();
		$('#cDiv', window.parent.document).remove();
		$('#theFrame').remove();
		$('#theFrame', window.parent.document).remove();
	}
	$(document).ready(function() {
		$("input[type='date'], input[type='datetime']" ).datepicker();


		var map;
 		var mapOptions = {
        	center: new google.maps.LatLng($("#s_dollar_dec_lat").val(), $("#s_dollar_dec_long").val()),
         	mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var bounds = new google.maps.LatLngBounds();
		function initialize() {
        	map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
      	}
		initialize();
		var latLng1 = new google.maps.LatLng($("#dec_lat").val(), $("#dec_long").val());
		if ($("#dec_lat").val().length>0){
			var marker1 = new google.maps.Marker({
			    position: latLng1,
			    map: map,
			    icon: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png'
			});
			var circleOptions = {
	  			center: latLng1,
	  			radius: Math.round($("#error_in_meters").val()),
	  			map: map,
	  			editable: false
			};
			var circle = new google.maps.Circle(circleOptions);
		}
		var latLng2 = new google.maps.LatLng($("#s_dollar_dec_lat").val(), $("#s_dollar_dec_long").val());
		if ($("#s_dollar_dec_lat").val().length>0){
			var marker2 = new google.maps.Marker({
			    position: latLng2,
			    map: map,
			    icon: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png'
			});
		}
		bounds.extend(latLng1);
        bounds.extend(latLng2);
		// center the map on the points
		map.fitBounds(bounds);
		// and zoom back out a bit, if the points will still fit
		// because the centering zooms WAY in if the points are close together
		var p1 = new google.maps.LatLng($("#dec_lat").val(),$("#dec_long").val());
		var p2 = new google.maps.LatLng($("#s_dollar_dec_lat").val(),$("#s_dollar_dec_long").val());
		var tdis=distHaversine(p1,p2);
		$("#distanceBetween").val(tdis);

		if (tdis < 50) {
			// if hte points are close together autozoom goes too far
			var listener = google.maps.event.addListener(map, "idle", function() {
				if (map.getZoom() > 4) map.setZoom(4);
				google.maps.event.removeListener(listener);
			});
		}



		// add wkt if available
        var wkt=$("#locpoly").val();
        if (wkt.length>0){

        	console.log('going wkt...');
			//using regex, we will get the indivudal Rings
			var regex = /\(([^()]+)\)/g;
			var Rings = [];
			var results;
			while( results = regex.exec(wkt) ) {
			    Rings.push( results[1] );
			    console.log('added ring');
			}
			var ptsArray=[];
			var polyLen=Rings.length;
			//now we need to draw the polygon for each of inner rings, but reversed
			for(var i=0;i<polyLen;i++){
			    AddPoints(Rings[i]);
			    console.log('added polyring');
			}
			var poly = new google.maps.Polygon({
			    paths: ptsArray,
			    strokeColor: '#DC143C',
			    strokeOpacity: 0.8,
			    strokeWeight: 2,
			    fillColor: '#FF7F50',
			    fillOpacity: 0.35
			  });
			  poly.setMap(map);
        }

        // add geowkt if available
        var wkt=$("#geopoly").val(); //this is your WKT string
        if (wkt.length>0){

        	console.log('going geopoly...');
			//using regex, we will get the indivudal Rings
			var regex = /\(([^()]+)\)/g;
			var Rings = [];
			var results;
			while( results = regex.exec(wkt) ) {
			    Rings.push( results[1] );
			    //console.log('added ring');
			}
			var ptsArray=[];
			var polyLen=Rings.length;
			//now we need to draw the polygon for each of inner rings, but reversed
			for(var i=0;i<polyLen;i++){
			    AddPoints(Rings[i]);
			    //console.log('added polyring');
			}
			var poly = new google.maps.Polygon({
			    paths: ptsArray,
			    strokeColor: '#1E90FF',
			    strokeOpacity: 0.8,
			    strokeWeight: 2,
			    fillColor: '#1E90FF',
			    fillOpacity: 0.35
			});
			 poly.setMap(map);
        }



		//function to add points from individual rings, used in adding WKT to the map
		function AddPoints(data){
		    //first spilt the string into individual points
		    var pointsData=data.split(",");
		    //iterate over each points data and create a latlong
		    //& add it to the cords array
		    var len=pointsData.length;
		    for (var i=0;i<len;i++)
		    {
		        var xy=pointsData[i].trim().split(" ");
		        var pt=new google.maps.LatLng(xy[1],xy[0]);
		        ptsArray.push(pt);
		    }
		}
		// END add wkt if available
		// end map setup


	});







</script>
<cfif action is "nothing">
<cfoutput>
<script>
function useGL(glat,glon,gerr){
			showLLFormat('decimal degrees','');
			$("##accepted_lat_long_fg").val('1');
			$("##coordinate_determiner").val('#session.username#');
			$("##determined_by_agent_id").val('#session.myAgentId#');
			$("##determined_date").val('#dateformat(now(),"yyyy-mm-dd")#');
			$("##max_error_distance").val(gerr);
			$("##max_error_units").val('m');
			$("##datum").val('World Geodetic System 1984');
			$("##georefmethod").val('GeoLocate');
			$("##extent").val('');
			$("##gpsaccuracy").val('');
			$("##verificationstatus").val('unverified');
			$("##lat_long_ref_source").val('GeoLocate');
			$("##dec_lat").val(glat);
			$("##dec_long").val(glon);
			$("##lat_long_remarks").val('');
			closeGeoLocate();
		}
</script>
	<cfquery name="l" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
    		select
	specimen_event.collection_object_id,
			 COLLECTING_EVENT.COLLECTING_EVENT_ID,
			 specimen_event_id,
			 locality.LOCALITY_ID,
			 VERBATIM_DATE,
			 VERBATIM_LOCALITY,
			 COLL_EVENT_REMARKS,
			 BEGAN_DATE,
			 ENDED_DATE,
			 geog_auth_rec.GEOG_AUTH_REC_ID,
			 SPEC_LOCALITY,
			 locality.DEC_LAT ,
			 locality.DEC_LONG ,
			 to_meters(locality.max_error_distance,locality.max_error_units) error_in_meters,
			 locality.datum,
			 MINIMUM_ELEVATION,
			 MAXIMUM_ELEVATION,
			 ORIG_ELEV_UNITS,
			 MIN_DEPTH,
			 MAX_DEPTH,
			 DEPTH_UNITS,
			 MAX_ERROR_DISTANCE,
			 MAX_ERROR_UNITS,
			 LOCALITY_REMARKS,
			 georeference_source,
			 georeference_protocol,
			 locality_name,
			 locality.s$dec_lat,
			 locality.s$dec_long,
			 locality.s$elevation,
			 locality.s$geography,
			to_meters(locality.minimum_elevation,locality.orig_elev_units) min_elev_in_m,
			to_meters(locality.maximum_elevation,locality.orig_elev_units) max_elev_in_m,
			locality.wkt_media_id,
			geog_auth_rec.wkt_media_id geopoly,
			  assigned_by_agent_id,
			 getPreferredAgentName(assigned_by_agent_id) assigned_by_agent_name,
			 assigned_date,
			 specimen_event_type,
			 COLLECTING_METHOD,
			 COLLECTING_SOURCE,
			 VERIFICATIONSTATUS,
			 habitat,
			geog_auth_rec.geog_auth_rec_id,
			higher_geog,
			state_prov,
			country,
			county,
			specimen_event_remark,
			specimen_event.VERIFIED_BY_AGENT_ID,
			getPreferredAgentName(specimen_event.VERIFIED_BY_AGENT_ID) verified_by_agent_name,
			specimen_event.VERIFIED_DATE
		from
			geog_auth_rec,
			locality,
			collecting_event,
			specimen_event
		where
			geog_auth_rec.geog_auth_rec_id=locality.geog_auth_rec_id and
			locality.locality_id=collecting_event.locality_id and
			collecting_event.collecting_event_id=specimen_event.collecting_event_id and
			specimen_event.specimen_event_id = #specimen_event_id#
	</cfquery>


	<cfquery name="geology" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		 select
		 	GEOLOGY_ATTRIBUTE_ID,
			GEOLOGY_ATTRIBUTE,
			GEO_ATT_VALUE,
			GEO_ATT_DETERMINER_ID,
			getPreferredAgentName(GEO_ATT_DETERMINER_ID) geo_att_determiner,
			GEO_ATT_DETERMINED_DATE,
			GEO_ATT_DETERMINED_METHOD,
			GEO_ATT_REMARK
		from
			geology_attributes
		where
			locality_id=#l.locality_id#
		order by
			GEOLOGY_ATTRIBUTE
	</cfquery>
	<cfquery name="ctElevUnit" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select orig_elev_units from ctorig_elev_units order by orig_elev_units
	</cfquery>
	<cfquery name="ctdepthUnit" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select depth_units from ctdepth_units order by depth_units
	</cfquery>
     <cfquery name="ctdatum" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select datum from ctdatum order by datum
     </cfquery>
	<cfquery name="ctVerificationStatus" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select VerificationStatus from ctVerificationStatus order by VerificationStatus
	</cfquery>
     <cfquery name="cterror" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select LAT_LONG_ERROR_UNITS from ctLAT_LONG_ERROR_UNITS order by LAT_LONG_ERROR_UNITS
     </cfquery>
     <cfquery name="ctew" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select e_or_w from ctew order by e_or_w
     </cfquery>
     <cfquery name="ctns" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select n_or_s from ctns order by n_or_s
     </cfquery>
     <cfquery name="ctunits" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select orig_lat_long_units from ctLAT_LONG_UNITS order by orig_lat_long_units
     </cfquery>
	<cfquery name="ctcollecting_source" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
        select COLLECTING_SOURCE from ctcollecting_source order by COLLECTING_SOURCE
     </cfquery>
	<cfquery name="ctgeology_attribute" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select geology_attribute from ctgeology_attribute order by geology_attribute
	</cfquery>
	<cfquery name="ctspecimen_event_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
		select specimen_event_type from ctspecimen_event_type order by specimen_event_type
	</cfquery>
	<form name="editForkSpecEvent" method="post" action="specLocality_forkLocStk.cfm">
		<input type="hidden" name="nothing" id="nothing">
		<input type="hidden" name="action" id="action" value="saveEdits">
		<input type="hidden" name="collection_object_id" value="#l.collection_object_id#">
		<input type="hidden" name="collecting_event_id" value="#l.collecting_event_id#">
		<input type="hidden" name="specimen_event_id" value="#l.specimen_event_id#">
		<!--- for geolocate --->
			<input type="hidden" name="error_in_meters" id="error_in_meters" value="#l.error_in_meters#">
			<input type="hidden" name="state_prov" id="state_prov" value="#l.state_prov#">
			<input type="hidden" name="country" id="country" value="#l.country#">
			<input type="hidden" name="county" id="county" value="#l.county#">
		<!--- END for geolocate --->
		<!--- for map --->
			<cfset gp="">
			<cfif len(l.geopoly) gt 0>
				<cfquery name="fmed" datasource="uam_god">
					select media_uri from media where media_id=#l.geopoly#
				</cfquery>
				<cfhttp method="GET" url=#fmed.media_uri#></cfhttp>
				<cfif left(cfhttp.statuscode,3) is "200">
					<cfset gp=cfhttp.filecontent>
				</cfif>
			</cfif>
			<input type="hidden" id="geopoly" value="#gp#">
			<cfset gp="">
			<cfif len(l.wkt_media_id) gt 0>
				<cfquery name="fmed" datasource="uam_god">
					select media_uri from media where media_id=#l.wkt_media_id#
				</cfquery>
				<cfhttp method="GET" url=#fmed.media_uri#></cfhttp>
				<cfif left(cfhttp.statuscode,3) is "200">
					<cfset gp=cfhttp.filecontent>
				</cfif>
			</cfif>
			<input type="hidden" id="locpoly" value="#gp#">
		<!--- END for map --->



		<!-------------------------- specimen_event -------------------------->

		<table>
			<tr>
				<td><!--- main cell --->

					<table>
						<tr>
							<td>
								<label for="specimen_event_type">Specimen/Event Type</label>
								<select name="specimen_event_type" id="specimen_event_type" size="1" class="reqdClr">
									<cfloop query="ctspecimen_event_type">
										<option <cfif ctspecimen_event_type.specimen_event_type is "#l.specimen_event_type#"> selected="selected" </cfif>
											value="#ctspecimen_event_type.specimen_event_type#">#ctspecimen_event_type.specimen_event_type#</option>
								    </cfloop>
								</select>
								<span class="infoLink" onclick="getCtDoc('ctspecimen_event_type');">Define</span>
							</td>
							<td>
								<label for="specimen_event_type">Event Determiner</label>
								<input type="text" name="assigned_by_agent_name" id="assigned_by_agent_name" class="reqdClr" value="#l.assigned_by_agent_name#" size="40"
									 onchange="getAgent('assigned_by_agent_id','assigned_by_agent_name','editForkSpecEvent',this.value); return false;"
									 onKeyPress="return noenter(event);">
								<input type="hidden" name="assigned_by_agent_id" id="assigned_by_agent_id" value="#l.assigned_by_agent_id#">
							</td>
							<td>
								<label for="assigned_date" class="helpLink" data-helplink="specimen_event_date">Determined Date</label>
								<input type="datetime" name="assigned_date" id="assigned_date" value="#dateformat(l.assigned_date,'yyyy-mm-dd')#" class="reqdClr" size="10">
							</td>
						</tr>
						<tr>
							<td>
								<label for="VerificationStatus" class="helpLink" data-helplink="verification_status">Verification Status</label>
								<select name="VerificationStatus" id="verificationstatus" size="1" class="reqdClr">
									<cfloop query="ctVerificationStatus">
										<option <cfif l.VerificationStatus is ctVerificationStatus.VerificationStatus> selected="selected" </cfif>
											value="#VerificationStatus#">#VerificationStatus#</option>
									</cfloop>
								</select>
								<span class="infoLink" onclick="getCtDoc('ctverificationstatus');">Define</span>
							</td>
							<td>
								<input type="hidden" name="verified_by_agent_id" id="verified_by_agent_id" value="#l.verified_by_agent_id#">
								<label for="verified_by_agent_name">Verified By</label>
								<input type="text" name="verified_by_agent_name" id="verified_by_agent_name" value="#l.verified_by_agent_name#" size="40"
									 onchange="pickAgentModal('verified_by_agent_id',this.id,this.value); return false;"
									 onKeyPress="return noenter(event);">
							</td>
							<td>
								<label for="verified_date" class="helpLink" data-helplink="verified_date">Verified Date</label>
								<input type="datetime" size="10" name="verified_date" id="verified_date" value="#dateformat(l.verified_date,'yyyy-mm-dd')#">
								<span class="infoLink" onclick="verifByMe('#session.MyAgentID#','#session.dbuser#');">Me, Today</span>
							</td>
						</tr>
					</table>



					<label for="specimen_event_remark">Specimen/Event Remark</label>
					<input type="text" name="specimen_event_remark" id="specimen_event_remark" value="#stripQuotes(l.specimen_event_remark)#" size="75">

					<label for="habitat">Habitat</label>
					<input type="text" name="habitat" id="habitat" value="#l.habitat#" size="75">
					<label for="collecting_source" class="helpLink" data-helplink="collecting_source">Collecting Source</label>
					<select name="collecting_source" id="collecting_source" size="1">
						<option value=""></option>
						<cfloop query="ctcollecting_source">
							<option <cfif ctcollecting_source.COLLECTING_SOURCE is l.COLLECTING_SOURCE> selected="selected" </cfif>
								value="#ctcollecting_source.COLLECTING_SOURCE#">#ctcollecting_source.COLLECTING_SOURCE#</option>
						</cfloop>
					</select>
					<span class="infoLink" onclick="getCtDoc('ctcollecting_source');">Define</span>

					<label for="collecting_method" class="helpLink" data-helplink="collecting_method">Collecting Method</label>
					<input type="text" name="collecting_method" id="collecting_method" value="#stripQuotes(l.COLLECTING_METHOD)#" size="75">







					<h4>
						Collecting Event
					</h4>



					<label for="verbatim_date" class="helpLink" data-helplink="verbatim_date">Verbatim Date</label>
					<input type="text" name="verbatim_date" id="verbatim_date" value="#stripQuotes(l.verbatim_date)#" size="75">
					<table>
						<tr>
							<td>
								<label for="began_date" class="helpLink" data-helplink="began_date">Began Date</label>
								<input type="text" name="began_date" id="began_date" value="#l.began_date#">
							</td>
							<td>
								<label for="ended_date" class="helpLink" data-helplink="ended_date">Ended Date</label>
								<input type="text" name="ended_date" id="ended_date" value="#l.ended_date#">
							</td>
						</tr>
					</table>

					<label for="verbatim_locality" class="helpLink" data-helplink="verbatim_locality">Verbatim Locality</label>
					<input type="text" name="verbatim_locality" id="verbatim_locality" value="#stripQuotes(l.verbatim_locality)#" size="75">

					<label for="coll_event_remarks" class="helpLink" data-helplink="coll_event_remarks">Collecting Event Remarks</label>
					<input type="text" name="coll_event_remarks" id="coll_event_remarks" value="#stripQuotes(l.coll_event_remarks)#" size="75">

					<h4>
						Locality
					</h4>


					<label for="spec_locality" class="helpLink" data-helplink="spec_locality">Specific Locality</label>
					<input type="text" name="spec_locality" id="spec_locality" value="#l.spec_locality#" size="75">



					<label for="locality_remarks" class="helpLink" data-helplink="locality_remarks">Locality Remarks</label>
					<input type="text" name="locality_remarks" id="locality_remarks" value="#l.locality_remarks#" size="75">


					<table>
						<tr>
							<td>
								<label for="dec_lat" class="helpLink" data-helplink="dec_lat">Decimal Latitude</label>
								<input type="number" name="dec_lat" id="dec_lat" value="#l.dec_lat#">
							</td>
							<td>
								<label for="dec_long" class="helpLink" data-helplink="dec_long">Decimal Longitude</label>
								<input type="number" name="dec_long" id="dec_long" value="#l.dec_long#">
							</td>


						</tr>
						<tr>
							<td>
								<label for="max_error_distance" class="helpLink" data-helplink="max_error_distance">Max Error Distance</label>
								<input type="number" name="max_error_distance" id="max_error_distance" value="#l.max_error_distance#">
							</td>
							<td>
								<label for="max_error_units" class="helpLink" data-helplink="max_error_units">Error Units</label>
								<select name="max_error_units" id="max_error_units" size="1">
									<cfloop query="cterror">
										<option <cfif l.max_error_units is cterror.LAT_LONG_ERROR_UNITS> selected="selected" </cfif>
											value="#LAT_LONG_ERROR_UNITS#">#LAT_LONG_ERROR_UNITS#</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</table>


					<label for="datum" class="helpLink" data-helplink="datum">Datum</label>
					<select name="datum" id="datum" size="1" class="reqdClr">
						<cfloop query="ctdatum">
							<option <cfif l.datum is ctdatum.datum> selected="selected" </cfif>
								value="#datum#">#datum#</option>
						</cfloop>
					</select>


					<label for="georeference_protocol" class="helpLink" data-helplink="georeference_protocol">Georeference Protocol</label>
					<input type="text" name="georeference_protocol" id="georeference_protocol" value="#l.georeference_protocol#" size="75">

					<label for="georeference_source" class="helpLink" data-helplink="georeference_source">Georeference Source</label>
					<input type="text" name="georeference_source" id="georeference_source" value="#l.georeference_source#" size="75">

					<label for="wkt_media_id" class="helpLink" data-helplink="wkt_media_id">WKT Media ID</label>
					<input type="text" name="wkt_media_id" id="wkt_media_id" value="#l.wkt_media_id#" size="75">








					<table>
						<tr>
							<td>
								<label for="minimum_elevation" class="helpLink" data-helplink="minimum_elevation">Min Elevation</label>
								<input type="number" name="minimum_elevation" id="minimum_elevation" value="#l.minimum_elevation#">
							</td>
							<td>
								<label for="maximum_elevation" class="helpLink" data-helplink="maximum_elevation">Max Elevation</label>
								<input type="number" name="maximum_elevation" id="maximum_elevation" value="#l.maximum_elevation#">
							</td>
							<td>
								<label for="orig_elev_units" class="helpLink" data-helplink="orig_elev_units">Elevation Units</label>
								<select name="orig_elev_units" id="orig_elev_units" size="1">
									<cfloop query="ctElevUnit">
										<option <cfif l.orig_elev_units is ctElevUnit.orig_elev_units> selected="selected" </cfif>
											value="#orig_elev_units#">#orig_elev_units#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="min_depth" class="helpLink" data-helplink="min_depth">Min Depth</label>
								<input type="number" name="min_depth" id="min_depth" value="#l.min_depth#">
							</td>
							<td>
								<label for="max_depth" class="helpLink" data-helplink="max_depth">Max Depth</label>
								<input type="number" name="max_depth" id="max_depth" value="#l.max_depth#">
							</td>
							<td>
								<label for="depth_units" class="helpLink" data-helplink="depth_units">Depth Units</label>
								<select name="depth_units" id="depth_units" size="1">
									<cfloop query="ctdepthUnit">
										<option <cfif l.depth_units is ctdepthUnit.depth_units> selected="selected" </cfif>
											value="#depth_units#">#depth_units#</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</table>


					<h4>
						Geography
					</h4>
					<input type="hidden" name="geog_auth_rec_id" value="#l.geog_auth_rec_id#">
					<label for="higher_geog">Higher Geography</label>
					<input type="text" name="higher_geog" id="higher_geog" value="#l.higher_geog#" size="120" class="readClr" readonly="yes">
					<input type="button" value="Pick" class="picBtn" id="changeGeogButton"
						onclick="GeogPick('geog_auth_rec_id','higher_geog','editForkSpecEvent'); return false;">
				</td><!--- END main cell --->
				<td><!--- maptools cell --->







					<div style="border:1px dashed red; padding:1em;background-color:lightgray;font-size:small;">
					<strong>Webservice Lookup Data</strong>
					<div style="font-size:small;font-style:italic; max-height:6em;overflow:auto;border:2px solid red;">
						<p style="font-style:bold;font-size:large;text-align:center;">READ THIS!</p>
						<span style="font-style:bold;">
							Data in this box come from various webservices. They are NOT "specimen data," are derived from entirely automated processes,
							 and come with no guarantees.
						</span>
						<p>Not seeing anything here, or seeing old data? Try waiting a couple minutes and reloading -
							webservice data are asynchronously refreshed when this page loads, but can take a few minutes to find their way here.
							(Webservice data are otherwise created when users load maps and refreshed
							every 6 months.)
						</p>
						<p>
							Automated georeferencing comes from either higher geography and locality or higher geography alone, and
							contains no indication of error.
							Curatorially-supplied error is displayed with the
							curatorially-asserted point on the map below. The accuracy and usefulness of the automated georeferencing is hugely variable -
							use it as a tool and make no assumptions.
						</p>
						<p>
							There's a link to add the generated coordinates to the edit form. It copies only; you'll
							need to manually calculate error (or use GeoLocate) and save to keep the copied data.
						</p>
						<p>
							Distance between points is an estimate calculated using the
							<a href="http://goo.gl/Pwhm0" class="external" target="_blank">Haversine formula</a>.
							If it's a large value, careful scrutiny of coordinates and locality information is warranted.
						</p>
						<p>
							Elevation is retrieved for the <strong>point</strong> given by the asserted coordinates.
						</p>
						<p>
							Reverse-georeference Geography string is for both the coordinates and the spec locality (including higher geog).
							It's used for searching, and can mostly be ignored.
							Use the Contact link in the footer if it's horrendously wrong somewhere - let us know the locality_id.
						</p>
					</div>
					<br>
						Coordinates:
						<input type="text" id="s_dollar_dec_lat" value="#l.s$dec_lat#" size="6">
						<input type="text" id="s_dollar_dec_long" value="#l.s$dec_long#" size="6">
						<span class="likeLink" onclick="useAutoCoords()">Copy these coordinates to the form</span>
					<br>Distance between asserted and lookup coordinates (km):
						<input type="text" id="distanceBetween" size="6">
					<br>Elevation (m):
						<input type="text" id="s_dollar_elev" value="#l.s$elevation#" size="6">
						<span style="font-style:italic;">
							<cfif len(l.min_elev_in_m) is 0>
								There is no curatorially-supplied elevation.
							<cfelseif locDet.min_elev_in_m gt l.s$elevation or l.s$elevation gt l.max_elev_in_m>
								Automated georeference is outside the curatorially-supplied elevation range.
							<cfelseif  locDet.min_elev_in_m lte l.s$elevation and l.s$elevation lte l.max_elev_in_m>
								Automated georeference is within the curatorially-supplied elevation range.
							</cfif>
						</span>
					<br>Tags:
						<span style="font-weight:bold;">#l.s$geography#</span>
					<div id="map-canvas"></div>
					<img src="https://maps.google.com/mapfiles/ms/micons/red-dot.png">=service-suggested,
					<img src="https://maps.google.com/mapfiles/ms/micons/green-dot.png">=curatorially-asserted,
					<span style="border:3px solid ##DC143C;background-color:##FF7F50;">&nbsp;&nbsp;&nbsp;</span>=locality WKT,
					<span style="border:3px solid ##1E90FF;background-color:##1E90FF;">&nbsp;&nbsp;&nbsp;</span>=geography WKT.


					<input type="button" value="Georeference with GeoLocate" class="insBtn" onClick="geolocate();">


							<cfif len(l.DEC_LONG) gt 0>
								<input type="button" value="Modify Coordinates/Error with GeoLocate" class="insBtn" onClick="geolocate('adjust');">
							</cfif>










				</td><!--- END maptools cell --->
			</tr>
			<tr>
				<td colspan="2"><!--- geology cell --->
					<h4>
						Geology
					</h4>

					<table border>
						<tr>
							<th>Attribute</th>
							<th>Value</th>
							<th>Determiner</th>
							<th>Date</th>
							<th>Method</th>
							<th>Remark</th>
						</tr>
						<cfset i=1>
						<cfloop query="geology">
							<tr>
								<td>
									<select name="geology_attribute__#i#" id="geology_attribute__#i#" class="reqdClr" onchange="populateGeology(this.id)">
										<option value="" class="red">Delete This</option>
										<cfloop query="ctgeology_attribute">
											<option <cfif ctgeology_attribute.geology_attribute is geology.geology_attribute> selected="selected" </cfif>value="#geology_attribute#">#geology_attribute#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<select name="geo_att_value__#i#" id="geo_att_value__#i#" class="reqdClr">
										<option value="#geo_att_value#">#geo_att_value#</option>
									</select>
								</td>
								<td>
									<input type="hidden" name="geo_att_determiner_id__#i#" id="geo_att_determiner_id__#i#" value="#geo_att_determiner_id#">
									<input type="text" name="geo_att_determiner_#i#"  size="20"
										onchange="pickAgentModal('geo_att_determiner_id__#i#','geo_att_determiner__#i#',this.value); return false;"
					 					onKeyPress="return noenter(event);"
					 					value="#agent_name#">
								</td>
								<td>
									<input type="text" name="geo_att_determined_date__#i#" id="geo_att_determined_date__#i#" value="#dateformat(geo_att_determined_date,'yyyy-mm-dd')#">
								</td>
								<td>
									<input type="text" name="geo_att_determined_method__#i#" id="geo_att_determined_method__#i#" size="60"  value="#geo_att_determined_method#">
								</td>
								<td>
									<input type="text" name="geo_att_remark__#i#" size="60" value="#geo_att_remark#">
								</td>
							</tr>
							<cfset i=i+1>
						</cfloop>
						<cfset lpt=i+3>
						<cfloop from ="#i#" to="#lpt#" index="i">
							<tr>
								<td>
									<select name="geology_attribute__#i#" id="geology_attribute__#i#" class="reqdClr" onchange="populateGeology(this.id)">
										<option value=""></option>
										<cfloop query="ctgeology_attribute">
											<option value="#geology_attribute#">#geology_attribute#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<select name="geo_att_value__#i#" id="geo_att_value__#i#" class="reqdClr">
										<option value=""></option>
									</select>
								</td>
								<td>
									<input type="hidden" name="geo_att_determiner_id__#i#" id="geo_att_determiner_id__#i#" >
									<input type="text" name="geo_att_determiner_#i#"  size="20"
										onchange="pickAgentModal('geo_att_determiner_id__#i#','geo_att_determiner__#i#',this.value); return false;"
					 					onKeyPress="return noenter(event);">
								</td>
								<td>
									<input type="text" name="geo_att_determined_date__#i#" id="geo_att_determined_date__#i#">
								</td>
								<td>
									<input type="text" name="geo_att_determined_method__#i#" size="60" >
								</td>
								<td>
									<input type="text" name="geo_att_remark__#i#" size="60">
								</td>
							</tr>
						</cfloop>
					</table>

				</td><!--- END geology cell --->
			</tr>
		</table>
		<label for="action">On Save....</label>
		<select name="sav_action" id="sav_action" class="reqdClr">
			<option value="">pick one</option>
			<option value="edit">Edit the current specimen_event</option>
			<option value="add">"unaccepted" the current specimen_event; add an Event with these data</option>
		</select>
		<input type="submit">





<!----

			<input type="button" value="Save Changes to this Specimen/Event" class="savBtn" onclick="loc#f#.action.value='saveChange';loc#f#.submit();">
			<input type="button" value="Delete this Specimen/Event" class="delBtn" onclick="loc#f#.action.value='delete';confirmDelete('loc#f#');">
---->
	</form>


	<!--------
	<cfset obj = CreateObject("component","component.functions")>
	</td><td valign="top">
		<h4>Geography</h4>
			<ul>
				<li>#higher_geog#</li>
			</ul>
			<h4>
				Locality
				<a style="font-size:small;" href="/editLocality.cfm?locality_id=#locality_id#" target="_top">[ Edit Locality ]</a>
			</h4>
			<cfset localityContents = obj.getLocalityContents(locality_id="#locality_id#")>

			#localityContents#
			<ul>
				<cfif len(locality_name) gt 0>
					<li>Locality Nickname: #locality_name#</li>
				</cfif>
				<cfif len(DEC_LAT) gt 0>
					<li>
						<cfset getMap = obj.getMap(locality_id="#locality_id#")>
						<!-------
						<cfinvoke component="component.functions" method="getMap" returnvariable="contents">
							<cfinvokeargument name="lat" value="#DEC_LAT#">
							<cfinvokeargument name="" value="#DEC_LONG#">
							<cfinvokeargument name="locality_id" value="#locality_id#">
						</cfinvoke>
						--->
						#getMap#
						<span style="font-size:small;">
							<br>#DEC_LAT# / #DEC_LONG#
							<br>Datum: #DATUM#
							<br>Error: #MAX_ERROR_DISTANCE# #MAX_ERROR_UNITS#
							<br>Georeference Source: #georeference_source#
							<br>Georeference Protocol: #georeference_protocol#
						</span>
					</li>
				</cfif>
				<cfif len(SPEC_LOCALITY) gt 0>
					<li>Specific Locality: #SPEC_LOCALITY#</li>
				</cfif>
				<cfif len(ORIG_ELEV_UNITS) gt 0>
					<li>Elevation: #MINIMUM_ELEVATION#-#MAXIMUM_ELEVATION# #ORIG_ELEV_UNITS#</li>
				</cfif>
				<cfif len(DEPTH_UNITS) gt 0>
					<li>Depth: #MIN_DEPTH#-#MAX_DEPTH# #DEPTH_UNITS#</li>
				</cfif>
				<cfif len(LOCALITY_REMARKS) gt 0>
					<li>Remark: #LOCALITY_REMARKS#</li>
				</cfif>
			</ul>
			<cfif g.recordcount gt 0>
				<h4>Geology</h6>
				<ul>
					<cfloop query="g">
						<li>GEOLOGY_ATTRIBUTE_ID: #GEOLOGY_ATTRIBUTE_ID#</li>
						<li>GEOLOGY_ATTRIBUTE: #GEOLOGY_ATTRIBUTE#</li>
						<li>GEO_ATT_VALUE: #GEO_ATT_VALUE#</li>
						<li>geo_att_determiner: #geo_att_determiner#</li>
						<li>GEO_ATT_DETERMINED_DATE: #GEO_ATT_DETERMINED_DATE#</li>
						<li>GEO_ATT_DETERMINED_METHOD: #GEO_ATT_DETERMINED_METHOD#</li>
						<li>GEO_ATT_REMARK: #GEO_ATT_REMARK#</li>
					</cfloop>
				</ul>
			</cfif>


	</td>
	</tr></table>
	</div>
		<cfset f=f+1>
	</cfloop>
	<div style="border:2px solid black; margin:1em;">
		<cfform name="loc_new" method="post" action="specLocality.cfm">
			<input type="hidden" name="action" value="createSpecEvent">
			<input type="hidden" name="nothing" id="nothing">
			<input type="hidden" name="collection_object_id" value="#collection_object_id#">
			<input type="hidden" name="collecting_event_id" value="">
			<!-------------------------- specimen_event -------------------------->
			<h4>
				Add Specimen/Event
				<a name="specimen_event_new" href="##top">[ scroll to top ]</a>
			</h4>
			<label for="specimen_event_type">Specimen/Event Type</label>
			<select name="specimen_event_type" id="specimen_event_type" size="1" class="reqdClr">
				<cfloop query="ctspecimen_event_type">
					<option value="#ctspecimen_event_type.specimen_event_type#">#ctspecimen_event_type.specimen_event_type#</option>
			    </cfloop>
			</select>
			<span class="infoLink" onclick="getCtDoc('ctspecimen_event_type');">Define</span>

			<label for="specimen_event_type">Event Assigned by Agent</label>
			<input type="text" name="assigned_by_agent_name" id="assigned_by_agent_name" class="reqdClr" size="40" value="#session.dbuser#"
				 onchange="getAgent('assigned_by_agent_id','assigned_by_agent_name','loc_new',this.value); return false;"
				 onKeyPress="return noenter(event);">
			<input type="hidden" name="assigned_by_agent_id" id="assigned_by_agent_id" value="#session.myAgentId#">

			<label for="assigned_date" class="helpLink" data-helplink="specimen_event_date">Specimen/Event Assigned Date</label>
			<input type="text" name="assigned_date" id="assigned_date" value="#dateformat(now(),'yyyy-mm-dd')#" class="reqdClr">

			<label for="specimen_event_remark" class="infoLink">Specimen/Event Remark</label>
			<input type="text" name="specimen_event_remark" id="specimen_event_remark" value="" size="75">

			<label for="habitat">Habitat</label>
			<input type="text" name="habitat" id="habitat" value="#l.habitat#" size="75">

			<label for="collecting_source" class="helpLink" data-helplink="collecting_source">Collecting Source</label>
			<select name="collecting_source" id="collecting_source" size="1">
				<option value=""></option>
				<cfloop query="ctcollecting_source">
					<option value="#ctcollecting_source.COLLECTING_SOURCE#">#ctcollecting_source.COLLECTING_SOURCE#</option>
				</cfloop>
			</select>
			<span class="infoLink" onclick="getCtDoc('ctcollecting_source');">Define</span>

			<label for="collecting_method" class="helpLink" data-helplink="collecting_method">Collecting Method</label>
			<input type="text" name="collecting_method" id="collecting_method" value="" size="75">

			<label for="VerificationStatus" class="helpLink" data-helplink="verification_status">Verification Status</label>
			<select name="VerificationStatus" id="verificationstatus" size="1" class="reqdClr">
				<cfloop query="ctVerificationStatus">
					<option <cfif VerificationStatus is "unverified"> selected="selected"</cfif>value="#VerificationStatus#">#VerificationStatus#</option>
				</cfloop>
			</select>
			<span class="infoLink" onclick="getCtDoc('ctverificationstatus');">Define</span>
			<h4>
				Collecting Event
			</h4>
			<label for="">Click the button to pick an event. The Verbatim Locality of the event you pick will go here.</label>
			<input type="text" size="50" class="reqdClr" name="cepick">
			<input type="button" class="picBtn" value="pick new event" onclick="findCollEvent('collecting_event_id','loc_new','cepick');">
			<br><input type="submit" value="Create this Specimen/Event" class="savBtn">
		</cfform>
	</div>
	----------->
	</cfoutput>
</cfif>
<cfif action is "saveEdits">
<cfoutput>



	<!--- this has to run as GOD; users will not have access to do this stuff --->
	<cftransaction>
		<!--- this will always result in a new locality --->
		<cfquery name="lid" datasource="uam_god">
			select sq_locality_id.nextval lid from dual
		</cfquery>
		<cfquery name="mkloc" datasource="uam_god">
			insert into locality (
	   	 		LOCALITY_ID,
	   	 		GEOG_AUTH_REC_ID,
	   	 		SPEC_LOCALITY,
	   	 		DEC_LAT,
	   	 		DEC_LONG,
	   	 		MINIMUM_ELEVATION,
	   	 		MAXIMUM_ELEVATION,
	   	 		ORIG_ELEV_UNITS,
	   	 		MIN_DEPTH,
	   	 		MAX_DEPTH,
	   	 		DEPTH_UNITS,
	   	 		MAX_ERROR_DISTANCE,
	   	 		MAX_ERROR_UNITS,
	   	 		DATUM,
	   	 		LOCALITY_REMARKS,
	   	 		GEOREFERENCE_SOURCE,
	   	 		GEOREFERENCE_PROTOCOL,
	   	 		wkt_media_id
	   	 	) values (
	   	 		#lid.lid#,
	   	 		#GEOG_AUTH_REC_ID#,
	   	 		'#escapeQuotes(SPEC_LOCALITY)#',
	   	 		<cfif len(DEC_LAT) gt 0>#DEC_LAT#<cfelse>NULL</cfif>,
	   	 		<cfif len(DEC_LONG) gt 0>#DEC_LONG#<cfelse>NULL</cfif>,
	   	 		<cfif len(MINIMUM_ELEVATION) gt 0>#MINIMUM_ELEVATION#<cfelse>NULL</cfif>,
	   	 		<cfif len(MAXIMUM_ELEVATION) gt 0>#MAXIMUM_ELEVATION#<cfelse>NULL</cfif>,
	   	 		'#ORIG_ELEV_UNITS#',
	   	 		<cfif len(MIN_DEPTH) gt 0>#MIN_DEPTH#<cfelse>NULL</cfif>,
	   	 		<cfif len(MAX_DEPTH) gt 0>#MAX_DEPTH#<cfelse>NULL</cfif>,
	   	 		'#DEPTH_UNITS#',
	   	 		<cfif len(MAX_ERROR_DISTANCE) gt 0>#MAX_ERROR_DISTANCE#<cfelse>NULL</cfif>,
	   	 		'#MAX_ERROR_UNITS#',
	   	 		'#DATUM#',
	   	 		'#escapeQuotes(LOCALITY_REMARKS)#',
	   	 		'#escapeQuotes(GEOREFERENCE_SOURCE)#',
	   	 		'#escapeQuotes(GEOREFERENCE_PROTOCOL)#'
	   	 	)
		</cfquery>
		<!--- this will always result in a new collecting event --->
		<cfquery name="cid" datasource="uam_god">
			select sq_collecting_event_id.nextval cid from dual
		</cfquery>
		<cfquery name="mkevt" datasource="uam_god">
			insert into collecting_event (
				COLLECTING_EVENT_ID,
				LOCALITY_ID,
				VERBATIM_DATE,
				VERBATIM_LOCALITY,
				COLL_EVENT_REMARKS,
				BEGAN_DATE,
				ENDED_DATE
	   	 	) values (
	   	 		#cid.cid#,
	   	 		#lid.lid#,
	   	 		'#escapeQuotes(VERBATIM_DATE)#',
	   	 		'#escapeQuotes(VERBATIM_LOCALITY)#',
	   	 		'#escapeQuotes(COLL_EVENT_REMARKS)#',
	   	 		'#BEGAN_DATE#',
	   	 		'#ENDED_DATE#'
	   	 	)
		</cfquery>
		<cfif sav_action is "edit">
			<!--- change the existing event --->
			<cfquery name="edsevt" datasource="uam_god">
				update
	   	 			specimen_event
	   	 		set
	   	 			collecting_event_id=#cid.cid#,
	   	 			ASSIGNED_BY_AGENT_ID=#ASSIGNED_BY_AGENT_ID#,
	   	 			ASSIGNED_DATE='#ASSIGNED_DATE#',
	   	 			SPECIMEN_EVENT_REMARK='#escapeQuotes(SPECIMEN_EVENT_REMARK)#',
	   	 			SPECIMEN_EVENT_TYPE='#SPECIMEN_EVENT_TYPE#',
	   	 			COLLECTING_METHOD='#escapeQuotes(COLLECTING_METHOD)#',
	   	 			COLLECTING_SOURCE='#COLLECTING_SOURCE#',
	   	 			VERIFICATIONSTATUS='#VERIFICATIONSTATUS#',
	   	 			HABITAT='#escapeQuotes(HABITAT)#',
	   	 			VERIFIED_BY_AGENT_ID=<cfif len(VERIFIED_BY_AGENT_ID) gt 0>#VERIFIED_BY_AGENT_ID#<cfelse>NULL</cfif>,
	   	 			VERIFIED_DATE='#VERIFIED_DATE#'
	   	 		where
	   	 			specimen_event_id=#specimen_event_id#
			</cfquery>
			<cfset redirSEID=specimen_event_id>
		<cfelseif  sav_action is "add">
			<!--- archive/unaccepted the existing event, make a new one --->
			<cfquery name="sid" datasource="uam_god">
				select sq_specimen_event_id.nextval sid from dual
			</cfquery>
			<cfquery name="mksevt" datasource="uam_god">
				insert into specimen_event (
	   	 			SPECIMEN_EVENT_ID,
	   	 			COLLECTION_OBJECT_ID,
	   	 			COLLECTING_EVENT_ID,
	   	 			ASSIGNED_BY_AGENT_ID,
	   	 			ASSIGNED_DATE,
	   	 			SPECIMEN_EVENT_REMARK,
	   	 			SPECIMEN_EVENT_TYPE,
	   	 			COLLECTING_METHOD,
	   	 			COLLECTING_SOURCE,
	   	 			VERIFICATIONSTATUS,
	   	 			HABITAT,
	   	 			VERIFIED_BY_AGENT_ID,
	   	 			VERIFIED_DATE
	   	 		) values (
	   	 			#sid.sid#,
	   	 			#COLLECTION_OBJECT_ID#,
	   	 			#cid.cid#,
	   	 			#ASSIGNED_BY_AGENT_ID#,
	   	 			'#ASSIGNED_DATE#',
	   	 			'#escapeQuotes(SPECIMEN_EVENT_REMARK)#',
	   	 			'#SPECIMEN_EVENT_TYPE#',
	   	 			'#escapeQuotes(COLLECTING_METHOD)#',
	   	 			'#COLLECTING_SOURCE#',
	   	 			'#VERIFICATIONSTATUS#',
	   	 			'#escapeQuotes(HABITAT)#',
	   	 			<cfif len(VERIFIED_BY_AGENT_ID) gt 0>#VERIFIED_BY_AGENT_ID#<cfelse>NULL</cfif>,
	   	 			'#VERIFIED_DATE#'
	   	 		)
			</cfquery>

			<cfquery name="arksevt" datasource="uam_god">
				update
	   	 			specimen_event
	   	 		set
	   	 			VERIFICATIONSTATUS='unaccepted'
	   	 		where
	   	 			specimen_event_id=#specimen_event_id#
			</cfquery>
			<cfset redirSEID=sid.sid>
			<!--- we should never get here --->
			<cfthrow message="invalid sav_action">
		</cfif>

		<!--- pull geology out --->
		<cfloop list="#form.FIELDNAMES#" index="fld">
			<cfif left(fld,19) is "GEOLOGY_ATTRIBUTE__">
				<cfset thisIndex=replace(fld,"GEOLOGY_ATTRIBUTE__","")>
				<cfset thisGA=evaluate("GEOLOGY_ATTRIBUTE__" & thisIndex)>
				<cfif len(thisGA) gt 0>
					<cfset thisGV=evaluate("GEO_ATT_VALUE__" & thisIndex)>
					<cfset thisGDid=evaluate("GEO_ATT_DETERMINER_ID__" & thisIndex)>
					<cfset thisGDD=evaluate("GEO_ATT_DETERMINED_DATE__" & thisIndex)>
					<cfset thisGDM=evaluate("GEO_ATT_DETERMINED_METHOD__1" & thisIndex)>
					<cfset thisGR=evaluate("GEO_ATT_REMARK__1" & thisIndex)>
					<cfquery name="insGeo" datasource="uam_god">
						insert into geology_attributes (
							GEOLOGY_ATTRIBUTE_ID,
							LOCALITY_ID,
							GEOLOGY_ATTRIBUTE,
							GEO_ATT_VALUE,
							GEO_ATT_DETERMINER_ID,
							GEO_ATT_DETERMINED_DATE,
							GEO_ATT_DETERMINED_METHOD,
							GEO_ATT_REMARK
						values (
							sq_GEOLOGY_ATTRIBUTE_ID.nextval,
							#lid.lid#,
							'#thisGA#',
				   	 		<cfif len(thisGDid) gt 0>#thisGDid#<cfelse>NULL</cfif>,
							'#thisGDD#',
							'#escapeQuotes(thisGDM)#',
							'#escapeQuotes(thisGR)#'
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	<cflocation url="specLocality_forkLocStk.cfm?specimen_event_id=#redirSEID#" addtoken="false">
</cfoutput>

</cfif>


<!----



<cfif action is "delete">
	<cfquery name="upSE" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		delete from specimen_event where specimen_event_id=#specimen_event_id#
	</cfquery>
	<cflocation url="specLocality.cfm?collection_object_id=#collection_object_id#" addtoken="false">
</cfif>

<cfif action is "createSpecEvent">
	<cfquery name="upSE" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		insert into specimen_event (
			collection_object_id,
			collecting_event_id,
			assigned_by_agent_id,
			assigned_date,
			specimen_event_remark,
			specimen_event_type,
			COLLECTING_METHOD,
			COLLECTING_SOURCE,
			VERIFICATIONSTATUS,
			habitat
		) values (
			#collection_object_id#,
			#collecting_event_id#,
			#assigned_by_agent_id#,
			'#dateformat(assigned_date,"yyyy=mm-dd")#',
			'#escapeQuotes(specimen_event_remark)#',
			'#specimen_event_type#',
			'#escapeQuotes(COLLECTING_METHOD)#',
			'#COLLECTING_SOURCE#',
			'#VERIFICATIONSTATUS#',
			'#escapeQuotes(habitat)#'
		)
	</cfquery>
	<cflocation url="specLocality.cfm?collection_object_id=#collection_object_id#" addtoken="false">
</cfif>


<cfif action is "saveChange">
	<cfquery name="upSE" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		update specimen_event set
			collecting_event_id=#collecting_event_id#,
			assigned_by_agent_id=#assigned_by_agent_id#,
			assigned_date='#dateformat(assigned_date,"yyyy=mm-dd")#',
			specimen_event_remark='#escapeQuotes(specimen_event_remark)#',
			specimen_event_type='#specimen_event_type#',
			COLLECTING_METHOD='#escapeQuotes(COLLECTING_METHOD)#',
			COLLECTING_SOURCE='#COLLECTING_SOURCE#',
			VERIFICATIONSTATUS='#VERIFICATIONSTATUS#',
			habitat='#escapeQuotes(habitat)#',
			<cfif len(verified_by_agent_id) gt 0>
				verified_by_agent_id=#verified_by_agent_id#,
			<cfelse>
				verified_by_agent_id=null,
			</cfif>
			verified_date='#verified_date#'
		where
			SPECIMEN_EVENT_ID=#SPECIMEN_EVENT_ID#
	</cfquery>
	<cflocation url="specLocality.cfm?collection_object_id=#collection_object_id#" addtoken="false">
</cfif>
---->