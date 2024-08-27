
<script language="javascript">
var __modalvars={},__modalwins={},__cntProcesando=0;
function procesando2(on,win){
 var cnt=top.__cntProcesando?isNaN(top.__cntProcesando)?0:top.__cntProcesando:0;
 var v=getId('ifr_procesando',top.document);
 if(on){
  cnt=((++cnt)<1)?1:cnt;
  v.style.display='block';
  if(top.ifr_procesando.debugMode) top.ifr_procesando.debugMode();
  v=getId('procesando',top.frames.ifr_procesando.document);
  if(v){
   var vp=top.frames.ifr_procesando.document.body,vh;
   v.style.display='';
   vh=(vp.offsetHeight>1024)?1024:vp.offsetHeight;
   v.style.top=((vh-v.offsetHeight)/2)+'px';
   v.style.left=((vp.offsetWidth-v.offsetWidth)/2)+'px';
  }
 }else{
  if((--cnt)<1){
   v.style.display='';
   if(v=getId('procesando',top.frames.ifr_procesando.document)){
    v.style.display='none';
   }
   cnt=0;
  }
 }
 top.__cntProcesando=cnt;
}
function modalPortal2(p,win){
 var ifs=top.document.getElementsByTagName('IFRAME');
 var el=top.document.createElement('IFRAME');
 __modalvars['md'+ifs.length]=p;
 __modalwins['mw'+ifs.length]=win;
 el.name=el.id='mp'+ifs.length;
 el.frameBorder=el.scrolling='no';
 el.marginHeight=el.marginWidth='0';
 el.allowTransparency=getId('ifr_alerts').getAttribute('allowtransparency');
 el.src='/newintra/lib/modal.html?id='+ifs.length;
 el.className='modales';
 el.style.zIndex=99+ifs.length;
 top.document.body.appendChild(el);
}
function cierraModal(nom,win){
 var w=top.document.getElementById(nom);
 if(w) top.document.body.removeChild(w);
}
function muestraError2(e,et,win){
 try{
  top.frames.ifr_alerts.muestraError(e,win);
 }catch(err){
  alert(et||e.msg.replace(/<br[^>]*>|<li[^>]*><p[^>]*>/ig,'\n').replace(/<\/[^>]*>/ig,''));
 }
}
///////////////////////////////////////////////////
function carga_xml2json() {
  /* nos aseguramos de que cargue la librería xml2json */
  if (typeof xml2json == 'undefined' || typeof xml2json.parser != 'function') {
   var head = document.getElementsByTagName('head')[0];
   var script = document.createElement("script");
   script.type = "text/javascript";
   script.src = '/newintra/js2.0/xml2json.js';
   head.appendChild(script);
  }
  /* ************************************************* */
 }

 function peticionAjax() {
  var browser = getBrowser();
  var dato = {
   metodo    : 'POST',
   direccion : '',
   caracteres: '',
   parametros: {},
   retorno   : function() { alert('no se ha especificado retorno'); },
   extra     : {},
   canal     : '',
   asincrono : (browser.browserName=='Internet Explorer' && parseInt(browser.browserVersion)<=8?false:true),
   autoXSID  : true,
   xres      :'C',
   contentType:'application/x-www-form-urlencoded' 
  };
  this.respuesta = function() {
   var http = (dato.asincrono)?this:this.xmlhttp;
   if (http.readyState==4) {
    var resultado = '';
    if(http.responseType !="arraybuffer"){
      if (http.responseText==""||http.responseText==null) {
       try { dato.retorno (false, 'La llamada no ha devuelto datos' ); } catch(e) {} 
       return; //Ha llegado una cadena vacía del servidor, abortamos el resto de comprobaciones y devolvemos la situación
      }
    }
    
    switch (dato.canal) {
     case 'JSON': try {resultado = (typeof JSON != 'undefined')?JSON.parse(http.responseText):eval("(function(){return " + http.responseText + ";})()"); } catch (e) { dato.retorno (false, 'No es un JSON v&aacute;lido'); return;} break;
     case 'XML' : try {resultado = xml2json.parser(http.responseText);} catch (e) { dato.retorno (false, 'No es un XML v&aacute;lido' ); return;} break;
     case 'FILE' : 
        try {
            if(http.status != 200){
               var resultado =  JSON.parse(arrayBufferToString(http.response));
            }else{
              var type = http.getResponseHeader("Content-Type");
              var blob = new Blob([http.response], {type: type});
              var filename =  getValueFilename(dato.parametros.originFile,dato.parametros.fileName);
              blob.name = filename;
              blob.filename = filename;
              if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                  window.navigator.msSaveOrOpenBlob(blob, filename);
              } else {
                  var URL = window.URL || window.webkitURL;
                  var downloadUrl = URL.createObjectURL(blob);
                  var a = document.createElement("a");
                  a.href = downloadUrl;
                  a.target = '_blank';
                  if (!dato.parametros.preview) a.download = filename;
                  var clicEvent = new MouseEvent('click', {'view': window, 'bubbles': true, 'cancelable': true});
                  a.dispatchEvent(clicEvent);
              }
              setTimeout(function () { try { URL.revokeObjectURL(downloadUrl); } catch(e) { return false; } }, 100); 
            }
        } catch (e) { 
              dato.retorno (false, decodeURIComponent(escape(JSON.parse(e.message).errorMessage))); return;
         } 
         break;
     default    : resultado = http.responseText;
    }
    if (typeof dato.retorno == 'function') dato.retorno ((http.status==200&&(typeof resultado.success == 'undefined' || resultado.success))?true:false,resultado,dato.extra);
   }
  }
  this.pide = function (obj) {
   var chd,cad='';
   dato.metodo     =((typeof obj.metodo     == 'undefined')?dato.metodo:obj.metodo).toUpperCase();
   dato.direccion  = (typeof obj.direccion  == 'undefined')?dato.direccion:obj.direccion;
   dato.parametros = (typeof obj.parametros == 'undefined')?dato.parametros:obj.parametros;
   dato.retorno    = (typeof obj.retorno    == 'undefined')?dato.retorno:obj.retorno;
   dato.extra      = (typeof obj.extra      == 'undefined')?dato.extra:obj.extra;
   dato.asincrono  = (typeof obj.asincrono  == 'undefined')?dato.asincrono:obj.asincrono;
   dato.autoXSID   = (typeof obj.autoXSID   == 'undefined')?dato.autoXSID:obj.autoXSID;
   dato.contentType   = (typeof obj.contentType  == 'undefined')?dato.contentType:obj.contentType;
   dato.contentType   = (typeof obj.parametros  == 'undefined')?dato.contentType:(typeof obj.parametros.contentType  == 'undefined')?dato.contentType:obj.parametros.contentType;
   dato.caracteres = (typeof obj.caracteres == 'undefined')?dato.caracteres:obj.caracteres;
   dato.caracteres = ((dato.caracteres!=''&&dato.caracteres!=null)?'charset='+dato.caracteres:'');
   if (obj.parametros && obj.parametros.xchn) {
     dato.canal = obj.parametros.xchn.toUpperCase();   
   } else {
	 dato.canal      = dato.direccion.split('.');
     dato.canal      = dato.canal[dato.canal.length-1].toUpperCase();
   }
   if (dato.canal == 'XML') carga_xml2json();
   if (window.XMLHttpRequest) { this.xmlhttp=new XMLHttpRequest(); }
   else { this.xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); }
   if (dato.asincrono) this.xmlhttp.onreadystatechange = this.respuesta;
   if (dato.autoXSID) {
    if (typeof dato.parametros.xsid == 'undefined') dato.parametros.xsid = null;
    if (dato.parametros.xsid == null) dato.parametros.xsid = (top.SESION_ID?top.SESION_ID:null);
    if (dato.parametros.xsid == null) dato.parametros.xsid = (opener && opener.top.SESION_ID?opener.top.SESION_ID:null);
    if (dato.parametros.xsid == null) dato.parametros.xsid = getValue('xsid').cambia('#','');
    if (dato.parametros.xsid == null) dato.parametros.xsid = getValue('xsid',parent).cambia('#','');
    if (dato.parametros.xsid == null) dato.parametros.xsid = getValue('xsid',opener).cambia('#','');
   }
   dato.parametros.xres = (typeof obj.xres == 'undefined')?'C':obj.parametros.xres;
   for(chd in dato.parametros) { cad+= "&"+chd+"="+escape(String(dato.parametros[chd]).cambia('€','E')); } cad = cad.substr(1);
   if (dato.metodo == 'POST') {
    this.xmlhttp.open(dato.metodo,dato.direccion,dato.asincrono);  
    if (dato.contentType =='application/json'){
      this.xmlhttp.setRequestHeader("Content-type","application/json;"+dato.caracteres+"");
      if(dato.canal == "FILE")
        this.xmlhttp.responseType = 'arraybuffer'; 
      this.xmlhttp.send(JSON.stringify(obj.parametros)); 
    }else if (dato.contentType =='multipart/form-data'){
       this.xmlhttp.send(dato.parametros.data);  
    }else{
      this.xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded;"+dato.caracteres+""); 
      if(dato.canal == "FILE")
        this.xmlhttp.responseType = 'arraybuffer'; 
      this.xmlhttp.send(cad);
    }
   }else if (dato.metodo == 'DELETE') {
      this.xmlhttp.open(dato.metodo,dato.direccion,dato.asincrono);
      this.xmlhttp.setRequestHeader("Content-type","application/json");  
      this.xmlhttp.send(JSON.stringify(obj.parametros));
   
   }else {
    this.xmlhttp.open("GET",dato.direccion+'?'+cad,dato.asincrono);
    //this.xmlhttp.setRequestHeader('Access-Control-Allow-Origin', '*');
    //this.xmlhttp.setRequestHeader('Access-Control-Allow-Methods', '*');
    this.xmlhttp.send();
   }
   if (!dato.asincrono) this.respuesta();
  }
 }
 
 function invocaAjax(obj) { 
  obj = obj||{};
  if (typeof obj.direccion == 'undefined' || obj.direccion.length == 0) {
   if (typeof obj.retorno == 'function') obj.retorno (false,'No se ha definido direcci&oacute;n de llamada');
   else alert('no se ha especificado retorno'); 
  } else {
   var conex = new peticionAjax(); 
   conex.pide(obj);
  }
 }
 
