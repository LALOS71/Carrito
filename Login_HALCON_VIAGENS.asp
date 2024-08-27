<%@ language=vbscript %>

<!--#include file="Conexion.inc"-->
<!--#include file="Capturar_IP.inc"-->
<%
	'recordsets
	dim sucursales
	dim datossucursal
	
	
		'variables
		dim usuario         'variable para almacenar el usuario de la sucursal
		dim contrasenna		'variable para almacenar la contraseña de la sucursal
		dim valido			'variable para controlar si se han encontrado datos o no
		
		mayorista="CARRITO IMPRENTA"
		autorizador="NO"
		
		direccion_ip=Request.Form("ocultoip")
		codigo_sucursal=request.QueryString("sucursal")
		if codigo_sucursal&""="" then 
			'direccion_ip=Request.ServerVariables("REMOTE_ADDR") 
			'response.write(direccion_ip)
			set  sucursales=Server.CreateObject("ADODB.Recordset")
			with sucursales
				.ActiveConnection=connimprenta
				.Source="Select  *  from [192.168.156.175\SERVERSQL].SUCPC.dbo.detalles_ips where ip='" & direccion_ip & "'"
				.open
			end with
			
			valido=""
			no_ip="NO"
			if not sucursales.eof then
				codigo_sucursal=sucursales("codigo")
			else
				response.write("<br><br><br><br><div align=center><font face=Calibri size=3><b>A C C E S O&nbsp;&nbsp;&nbsp;A U T O M A T I C O&nbsp;&nbsp;&nbsp;A L&nbsp;&nbsp;&nbsp;C A R R I T O</FONT>")
				response.write("<br><br><font face=Calibri size=2>ESTE EQUIPO NO TIENE LA DIRECCION IP DADA DE ALTA PARA UTILIZAR ESTA APLICACION")
				response.write("<br>PONGASE EN CONTACTO CON EL DEPARTAMENTO DE INFORMATICA DE SALAMANCA (923 20 33 10)...")
				response.write("<br><br>O ENVIENOS UN EMAIL INDICANDO LA SUCURSAL A LA QUE PERTENECE EL EQUIPO")
				'response.write("<br><br>O ENVIENOS LA DIRECCION IP DE SU EQUIPO POR M2 A LA 995 INDICANDO DICHA DIRECCION IP Y LA SUCURSAL A LA QUE PERTENECE EL EQUIPO")
				'response.write("<br><br>LA DIRECCION IP PUEDE OBTENERLA ENTRANDO EN LA INTRANET, EN LA PAGINA PRINCIPAL APARECE ABAJO A LA IZQUIERDA LA DIRECCION IP, QUE SON 4 NUMEROS SEPARADOS POR PUNTOS (.)")
				cadena="mailto:microinformatica@halcon-viajes.es"
				cadena=cadena & "?body=La%20Direccion%20IP%20de%20Este%20Equipo%20es:%20" & direccion_ip
				cadena=cadena & "%0D%0A%0Ay%20pertenece%20a%20la%20sucursal:%20<<<%20PONGA%20AQUI%20LA%20SUCURSAL%20A%20LA%20QUE%20PERTENECE%20EL%20EQUIPO%20>>>"
				cadena=cadena & "&subject=Validacion Automatica IP (CARRITO IMPRENTA)"
				response.write("<br><br><a href='" & cadena & "'>Enviar Correo</a></b></font></DIV>")
				no_ip="SI"
			end if	
			sucursales.close
			set sucursales=Nothing
		end if

		if codigo_sucursal&""<>"" then 
			set datossucursal=Server.CreateObject("ADODB.Recordset")
			'recogemos el usuario y la contraseña de la sucursal y el tipo
			'  de acceso que se ha hecho
			with datossucursal
				.ActiveConnection=connimprenta
				.Source="SELECT usuario, password, b.EMPRESA"
				.Source = .Source & " FROM [192.168.156.175\SERVERSQL].SUCPC.dbo.claves_accesos a"
				.Source = .Source & " INNER JOIN V_CLIENTES b"
				.Source = .Source & " ON a.usuario=b.id"
				.Source = .Source & " WHERE (a.tipo_clave = 'EC') AND (a.sucursal = '" & codigo_sucursal & "')"
				
				'response.write("<br>" & .Source)
				.Open
			end with
			'response.write("<br>" & codigo_sucursal)
			'si encuentra datos relativos a la sucursal introducida y al tipo
			' de acceso que quiere hacerse, los vuelca en las variables de
			' usuario y contraseña y utiliza una variable para indicar que ha
			' encontrado los datos, esa variable es valido
			valido=0
			if not datossucursal.EOF then
				usuario=datossucursal("usuario")
				contrasenna=datossucursal("password")
				vempresa=datossucursal("empresa")
				valido=1
			end if
	
			datossucursal.close
			set datossucursal = Nothing
		end if	
		
		'response.write("sucursal: " & codigo_sucursal & "<br>Usuario: " & usuario & "<br>Contraseña: " & contrasenna)
		
		
		
		'controlamos si entran los autorizadores para que no entre automaticamente,
		'sino que muestre un combo para seleccionar la empresa que gestionar
		set autorizadores=Server.CreateObject("ADODB.Recordset")
			'recogemos el usuario y la contraseña de la sucursal y el tipo
			'  de acceso que se ha hecho
			with autorizadores
				.ActiveConnection=connimprenta
				.Source="SELECT  A.TipoTabla, A.Codigo, A.Texto as IP, A.Texto2 as DESCRIPCION, A.Importe as CLIENTE_AD,"
				.Source=.Source & " A.Texto3, B.CONTRASENNA, B.EMPRESA"
				.Source=.Source & " FROM [192.168.156.175\SERVERSQL].GAG.dbo.Tablas A LEFT JOIN V_CLIENTES B"
				.Source=.Source & " ON A.Importe = B.ID"
				.Source=.Source & " WHERE (A.TipoTabla = 'IPSA')"
				.Source=.Source & " AND (A.Texto2 LIKE 'AUTORIZADOR_GAG_%')"
				.Source=.Source & " AND A.TEXTO='" & direccion_ip & "'"

				'response.write("<br>" & .Source)
				.Open
			end with
			
			if not autorizadores.eof then
				autorizador="SI"
			else
				autorizador="NO"
			end if
				
			
