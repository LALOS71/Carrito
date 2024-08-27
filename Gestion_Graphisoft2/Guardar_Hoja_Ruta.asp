<!--#include file="DB_Manager.inc"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	Function URLEncode_utf8(cadena)
		texto=""
		For i = 1 To Len(cadena)
			letra = Mid(cadena, i, 1)
			'response.write("<br>letra " & i & ": " & letra)
			
			Select Case letra
				Case " "  codigo = "%20"
				Case "!"  codigo = "%21"
				Case """" codigo = "%22"
				Case "#"  codigo = "%23"
				Case "$"  codigo = "%24"
				Case "%"  codigo = "%25"
				Case "&"  codigo = "%26"
				Case "'"  codigo = "%27"
				Case "("  codigo = "%28"
				Case ")"  codigo = "%29"
				Case "*"  codigo = "%2A"
				Case "+"  codigo = "%2B"
				Case ","  codigo = "%2C"
				Case "-"  codigo = "%2D"
				Case "."  codigo = "%2E"
				Case "/"  codigo = "%2F"
				Case ":"  codigo = "%3A"
				Case ";"  codigo = "%3B"
				Case "<"  codigo = "%3C"
				Case "="  codigo = "%3D"
				Case ">"  codigo = "%3E"
				Case "?"  codigo = "%3F"
				Case "@"  codigo = "%40"
				Case "["  codigo = "%5B"
				Case "\"  codigo = "%5C"
				Case "]"  codigo = "%5D"
				Case "^"  codigo = "%5E"
				Case "_"  codigo = "%5F"
				Case "`"  codigo = "%60"
				Case "{"  codigo = "%7B"
				Case "|"  codigo = "%7C"
				Case "}"  codigo = "%7D"
				Case "~"  codigo = "%7E"
				Case "`"  codigo = "%E2%82%AC"
				Case "‚"  codigo = "%E2%80%9A"
				Case "ƒ"  codigo = "%C6%92"
				Case "„"  codigo = "%E2%80%9E"
				Case "…"  codigo = "%E2%80%A6"
				Case "†"  codigo = "%E2%80%A0"
				Case "‡"  codigo = "%E2%80%A1"
				Case "ˆ"  codigo = "%CB%86"
				Case "‰"  codigo = "%E2%80%B0"
				Case "Š"  codigo = "%C5%A0"
				Case "‹"  codigo = "%E2%80%B9"
				Case "Œ"  codigo = "%C5%92"
				Case ""   codigo = "%C5%8D"
				Case "Ž"  codigo = "%C5%BD"
				Case ""   codigo = "%C2%90"
				Case "‘"  codigo = "%E2%80%98"
				Case "’"  codigo = "%E2%80%99"
				Case "“"  codigo = "%E2%80%9C"
				Case "”"  codigo = "%E2%80%9D"
				Case "•"  codigo = "%E2%80%A2"
				Case "–"  codigo = "%E2%80%93"
				Case "—"  codigo = "%E2%80%94"
				Case "˜"  codigo = "%CB%9C"
				Case "™"  codigo = "%E2%84"
				Case "š"  codigo = "%C5%A1"
				Case "›"  codigo = "%E2%80"
				Case "œ"  codigo = "%C5%93"
				Case ""   codigo = "%9D"
				Case "ž"  codigo = "%C5%BE"
				Case "Ÿ"  codigo = "%C5%B8"
				Case ""   codigo = "%C2%A0"
				Case "¡"  codigo = "%C2%A1"
				Case "¢"  codigo = "%C2%A2"
				Case "£"  codigo = "%C2%A3"
				Case "¤"  codigo = "%C2%A4"
				Case "¥"  codigo = "%C2%A5"
				Case "¦"  codigo = "%C2%A6"
				Case "§"  codigo = "%C2%A7"
				Case "¨"  codigo = "%C2%A8"
				Case "©"  codigo = "%C2%A9"
				Case "ª"  codigo = "%C2%AA"
				Case "«"  codigo = "%C2%AB"
				Case "¬"  codigo = "%C2%AC"
				Case "­"  codigo = "%C2%AD"
				Case "®"  codigo = "%C2%AE"
				Case "¯"  codigo = "%C2%AF"
				Case "°"  codigo = "%C2%B0"
				Case "±"  codigo = "%C2%B1"
				Case "²"  codigo = "%C2%B2"
				Case "³"  codigo = "%C2%B3"
				Case "´"  codigo = "%C2%B4"
				Case "µ"  codigo = "%C2%B5"
				Case "¶"  codigo = "%C2%B6"
				Case "·"  codigo = "%C2%B7"
				Case "¸"  codigo = "%C2%B8"
				Case "¹"  codigo = "%C2%B9"
				Case "º"  codigo = "%C2%BA"
				Case "»"  codigo = "%C2%BB"
				Case "¼"  codigo = "%C2%BC"
				Case "½"  codigo = "%C2%BD"
				Case "¾"  codigo = "%C2%BE"
				Case "¿"  codigo = "%C2%BF"
				Case "À"  codigo = "%C3%80"
				Case "Á"  codigo = "%C3%81"
				Case "Â"  codigo = "%C3%82"
				Case "Ã"  codigo = "%C3%83"
				Case "Ä"  codigo = "%C3%84"
				Case "Å"  codigo = "%C3%85"
				Case "Æ"  codigo = "%C3%86"
				Case "Ç"  codigo = "%C3%87"
				Case "È"  codigo = "%C3%88"
				Case "É"  codigo = "%C3%89"
				Case "Ê"  codigo = "%C3%8A"
				Case "Ë"  codigo = "%C3%8B"
				Case "Ì"  codigo = "%C3%8C"
				Case "Í"  codigo = "%C3%8D"
				Case "Î"  codigo = "%C3%8E"
				Case "Ï"  codigo = "%C3%8F"
				Case "Ð"  codigo = "%C3%90"
				Case "Ñ"  codigo = "%C3%91"
				Case "Ò"  codigo = "%C3%92"
				Case "Ó"  codigo = "%C3%93"
				Case "Ô"  codigo = "%C3%94"
				Case "Õ"  codigo = "%C3%95"
				Case "Ö"  codigo = "%C3%96"
				Case "×"  codigo = "%C3%97"
				Case "Ø"  codigo = "%C3%98"
				Case "Ù"  codigo = "%C3%99"
				Case "Ú"  codigo = "%C3%9A"
				Case "Û"  codigo = "%C3%9B"
				Case "Ü"  codigo = "%C3%9C"
				Case "Ý"  codigo = "%C3%9D"
				Case "Þ"  codigo = "%C3%9E"
				Case "ß"  codigo = "%C3%9F"
				Case "à"  codigo = "%C3%A0"
				Case "á"  codigo = "%C3%A1"
				Case "â"  codigo = "%C3%A2"
				Case "ã"  codigo = "%C3%A3"
				Case "ä"  codigo = "%C3%A4"
				Case "å"  codigo = "%C3%A5"
				Case "æ"  codigo = "%C3%A6"
				Case "ç"  codigo = "%C3%A7"
				Case "è"  codigo = "%C3%A8"
				Case "é"  codigo = "%C3%A9"
				Case "ê"  codigo = "%C3%AA"
				Case "ë"  codigo = "%C3%AB"
				Case "ì"  codigo = "%C3%AC"
				Case "í"  codigo = "%C3%AD"
				Case "î"  codigo = "%C3%AE"
				Case "ï"  codigo = "%C3%AF"
				Case "ð"  codigo = "%C3%B0"
				Case "ñ"  codigo = "%C3%B1"
				Case "ò"  codigo = "%C3%B2"
				Case "ó"  codigo = "%C3%B3"
				Case "ô"  codigo = "%C3%B4"
				Case "õ"  codigo = "%C3%B5"
				Case "ö"  codigo = "%C3%B6"
				Case "÷"  codigo = "%C3%B7"
				Case "ø"  codigo = "%C3%B8"
				Case "ù"  codigo = "%C3%B9"
				Case "ú"  codigo = "%C3%BA"
				Case "û"  codigo = "%C3%BB"
				Case "ü"  codigo = "%C3%BC"
				Case "ý"  codigo = "%C3%BD"
				Case "þ"  codigo = "%C3%BE"
				Case "ÿ"  codigo = "%C3%BF"
				Case Else codigo = letra

			End Select
			texto = texto & codigo
		Next
		URLEncode_utf8 = texto
	End Function

	Dim sql

	If Session("usuario") = "" Then
		Response.Redirect("Login.asp")
	End If
	
	id_hoja_ruta	= Request.Form("ocultoid_hoja_ruta")
	estado			= Request.Form("cmbestados_d")
	observaciones	= Request.Form("txtobservaciones_local_d")

	campo_estado		= ""
	campo_observaciones = ""

	'response.write("<br><br>hoja de ruta: " & id_hoja_ruta)
	'response.write("<br><br>estado: " & estado)
	'response.write("<br><br>observaciones: " & observaciones)
	
	'response.write("<br>id: " & id)
	'response.write("<br>estado: " & estado)
	
	' If there is a id_hoja_ruta
	If id_hoja_ruta <> "" Then
		sql = "SELECT B.ID_ESTADO, B.OBSERVACIONES_GESTION OBSERVACIONES_LOCAL"
		sql = sql & " FROM GESTION_GRAPHISOFT_HOJAS_IMPORTADAS B"	
		sql = sql & " WHERE B.ID=" & id_hoja_ruta
		'response.write("<br><br>BUSCAMOS EL ESTADO Y LAS OBSERVACIONES PREVIAS DE LA HOJA DE RUTA: " & sql)
		Set hoja_ruta_ant = execute_sql(conn_gag, sql)

		If Not hoja_ruta_ant.EOF Then
			campo_estado = "" & hoja_ruta_ant("id_estado")
			campo_observaciones_local = "" & hoja_ruta_ant("observaciones_local")
		End If

		close_connection(hoja_ruta_ant)

		'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
		' de fecha con mes-dia-a�o
		query_options = adCmdText + adExecuteNoRecords
		execute_sql_with_options conn_gag, "set dateformat dmy", query_options

		sql_hoja_ruta = ""
		sql_hoja_ruta = "ESTADO=NULL"

		'Comenzamos la Transaccion
		conn_gag.BeginTrans 

		If campo_estado <> estado Then		
			sql = "INSERT INTO GESTION_GRAPHISOFT_HISTORICO_HOJAS (ID_HOJA_RUTA, HOJA_RUTA, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			sql = sql & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			sql = sql & " SELECT " & id_hoja_ruta & ", '" & hoja_ruta & "',"
			sql = sql & " GETDATE(), 'CAMBIO', 'ESTADO', (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS WHERE ID=" & campo_estado & "),"
			sql = sql & " (SELECT DESCRIPCION FROM GESTION_GRAPHISOFT_ESTADOS WHERE ID=" & estado & "), '" & session("usuario") & "', NULL, NULL"
			
			'response.write("<br>sql de insercion en el historico por cambio de estado: " & sql)

			If sql_hoja_ruta <> "" Then
				sql_hoja_ruta = sql_hoja_ruta & ", "
			End If

			sql_hoja_ruta = sql_hoja_ruta & "ID_ESTADO='" & estado &"'"
			
			query_options = adCmdText + adExecuteNoRecords
			execute_sql_with_options conn_gag, sql, query_options
		End If

		If campo_observaciones_local <> observaciones Then		
			sql = "INSERT INTO GESTION_GRAPHISOFT_HISTORICO_HOJAS (ID_HOJA_RUTA, HOJA_RUTA, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
			sql = sql & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
			sql = sql & " VALUES (" & id_hoja_ruta & ", '" & hoja_ruta & "',"
			sql = sql & " GETDATE(), 'MODIFICA', 'OBSERVACIONES', '" & campo_observaciones_local & "',"
			sql=sql & " '" & observaciones & "', '" & session("usuario") & "', NULL, NULL)"
			
			'response.write("<br>sql de insercion en el historico por cambio en las observaciones: " & sql)

			if sql_hoja_ruta <> "" Then
				sql_hoja_ruta = sql_hoja_ruta & ", "
			End If
			sql_hoja_ruta = sql_hoja_ruta & "OBSERVACIONES_GESTION='" & observaciones &"'"

			query_options = adCmdText + adExecuteNoRecords
			execute_sql_with_options conn_gag, sql, query_options
		End If

		If sql_hoja_ruta <> "" Then
			sql = "UPDATE GESTION_GRAPHISOFT_HOJAS_IMPORTADAS SET " & sql_hoja_ruta & " WHERE ID=" & id_hoja_ruta

			'response.write("<br>sql update gestion_graphisoft_hojas de ruta: " & sql)

			query_options = adCmdText + adExecuteNoRecords
			execute_sql_with_options conn_gag, sql, query_options
		End If

		' finaliza la transaccion
		conn_gag.CommitTrans 
		
		mensaje_aviso="HOJA DE RUTA MODIFICADA CON EXITO"
	End If	
%>
<html lang="es">
<head>
	<meta charset="utf-8">
	<title>Grabar Hoja de Ruta</title>
</head>
<body onload="validar('<%=mensaje_aviso%>','<%=id_hoja_ruta%>')">
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
	<form name="frmgrabar" id="frmgrabar" method="post" action=""></form>

 <!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos">	
    <div class="modal-dialog modal-lg">	  
      <div class="modal-content">	    
        <div class="modal-header">	      
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>     
          <h4 class="modal-title" id="cabecera_pantalla_avisos"></h4>	    
        </div>	    
        <div class="container-fluid" id="body_avisos"></div>	
        <div class="modal-footer">                  
          <p><button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button></p>                
        </div>  
      </div><!-- /.modal-content -->	
    </div><!-- /.modal-dialog -->      
  </div>    
  <!-- FIN capa mensajes -->

	<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

	<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
	<script language="javascript">
	var j$=jQuery.noConflict();
	</script>
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<script language="javascript">
		function validar(mensaje, id_hoja_ruta) {
			//alert('PIR GUARDADO CORRECTAMENTE');
			//refresco la tabla de pirs de la pagina principal por si hay modificaciones
			window.parent.j$("#capa_detalle_hoja_ruta").modal("hide");
			window.parent.j$("#cabecera_pantalla_avisos").html("<h3>Aviso</h3>")
			window.parent.j$("#body_avisos").html('<H4><br>' + mensaje + '<br></h4>');
			window.parent.j$("#pantalla_avisos").modal("show");
			/*
			j$("#cabecera_pantalla_avisos").html("<h3>Aviso</h3>")
			j$("#body_avisos").html('<H4><br>' + mensaje + '<br></h4>');
			j$("#pantalla_avisos").modal("show");
			*/
			
			window.parent.lst_hojas_ruta.ajax.reload(); 	
		}
	</script>
</body>
<%
	close_connection(conn_gag)
%>
</html>
