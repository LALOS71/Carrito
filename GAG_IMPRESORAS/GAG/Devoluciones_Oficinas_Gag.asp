<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%

		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		
		dia=day(date())
		if dia<10 then
			dia="0" & dia
		end if
		mes=month(date())
		if mes<10 then
			mes= "0" & mes
		end if
		anno=year(date())
		fecha_hoy=dia &"-" & mes & "-" & anno
		fecha_limite="21-10-2017"
		
		diferencia_dias=datediff("d",fecha_hoy, fecha_limite)		
		if diferencia_dias<=0 then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		
		'recordsets
		dim articulos
		
		mostrar_totales="no"
		
		'variables
		dim sql
		
		pedido_seleccionado=Request.QueryString("pedido")
		if pedido_seleccionado="" then
			pedido_seleccionado=0
		end if

	    
	    set articulos=Server.CreateObject("ADODB.Recordset")
		
		'response.write("<br>" & sql)
		

			with articulos
				.ActiveConnection=connimprenta
				 

                          
                            
                            

				.Source="SELECT A.ID_ARTICULO, A.REFERENCIA, A.DESCRIPCION, A.PRECIO, A.FAMILIA, A.ORDEN,"
				.Source=.Source & " B.ID_OFICINA, B.DEVOLUCION, B.SOLICITUD, B.ESTADO"
				
				.Source=.Source & " FROM DEVOLUCIONES_ARTICULOS AS A LEFT OUTER JOIN"
				.Source=.Source & " (SELECT ID, ID_OFICINA, ID_ARTICULO, DEVOLUCION, SOLICITUD, ESTADO"
				.Source=.Source & " FROM DEVOLUCIONES_OFICINAS"
				.Source=.Source & " WHERE ID_OFICINA = " & session("usuario") & ") AS B"
				.Source=.Source & " ON A.ID_ARTICULO = B.ID_ARTICULO"

				.Source=.Source & " ORDER BY a.ORDEN"

				
				'RESPONSE.WRITE(.SOURCE)
				.Open
			end with


		





'Recogemos la variable borrar 
borrar=Request.Querystring("borrar")

'Si no quedan articulos en el carrito despues del borrado
cadena="Lista_Articulos_Gag.asp"
'response.write("<br>" & sql)


%>
<html>
<head>
<title><%=pedido_detalles_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<style>
	a.enlace { 
			text-decoration:none;
			font: bold courier }
	a.enlace:link { color:#990000}
	a.enlace:visited { color:#990000}
	a.enlace:actived {color:#990000}
	a.enlace:hover {
			font: bold italic ;color:blue}
			
	a.nosub { 
			text-decoration:none;
			}
	a.nosub:link { color:blue}
	a.nosub:visited { color:blue}
	a.nosub:actived {color:blue}
	a.nosub:hover {
			font: bold italic ;color:#8080c0}
		
		
		
		
tr:nth-child(odd) {
    background-color:#f2f2f2;
}

tr:nth-child(even) {
    background-color:#fbfbfb;
}		

.enrojo{
color:#FF0000;
font-size:110%;
}
</style>

<script language="javascript">
function cambiacomaapunto (s)
{
	var saux = "";
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ",")
			saux = saux + ".";
		else
			saux = saux + s.charAt (j);
	}
	return saux;
}

// una vez calculado el resultado tenemos que volver a dejarlo como es devido, con la coma
//    representando los decimales y no el punto
function cambiapuntoacoma(s)
{
	var saux = "";
	//alert("pongo coma")
	//alert("tamaño: " + s.legth)
	for (j=0;j<s.length; j++ )
	{
		if (s.charAt(j) == ".")
			saux = saux + ",";
		else
			saux = saux + s.charAt (j);
		//alert("total: " + saux)
	}
	return saux;
}

// ademas redondeamos a 2 decimales el resultado
function redondear (v){
	var vaux;
	vaux = Math.round (v * 100);
	vaux =  vaux / 100;
	return  vaux;
}


	
	
   function mover_formulario(objetivo)
   {
   	if (objetivo=='volver')
   		accion='Lista_Articulos_Gag.asp'
	  else
	  	accion='Grabar_Pedido_Gag.asp';
	document.getElementById('frmpedido').action=accion
	document.getElementById('frmpedido').submit()	
	

   }
   	
	
var flecha; 

function detener() 
{ 
   clearInterval(flecha); 
} 

function subir() 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop -=8; 
  },50); 
} 

