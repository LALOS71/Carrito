<%@ language=vbscript %>
<!--#include file="Conexion.inc"-->
<%

'Response.ContentEncoding = Encoding.Default 

'response.write("<br>ocultosql: " &  Request.Form("ocultosql"))
consulta_filtro="" & Request.Form("ocultosql")


		
		
		

'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 


	set pedidos=Server.CreateObject("ADODB.Recordset")
	
		with pedidos
			.ActiveConnection=connimprenta
			.Source=consulta_filtro
			'response.write("<br>" & .source)			
			.Open
		end with
		



Response.ContentType = "application/vnd.ms-excel.numberformat:#.###"
Response.AddHeader "Content-Disposition", "attachment;filename=Listado_Pedidos.xls"

'Response.AddHeader "Content-Disposition", "inline;attachment;filename=Listado_Costes_Articulos.xls"
'Response.AppendHeader(“content-disposition“, “inline; filename=report.xls“);
		
'funcion para formatear:' - a 2 decimales,' - con separadores de miles,' - con el 0 delante de valores entre 0 y 1...
Function formatear_importe(importe)
	   if importe<>"" then				
		importe_formateado=FORMATNUMBER(importe,2,-1,,-1)
        
	      else
		importe_formateado=""
	   end if		
		'response.write("<br><br>" & importe_formateado)
		formatear_importe=importe_formateado
End Function
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">

<title>...:: Informe Imprenta ::...</title>


<style>


.cabeceras_grises{background: #666666;text-align:center;
				font-family:Calibri;font-weight:bold;font-size:15px;color:#eeeeee;}	

body {
	margin-top: 4px;
}

.contenedor_con_borde{ border:1 solid #888888}



/*para que el salto de linea lo deje en la misma celda y no genera una linea nueva*/
br {mso-data-placement:same-cell;}

</style>
</head>

<body bgcolor="#FFFFFF">



<div align="center">	


	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
								<tr>
									<th class="contenedor_con_borde">Cliente</th>
									<th class="contenedor_con_borde">Num. Pedido</th>
									<th class="contenedor_con_borde">Fecha</th>
									<th class="contenedor_con_borde">Importe</th>
									<th class="contenedor_con_borde">Estado</th>
                                    
								</tr>
								<%if pedidos.eof then%>
									<tr> 
										<td align="center" colspan="5"><b><FONT class="fontbold">Aún No Se Han Realizado Pedidos...</font></b><br>
										</td>
									</tr>
								<%end if%>
								<%vueltas=1
									while not pedidos.eof%>									  
									<%if numero_registros=200 then
												response.Flush()
												numero_registros=0
											else
												numero_registros=numero_registros + 1
										end if%>
											
											
									<tr>
										<td class="contenedor_con_borde">
										<%=pedidos("empresa")%> -
										<%if pedidos("codigo_externo")<>"" then%>
											&nbsp;(<b><%=pedidos("codigo_externo")%></b>)
										<%end if%>
										&nbsp;<%=pedidos("nombre")%>
										</td>
										
										<td class="contenedor_con_borde"><%=pedidos("id")%></td>
										<td class="contenedor_con_borde"><%=pedidos("fecha")%></td>                                            
                                        <td class="contenedor_con_borde"><%=formatear_importe(pedidos("TotalEnvio"))%></td>                                                                                                                             
										<td class="contenedor_con_borde"><%=pedidos("estado")%></td>
									</tr>
								
								<%		
									pedidos.movenext
									if vueltas=800 then
										response.Flush()
										vueltas=0
									else
										vueltas=vueltas+1
									end if
								Wend
									
								%>


									
						</table>

</div>




</body>
<% 
	pedidos.close
	connimprenta.close
	
	set pedidos=Nothing
	set connimprenta=Nothing	

%>
</html>
