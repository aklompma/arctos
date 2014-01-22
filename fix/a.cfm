
<cfinclude template="/includes/_header.cfm">

<style>


	#td_search {
		height:50%;
		width:30%;
	}
	
	#td_rslt {
		height:50%;
		width:30%;
	}
	
	#td_edit {
		height:100%;
		width:30%;
	}
	#olTabl {
		height:100%;
		width:100%;
	}
	
	
	
	
	
	.valigntop {
	vertical-align:top;
}
#gmapsrchtarget {
	width: 345px;
}
#map_canvas { height: 500px;width:100%; }

.relCacheDiv {
	border:1px dashed green;
	padding:.1em;
	margin-left:1em;
	font-size:smaller;
}
}.isDuplicateRecord {
	border: .6em solid red;
	padding: .2em;
}
.ui-autocomplete {
       max-height: 100px;
       overflow-y: auto;
       /* prevent horizontal scrollbar */
       overflow-x: hidden;
       font-size:x-small;
       max-width:200px;
   }
.ui-widget { font-size: .6em; }

figure {
    display: table;
    width: 1px; /* This can be any width, so long as it's narrower than any image */
}
img, figcaption {
    display: table-row;
	font-size:small;
	color:gray;
}
.hide {visibility:hidden;}
.soft404 {opacity:.8;}
.fourohfour {opacity:.2;}
.bgDiv {
	position: fixed;
	top: 0;
	left: 0;
	bottom: 0;
	right: 0;
	z-index:2000;
	opacity:0.5;
	background:#024;
}


.editAppBox {
	border:1px solid gray;
	z-index:9998;
	position:fixed;
	top:1%;
	left:2%;
	width:95%;
	height:95%;
	background-color:lightgray;
	overflow:auto;
}

.centeredImage {
   position:absolute;
   top:50%;
   left:50%;
   margin-top:-25px;
   margin-left:-100px;
	border:1px solid white;
			 }
.editFrame {
	border-top:1px solid gray;
	z-index:1000;
	position:fixed;
	top:40px;
	left:2%;
	width:95%;
	height:90%;
	z-index:9998;
}

.fancybox-close {
	background:url("/images/fancybox.png") repeat scroll -40px 0 transparent;
	cursor:pointer;
	height:30px;
	position:absolute;
	right:0;
	top:0;
	width:30px;
	z-index:10999;
}
.fancybox-help {
	cursor:pointer;
	height:30px;
	position:absolute;
	left:10;
	top:5;
	width:50px;
	z-index:10999;
}
#navbar .activeButton , #navbar .activeButton:hover{
	border:1px solid gray;
	color:gray;
	background-color:lightgray;
	cursor:default;
}


.borderBox{
	display:inline-block;
	margin: 1em 1em 1em 1em;
	padding: .5em 1em 1em 1em;
	border:1px dashed green;
}
#browseArctos {
font-size:small;
border:1px solid green;
margin:1em;
padding:1em;
max-width:400px;
position:fixed;
top:7em;
left:65em;
max-height:65%;
overflow:auto;
}
	
#browseArctos ul {
list-style-type:none;
margin-left:-3em;
vertical-align:middle;
}

#browseArctos ul li {
margin:.5em;
border-bottom:1px solid green;
}

#browseArctos .title {
text-align:center;
font-weight:bold;
font-size:large;
color:black;
}
	
#browseArctos ul li {
text-indent:-1em;
padding-left:1em;
}