function bajar() 
{ 
{ 
    flecha=setInterval(function(){ 
  document.getElementById("contenidos").scrollTop +=8; 
  },50); 
} 
} 

</script>


 <script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-touchspin/js/jquery.bootstrap-touchspin.js"></script>

<script type="text/javascript">
     var j$=jQuery.noConflict();
</script>   

</head>
<body onload="">


<div class="panel panel-primary" id="condiciones_devolucion">
	<div class="panel-heading">
		<h3 class="panel-title">INSTRUCCIONES</h3>
	</div>
	
	<div class="panel-body">
		<div class="form-group">
			<div class="col-sm-12 col-md-12 col-lg-12">
					  <!--
					  <div width="95%">
								<div class="btn-group" role="group" id="botones_historico">
								  <button type="button" class="btn btn-default">Todo</button>
								  <button type="button" class="btn btn-default">Hist&oacute;rico</button>
								  <button type="button" class="btn btn-default active">Incidencias</button>
								</div>
						</div>
						-->
					<div width="95%">
						<h5>
						CONDICIONES DE LA DEVOLUCIÓN:
						<br />
						<BR />
						Solo se podrán solicitar devoluciones del material mostrado en la siguiente lista. 
						<br />
						Las devoluciones y solicitudes deben pertenecer a la misma familia de producto.
						<br />
						Se rechazará cualquier material que no esté en perfectas condiciones o haya sido utilizado.
						<br />
						En el caso de que haya un descuadre entre el importe de la mercancía devuelta y solicitada, se solicitará 
						el ingreso del importe restante o se guardará a crédito el importe a mayores para futuras compras 
						( llegado el caso se os informará individualmente ).
						<br />
						En el caso del vestuario laboral, existe la posibilidad de solicitar el cambio del kit completo o 
						por cada prenda individualmente. Si se solicita el cambio de un kit completo habrá que asegurarse de que 
						se conservan todas las prendas que lo componen sin usar y en perfecto estado.
						<br /><br /><br>

						<b>PROCEDIMIENTO:</b>
						<br>
						<br>
						1. Seleccione la cantidad de la referencia que desea devolver.
						<br />
						2. Se habilitarán las referencias por las cuales puede solicitar el cambio.
						<br />
						3. Seleccione la cantidad de la referencia por la que desea realizar el cambio.
						<br />
						4. Repita esta operación con todas las referencias que necesite cambiar.
						<br />
						5. Una vez finalizado pulse guardar.
						<br />
						6. Podrá modificar su solicitud hasta que finalice el plazo indicado.

						<br /><br />
						NO NOS ENVIE NINGUN MATERIAL HASTA QUE NO SE LO COMUNIQUEMOS.
						
						<br /><br />
						Gracias.
						</h5>
					</div>
			</div>
		</div>
	</div>
</div>
<!--fin condiciones de Devolucion-->				
		



<form action="Guardar_Devoluciones_Gag.asp" method="post" name="frmdatos" id="frmdatos">
	<input type="hidden" name="ocultooficina" id="ocultooficina" value="<%=session("usuario")%>">
