// JavaScript Document
//Función para crear un objeto XMLHttpRequest
function crearAjax() {
  var Ajax
 
  if (window.XMLHttpRequest)
  	{ // Intento de crear el objeto para Mozilla, Safari,...
    Ajax = new XMLHttpRequest();
    if (Ajax.overrideMimeType) 
		{
		//alert('mimetype ajax: ' + Ajax.overrideMimeType)
      	//Se establece el tipo de contenido para el objeto
      	//http_request.overrideMimeType('text/xml');
      	//http_request.overrideMimeType('text/html; charset=iso-8859-1');
	  	//http_request.overrideMimeType('text/html; charset=windows-1252');
		//http_request.overrideMimeType('text/html; charset=utf-8');
		}
   	}
  else if (window.ActiveXObject) 
  	{ // IE
    try
		{ //Primero se prueba con la mas reciente versión para IE
      	Ajax = new ActiveXObject("Msxml2.XMLHTTP");
     	} 
		catch (e)
			{
       		try
				{ //Si el explorer no esta actualizado se prueba con la versión anterior
         		Ajax = new ActiveXObject("Microsoft.XMLHTTP");
        		} 
				catch (e) 
					{}
      		}
   	}
 	//Ajax.SetRequestHeader "Content-Type","text/html; charset=utf-8" 
  if (!Ajax) {
    alert('¡Por favor, actualice su navegador!');
    return false;
   }
  else
  {
    return Ajax;
    }
 
 }

function Actualizar_Combos (pagina, empresa, valor_seleccionado, divContenedora, ordenacion)
  {
	var contenedor = document.getElementById(divContenedora);  	
	
	
			
		//alert('Actualizamos combo de la Capa ' + divContenedora)
 		//Se contruye la url pasando, como parámetro, el valor seleccionado
		var url_final = pagina + '?empresa=' + empresa + '&valor_seleccionado=' + valor_seleccionado + '&orden=' + ordenacion
 		//alert(url_final)
	    //Se muestra una imagen de espera en la capa contenedora del combo delimitado
    	contenedor.innerHTML = '<img src="images/loading_ajax.gif" />'
		//alert('he puesto la imagen')
		//Se crea un objeto XMLHttpRequest
	    var objAjax = crearAjax()
 		//alert('he creado el objeto ajax')
 		
 		//alert('mimetype ajax: ' + objAjax.overrideMimeType)
		
    	objAjax.open("GET", url_final)
		//objAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); 
		//objAjax.SetRequestHeader("Content-Type","text/html; charset=utf-8")
		//objAjax.SetRequestHeader("Content-Type","text/html; charset=iso-8859-1")
		//alert('antes de igualar lo que devuelve ajax')
	    objAjax.onreadystatechange = function() {
    											if (objAjax.readyState == 4)
													{
													//Se escribe el resultado en la capa contenedora
       												contenedor.innerHTML = objAjax.responseText;
													//contenedor.innerHTML = objAjax.responseText;
      												}
    											}
    	objAjax.send(null);
		
		
	

	//alert('FIN CREACION AJAX')	
  }
  
  