/* GMaps selector */
.divlayer {
 border: 2px solid #ff0000;
 background-color:#ffe4e1;
 filter:alpha(opacity=50);
 opacity: 0.5;
 -moz-opacity:0.5;
 z-index: 10000;
 height: 100px;
 width: 100px;
 left: 0px;
 top: 0px;
 margin: 0px;
 padding: 0px;
 position: absolute;
 line-height:0px;
 cursor:move;
}
.Bar {
  position:absolute;
  overflow:hidden;
  height:0px;
  width:0px;
}
.ResBtn {
  background-image: url(/images/resize.gif);
  background-repeat:no-repeat;
  background-position:center;
  position:absolute;
  overflow:hidden;
  width:20px;
  height:20px;
  margin:0;
  padding:0;
  cursor:se-resize;
}
.ZoomBtn {
  background-image: url(/images/magnify.png);
  background-repeat:no-repeat;
  background-position:center;
  position:absolute;
  overflow:hidden;
  width:20px;
  height:20px;
  margin:0;
  padding:0;
  cursor:hand;
  cursor:pointer;
}
/* / GMaps selector */	

div.bigThumbDiv {
 	float: left;
 	width: 300px;
 	padding: 1px;
	border:1px solid green;
	height:300px;
	overflow:hidden;
	text-align: center;
}
div.imgCaptionDiv {
	font-size:smaller;
	margin-top:0px;
 }
.bigImgPrev {
	max-height:180px;
	max-width:180px;
}
div.smallPaddedIndent{
	text-align:left;
	text-indent: -1em;
	padding-left: 2em;
	padding-right:1em;
}
div.thumb_spcr {
	clear: both;
}
div.shortThumb {
	overflow:scroll;
	height:200px;
}
div.thumbs {
	border: 1px dashed black;
	max-width:910px;
	align:center;
	margin-left:auto;
	margin-right:auto;
}
div.one_thumb {
 	float: left;
 	width: 180px;
 	padding: 1px;
	height:187px;
	overflow:hidden;
	text-align: center;
}
div.one_thumb p {
	font-size:smaller;
	margin-top:0px;
 }
.smallMediaPreview {
	max-width:20px;
	max-height:20px;
	display:inline;
}
.theThumb{
	max-width:120px;
	max-height:120px;
}

/* --------  TAG style - DO NOT EDIT THIS STUFF UNLESS YOU REALLY KNOW WHAT YOU'RE DOING! -------------   */

.editing {
	border:1px solid red;
	z-index:300;
}
.refDiv{
	border:1px solid blue;
	z-index:299;
}
#imgDiv{
	border:1px solid black;
	max-width:60%;
	position:absolute;
	float: left;
}
#navDiv {
	float:right;
	border:1px solid green;
	width:35%;
	height:400px;
	overflow:auto;
	margin:5px;
	padding:5px;
	position:fixed;
	right:0px;
	top:20%;
}
.refPane_cataloged_item {
    background-color:#A7B3BC;
    padding:3px;
    border:1px solid black;
}
.refPane_collecting_event {
    background-color:#A0C4DF;
    padding:3px;
    border:1px solid black;
}
.refPane_locality {
    background-color:yellow;
    padding:3px;
    border:1px solid black;
}
.refPane_agent {
    background-color:orange;
    padding:3px;
    border:1px solid black;
}
.refPane_comment {
    background-color:#76A5D4;
    padding:3px;
    border:1px solid black;
}
.refPane_editing {
	border:3px solid red;
}
#theImage{
	max-width:100%;
}
.highlight {
	border:2px solid yellow;
	z-index:300;
}
.refPane_highlight {
	border:3px solid yellow;
}
/* -------------------   end TAG style ------------------------  */

