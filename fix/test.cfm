
<script type="javascript">
    function ahah(url, target, delay) {
      var req;
      document.getElementById(target).innerHTML = 'Fetching Data...';
	  if (window.XMLHttpRequest) {
	    req = new XMLHttpRequest();
	  } else if (window.ActiveXObject) {
	    req = new ActiveXObject("Microsoft.XMLHTTP");
	  }
	  if (req != undefined) {
	    req.onreadystatechange = function() {ahahDone(req, url, target, delay);};
	    req.open("GET", url, true);
	    req.send("");
	  }
    }  
    function ahahDone(req, url, target, delay) {
        if (req.readyState == 4) { // only if req is "loaded"
            if (req.status == 200) { // only if "OK"
              document.getElementById(target).innerHTML = req.responseText;
            } else {
              document.getElementById(target).innerHTML="ahah error:\n"+req.statusText;
            }
            if (delay != undefined) {
               setTimeout("ahah(url,target,delay)", delay); // resubmit after delay
	        }
         }
    }
</script>

bla
<div id="test">

</div>

<script>
	ahah('http://g-arctos.appspot.com/ws?q=elevation','test');
</script>