%>
<%

'Mensaje para notificar a la sucursales qué deben hacer cuando no están dadas de alta en una mayorista
mensaje="No existen datos para la sucursal en " & mayorista & "...\n"
mensaje=mensaje&"Póngase en contacto con el Dpto. de Soporte de Salamanca enviando un correo \n"
mensaje=mensaje&"a peticiones@globalia-sistemas.com o bien a través del teléfono 923 20 33 10"

%>

<HTML>
<HEAD>
<TITLE>Validacion HALCON VIAGENS</TITLE>
<META NAME="Generator" CONTENT="Microsoft FrontPage 4.0">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">

<link href="estilos.css" rel="stylesheet" type="text/css" />

<script language="javascript">

	/****************************************************
	  esta funcion es la que ira al enlace de la pagina
	  del mayorista o ejecutara el submit del formulario
	  correspondiente al acceso que se quiere hacer.
	    tiene 4 parametros:
		-sino... para controlar si hay datos de la sucursal o no
		-usuario... el usuario de la sucursal que se introdujo
		-contrasenna... contraseña de la sucursal que se introdujo
		-origen... indica a que mayorista se va a acceder
	*****************************************************/
	function moverse(sino, autorizador)
	{
		//alert('validamos 2..3..4..5..6')
		//alert(sino)
		//vemos si hay datos de esa sucursal, es decir, si es correcta
	if (autorizador!='SI')
		{
		if (sino==1)
			{
				
				//location.href = 'http://online.condorvacaciones.es/reservas/login.do?tipoEntrada=RESERVAR&login=<%=usuario%>&password=<%=contrasenna%>'
				//window.close()
				document.getElementById('frmcarrito').submit()
			}
		  else
			{
				if (sino==0)
				{
				alert('<%=mensaje%>')
				//history.back(-1)
				self.close()
				}
			}
		}
	}
	
function ir(empresa, suc, cont)
{
	document.getElementById('ocultoempresa').value= empresa
	document.getElementById('cmbhoteles').value= suc
	document.getElementById('txtcontrasenna').value= cont
	
	document.getElementById('frmcarrito').submit()
}	
</script>

</HEAD>

<!--
  al cargarse la pagina, aparte de construirse en funcion del
 mayorista al que se accede, se ejecuta la funcion moverse
 ya comentada
-->

<BODY onload="moverse(<%=valido%>, '<%=autorizador%>')">



<!-- Cambia el 02/04/2012
<form method="post" action="http://www.antalissupplies.com/j_signon_check" name="frmantalis">
	<input type="hidden" name="j_username" id="j_username" value="<%=usuario%>">
	<input type="hidden" name="j_password" id="j_password" value="<%=contrasenna%>">
</form>
 
nos pasan nuevo formulario el 26/06/2013, este deja de funcionar


<form method="post" action="http://www.lyreco.com/OLO/FH1/dispatch.do?language=SP&country=SP&user=<%=usuario%>&password=<%=contrasenna%>" name="frmantalis">
</form>
 -->

<%if autorizador="SI" and no_ip<>"SI" then%>



<div id="loginform">
  		<table width="69%" cellspacing="6" cellpadding="0" class="logintable" align="center">
  			<tr>
  				<!--6.08 - Translate titles and buttons-->
  				<td class="al">
  					<span class='fontbold'>Login Autorizador</span>
  				</td>
  			</tr>
  			<tr>
				<td class="dottedBorder vt al" width="50%">
  					Seleccione el Tipo de Acceso: <br /><br />
					
					<table width="626">
						<tr>
							<td width="261"><img src="Images/Logo_Artes-Graficas.png" /></td>
							<td width="353">
								
									<table cellpadding="2" cellspacing="1" border="0" width="100%">
										<%WHILE NOT AUTORIZADORES.EOF%>
											<tr>
												<td width="14%">- <a href="#" onClick="ir('<%=AUTORIZADORES("EMPRESA")%>', '<%=AUTORIZADORES("CLIENTE_AD")%>', '<%=AUTORIZADORES("CONTRASENNA")%>')"><%=REPLACE(AUTORIZADORES("DESCRIPCION"),"_", " ")%></a></td>
											</tr>
											<%AUTORIZADORES.MOVENEXT%>
										<%WEND%>
									</table>
							</td>
						</tr>
						<tr>
							<td width="261">&nbsp;</td>
						</tr>
				  </table>
  
 					
				</td>
			</tr>
  </table>
</div>
<%end if%>


<form name="frmcarrito" id="frmcarrito" method="post" action="Validar.asp" onsubmit="return validar(this)">
	<input type="hidden" name="ocultoempresa" id="ocultoempresa" value="<%=vempresa%>" />
	<input type="hidden" name="cmbhoteles" id="cmbhoteles" value="<%=usuario%>" />
	<input type="hidden" name="txtcontrasenna" id="txtcontrasenna" value="<%=contrasenna%>" />
</form>
							
<!--
-->

</BODY>
<%
	
	connimprenta.close

	set connimpresta=Nothing
	
%>
</HTML>