.annotateBox {
	border:3px solid green;
	z-index:9999;
	position:absolute;
	top:5%;
	left:5%;
	width:85%;
	height:85%;
	background-color:white;
	overflow:auto;
}
.imgDiv{
	float: left;
	margin:.1em;
	max-width:200px;
	max-height:200px;
}
.imgCaption{
	text-align:center;
	margin:.0em;
	font-style: italic;
	font-size: smaller;
  	text-indent: 0;
}
.imgStyle{
	max-width:200px;
	max-height:200px;
}
.greenBorder {
	border:1px solid green;
}
.redBorder {
	border:1px solid red;
}
.blackBorder {
	border:1px solid black;
}
.cellDiv {
	border:1px dashed green;
	padding:10px;
	margin: 10px;
	width:80%;
}
label.badPickLbl {
	color:red;
	width:15em;
	height:2em;
	background-image:url('/images/caution.gif');
	background-repeat:no-repeat;
	background-position:right; 
	display: table-cell; 
	vertical-align: bottom;
}
.noShow {
	display:none;
}
.doShow {
	display:block;
}
.browserCheck {
	text-align:center;
	border:1px dotted #CC0000;
	font-size:smaller;	
}
.goodPW {
	font-size:smaller;
	background-color:green;
	margin-left:.1em;
	padding:.2em;
}
.badPW {
	font-size:smaller;
	background-color:red;
	margin-left:.1em;
	padding:.2em;
}
.showType {
	font-size:small;
	color:green;
	border:1px dotted green;
	padding-left:5px;
}
.pickBox {
	border:2px solid green;	
	z-index:2001;
	background-color:gray;
	position:absolute;
	width:50%;
	top:20%;
	padding: 12px;
	left:20%;
}

.mediaLink {
	padding-left:5px;	
	color:#2B547E;
	font-size:small;
	font-family:Arial, Helvetica, sans-serif;
	display:block;
}
.mediaLink:hover {
	color:#FF0000;
	text-decoration: underline;
}
.mediaLink:visited {
	color:#2B547E;
}
.ajaxStatus{
	background-color:yellow;
	position:absolute;top:5em;right:0%;
	font-size:small;
	padding:5px;
}
.hdrCredit {
	font-size:small;
}
/************************************** jquery suggest plugin ************************/
.ac_results {
	padding: 0px;
	border: 1px solid black;
	background-color: white;
	overflow: hidden;
	z-index: 99999;
}
.ac_results ul {
	width: 100%;
	list-style-position: outside;
	list-style: none;
	padding: 0;
	margin: 0;
}
.ac_results li {
	margin: 0px;
	padding: 2px 5px;
	cursor: default;
	display: block;
	font: menu;
	font-size: 12px;
	line-height: 16px;
	overflow: hidden;
}
.ac_loading {
	background: white url('/images/indicator.gif') right center no-repeat;
}
.ac_odd {
	background-color: #eee;
}
.ac_over {
	background-color: #0A246A;
	color: white;
}
.smallBtn {
	color:	#666666;
	font-size:.9em;
	font-weight:bold;
	background-color:#99CCFF;
	border:1px solid #336666;;
}
.smallBtn:hover {
	color:	red;
	cursor:pointer;
}
.loginTxt {
	font-size:.7em;
}
.helpLink {
	cursor:pointer;
	color: blue;
	text-align:right;
}
.helpLink:hover {
	color: #CC0000;
	text-decoration:underline;
}
.docSrchTip {
	font-size:smaller;
	padding-left:5px;
	padding-top:5px;
}	
.docDef {
	font-size:smaller;
	padding-left:5px;
}	
.docMoreInfo{font-size:smaller;}
.docControl {
	position:absolute;
	top:0px;
	right:0px;
	border:1px solid red;
	background-color:gray;
	z-index:101;
	cursor:pointer;
	padding:1px;
	font-size:.7em;
	}
.docTitle {
	font-weight:bold;
	padding-right:20px;
	font-size:smaller;
	}
.helpBox {
	border:1px solid green;
	padding:5px;
	background-color:#99C68E;
	max-width:20em;
	padding:.1em;
	z-index:2001;
	overflow:auto;
}

.centered {
  position: fixed;
  top: 20%;
  left: 50%;
  margin-top: -50px;
  margin-left: -100px;
}

.sscustomBox {
	border:3px solid green;
	padding:.5em;
	z-index:9999;
	position:absolute;
	top:5%;
	left:5%;
	background-color:white;
	max-width:60em;
}
.secHead{background-color:lightgrey;}
.secLabel{
	float:left;
	font-weight:bold;
}
.secControl ,.infoLink a:visited{
	float:right;
	padding-right:1em;
	cursor:pointer;
	color:#2B547E;
	font-size:.65em;
	font-family:Arial, Helvetica, sans-serif;
}
.secControl:hover {
	color:#FF0000;
	text-decoration: underline;
	}