function arrayBufferToString(buffer){
    var arr = new Uint8Array(buffer);
    var str = String.fromCharCode.apply(String, arr);
    if(/[\u0080-\uffff]/.test(str)){
        throw new Error(str);
    }
    return str;
}

function getValueFilename(path,name) {
		var filename = new String();
		if(empty(name) && !empty(path) )
			filename = path.substr(path.lastIndexOf("/")+1);
		else
			filename = name;
		return filename;
	}




function abreDoc(obj) {
    
    //procesando(1);
    invocaAjax({
 	  direccion: '/newintra/newintra/1/xwi_consulta_nomina.genera_nomina.json',
    parametros: {p_pernr:   obj.getAttribute('p_pernr')||'',
                 p_periodo: obj.getAttribute('p_periodo')||'',
                 p_bukrs:   obj.getAttribute('p_bukrs')||'',
                 p_gjahr:   obj.getAttribute('p_gjahr')||'',
                 p_juper:   obj.getAttribute('p_juper')||'',
                 p_abkrs:   obj.getAttribute('Abkrs')||''
                },
	  retorno: function (suc, dat, ext) {
                procesando(0);
                if(suc) getFile(dat.file.origen,dat.file.nombre,false);
                else    muestraError({tit:'Consulta de nóminas', tipo:'error', msg:resuelveError(dat)});
             }
	  }); 
}


</script>


<body>
<button class="docpdf" type="button" onclick="abreDoc(this);" p_juper="" p_pernr="00019316" p_periodo="06" p_bukrs="HGA" p_gjahr="2017" p_abkrs="Z3"></button>

</body>