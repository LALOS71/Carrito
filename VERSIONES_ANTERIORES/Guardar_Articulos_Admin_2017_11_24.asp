<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->


<%

		if session("usuario_admin")="" then
			Response.Redirect("Login_Admin.asp")
		end if
		
		
		accion=Request.Form("ocultoaccion")
		articulo_seleccionado=Request.Form("ocultoarticulo")
		cambio_compromiso_compra=Request.Form("oculto_cambio_compromiso_compra")
		
		'response.write("<br>cambio_compromiso_compra: " & cambio_compromiso_compra)
		'response.write("<br>hotel: " & hotel_seleccionado)
		'response.write("<br>poblacion: " & Request.Form("txtpoblacion"))
		'response.write("<br>provincia: " & Request.Form("txtprovincia"))

		if accion="MODIFICAR" then 'aqui modificamos articulos
					
					cadena_ejecucion="UPDATE ARTICULOS SET"
					'cadena_ejecucion=cadena_ejecucion & " CODIGO_EMPRESA='" & Request.Form("cmbempresas") & "'"
					cadena_ejecucion=cadena_ejecucion & " CODIGO_SAP='" & Request.Form("txtcodigo_sap") & "'"
					cadena_ejecucion=cadena_ejecucion & " , DESCRIPCION='" & Request.Form("txtdescripcion") & "'"
					cadena_ejecucion=cadena_ejecucion & " , TAMANNO='" & Request.Form("txttamanno") & "'"
					cadena_ejecucion=cadena_ejecucion & " , TAMANNO_ABIERTO='" & Request.Form("txttamanno_abierto") & "'"
					cadena_ejecucion=cadena_ejecucion & " , TAMANNO_CERRADO='" & Request.Form("txttamanno_cerrado") & "'"
					cadena_ejecucion=cadena_ejecucion & " , PAPEL='" & Request.Form("txtpapel") & "'"
					cadena_ejecucion=cadena_ejecucion & " , TINTAS='" & Request.Form("txttintas") & "'"
					cadena_ejecucion=cadena_ejecucion & " , ACABADO='" & Request.Form("txtacabado") & "'"
					cadena_ejecucion=cadena_ejecucion & " , UNIDADES_DE_PEDIDO='" & Request.Form("txtunidades_pedido") & "'"
					cadena_ejecucion=cadena_ejecucion & " , FECHA='" & Request.Form("txtfecha") & "'"
					cadena_ejecucion=cadena_ejecucion & " , COMPROMISO_COMPRA='" & Request.Form("cmbcompromiso_de_compra") & "'"
					cadena_ejecucion=cadena_ejecucion & " , MOSTRAR='" & Request.Form("cmbmostrar") & "'"
					cadena_ejecucion=cadena_ejecucion & " , BORRADO='" & Request.Form("cmbeliminado") & "'"
					cadena_ejecucion=cadena_ejecucion & " , REQUIERE_AUTORIZACION='" & Request.Form("cmbautorizacion") & "'"
					cadena_ejecucion=cadena_ejecucion & " , PACKING='" & Request.Form("txtpacking") & "'"
					cadena_ejecucion=cadena_ejecucion & " , FACTURABLE='" & Request.Form("cmbfacturable") & "'"
					if Request.Form("txtmaterial")<>"" then
						cadena_ejecucion=cadena_ejecucion & " , MATERIAL='" & Request.Form("txtmaterial") & "'"
					  else
					  	cadena_ejecucion=cadena_ejecucion & " , MATERIAL= null"
					end if
					
					'if Request.Form("cmbfamilias")<>"" then
					'	cadena_ejecucion=cadena_ejecucion & " , FAMILIA=" & Request.Form("cmbfamilias") 
					'  else
					'  	cadena_ejecucion=cadena_ejecucion & " , FAMILIA= null"
					'end if
					
					cadena_ejecucion=cadena_ejecucion & " WHERE ARTICULOS.ID=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'FALTARIA VER SI HAY QUE MODIFICAR EL ICONO E IMAGEN DEL ARTICULO
					'VER COMO SE GESTIONA LA TABLA DE CANTIDADES PRECIOS
					
					
					'Si se ha cambiado el Compromiso de Compra del artíulo, eliminamos los precios que se hayan 
					'dado de alta hasta ahora para no tener duplicados...
					if cambio_compromiso_compra&""="S" then
						cadena_ejecucion="DELETE FROM CANTIDADES_PRECIOS WHERE CODIGO_ARTICULO=" & articulo_seleccionado
						'response.write("<br>" & cadena_ejecucion)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					end if					
					
					'Ahora modificamos las empresas asociadas al artículo...
					'borramos lo que habia previamente y grabamos lo que venga de la ficha del articulo
					cadena_ejecucion="DELETE FROM ARTICULOS_EMPRESAS WHERE ID_ARTICULO=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'Ahora añadimos un registro por cada empresa seleccionada en ARTICULOS_EMPRESAS
					I = 0 
					empresa_barcelo="N"
					For Each empresa In Request.Form("rbempresas") 
						if empresa=1 then
							empresa_barcelo="S"
						end if
						combo_familia="cmbfamilias_"&empresa
						familia = Request.Form(combo_familia)
						'response.Write(articulo_seleccionado&"---"&empresa&"---"&familia&"<br>")
						cadena_campos=""
						cadena_campos="ID_ARTICULO, CODIGO_EMPRESA, FAMILIA"
							
						cadena_valores=""
						cadena_valores=articulo_seleccionado & ", " & empresa & ", " & familia
						cadena_ejecucion="Insert into ARTICULOS_EMPRESAS (" & cadena_campos & ") values(" & cadena_valores & ")"
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
						I = I + 1 
					Next 


					'ahora vamos con el control de stocks
					'borramos lo que habia previamente y grabamos lo que venga de la ficha del articulo
					cadena_ejecucion="DELETE FROM ARTICULOS_MARCAS WHERE ID_ARTICULO=" & articulo_seleccionado
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					
					'05/02/14 - Como hemos desasociado el artículo de las empresas y podemos tener más de una empresa para un artículo, 
					'           sólamente pueden compartir stock si no se asocia Barceló con otra empresa. Por lo tanto, tomaremos las 
					'           marcas de Barceló si el artículo es exclusivo de Barceló, o la marca STANDARD para el resto...
					if empresa_barcelo="S" then
						set marcas_articulo=Server.CreateObject("ADODB.Recordset")
						sql="SELECT V_CLIENTES_MARCA.MARCA FROM V_CLIENTES_MARCA"
						sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=1"
						sql=sql & " ORDER BY V_CLIENTES_MARCA.MARCA"
						
						'response.write("<br>" & sql)
						with marcas_articulo
							.ActiveConnection=connimprenta
							.CursorType=3 'adOpenStatic
							.Source=sql
							.Open
						end with
						
						while not marcas_articulo.eof
							stock_marca= Request.Form("txtstock_" & marcas_articulo("marca"))
							stock_minimo_marca=Request.Form("txtstock_minimo_" & marcas_articulo("marca"))
							'if stock_marca<>"" or stock_minimo_marca<>"" then
								cadena_campos=""
								cadena_campos="ID_ARTICULO, MARCA, STOCK, STOCK_MINIMO"
								
								cadena_valores=""
								cadena_valores=articulo_seleccionado & ", '" & marcas_articulo("marca") & "'"
								if stock_marca="" then
									cadena_valores=cadena_valores & ", null"
								else
									cadena_valores=cadena_valores & ", " & stock_marca
								end if
								if stock_minimo_marca="" then
									cadena_valores=cadena_valores & ", null"
								else
									cadena_valores=cadena_valores & ", " & stock_minimo_marca
								end if
								
								cadena_ejecucion="Insert into ARTICULOS_MARCAS (" & cadena_campos & ") values(" & cadena_valores & ")"
								'response.write("<br>" & cadena_ejecucion)
								connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
									
							'end if
							
							marcas_articulo.movenext
						wend
							 
						marcas_articulo.close
						set marcas_articulo=Nothing
						
					else
						stock_marca= Request.Form("txtstock_STANDARD")
						stock_minimo_marca=Request.Form("txtstock_minimo_STANDARD")
						cadena_campos="ID_ARTICULO, MARCA, STOCK, STOCK_MINIMO"
						cadena_valores=articulo_seleccionado & ", 'STANDARD'"
						if stock_marca="" then
							cadena_valores=cadena_valores & ", null"
						else
							cadena_valores=cadena_valores & ", " & stock_marca
						end if
						if stock_minimo_marca="" then
							cadena_valores=cadena_valores & ", null"
						else
							cadena_valores=cadena_valores & ", " & stock_minimo_marca
						end if
								
						cadena_ejecucion="Insert into ARTICULOS_MARCAS (" & cadena_campos & ") values(" & cadena_valores & ")"
						'response.write("<br>" & cadena_ejecucion)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					end if				
					
					set marcas_articulo=Nothing
					
					
					
					connimprenta.CommitTrans ' finaliza la transaccion
					
			
					mensaje_aviso="El Articulo Ha Sido Modificado Con Exito..."			
					
			else
				if accion="ALTA" then
					'cadena_campos="CODIGO_EMPRESA, CODIGO_SAP, DESCRIPCION, TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, "
					cadena_campos="CODIGO_SAP, DESCRIPCION, TAMANNO, TAMANNO_ABIERTO, TAMANNO_CERRADO, PAPEL, "
					cadena_campos=cadena_campos & " TINTAS, ACABADO, UNIDADES_DE_PEDIDO, FECHA, COMPROMISO_COMPRA,"
					cadena_campos=cadena_campos & " MOSTRAR, BORRADO, REQUIERE_AUTORIZACION, PACKING, FACTURABLE, MATERIAL "
					  
					
					cadena_valores="'" & Request.Form("txtcodigo_sap") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtdescripcion") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txttamanno") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txttamanno_abierto") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txttamanno_cerrado") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtpapel") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txttintas") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtacabado") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtunidades_pedido") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtfecha") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("cmbcompromiso_de_compra") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("cmbmostrar") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("cmbeliminado") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("cmbautorizacion") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("txtpacking") & "',"
					cadena_valores=cadena_valores & " '" & Request.Form("cmbfacturable") & "',"
					
					if Request.Form("txtmaterial")<>"" then
						cadena_valores=cadena_valores & " '" & Request.Form("txtmaterial") & "'"
					  else
					  	cadena_valores=cadena_valores & " NULL"
					end if
					
					connimprenta.BeginTrans 'Comenzamos la Transaccion
					cadena_ejecucion="Insert into ARTICULOS (" & cadena_campos & ") values(" & cadena_valores & ")"
					'response.write("<br>" & cadena_ejecucion)
					connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					
					'me quedo con el nuevo numero introducido
					Set valor_nuevo = connimprenta.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
					numero_articulo_nuevo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
					valor_nuevo.Close
					Set valor_nuevo = Nothing
				
					'Ahora añadimos un registro por cada empresa seleccionada en ARTICULOS_EMPRESAS
					I = 0 
					empresa_barcelo="N"
					For Each empresa In Request.Form("rbempresas") 
						if empresa=1 then
							empresa_barcelo="S"
						end if
						combo_familia="cmbfamilias_"&empresa
						familia = Request.Form(combo_familia)
						'response.Write(numero_articulo_nuevo&"---"&empresa&"---"&familia&"<br>")
						cadena_campos=""
						cadena_campos="ID_ARTICULO, CODIGO_EMPRESA, FAMILIA"
							
						cadena_valores=""
						cadena_valores=numero_articulo_nuevo & ", " & empresa & ", " & familia
						cadena_ejecucion="Insert into ARTICULOS_EMPRESAS (" & cadena_campos & ") values(" & cadena_valores & ")"
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
						I = I + 1 
					Next 
		
				
					'ahora vamos con el control de stocks
					'05/02/14 - Como hemos desasociado el artículo de las empresas y podemos tener más de una empresa para un artículo, 
					'           sólamente pueden compartir stock si no se asocia Barceló con otra empresa. Por lo tanto, tomaremos las 
					'           marcas de Barceló si el artículo es exclusivo de Barceló, o la marca STANDARD para el resto...
					if empresa_barcelo="S" then
						set marcas_articulo=Server.CreateObject("ADODB.Recordset")
						sql="SELECT V_CLIENTES_MARCA.MARCA FROM V_CLIENTES_MARCA"
						sql=sql & " WHERE V_CLIENTES_MARCA.EMPRESA=1"
						sql=sql & " ORDER BY V_CLIENTES_MARCA.MARCA"
						
						'response.write("<br>" & sql)
						with marcas_articulo
							.ActiveConnection=connimprenta
							.CursorType=3 'adOpenStatic
							.Source=sql
							.Open
						end with
						
						while not marcas_articulo.eof
							stock_marca= Request.Form("txtstock_" & marcas_articulo("marca"))
							stock_minimo_marca=Request.Form("txtstock_minimo_" & marcas_articulo("marca"))
							'if stock_marca<>"" or stock_minimo_marca<>"" then
								cadena_campos=""
								cadena_campos="ID_ARTICULO, MARCA, STOCK, STOCK_MINIMO"
								
								cadena_valores=""
								cadena_valores=numero_articulo_nuevo & ", '" & marcas_articulo("marca") & "'"
								if stock_marca="" then
									cadena_valores=cadena_valores & ", null"
								else
									cadena_valores=cadena_valores & ", " & stock_marca
								end if
								if stock_minimo_marca="" then
									cadena_valores=cadena_valores & ", null"
								else
									cadena_valores=cadena_valores & ", " & stock_minimo_marca
								end if
								
								cadena_ejecucion="Insert into ARTICULOS_MARCAS (" & cadena_campos & ") values(" & cadena_valores & ")"
								'response.write("<br>" & cadena_ejecucion)
								connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
									
							'end if
							
							marcas_articulo.movenext
						wend
							 
						marcas_articulo.close
						set marcas_articulo=Nothing
						
					else
						stock_marca= Request.Form("txtstock_STANDARD")
						stock_minimo_marca=Request.Form("txtstock_minimo_STANDARD")
						cadena_campos="ID_ARTICULO, MARCA, STOCK, STOCK_MINIMO"
						cadena_valores=numero_articulo_nuevo & ", 'STANDARD'"
						if stock_marca="" then
							cadena_valores=cadena_valores & ", null"
						else
							cadena_valores=cadena_valores & ", " & stock_marca
						end if
						if stock_minimo_marca="" then
							cadena_valores=cadena_valores & ", null"
						else
							cadena_valores=cadena_valores & ", " & stock_minimo_marca
						end if
								
						cadena_ejecucion="Insert into ARTICULOS_MARCAS (" & cadena_campos & ") values(" & cadena_valores & ")"
						'response.write("<br>" & cadena_ejecucion)
						connimprenta.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
					end if				
					
					connimprenta.CommitTrans ' finaliza la transaccion
			
					mensaje_aviso="El Articulo Ha Sido Dado de Alta Con Exito..."			
						
				end if
		end if
		
		
		
		
		
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Grabar Pedido</TITLE>
</HEAD>
<script language="javascript">
function validar(mensaje)
{
	alert(mensaje);
	document.getElementById('frmgrabar_articulo').submit()	
	

	//alert('articulos.asp?codsucursal=' + sucursal)
	//location.href='articulos.asp?codsucursal=' + sucursal
	//window.history.back(window.history.back())
}

</script>

   
<BODY onload="validar('<%=mensaje_aviso%>')">
	
	<%
	'sql="exec GRABAR_CABECERA_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', 'INTRANET'," & cint(numero) & ";"
	'conn.execute sql
	'numero=18
	'sql="exec GRABAR_DETALLE_PEDIDO " & numero & ", " & cint(codsucursal) & ", " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "';"		
	'conn.execute sql
	
	'sql="exec GRABAR_CABECERAYDETALLE_PEDIDO " & cint(codsucursal) & ", '" & cdate(fecha) & "', " & codarticulo & ", " & cint(cantidad) & ", '" & expediente & "', '" & pedido_por & "';"		
	'conn.execute sql
%>
<form name="frmgrabar_articulo" id="frmgrabar_articulo" method="post" action="Consulta_Articulos_Admin.asp">
</form>
</BODY>
   <%	
   		'regis.close			
		connimprenta.Close
		set connimprenta=Nothing
	%>
   </HTML>
