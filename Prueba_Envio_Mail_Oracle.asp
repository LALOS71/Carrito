<%@ language=vbscript%>
<!--#include file="Conexion_ORACLE_Envios_Distri_PRODUCCION.inc"-->

<%

'Response.CharSet = "UTF-8"
'Response.CodePage = 65001


	adCmdStoredProc=4
	adVarChar=200
	adLongVarChar=201
	adParamInput=1

		set cmd = Server.CreateObject("ADODB.Command")
		'set cmd2 = Server.CreateObject("ADODB.Command")
		set cmd.ActiveConnection = conn_envios_distri
		'set cmd2.ActiveConnection = conndistribuidora
	
		cmd.CommandText = "PAQUETE_ENVIOS_DISTRI.ENVIAR_MAIL"
		cmd.CommandType = adCmdStoredProc
		
		cmd.parameters.append cmd.createparameter("P_ENVIA",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_RECIBE",adVarChar,adParamInput,255)
		cmd.parameters.append cmd.createparameter("P_ASUNTO",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("P_MENSAJE",adVarChar,adParamInput,2000)
		cmd.parameters.append cmd.createparameter("P_MENSAJE",adLongVarChar,adParamInput,-1)
		cmd.parameters.append cmd.createparameter("P_HOST",adVarChar,adParamInput,255)
		'cmd.parameters.append cmd.createparameter("C_ALTO_GENERICO",adInteger,adParamInput,2)
		'cmd.parameters.append cmd.createparameter("C_PESO_GENERICO",adDouble,adParamInput)
		
		'cmd.parameters.append cmd.createparameter("texto_explicacion",adVarChar,adParamOutPut,255)
		
		cmd.parameters("P_ENVIA")="carlos.gonzalez@globalia-artesgraficas.com"
		
		
		'para diferenciar los correos a los que se envia cuando estamos en pruebas o en real
		' y no tener que andar comentando y descomentando lineas		
		cadena_asunto="Probando áéíóúñüÁÉÍÓÚÑÜ"
		correos_recibe="malba@globalia-artesgraficas.com"

		cmd.parameters("P_RECIBE")=correos_recibe
		
		
		cadena_asunto = replace(cadena_asunto, "á", "&aacute;")
		cadena_asunto = replace(cadena_asunto, "é", "&eacute;")
		cadena_asunto = replace(cadena_asunto, "í", "&iacute;")
		cadena_asunto = replace(cadena_asunto, "ó", "&oacute;")
		cadena_asunto = replace(cadena_asunto, "ú", "&uacute;")
		cadena_asunto = replace(cadena_asunto, "Á", "&Aacute;")
		cadena_asunto = replace(cadena_asunto, "É", "&Eacute;")
		cadena_asunto = replace(cadena_asunto, "Í", "&Iacute;")
		cadena_asunto = replace(cadena_asunto, "Ó", "&Oacute;")
		cadena_asunto = replace(cadena_asunto, "Ú", "&Uacute;")
		cadena_asunto = replace(cadena_asunto, "ñ", "&ntilde;")
		cadena_asunto = replace(cadena_asunto, "Ñ", "&Ntilde;")
		cadena_asunto = replace(cadena_asunto, "ü", "&uuml;")
		cadena_asunto = replace(cadena_asunto, "Ü", "&Uuml;")
		cadena_asunto = replace(cadena_asunto, "ç", "&ccedil;")
		cadena_asunto = replace(cadena_asunto, "Ç", "&Ccedil;")
		cmd.parameters("P_ASUNTO")= cadena_asunto
			
		mensaje = "<div style='background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto'>"
		mensaje = mensaje & "<table style='width:100%' bgcolor='#ffffff'>"
		mensaje = mensaje & "<tbody>"
		mensaje = mensaje & "<tr><td style='border-bottom:4px solid #333333;padding:7px 0'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Se ha procedido a generar un CARGO ABONO con número XX con el siguiente detalle.<br>áéíóúÁÉÍÓÚÑñüÜÇç</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0'>"
		mensaje = mensaje & "<table style='width:100%'>"
		mensaje = mensaje & "<tbody>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<p style='border-bottom:1px solid #d6d4d4;margin:3px 0 7px;text-transform:uppercase;font-weight:500;font-size:18px;padding-bottom:10px'>"
		mensaje = mensaje & "Saldo xx&nbsp;-&nbsp;Cargo/Abono</p>"
		mensaje = mensaje & "<span style='color:#777'>"
		mensaje = mensaje & "El pago para el pedido con refencia <strong><span style='color:#333'>IKZYEYGUM</span></strong> ha sido procesado correctamente.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "<td style='padding:7px 0' width='10'>&nbsp;</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "</tbody>"
		mensaje = mensaje & "</table>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Este saldo, se compensará en el importe a pagar del próximo pedido que realice.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='padding:7px 0'>"
		mensaje = mensaje & "<font size='2' face='Open-sans, sans-serif' color='#555454'>"
		mensaje = mensaje & "<span>Saludos y gracias.</span>"
		mensaje = mensaje & "</font>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "<tr><td style='padding:0!important'>&nbsp;</td></tr>"
		mensaje = mensaje & "<tr>"
		mensaje = mensaje & "<td style='border-top:4px solid #333333;padding:7px 0'>"
		mensaje = mensaje & "<span></span>"
		mensaje = mensaje & "</td>"
		mensaje = mensaje & "</tr>"
		mensaje = mensaje & "</tbody>"
		mensaje = mensaje & "</table>"
		mensaje = mensaje & "</div>"

		
		
		
		mensaje = replace(mensaje, "á", "&aacute;")
		mensaje = replace(mensaje, "é", "&eacute;")
		mensaje = replace(mensaje, "í", "&iacute;")
		mensaje = replace(mensaje, "ó", "&oacute;")
		mensaje = replace(mensaje, "ú", "&uacute;")
		mensaje = replace(mensaje, "Á", "&Aacute;")
		mensaje = replace(mensaje, "É", "&Eacute;")
		mensaje = replace(mensaje, "Í", "&Iacute;")
		mensaje = replace(mensaje, "Ó", "&Oacute;")
		mensaje = replace(mensaje, "Ú", "&Uacute;")
		mensaje = replace(mensaje, "ñ", "&ntilde;")
		mensaje = replace(mensaje, "Ñ", "&Ntilde;")
		mensaje = replace(mensaje, "ü", "&uuml;")
		mensaje = replace(mensaje, "Ü", "&Uuml;")
		mensaje = replace(mensaje, "ç", "&ccedil;")
		mensaje = replace(mensaje, "Ç", "&Ccedil;")
		cmd.parameters("P_MENSAJE")=mensaje
		'cmd.parameters("P_HOST")="195.76.0.183"
		cmd.parameters("P_HOST")="192.168.150.44"
		   
		cmd.execute()
		'response.write("<br>" & mensaje)
		set cmd=Nothing
			
	conn_envios_distri.close
	set conn_envios_distri=Nothing

%>

<div id=":12h" class="a3s aiL msg-6863359583690328922"><u></u>

	
		
		
		
		
		
		

	
	<div style="background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto">
		<table class="m_-6863359583690328922table" style="width:100%;margin-top:10px">
			<tbody><tr>
				<td style="width:20px;padding:7px 0">&nbsp;</td>
				<td style="padding:7px 0" align="center">
					<table class="m_-6863359583690328922table" style="width:100%" bgcolor="#ffffff">
						<tbody><tr>
							<td class="m_-6863359583690328922logo" style="border-bottom:4px solid #333333;padding:7px 0" align="center">
								<a title="S.C.A. del Campo LA CARRERA" href="https://www.cooperativalacarrera.com/tienda/es/" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.cooperativalacarrera.com/tienda/es/&amp;source=gmail&amp;ust=1643877047718000&amp;usg=AOvVaw1QB1cMPs3hrnTp72lTMmxB">
									<img src="https://mail.google.com/mail/u/0?ui=2&amp;ik=aba4f75de9&amp;attid=0.0.1.1&amp;permmsgid=msg-f:1723288068547936060&amp;th=17ea595e3377ff3c&amp;view=fimg&amp;fur=ip&amp;sz=s0-l75-ft&amp;attbid=ANGjdJ9jq-oRTfhilVD0XnozpZXD0PRVBGsSIHw_ITtzSCjy8Nh26nNVhxApI0hhLpK5TXOfRkGFAw2GKRC0E_XQWFaUvR3qzUHM5-1HSw2kzzj9JiXeFA0_baIFpVc&amp;disp=emb" alt="S.C.A. del Campo LA CARRERA" data-image-whitelisted="" class="CToWUd">
								</a>
							</td>
						</tr>

<tr>
	<td class="m_-6863359583690328922titleblock" style="padding:7px 0" align="center">
		<font size="2" face="Open-sans, sans-serif" color="#555454">
			<span class="m_-6863359583690328922title" style="font-weight:500;font-size:28px;text-transform:uppercase;line-height:33px">Hola Manuel Alba Gallego,</span><br>
			<span class="m_-6863359583690328922subtitle" style="font-weight:500;font-size:16px;text-transform:uppercase;line-height:25px">¡Gracias por comprar en S.C.A. del Campo LA CARRERA!</span>
		</font>
	</td>
</tr>
<tr>
	<td class="m_-6863359583690328922space_footer" style="padding:0!important">&nbsp;</td>
</tr>
<tr>
	<td class="m_-6863359583690328922box" style="border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0">
		<table class="m_-6863359583690328922table" style="width:100%">
			<tbody><tr>
				<td style="padding:7px 0" width="10">&nbsp;</td>
				<td style="padding:7px 0">
					<font size="2" face="Open-sans, sans-serif" color="#555454">
						<p style="border-bottom:1px solid #d6d4d4;margin:3px 0 7px;text-transform:uppercase;font-weight:500;font-size:18px;padding-bottom:10px">
							Pedido IKZYEYGUM&nbsp;-&nbsp;Pago procesado						</p>
						<span style="color:#777">
							El pago para el pedido con refencia <strong><span style="color:#333">IKZYEYGUM</span></strong> ha sido procesado correctamente.						</span>
					</font>
				</td>
				<td style="padding:7px 0" width="10">&nbsp;</td>
			</tr>
		</tbody></table>
	</td>
</tr>
<tr>
	<td class="m_-6863359583690328922space_footer" style="padding:0!important">&nbsp;</td>
</tr>
<tr>
	<td class="m_-6863359583690328922linkbelow" style="padding:7px 0">
		<font size="2" face="Open-sans, sans-serif" color="#555454">
			<span>
				Puede revisar su pedido y descargar la factura desde <a href="https://www.cooperativalacarrera.com/tienda/es/historial-compra" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.cooperativalacarrera.com/tienda/es/historial-compra&amp;source=gmail&amp;ust=1643877047719000&amp;usg=AOvVaw19RIkQJ8O8Rd_pqy-Y_eBD">"Historial de pedidos"</a> de su cuenta de cliente, haciendo clic en <a href="https://www.cooperativalacarrera.com/tienda/es/mi-cuenta" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.cooperativalacarrera.com/tienda/es/mi-cuenta&amp;source=gmail&amp;ust=1643877047719000&amp;usg=AOvVaw29OdznMGHwySXp96OjvoPF"></a> en nuestra tienda.			</span>
		</font>
	</td>
</tr>
<tr>
	<td class="m_-6863359583690328922linkbelow" style="padding:7px 0">
		<font size="2" face="Open-sans, sans-serif" color="#555454">
			<span>
				Si tiene una cuenta de invitado, puede seguir su pedido desde la sección: <a href="https://www.cooperativalacarrera.com/tienda/es/seguimiento-cliente-no-registrado?id_order=IKZYEYGUM" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.cooperativalacarrera.com/tienda/es/seguimiento-cliente-no-registrado?id_order%3DIKZYEYGUM&amp;source=gmail&amp;ust=1643877047719000&amp;usg=AOvVaw1eRtCYrOssr9b75PqdpOQn">"Seguimiento de invitado"</a> de nuestra tienda.			</span>
		</font>
	</td>
</tr>

						<tr>
							<td class="m_-6863359583690328922space_footer" style="padding:0!important">&nbsp;</td>
						</tr>
						<tr>
							<td class="m_-6863359583690328922footer" style="border-top:4px solid #333333;padding:7px 0">
								<span><a href="https://www.cooperativalacarrera.com/tienda/es/" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.cooperativalacarrera.com/tienda/es/&amp;source=gmail&amp;ust=1643877047719000&amp;usg=AOvVaw0QmBwgq7cXeCl98V3KZ8sq">S.C.A. del Campo LA CARRERA</a> - Software Ecommerce desarrollado por <a href="http://ayfasoft.es/" style="color:#337ff1" target="_blank" data-saferedirecturl="https://www.google.com/url?q=http://ayfasoft.es/&amp;source=gmail&amp;ust=1643877047719000&amp;usg=AOvVaw2lO_Zdaz6IVLwSHf6__MMk">AyFASOFT</a> sobre la plataforma PrestaShop™</span>
							</td>
						</tr>
					</tbody></table>
				</td>
				<td style="width:20px;padding:7px 0">&nbsp;</td>
			</tr>
		</tbody></table><div class="yj6qo"></div><div class="adL">
	</div></div><div class="adL">


</div></div>


-------------------------


	
		
		
		
		
		
		

	
<div style="background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto">

<table style="width:100%" bgcolor="#ffffff">
	<tbody>
		<tr><td style="border-bottom:4px solid #333333;padding:7px 0">&nbsp;</td></tr>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
			<td style="padding:7px 0">
				<font size="2" face="Open-sans, sans-serif" color="#555454">
					<span>Se ha procedido a generar un "CARGO" "ABONO" con número "XX" con el siguiente detalle.</span>
				</font>
			</td>
		</tr>

		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
			<td style="border:1px solid #d6d4d4;background-color:#f8f8f8;padding:7px 0">
				<table style="width:100%">
					<tbody>
						<tr>
							<td style="padding:7px 0" width="10">&nbsp;</td>
							<td style="padding:7px 0">
								<font size="2" face="Open-sans, sans-serif" color="#555454">
									<p style="border-bottom:1px solid #d6d4d4;margin:3px 0 7px;text-transform:uppercase;font-weight:500;font-size:18px;padding-bottom:10px">
										Saldo xx&nbsp;-&nbsp;Cargo/Abono</p>
										<span style="color:#777">
										El pago para el pedido con refencia <strong><span style="color:#333">IKZYEYGUM</span></strong> ha sido procesado correctamente.</span>
								</font>
							</td>
							<td style="padding:7px 0" width="10">&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
			<td style="padding:7px 0">
				<font size="2" face="Open-sans, sans-serif" color="#555454">
					<span>Este saldo, se compensará en el importe a pagar del próximo pedido que realice.</span>
				</font>
			</td>
		</tr>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
			<td style="padding:7px 0">
				<font size="2" face="Open-sans, sans-serif" color="#555454">
					<span>Saludos y gracias.</span>
				</font>
			</td>
		</tr>
		<tr><td style="padding:0!important">&nbsp;</td></tr>
		<tr>
			<td style="border-top:4px solid #333333;padding:7px 0">
				<span></span>
			</td>
		</tr>
	</tbody>
</table>
</div>

----------------------------

<div style="background-color:#fff;width:650px;font-family:Open-sans,sans-serif;color:#555454;font-size:13px;line-height:18px;margin:auto">
		<table class="m_-6863359583690328922table" style="width:100%;margin-top:10px">
			<tbody><tr>
				<td style="width:20px;padding:7px 0">&nbsp;</td>
				<td style="padding:7px 0" align="center">&nbsp;	TABLAAAAAA		  </td>
				<td style="width:20px;padding:7px 0">&nbsp;</td>
			</tr>
		</tbody></table>
</div>

