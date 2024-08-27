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
  	
		if (!valido)
		 	return (false)
  		  else
		  	return (true);

}

function comprobar_numero_decimal(numero)
{
	if (!/^([0-9])*[.]?[0-9]*$/.test(numero))
	{
		if (!/^([0-9])*[,]?[0-9]*$/.test(numero))
			return (false);
	  	else
			return (true);
	}
	else
	{
		return (true);
	}
}

function comprobar_cadena(dato)
{


		var cadenachequeo = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚabcdefghijklmnñopqrstuvwxyzáéíóú "; 
  		var valido = true; 
  		cadenacompleta = ""; 
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
  	
		if (!valido)
		 	return (false)
		  else
		  	return (true);
  		 
		
		}	
		
		
function comprobar_correo_electronico(dato)
{
	if (dato.length > 0)
		{
		  if ((dato.value.indexOf ('@', 0) == -1)||(dato.value.length < 5))
		 		return (false)
			else
				return (true)
			 
  		 }
	  else
	  	return (false);	 

}		


	
function comprobar_formato_fecha(fecha)
	{
		//alert('valor: ' + fecha)
		//alert('tamaño: ' + fecha.length)
		
	  var correcto=true;
	  if (fecha.length==10)
		for (i = 0; i < fecha.length; i++)
		 {
		 	//alert('vuelta :' + i) 
		 	if ((i==2) || (i==5))
				{
					if (fecha.charAt(i)!='-')
						{
						 correcto=false;
						 break;
						}
				}
			  else
			  	{
		 		if ((fecha.charAt(i)=='0')||(fecha.charAt(i)=='1')||(fecha.charAt(i)=='2')||(fecha.charAt(i)=='3')||(fecha.charAt(i)=='4')||(fecha.charAt(i)=='5')||(fecha.charAt(i)=='6')||(fecha.charAt(i)=='7')||(fecha.charAt(i)=='8')||(fecha.charAt(i)=='9'))
					correcto=true
				  else
					{
						correcto=false
						break;
					}
		 		}
		 }
	  else
	  	correcto=false;
		 
		if (correcto)
			{	
		 	  //alert('la fecha ' + fecha + ' es correcta')
				return (true)
			}
		   else
		   	{
		     //alert('la fecha ' + fecha + ' es INcorrecta')
		   	return (false)
			}
    	
		
	}

function comprobar_fecha_correcta(fecha)
{
	var dia=fecha.substring(0,2)
	var mes=fecha.substring(3,5)
	var anno=parseInt(fecha.substring(6,10))
	
	var diasmeses=new Array(31,28,31,30,31,30,31,31,30,31,30,31)
	var valido=true
	
	//alert('subcadena fecha del mes: ' + fecha.substring(3,5))
	//alert('dia: ' + dia + '\nMes: ' + mes + '\nAño: ' + anno + '\nDiasmes: ' + diasmeses[mes-1])
	
	if (esbisiesto(anno))
		diasmeses[1]=29
	
	if ((mes>0) && (mes<=12))
		if ((dia>0)&& (dia<=diasmeses[mes-1]))
			valido=true
		  else
		  	{
		  	valido=false;
			//alert('el mes ' + mes + ' tiene ' + diasmeses[mes-1] + ' dias, y no ' + dia);
			}
	  else
	  	{
	  	valido=false;
		//alert('el mes ha de ser menor que 13');
		}
	if (anno<1900)
		valido=false;
	return (valido)
	
}

function esbisiesto(anno) 
{ 
	var BISIESTO; 
	if(parseInt(anno)%4==0)
		{ 
		 if(parseInt(anno)%100==0)
		 	{ 
			 if(parseInt(anno)%400==0)
			 	{ 
					BISIESTO=true; 
				} 
			  else
			  	{ 
					BISIESTO=false; 
				} 
			} 
		  else
		  	{ 
				BISIESTO=true; 
			} 
		} 
	  else 
		BISIESTO=false; 


return BISIESTO; 
} 


function comprobar_formato_hora(hora)
	{
		//alert('valor: ' + fecha)
		//alert('tamaño: ' + fecha.length)
		
	  var correcto=true;
	  if (hora.length==5)
		for (i = 0; i < hora.length; i++)
		 {
		 	//alert('vuelta :' + i) 
		 	if ((i==2))
				{
					if (hora.charAt(i)!=':')
						{
						 correcto=false;
						 break;
						}
				}
			  else
			  	{
		 		if ((hora.charAt(i)=='0')||(hora.charAt(i)=='1')||(hora.charAt(i)=='2')||(hora.charAt(i)=='3')||(hora.charAt(i)=='4')||(hora.charAt(i)=='5')||(hora.charAt(i)=='6')||(hora.charAt(i)=='7')||(hora.charAt(i)=='8')||(hora.charAt(i)=='9'))
					correcto=true
				  else
					{
						correcto=false
						break;
					}
		 		}
		 }
	  else
	  	correcto=false;
		 
		if (correcto)
			{	
		 	  //alert('la fecha ' + fecha + ' es correcta')
				return (true)
			}
		   else
		   	{
		     //alert('la fecha ' + fecha + ' es INcorrecta')
		   	return (false)
			}
    	
		
	}