<div class="panel panel-primary">
	<div class="panel-body">
		<div>	
			<table class="table">
				<thead>
					<tr>
						<th class="col-xs-2">Familia</th>
						<th class="col-xs-2" style="text-align:center">Referencia</th>
						<th class="col-xs-3">Descripci&oacute;n</th>
						<th class="col-xs-1" style="text-align:right ">Precio</th>
						<th class="col-xs-1" style="text-align:center ">Devoluci&oacute;n</th>
						<th class="col-xs-1" style="text-align:center ">Solicitud</th>
					</tr>
				</thead>
				<tbody>
					
					
					<%
						total_devuluciones=0
						total_solicitudes=0
						pedido_automatico=""
						estado_devoluciones=""
					%>
					
						
					<%while not articulos.eof
						if estado_devoluciones="" then
							estado_devoluciones="" & articulos("ESTADO")
						end if
						%>
					<tr valign="top">
						<td height="66" class="celda_familia" style="text-align:left;vertical-align:middle">
							<%=articulos("FAMILIA")%>
					  </td>
						<td style="text-align:center;vertical-align:middle">
							<a href="../Imagenes_Articulos/<%=articulos("id_articulo")%>.jpg" target="_blank">
								<%=articulos("REFERENCIA")%>
							</a>
						</td>
						<td style="text-align:left;vertical-align:middle;" class="celda_descripcion"><%=articulos("DESCRIPCION")%></td>
						<td style="text-align:right;vertical-align:middle"><%=articulos("PRECIO")%> €&nbsp;</td>
						<%
							devolucion="0" & articulos("DEVOLUCION")
							devolucion= cint(devolucion)
							totales=(articulos("PRECIO") * devolucion)
							total_devoluciones=total_devoluciones + totales
							
							
							solicitud="0" & articulos("solicitud")
							solicitud=cint(solicitud)
							totales=(articulos("PRECIO") * solicitud)
							
							total_solicitudes=total_solicitudes + totales
						%>
						<td style="text-align:left">
							<input type="text" value="<%=articulos("DEVOLUCION")%>" id="txtdevolucion_<%=articulos("id_articulo")%>" name="txtdevolucion_<%=articulos("id_articulo")%>" class="classdevolucion familia_<%=replace(articulos("FAMILIA"), " ", "_")%>"
								data-bts-button-down-class="btn btn-default popover_ejemplo"
								data-bts-button-up-class="btn btn-default popover_ejemplo"
								>
							
							
						</td>
						<td style="text-align:left">
							<input type="text" value="<%=articulos("SOLICITUD")%>" id="txtsolicitud_<%=articulos("id_articulo")%>" name="txtsolicitud_<%=articulos("id_articulo")%>" class="classsolicitud familia_<%=replace(articulos("FAMILIA"), " ", "_")%>">
							
							
						</td>
					</tr>
					<%		
						
						articulos.movenext
					Wend
					
					%>
					
					
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" align="center">
							<button type="button" id="cmdguardar" name="cmdguardar" class="btn btn-primary">
									<i class="glyphicon glyphicon-floppy-disk"></i>
									<span>Guardar</span>
							</button>
							
							<%if estado_devoluciones="CERRADO" then%>
								<script language="javascript">
									j$('.classdevolucion').prop('disabled', true);
									j$('.classsolicitud').prop('disabled', true);
									j$('#cmdguardar').prop('disabled', true);
								</script>
								
								<br />
								<div align="center" style="color:#FF0000 ">
								Las Devoluciones ya est&aacute;n siendo tramitadas por Globalia Artes Gr&aacute;ficas y no se pueden modificar
								</div>
							<%end if%>

						</td>
						<th style="text-align:right" colspan="2"><h5>Totales..... </h5></th>
						<th style="text-align:center" id="celda_totales_devoluciones"><h5><%=total_devoluciones%> €&nbsp;</h5></th>
						<th style="text-align:center" id="celda_totales_solicitudes"><h5><%=total_solicitudes%> €&nbsp;</h5></th>
					</tr>
				</tfoot>	
				
			</table>
		</div>
	</div>
</div>
					
</form>							
								
					
<script language="javascript">


j$(document).ready(function() {
    
j$(".classdevolucion").TouchSpin({
					min: 0, 
					initval: 0
					});

j$(".classsolicitud").TouchSpin({
					min: 0, 
					initval: 0
					});


//para que se configuren los popover-titles...
	//j$('[data-toggle="popover"]').popover({html:true});
	/*
	j$('.popover_ejemplo').popover({html:true,
									placement:'bottom', 
									trigger:'hover', 
									content:'hola radiola',
									title:''}
									);
	*/

	
	
									
									


});


