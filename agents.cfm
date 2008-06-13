<cfif not isdefined("agent_id")>
	<cfset agent_id=-1>
</cfif>
<cfinclude template="/includes/_header.cfm">
<cfset title='Manage Agents'>

<script type="text/javascript">

/***********************************************
* IFrame SSI script II- � Dynamic Drive DHTML code library (http://www.dynamicdrive.com)
* Visit DynamicDrive.com for hundreds of original DHTML scripts
* This notice must stay intact for legal use
***********************************************/

//Input the IDs of the IFRAMES you wish to dynamically resize to match its content height:
//Separate each ID with a comma. Examples: ["myframe1", "myframe2"] or ["myframe"] or [] for none:
var iframeids=["_search","_person","_pick"]

//Should script hide iframe from browsers that don't support this script (non IE5+/NS6+ browsers. Recommended):
var iframehide="yes"

var getFFVersion=navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1]
var FFextraHeight=parseFloat(getFFVersion)>=0.1? 16 : 0 //extra height in px to add to iframe in FireFox 1.0+ browsers

function resizeCaller() {
var dyniframe=new Array()
for (i=0; i<iframeids.length; i++){
if (document.getElementById)
resizeIframe(iframeids[i])
//reveal iframe for lower end browsers? (see var above):
if ((document.all || document.getElementById) && iframehide=="no"){
var tempobj=document.all? document.all[iframeids[i]] : document.getElementById(iframeids[i])
tempobj.style.display="block"
}
}
}

function resizeIframe(frameid){
var currentfr=document.getElementById(frameid)
if (currentfr && !window.opera){
currentfr.style.display="block"
if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight) //ns6 syntax
currentfr.height = currentfr.contentDocument.body.offsetHeight+FFextraHeight; 
else if (currentfr.Document && currentfr.Document.body.scrollHeight) //ie5+ syntax
currentfr.height = currentfr.Document.body.scrollHeight;
if (currentfr.addEventListener)
currentfr.addEventListener("load", readjustIframe, false)
else if (currentfr.attachEvent){
currentfr.detachEvent("onload", readjustIframe) // Bug fix line
currentfr.attachEvent("onload", readjustIframe)
}
}
}

function readjustIframe(loadevt) {
var crossevt=(window.event)? event : loadevt
var iframeroot=(crossevt.currentTarget)? crossevt.currentTarget : crossevt.srcElement
if (iframeroot)
resizeIframe(iframeroot.id);
}

function loadintoIframe(iframeid, url){
if (document.getElementById)
document.getElementById(iframeid).src=url
}

if (window.addEventListener)
window.addEventListener("load", resizeCaller, false)
else if (window.attachEvent)
window.attachEvent("onload", resizeCaller)
else
window.onload=resizeCaller


</script>
<style>
	#srch{
		position:relative;
		top:0px;
		left:0px;
		width:25%;
		height:300px;
		}
	#reslts{
		position:relative;
		top:0px;
		right:0px;
		width:74%;
		}
	#grid{
		position:relative;
		top:301px;
		left:0px;
		width:25%;
		}
	#wrap{
		position:relative;
		width:100%;
		border:1px solid red;
		}
</style>

<cfoutput>
<div id="wrap">
<div id="srch">

</div>
<div id="grid">
	
</div>
<div id="reslts">
	
</div>	

</div>
<table>
	<tr>
		<td width="25%">
			<iframe src="/AgentSearch.cfm" id="_search" name="_search" width="100%"></iframe>
		</td>
		<td rowspan="2">
			<iframe src="/AgentGrid.cfm" name="_pick" id="_pick" width="100%"></iframe>
		</td>
	</tr>
	<tr>
		<td>
			<iframe src="/editAllAgent.cfm" name="_person" id="_person" width="100%"></iframe>
		</td>
	</tr>
</table>
<span onclick="autofitIframe('_search')">_search</span>
<span onclick="autofitIframe('_person')">_person</span>
<span onclick="autofitIframe('_pick')">_pick</span>
<span onclick="autofitIframe('resizeCaller')">resizeCaller</span>

</cfoutput>
