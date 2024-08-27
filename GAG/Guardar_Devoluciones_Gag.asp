<%@ language=vbscript %>
<!--#include file="../Conexion.inc"-->
<%

oficina=Request.Form("ocultooficina")

'response.write("<br>todo el tocho: " & request.form)


	set lista_articulos=Server.CreateObject("ADODB.Recordset")
	CAMPO_ID_ARTICULO=0
	
	
	with lista_articulos
		.ActiveConnection=connimprenta
		'.Source="SELECT  ID, ID_EMPRESA, GRUPO_FAMILIAS, ID_FAMILIA"
		.Source="SELECT ID_ARTICULO FROM DEVOLUCIONES_ARTICULOS ORDER BY ORDEN"
		'response.write("<br>LISTA ARTICULOS: " & .source)
		.Open
		vacio_lista_articulos=false
		if not .BOF then
			tabla_lista_articulos=.GetRows()
		  else
			vacio_lista_articulos=true
		end if
	end with

	lista_articulos.close
	set lista_articulos=Nothing




connimprenta.BeginTrans 'Comenzamos la Transaccion

cadena_ejecucion="DELETE FROM DEVOLUCIONES_OFICINAS WHERE ID_OFICINA=" & oficina
'response.write("<br><br>ejecutamos...: " & cadena_ejecucion)

connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
				
cadena_campos="ID_OFICINA, ID_ARTICULO, DEVOLUCION, SOLICITUD, ESTADO"

if not vacio_lista_articulos then
	for i=0 to UBound(tabla_lista_articulos,2)
		art=tabla_lista_articulos(CAMPO_ID_ARTICULO,i)
		controlfrm1="txtdevolucion_" & art
		controlfrm2="txtsolicitud_" & art
		
		'response.write("<br><br>oficina: " & oficina)
		'response.write(" -- articulo: " & art)
		'response.write(" -- control devolucion: " & controlfrm1)
		'response.write(" -- devolucion: " & request.form(controlfrm1))
		'response.write(" -- control solicitud: " & controlfrm2)
		'response.write(" -- solicitud: " & request.form(controlfrm2))
		cadena_valores=oficina
		cadena_valores=cadena_valores & ", " & art
		if request.form(controlfrm1)="" then
			cadena_valores=cadena_valores & ", NULL"
		  else
			cadena_valores=cadena_valores & ", " & request.form(controlfrm1)
		end if
		if request.form(controlfrm2)="" then
			cadena_valores=cadena_valores & ", NULL"
		  else
			cadena_valores=cadena_valores & ", " & request.form(controlfrm2)
		end if
		cadena_valores=cadena_valores & ", 'ABIERTO'"
		
		'solo insertamos cuando haya algo... si no hay devolucion ni solicitud no se inserta
		if request.form(controlfrm1)<>"0" or request.form(controlfrm2)<>"0" then
			cadena_ejecucion="INSERT INTO DEVOLUCIONES_OFICINAS (" & cadena_campos & ") values(" & cadena_valores & ")"
			'response.write("<br>ejecutamos...: " & cadena_ejecucion)
			connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords				
		end if
	next
end if
												


connimprenta.CommitTrans ' finaliza la transaccion
%>
<html>
<head>
<title></title>
	<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
	<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="../estilos.css" />
	<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />

<script language="javascript">
function validar()
{
	//alert(mensaje);
	mensaje='Su solicitud se ha guardado satisfactoriamente.<br><br>En breve se pasar&aacute; nueva comunicaci&oacute;n...'
	
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#body_avisos").html("<br><br><h4>" + mensaje + "</h4><br><br>");
	$("#pantalla_avisos").modal("show");
				
	

}

</script>
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>


</head>

<body onLoad="validar()">



<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer" id="botones_avisos">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->


<script language="javascript">
$('#pantalla_avisos').on('hidden.bs.modal', function (e) {
	 	location.href = 'Lista_Articulos_Gag.asp'
})

</script>
</body>


<%	
	connimprenta.Close
	set connimprenta=Nothing
%>
</html>