j$(".classdevolucion").on("touchspin.on.stopspin", function () {
//me quedo con el nombre de la clase de todas las touchspin de la misma familia
	var brothers=('.' + j$(this).attr('class').split(' ').join('.'))

	//console.log('nombre clase de classdevolucion: ' + brothers)
	//console.log('familia.... ' + j$(this).closest('tr').find(".celda_familia").text())
	
	nombre_familia_mostrar=j$(this).closest('tr').find(".celda_familia").text()

	recuento_devolucion=0
	recuento_solicitud=0
	//recuento la suma de valores de las devoluciones de la misma familia
	j$(brothers).each(function( index ) {
  		//console.log( index + ": " + j$(this).val() );
		recuento_devolucion=recuento_devolucion + parseInt(j$(this).val())
		
	});
	
	//obtengo el nombre de la clase de las solicitudes de la misma familia que la devolucion pulsada
	brothers = brothers.replace('devolucion', 'solicitud');
	
	//console.log('nombre clase de classsolicitud: ' + brothers)
	
	//recuento la suma de valores de las solicitudes de la misma familia
	j$(brothers).each(function( index ) {
  		//console.log( index + ": " + j$(this).val() );
		recuento_solicitud=recuento_solicitud + parseInt(j$(this).val())
		
	});
	
	//console.log('recuento devolucion: ' + recuento_devolucion)
	//console.log('recuento solicitud: ' + recuento_solicitud)
	
	//comparo las devoluciones y las solicitudes porque tienen que ser iguales
	if (recuento_devolucion!=recuento_solicitud)
		{
		//bloqueo el boton de guardar
		j$("#cmdguardar").prop('disabled', true);
		
		//si las devoluciones y las solicitudes de la misma familia son diferentes, se bloquean
		// los controles de las otras familias hasta que se igualen para que no haya desfases
		// primero bloqueo todo
		//console.log('bloqueamos controles menos ' + brothers)
		j$(".classdevolucion").each(function( index ) {
			
			//$('#element').popover('dispose')
			j$(this).closest('tr').find(".popover_ejemplo").popover({html:true,
									placement:'bottom', 
									trigger:'hover', 
									content:'Han de cuadrar las devoluciones y las solicitudes de la familia ' + nombre_familia_mostrar,
									title:''}
									);
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', true);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', true);
			
			
		});
		
		//y despues desbloqueo la familia que no cuadran sus devoluciones y solicitudes
		j$(brothers).each(function( index ) {
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', false);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', false);
			j$(this).closest('tr').find('.celda_familia').addClass("enrojo");
			j$(this).closest('tr').find('.celda_descripcion').addClass("enrojo");
		});
		
		
		}
	  else //cuando coinciden devoluciones y solicitudes, se desbloquean todos
	  	{
		
		//desbloqueo el boton de guardar
		j$("#cmdguardar").prop('disabled', false);

		j$(".classdevolucion").each(function( index ) {
			j$(this).closest('tr').find(".popover_ejemplo").popover('destroy')
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', false);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', false);
			j$(this).closest('tr').find('.celda_familia').removeClass("enrojo");
			j$(this).closest('tr').find('.celda_descripcion').removeClass("enrojo");
			
			
		});
		}
		
		
		//recalculo totales	de devoluciones	
		total_devolucion_nuevo=0.0
		total_redondeado=0.0
		j$(".classdevolucion").each(function( index ) {
			importes=j$(this).closest('tr').find("td").eq(3).text()
			importes=importes.replace('€', '');
			importes=parseFloat(importes.replace(',', '.'));
			//console.log('calculando totales (precio):..' + importes + '...') 
			//console.log('calculando devolucion: ' + j$(this).val())
			//console.log('calculando solicitudes: ' + j$(this).closest('tr').find(".classsolicitud").val())
			total_devolucion_nuevo=total_devolucion_nuevo + (j$(this).val() * importes)
			//para que redondee al siguitente valor... al ser moneda...
			total_redondeado= +(Math.round(total_devolucion_nuevo + "e+2")  + "e-2")
			
		});
		
		j$("#celda_totales_devoluciones").html("<h5>" + total_redondeado.toString().replace('.', ',') + " €&nbsp;</h5>")
		
	
});




