function muestra(nombrediv) 
{ 
	if(document.getElementById(nombrediv).style.display == '') 
		{ 
        	document.getElementById(nombrediv).style.display = 'none'; 
        }
	  else 
	  	{ 
        	document.getElementById(nombrediv).style.display = ''; 
        } 
}



function h3hover() {this.id == 'h3hover' ? this.id = '' : this.id = 'h3hover'} /* para IE */

function recogeODespliega() {
	if (this.className == 'recogido') {
		this.className = ''
		this.nextSibling.className = '' /* para IE */
		if (this.nextSibling.nextSibling)
			this.nextSibling.nextSibling.className = '' /* para el resto */
	} else {
		this.className = 'recogido'
		this.nextSibling.className = 'recogido' /* para IE */
		if (this.nextSibling.nextSibling)
			this.nextSibling.nextSibling.className = 'recogido' /* para el resto */
	}
}

function recogearticulos() {
	var noticiasDIV = document.getElementById('displaynewproducts0')
	if (noticiasDIV) {
		var noticiasH3 = noticiasDIV.getElementsByTagName('a')
		for (var i=0, noticiaH3; noticiaH3=noticiasH3[i]; i++) {
			//noticiaH3.onmouseover = h3hover /* para IE */
			//noticiaH3.onmouseout = h3hover /* para IE */
			noticiaH3.onclick = recogeODespliega
			noticiaH3.className = '' /* para IE */
			if (i != 0)
				noticiaH3.onclick()
		}
	}
}

function comprobar_numero_entero(dato)
{
		var cadenachequeo = "0123456789"; 
  		var valido = true; 
  		var lugaresdecimales = 0; 
  		var cadenacompleta = ""; 
		for (i = 0; i < dato.length; i++)
		 { 
    		ch = dato.charAt(i); 
    		for (j = 0; j < cadenachequeo.length; j++) 
      			if (ch == cadenachequeo.charAt(j))
        			break; 
    		if (j == cadenachequeo.length)
			 { 
      			valido = false; 
      			break; 
    		 } 
    		cadenacompleta += ch; 
  		 } 
  	
		if ((!valido) || (dato=='') || (dato<=0))
		 	return (false)
  		  else
		  	return (true);

}

function annadir_al_carrito(articulo)
{
	if (document.getElementById('ocultocantidades_precios_' + articulo).value=='')
		{
		alert('Para Añadir El Artículo al Carrito ha de Seleccionar Las Cantidades/Precios del Mismo')
		}
	  else
		{
		if (document.getElementById('ocultocantidades_precios_' + articulo).value=='OTRAS CANTIDADES')
			{
			//alert('Para poder seleccionar Otras Cantidades/Precios ha de ponerse en contacto con Globalia Artes Graficas')
			//equivalencia de los caracteres especiales y lo que hay que poner en el mailto
			//á é í ó ú Á É Í Ó Ú Ñ ñ ü Ü
			//%E1 %E9 %ED %F3 %FA %C1 %C9 %CD %D3 %DA %D1 %F1 %FC %DC
			//
			//para insertar saltos de linea
			//%0D%0A%0A
			
			cadena_email='mailto:carlos.gonzalez@globalia-artesgraficas.com'
			cadena_email+= '?subject=Nuevo Escalado Barcel%F3'
			cadena_email+= '&body=Por favor indique el nombre y c%F3digo Sap. del art%EDculo del que desea que le facilitemos'
			cadena_email+= ' un nuevo escalado y a continuaci%F3n la cantidad requerida.'
			cadena_email+= '%0D%0A%0A En breve la encontrar%E1 colgada en el gestor de pedidos.'
			cadena_email+= '%0D%0A%0AUn saludo.'

			location.href=cadena_email
			}
		  else
		  	{
			document.getElementById('ocultoarticulo').value=articulo
			//si es uno de los articulos con compromiso de compra, vendra con xxx en las cantidades
			//  tengo que sustituirlo por lo que el usuario introduzca manualmente en la cantidad del
			//  articulo seleccionado
			//alert('cantidades antes: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
			if (document.getElementById('ocultocantidades_precios_' + articulo).value.indexOf('XXX')!=-1) 
				{
				if (comprobar_numero_entero(document.getElementById('txtcantidad_' + articulo).value))
					{
					document.getElementById('ocultocantidades_precios_' + articulo).value=document.getElementById('ocultocantidades_precios_' + articulo).value.replace('XXX',document.getElementById('txtcantidad_' + articulo).value)
					document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
					//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)

					document.getElementById('frmannadir_al_carrito').submit()
					}
				  else
				  	{
						alert('La Cantidad Introducida Ha De Ser Un Número Entero')
						document.getElementById('txtcantidad_' + articulo).value=''
					}
				}
			  else
			  	{
				//cuando el articulo es sin compromiso de compra, ya viene la cantidad bien
				document.getElementById('ocultocantidades_precios').value=document.getElementById('ocultocantidades_precios_' + articulo).value
				//alert('cantidades despues: ' + document.getElementById('ocultocantidades_precios_' + articulo).value)
				document.getElementById('frmannadir_al_carrito').submit()
				}
			
			}
	
		}  
}

function seleccionar_fila(articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';

	}
	
	document.getElementById('fila_' + articulo + '_' + fila_pulsada).style.background='#E1E1E1' 
	document.getElementById ('fila_' + articulo + '_' + fila_pulsada).style.fontWeight = 'bold'
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
}

function seleccionar_fila_admin(tipo_precio, articulo, fila_pulsada, numero_filas,cantidades_precio_total_articulo,compromiso_compra)
{
	for (i=1;i<=numero_filas;i++)
	{
	document.getElementById('fila_' + articulo + '_' + i + '_' + tipo_precio).style.background=''
	document.getElementById ('fila_' + articulo + '_' + i + '_' + tipo_precio).style.fontWeight = 'normal'
//var fontTest = document.getElementById ('fila_' + articulo + '_' + i)
    //fontTest.style.fontWeight = '900';

	}
	
	document.getElementById('fila_' + articulo + '_' + fila_pulsada + '_' + tipo_precio).style.background='#E1E1E1' 
	document.getElementById ('fila_' + articulo + '_' + fila_pulsada + '_' + tipo_precio).style.fontWeight = 'bold'
	//alert('compromiso_compra: ' + compromiso_compra)
	document.getElementById('ocultocantidades_precios_' + articulo).value=cantidades_precio_total_articulo
		
	  	
}