function comprobar_hora_correcta(hora)
{
	var horas=hora.substring(0,2)
	var minutos=hora.substring(3,5)
	
	var valido=true
	
	//alert('subcadena fecha del mes: ' + fecha.substring(3,5))
	//alert('HORA: ' + horas + '\nminutos: ' + minutos) 
	
	
	if ((horas>=0) && (horas<=24))
		if ((minutos>=0)&& (minutos<=59))
			valido=true
		  else
		  	{
		  	valido=false;
			//alert('el mes ' + mes + ' tiene ' + diasmeses[mes-1] + ' dias, y no ' + dia);
			}
	  else
	  	{
	  	valido=false;
		//alert('el mes ha de ser menor que 13');
		}
	
	return (valido)
	
}

function comprobar_formato_expediente(expediente)
{
	var valido=true;
	var sucursal=expediente.substring(0,3)
	var documento=expediente.substring(4,11)
	
	//alert(expediente.charAt(3))
	//alert(sucursal)
	//alert(documento)
			
	//formato 995/1234567
	if (expediente.length==11)
		{
			if (expediente.charAt(3)=='/')
				{
					if (comprobar_numero_entero(sucursal.substring(1,3)))
						{
							if (comprobar_numero_entero(documento))
								valido=true;
							  else
							  	valido=false;
							  
						}
					  else
					  	valido=false;
				}
			  else
			  	valido=false;
			
		}
	else
		{
			valido=false;
		}
	return (valido);
}

function currencyFormat(fld, milSep, decSep, e,limite,decimales) { 
if (fld.value.length>limite)
	return false;
    var sep = 0; 
    var key = ''; 
    var i = j = 0; 
    var len = len2 = 0; 
    var strCheck = '0123456789'; 
    var aux = aux2 = ''; 
    var whichCode = (window.Event) ? e.which : e.keyCode; 
    if (whichCode == 13) return true; // Enter 
    key = String.fromCharCode(whichCode); // Get key value from key code 
    if (strCheck.indexOf(key) == -1) return false; // Not a valid key 
    len = fld.value.length; 
    for(i = 0; i < len; i++) 
     if ((fld.value.charAt(i) != '0') && (fld.value.charAt(i) != decSep)) break; 
    aux = ''; 
    for(; i < len; i++) 
     if (strCheck.indexOf(fld.value.charAt(i))!=-1) aux += fld.value.charAt(i); 
    aux += key; 
    len = aux.length; 
   if(decimales==2)
   {
    if (len == 0) fld.value = ''; 
    if (len == 1) fld.value = '0'+ decSep + '0' + aux; 
    if (len == 2) fld.value = '0'+ decSep + aux; 
    if (len > 2) 
	{ 
     aux2 = ''; 
     for (j = 0, i = len - 3; i >= 0; i--) { 
      if (j == 3) { 
       aux2 += milSep; 
       j = 0; 
      } 
      aux2 += aux.charAt(i); 
      j++; 
     } 
     fld.value = ''; 
     len2 = aux2.length; 
     for (i = len2 - 1; i >= 0; i--) 
      fld.value += aux2.charAt(i); 
     fld.value += decSep + aux.substr(len - 2, len); 
	 }
   } 
   else
   {
	if (len == 0) fld.value = ''; 
    if (len == 1) fld.value = '0'+ decSep + '000' + aux; 
	if (len == 2) fld.value = '0'+ decSep + '00' + aux; 
    if (len == 3) fld.value = '0'+ decSep + '0' + aux; 
	if (len == 4) fld.value = '0'+ decSep + aux; 
	
    if (len > 4) { 
     aux2 = ''; 
     for (j = 0, i = len - 5; i >= 0; i--) { 
      if (j == 3) { 
       aux2 += milSep; 
       j = 0; 
      } 
      aux2 += aux.charAt(i); 
      j++; 
     } 
     fld.value = ''; 
     len2 = aux2.length; 
     for (i = len2 - 1; i >= 0; i--) 
      fld.value += aux2.charAt(i); 
     fld.value += decSep + aux.substr(len - 4, len); 
	}
   }
    return false; 
  }
  
function formato_numerico(dato,tipo)
{
	var cadenacompleta = ''; 
    var key = ''; 
    var i = 0; 
    var strCheck = ''; 
	
	//configuro las teclas que admite cada tipo de dato
    if (tipo=='DECIMAL')
		strCheck = '0123456789,';
	if (tipo=='ENTERO')
		strCheck = '0123456789';
	//alert(strCheck)
	for (i = 0; i < dato.value.length; i++)
		 { 
    		ch = dato.value.charAt(i);
			//alert('caracter ' + i + ' (' + ch + ')')
			//no permito meter caracteres que no 
			//  representen un numero
			if (!(strCheck.indexOf(ch) == -1)) 
				cadenacompleta += ch; 
				
  		 } 
	dato.value=cadenacompleta
		
}