.secDiv {
	border:1px solid green;
	width:50em;
	margin-left:1em;
}
table.ssrch {
	width:100%;
}
td.lbl {
	width:15em;
	text-align:right;
	padding-right:5px;
}
.detailBlock{
}
.innerDetailLabel{
	color: #000000;
	font-weight:normal;
}
.detailData{
	margin-left:-10px;
}
.detailCellSmall {
	font-size:.6em;
	font-weight:normal;
	color: #444444;
}
.detailCell {
	border:1px dotted gray;
	text-align:left;
	padding:2px 3px 3px 15px;
	position:relative;
	margin:1px 6px 12px 2px;
	}
.detailLabel {
	margin: 1px 0px 1px -11px;
	position:relative;
	color: #6a6a6a;
	font-size:1em;
	}
.detailEditCell {
	float:right;
	right:2px;
	top:0px;;
	position: absolute;
	cursor:pointer;
	color:#2B547E;
	font-size:.6em;
	font-family:Arial, Helvetica, sans-serif;
	}
.detailEditCell:hover {
	color:#FF0000;
	text-decoration: underline;
	}
table#SD {
	border-collapse: collapse;
}
td#SDCellLeft{
	text-align: right;
	vertical-align:top;
	row-span: 1;
	}
td#SDCellRight{
	text-align: left;
	vertical-align:top;
	row-span: 1;
	}
.detailElements{
	font-size:1em;
}
.headerInstitutionText {
	font-family:Arial, Helvetica, sans-serif;
	color:#000066; 
	font-weight:bold;
}
.headerCollectionText {
	font-family:Arial, Helvetica, sans-serif;
	font-size:24px;
	color:#000066;
}
.annotateSpace, .annotateSpace a:visited .annotateSpace a {
	font-size:.75em;
	font-weight:bold;
	color:#2B547E;
	float:right;
	cursor:pointer;
	font-family:Arial, Helvetica, sans-serif;}
}
.annotateSpace:hover {
	color:#FF0000;
	text-decoration: underline;
	}
.specResultPartCell {
	font-size: small;
	border:none;	
}
.popDivControl {
	position:absolute;
	top:0px;
	right:0px;
	cursor:pointer;
	color:#2B547E;
	font-size:.85em;
	padding:3px;
	border:1px solid red;
}
.windowCloser {
	float:right;
	clear:left;
	position:relative;
	top:0px;
	cursor:pointer;
	color:#2B547E;
	font-size:.85em;
}
.windowCloser:hover {
	color:#FF0000;
	text-decoration: underline;
}
.uploadMediaDiv {
	border:3px solid red;
	z-index:9999;
	position:absolute;
	top:5%;
	left:5%;
	width:85%;
	height:65%;
	background-color:white;
}
.customBox {
	border:3px solid green;
	z-index:9999;
	position:fixed;
	top:5%;
	left:5%;
	width:65%;
	max-height:450px;
	background-color:white;
	overflow:auto;
}
.pickDiv {
	border:3px solid green;
	z-index:9999;
	position:absolute;
	top:5%;
	left:5%;
	width:65%;
	height:450px;
	background-color:white;
	overflow:auto;
}
.popDiv {
	border:3px solid green;
	z-index:9999;
	position:absolute;
	background-color:white;
	overflow:auto;
}
table.specResultTab {
	border-width: 1px 1px 1px 1px;
	border-spacing: 0px;
	border-style: outset outset outset outset;
	border-color: gray gray gray gray;
	border-collapse: collapse;
}
table.specResultTab th {
	border-width: 1px 1px 1px 1px;
	padding: 0px 1px 0px 1px;
	border-style: solid solid solid solid;
	border-color: gray gray gray gray;
	-moz-border-radius: 0px 0px 0px 0px;
	color:gray;
}
table.specResultTab td {
	border-width: 1px 1px 1px 1px;
	padding: 0px 1px 0px 1px;
	border-style: solid solid solid solid;
	border-color: gray gray gray gray;
	-moz-border-radius: 0px 0px 0px 0px;
}
.wrapLong {
	font-size:smaller;
	width:250px;
}
div.code {
	font-size:smaller;
	color:#2F4F4F;
}
span.helpDiv{

    position:relative; /*this is the key*/

    z-index:2001;

    color:#0000FF;

    text-decoration:none;}