j$(".classsolicitud").on("touchspin.on.stopspin", function () {
//me quedo con el nombre de la clase de todas las touchspin de la misma familia
	var brothers=('.' + j$(this).attr('class').split(' ').join('.'))

	//console.log('nombre clase de classdevolucion: ' + brothers)
	//console.log('familia.... ' + j$(this).closest('tr').find(".celda_familia").text())
	
	nombre_familia_mostrar=j$(this).closest('tr').find(".celda_familia").text()

	recuento_devolucion=0
	recuento_solicitud=0
	//recuento la suma de valores de las devoluciones de la misma familia
	j$(brothers).each(function( index ) {
  		//console.log( index + ": " + j$(this).val() );
		recuento_solicitud=recuento_solicitud + parseInt(j$(this).val())
		
	});
	
	//obtengo el nombre de la clase de las devoluciones de la misma familia que la solicitud pulsada
	brothers = brothers.replace('solicitud', 'devolucion');
	
	//console.log('nombre clase de classdevolucion: ' + brothers)
	
	//recuento la suma de valores de las solicitudes de la misma familia
	j$(brothers).each(function( index ) {
  		//console.log( index + ": " + j$(this).val() );
		recuento_devolucion=recuento_devolucion + parseInt(j$(this).val())
		
	});
	
	//console.log('recuento devolucion: ' + recuento_devolucion)
	//console.log('recuento solicitud: ' + recuento_solicitud)
	
	//comparo las devoluciones y las solicitudes porque tienen que ser iguales
	if (recuento_devolucion!=recuento_solicitud)
		{
		
		//bloqueo el boton de guardar
		j$("#cmdguardar").prop('disabled', true);
		
		
		//si las devoluciones y las solicitudes de la misma familia son diferentes, se bloquean
		// los controles de las otras familias hasta que se igualen para que no haya desfases
		// primero bloqueo todo
		//console.log('bloqueamos controles menos ' + brothers)
		j$(".classsolicitud").each(function( index ) {
			
			//$('#element').popover('dispose')
			j$(this).closest('tr').find(".popover_ejemplo").popover({html:true,
									placement:'bottom', 
									trigger:'hover', 
									content:'Han de cuadrar las devoluciones y las solicitudes de la familia ' + nombre_familia_mostrar,
									title:''}
									);
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', true);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', true);
			
			
		});
		
		//y despues desbloqueo la familia que no cuadran sus devoluciones y solicitudes
		j$(brothers).each(function( index ) {
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', false);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', false);
			j$(this).closest('tr').find('.celda_familia').addClass("enrojo");
			j$(this).closest('tr').find('.celda_descripcion').addClass("enrojo");
		});
		
		
		}
	  else //cuando coinciden devoluciones y solicitudes, se desbloquean todos
	  	{
		
		//desbloqueo el boton de guardar
		j$("#cmdguardar").prop('disabled', false);
		
		j$(".classsolicitud").each(function( index ) {
			j$(this).closest('tr').find(".popover_ejemplo").popover('destroy')
			j$(this).closest('tr').find(".classdevolucion").prop('disabled', false);
			j$(this).closest('tr').find(".classsolicitud").prop('disabled', false);
			j$(this).closest('tr').find('.celda_familia').removeClass("enrojo");
			j$(this).closest('tr').find('.celda_descripcion').removeClass("enrojo");
			
			
		});
		}
		
		
		//recalculo totales	de solicitudes	
		total_solicitud_nuevo=0.0
		total_redondeado=0.0
		j$(".classsolicitud").each(function( index ) {
			importes=j$(this).closest('tr').find("td").eq(3).text()
			importes=importes.replace('€', '');
			importes=parseFloat(importes.replace(',', '.'));
			//console.log('calculando totales (precio):..' + importes + '...') 
			//console.log('calculando devolucion: ' + j$(this).val())
			//console.log('calculando solicitudes: ' + j$(this).closest('tr').find(".classsolicitud").val())
			total_solicitud_nuevo=total_solicitud_nuevo + (j$(this).val() * importes)
			//para que redondee al siguitente valor... al ser moneda...
			total_redondeado= +(Math.round(total_solicitud_nuevo + "e+2")  + "e-2")
			
		});
		
		j$("#celda_totales_solicitudes").html("<h5>" + total_redondeado.toString().replace('.', ',') + " €&nbsp;</h5>")
		

	
});

//para que no se pueda escribir en las devoluciones y las solicitudes
// solo se puedan cambiar desde los botones + y -
j$('.classdevolucion').keydown(function(event) {return false});
j$('.classdevolucion').keypress(function(event) {
		//console.log('keypress, keycode: ' + event.keyCode)
		return false
});

j$('.classsolicitud').keydown(function(event) {return false});
j$('.classsolicitud').keypress(function(event) {
		//console.log('keypress, keycode: ' + event.keyCode)
		return false
});
	
	
j$("#cmdguardar").on("click", function () {
	//console.log('guardamosoooossssss')
	j$(".classdevolucion").each(function( index ) {
		articulo=j$(this).prop('id');
		//console.log('articulo: ' + articulo + ' -- valor: ' + j$(this).val())
		});
	j$("#frmdatos").submit()

});	
</script>								






</body>
<%
	'articulos.close
	articulos.close
	connimprenta.close
	
	set articulos=Nothing
	set connimprenta=Nothing

%>
</html>