.red {background-color:#FF0000;}

redCheck{

	border: 5px solid red;}

.infoLink ,.infoLink a:visited {
	cursor:pointer;

	color:#2B547E;

	font-size:.65em;

	font-family:Arial, Helvetica, sans-serif;}

.infoLink:hover {

	color:#FF0000;

	text-decoration: underline;

	}
.browseLink {
	cursor:pointer;
	color: blue;}
.browseLink:hover {
	text-decoration: underline;
	color: #CC0000;
	}

.pageHelp, .pagehelp a:visited{

	font-size:.75em;

	font-weight:bold;
	color:#2B547E;

	float:right;

	}

.error {
	position:absolute;
	font-size:1.2em;
	color:red;
	border:2px solid red;
	padding:.5em;
	margin:10px;
	text-align:center;
	top:50%;
	left:20%;
	background-color:white;
	z-index:20;}
.status {
	position:absolute;
	top:50%;
	right:50%;
	z-index:998;
	background-color:green;
	color:white;
	font-size:large;
	font-weight:bold;
	padding:15px;
}
#navbar {
	color: green;
	border-bottom: 2px solid black;
	border-top: 2px solid black;
	margin: 12px 0px 0px 0px;
	padding: 0px;
	z-index: 1;
	text-align:center;}
#navbar li {
	display: inline;
	overflow: hidden;
	list-style-type: none;}
#navbar a, a.active {
	color: green;
	background-color:#E7E7E7;
	border-right:1px solid black;
	text-decoration: none;
	border-left:1px solid black;
	border-top:1px solid black;
	border-bottom:1px solid black;
	padding: 0px 5px 0px 5px;
	margin: 0px;
	font-weight:bolder;
	font-size:small;
	font-family:Arial, Helvetica, sans-serif;}	
#navbar span, span.active {
	color: green;
	background-color:#E7E7E7;
	border-right:1px solid black;
	text-decoration: none;
	border-left:1px solid black;
	border-top:1px solid black;
	border-bottom:1px solid black;
	padding: 0px 5px 0px 5px;
	margin: 0px;
	font-weight:bolder;
	font-size:small;
	font-family:Arial, Helvetica, sans-serif;}
#navbar a.active {
	background-color:#000000;
	color:green; }
#navbar span.active {
	background-color:#000000;
	color:green; }
#navbar a:hover {
	color:red;
	background: #E7E7E7;
	border-bottom:1px solid black;}
#navbar span:hover {
	color:red;
	background: #E7E7E7;
	border-bottom:1px solid black;}
#navbar a:visited {
	color: #0000FF; }
#navbar span:visited {
	color: #0000FF; }
#navbar a.active:hover {
	background: #FFFFFF;
	color: #FF0000; }
#navbar span.active:hover {
	background: #FFFFFF;
	color: #FF0000; }

div.fldDef {

	float:right; 

	clear:both; 

	border:1px solid green;

	font-size:x-small;

	color:#999999;

	padding:3px;

	margin-left:5px;

	margin-right:2px;

	width:200px;

	z-index:1;}

a.info{

    position:relative; /*this is the key*/

    z-index:24;

    color:#000;

    text-decoration:none;}

a.info:hover{z-index:20;

	background-color: transparent;

	font-size:small;}

a.info span{display: none}

a.info:hover span{ /*the span will display just on :hover state*/

    display:block;

    position:absolute;

    top:2em; left:2em;

    border:1px solid #0cf;

	background-color:#FFFFFF;

    color:#000;

    text-align: center;

	text-decoration:none;}

span.helpLink {

	background-color:#FFFFFF; 

	padding:2px;}

h1 {

	font-size:2em;

	font-weight: bold;}

h2 {

	font-size:1.6em;

	font-weight:bold;}

table.sortable a.sortheader {

    background-color:#eee;

    color:#666666;

    font-weight: bold;

    text-decoration: none;

    display: block;
    }

table.sortable span.sortarrow {

    color: black;

    text-decoration: none;}

label.h {
	display:inline;
	font-size:12px;
	font-weight:800;
	padding-right:.5em;}
label {

	display:block;

	font-size:12px;

	font-weight:800;}

fieldset {

	padding:0;}

div.content {

	margin-left:5px;

	margin-right:5px;
	clear:both;}

.smaller {

	font-size:.8em;}

div.infoBox {

	background-color:#999999;

	color:#333333;

	font-size:smaller;

	padding:3px;}

.likeLink {

	cursor:pointer;

	color: blue;}

.likeLink:hover {

	text-decoration: underline;

	color: #CC0000;}

div.group {

	background-color:#EFEFEF;

	padding: 5px;

	border: 3px solid #EFEFEF;}
.controlButton {
	color:	#666666;
	font-size:10pt;
	font-weight:bold;
	font-family: Arial, Helvetica, sans-serif;
	background-color:#99CCFF;
	border-color: #336666;
	border:1px solid;
	padding:2px;
	text-align:center;
	cursor:hand;
	text-decoration: none;}	
.redButton {
	background-color:red;
}
.removeRed {
	border:1px solid red;
}

.linkButton {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#99CCFF;

	border-color: #336666;

	border:1px solid;

	padding:2px;

	text-align:center;}

body {

	font-family:arial,sans-serif;

	background-color:#FFFFFF;}

a:link {

	text-decoration: none; 

	color: blue;}

a:visited:hover {

	text-decoration: underline;

	color: #CC0000;}

a:visited {

	text-decoration: none;

	color:#660099;}

a:hover  {

	text-decoration: underline;

	color: #CC0000;}

a.novisit {

	color: blue;}

.evenRow {

	background-color:#E5E5E5;}

.oddRow {

	background-color:#F5F5F5;}

.indent{
	text-indent:-2em;
	padding-left:2em;
}
.notFound {
	color:red;
	font-style:italic;
	text-align:center;
	padding:2em;
}
.newRec {

	background-color:#D6F5F2;}

table.newRec {

	background-color: #D6F5F2;

	padding:0;

	border-spacing:0;}
input.savBtn {

   	color:	#666666;

   	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#FBD29B;

	border:1px solid;

	border-color: #336666;}

input.lnkBtn {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#99CCFF;

	border-color: #336666;

	border:1px solid;}
.controlButton:hover, input.qutBtn:hover, input.delBtn:hover, input.picBtn:hover, input.clrBtn:hover, input.lnkBtn:hover, input.schBtn:hover, input.insBtn:hover,input.savBtn:hover {
	border-color:#FF6633;
	cursor:pointer;
} 

input.schBtn {

	color:#666666;

	font-size:10pt;

	font-weight:bold;

	font-family:Arial, Helvetica, sans-serif;

	background-color:#CCCC99;

	border-color:#336666;

	border:1px solid;}


input.clrBtn {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#FFCC00;

	border-color: #336666;

	border:1px solid;}

input.insBtn {

	color:	#666666;

	font-weight:bold;

	background-color:#99CCCC;

	border:1px solid #336666;}

input.picBtn {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#CCCC99;

	border-color: #336666;

	border:1px solid;}

input.delBtn {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#FF9966;

	border-color: #336666;

	border:1px solid;}

input.qutBtn {

	color:	#666666;

	font-size:10pt;

	font-weight:bold;

	font-family: Arial, Helvetica, sans-serif;

	background-color:#FFFF00  ;

	border-color: #336666;

	border:1px solid;}

input.reqdClr, select.reqdClr, textarea.reqdClr {

   background-color:#FFFF33; }

input.badPick, select.badPick, textarea.badPick {

	background-color:#FF3366;}

.goodPick {

	background-color:#8BFEB9;}	 

input.seleClr, select.seleClr, textarea.seleClr {

	background-color:#FF0000;}	 	

input.readClr, select.readClr {

	background-color:#CCCCCC;}
.btnhov {

	border-top-color:#FF6633 ;

	border-left-color:#FF6633 ;

	border-right-color:#FF6666 ;

	border-bottom-color:#FF6666 ;

	cursor:pointer;}
.external:after {
	text-decoration: none !important;
	content: url(/images/linkOut.gif);	margin-left: 3px;
	
	}
a.external:link:after {
	text-decoration: none !important;
	content: url(/images/linkOut.gif);	margin-left: 3px;
	
	}
a.external:hover:after {
	text-decoration: none !important;
	content: url(/images/linkOutHover.gif);	margin-left: 3px;
	
	}
a.external:visited:after {
	text-decoration: none !important;
	content: url(/images/linkOutVisited.gif);	margin-left: 3px;
	
	}
a.external:hover:visited:after {
	text-decoration: none !important;
	content: url(/images/linkOutHover.gif);	margin-left: 3px;
	
	}
/*************************************************** Superfish ********************************************************/
.sf-menu, .sf-menu * {
	margin:			0;
	padding:		0;
	list-style:		none;
}
.sf-menu {
	line-height:	1.0;
}
.sf-menu ul {
	position:		absolute;
	top:			-999em;
	width:			10em; /* left offset of submenus need to match (see below) */
}
.sf-menu ul li {
	width:			100%;
}
.sf-menu li:hover {
	visibility:		inherit; /* fixes IE7 'sticky bug' */
}
.sf-menu li {
	float:			left;
	position:		relative;
}
.sf-menu a {
	display:		block;
	position:		relative;
}
.sf-menu li:hover ul,
.sf-menu li.sfHover ul {
	left:			0;
	top:			1.5em; /* match top ul list item height */
	z-index:		99;
}
ul.sf-menu li:hover li ul,
ul.sf-menu li.sfHover li ul {
	top:			-999em;
}
ul.sf-menu li li:hover ul,
ul.sf-menu li li.sfHover ul {
	left:			10em; /* match ul width */
	top:			0;
}
ul.sf-menu li li:hover li ul,
ul.sf-menu li li.sfHover li ul {
	top:			-999em;
}
ul.sf-menu li li li:hover ul,
ul.sf-menu li li li.sfHover ul {
	left:			10em; /* match ul width */
	top:			0;
}
/*** DEMO SKIN ***/
.sf-menu {
	float:			left;
	margin-bottom:	.1em;
}
.sf-menu a {
	border-left:	1px solid #fff;
	border-top:		1px solid #CFDEFF;
	padding: 		.25em 2em;
	text-decoration:none;
}
.sf-menu a, .sf-menu a:visited  { /* visited pseudo selector so IE6 applies text colour*/
	color:			#0000FF;
}
.sf-menu li {
	background:		#E7E7E7;
}
.sf-menu li li {
	background:		#E7E7E7;
}
.sf-menu li li li {
	background:		#E7E7E7;
}
.sf-menu li:hover, .sf-menu li.sfHover,
.sf-menu a:focus, .sf-menu a:hover, .sf-menu a:active {
	background:		#D0D0D0;
	outline:		0;
	color:red;
}
.sf-menu a.sf-with-ul {
	padding-right: 	2.25em;
	min-width:		1px; /* trigger IE7 hasLayout so spans position accurately */
}
.sf-sub-indicator {
	position:		absolute;
	display:		block;
	right:			.25em;
	top:			1.05em; /* IE6 only */
	width:			10px;
	height:			10px;
	text-indent: 	-999em;
	overflow:		hidden;
	background:		url('/images/css/arrows-ffffff.png') no-repeat -10px -100px; /* 8-bit indexed alpha png. IE6 gets solid image only */
}
a > .sf-sub-indicator {  /* give all except IE6 the correct values */
	top:			.6em;
	background-position: 0 -100px; /* use translucent arrow for modern browsers*/
}
/* apply hovers to modern browsers */
a:focus > .sf-sub-indicator,
a:hover > .sf-sub-indicator,
a:active > .sf-sub-indicator,
li:hover > a > .sf-sub-indicator,
li.sfHover > a > .sf-sub-indicator {
	background-position: -10px -100px; /* arrow hovers for modern browsers*/
}

/* point right for anchors in subs */
.sf-menu ul .sf-sub-indicator { background-position:  -10px 0; }
.sf-menu ul a > .sf-sub-indicator { background-position:  0 0; }
/* apply hovers to modern browsers */
.sf-menu ul a:focus > .sf-sub-indicator,
.sf-menu ul a:hover > .sf-sub-indicator,
.sf-menu ul a:active > .sf-sub-indicator,
.sf-menu ul li:hover > a > .sf-sub-indicator,
.sf-menu ul li.sfHover > a > .sf-sub-indicator {
	background-position: -10px 0; /* arrow hovers for modern browsers*/
}

/*** shadows for all but IE6 ***/
.sf-shadow ul {
	background:	url('/images/css/shadow.png') no-repeat bottom right;
	padding: 0 8px 9px 0;
	-moz-border-radius-bottomleft: 17px;
	-moz-border-radius-topright: 17px;
	-webkit-border-top-right-radius: 17px;
	-webkit-border-bottom-left-radius: 17px;
}
.sf-shadow ul.sf-shadow-off {
	background: transparent;
}
.sf-mainMenuWrapper { 
	clear:left;
	float:left;
	width:100%;
	font-size:small;
	font-weight:400;
	background:#E7E7E7;
	border-top:1px solid white;
}
/************************ dropdown taxonomy results *****************************/
div.submenu {
width:100%;
float: left;
}

div.submenu ul {
list-style: none;
margin: 0;
padding: 0;
width: 100%;
float: left;
}

div.submenu a, div.submenu h2 {
font: bold 11px/16px arial, helvetica, sans-serif;
display: block;
border-width: 1px;
border-style: solid;
border-color: #ccc #888 #555 #bbb;
margin: 0;
padding: 2px 3px;
}

div.submenu h2 {
color: #0000FF;
background:url(/images/small-black-down-arrow.gif) no-repeat 100% 100%;
cursor:pointer;
}

div.submenu a {
color: #0000FF;
background: #E7E7E7;
text-decoration: none;
}

div.submenu a:hover {
color: red;
}

div.submenu li {position: relative;}

div.submenu ul ul {
position: absolute;
z-index: 500;
}

div.submenu ul ul ul {
position: absolute;
top: 0;
left: 100%;
}

div.submenu ul ul,
div.submenu ul li:hover ul ul,
div.submenu ul ul li:hover ul ul
{display: none;}

div.submenu ul li:hover ul,
div.submenu ul ul li:hover ul,
div.submenu ul ul ul li:hover ul
{display: block;}

div.submenu h2:hover{
background:#E7E7E7 url(/images/small-black-down-arrow.gif) no-repeat 100% 100%;
color:#0000FF;
}




</style>



<table border id="olTabl">
	<tr>
		<td id="td_search">
			srch
		</td>
		<td id="td_rslt" rowspan="2">
			edit 
		</td>
	</tr>
	<tr>
		<td id="td_edit" valign="top">
			results
		</td>
	</tr>
</table>