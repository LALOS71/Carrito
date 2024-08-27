<%@ language=vbscript%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->




<%
	'if session("usuario")="" then
	'	response.Redirect("Login.asp")
	'end if
%>
<html>



<head>


	<title>Importar PIRs</title>
	

	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="plugins/bootstrap-select/css/bootstrap-select.min.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/media/css/dataTables.bootstrap.css">
	<link rel="stylesheet" type="text/css" href="plugins/dataTable/extensions/Buttons/css/buttons.dataTables.min.css">
  
	<link rel="stylesheet" type="text/css" href="plugins/font-awesome-4.7.0/css/font-awesome.min.css">

	<style>
		body { padding-top: 70px; }
		
		#capa_detalle_pir .modal-dialog  {width:90%;}
		
		.table th { font-size: 13px; }
		.table td { font-size: 12px; }
		
		.dataTables_length {float:left;}
		.dataTables_filter {float:right;}
		.dataTables_info {float:left;}
		.dataTables_paginate {float:right;}
		.dataTables_scroll {clear:both;}
		.toolbar {float:left;}    
		div .dt-buttons {float:right; position:relative;}
		table.dataTable tr.selected.odd {background-color: #9FAFD1;}
		table.dataTable tr.selected.even {background-color: #B0BED9;}
		
		
		
		//para alinear las celdas y la cabecera
		// esta en v2\plugins\dataTable\media\css\jquery.datatables.css
		// pero si lo incluimos entero muestra iconos innecesarios en la cabecera del datatable
		// salen triangulitos para ordenar ascendente o descendentemente
		table.dataTable th.dt-left,
		table.dataTable td.dt-left {text-align:left}
		
		table.dataTable th.dt-center,
		table.dataTable td.dt-center,
		table.dataTable td.dataTables_empty {text-align:center}
		
		table.dataTable th.dt-right,
		table.dataTable td.dt-right {text-align:right}
		
		table.dataTable th.dt-justify,
		table.dataTable td.dt-justify {text-align:justify}
		
		table.dataTable th.dt-nowrap,
		table.dataTable td.dt-nowrap {white-space:nowrap}
		
		table.dataTable thead th.dt-head-left,
		table.dataTable thead td.dt-head-left,
		table.dataTable tfoot th.dt-head-left,
		table.dataTable tfoot td.dt-head-left {text-align:left}
		
		table.dataTable thead th.dt-head-center,
		table.dataTable thead td.dt-head-center,
		table.dataTable tfoot th.dt-head-center,
		table.dataTable tfoot td.dt-head-center {text-align:center}
		
		table.dataTable thead th.dt-head-right,
		table.dataTable thead td.dt-head-right,
		table.dataTable tfoot th.dt-head-right,
		table.dataTable tfoot td.dt-head-right {text-align:right}
		
		table.dataTable thead th.dt-head-justify,
		table.dataTable thead td.dt-head-justify,
		table.dataTable tfoot th.dt-head-justify,
		table.dataTable tfoot td.dt-head-justify {text-align:justify}
		
		table.dataTable thead th.dt-head-nowrap,
		table.dataTable thead td.dt-head-nowrap,
		table.dataTable tfoot th.dt-head-nowrap,
		table.dataTable tfoot td.dt-head-nowrap {white-space:nowrap}
		
		table.dataTable tbody th.dt-body-left,
		table.dataTable tbody td.dt-body-left {text-align:left}
		
		table.dataTable tbody th.dt-body-center,
		table.dataTable tbody td.dt-body-center {text-align:center}
		
		table.dataTable tbody th.dt-body-right,
		table.dataTable tbody td.dt-body-right {text-align:right}
		
		table.dataTable tbody th.dt-body-justify,
		table.dataTable tbody td.dt-body-justify {text-align:justify}
		
		table.dataTable tbody th.dt-body-nowrap,
		table.dataTable tbody td.dt-body-nowrap {white-space:nowrap}
		
		table.dataTable,
		table.dataTable th,
		table.dataTable td{-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box}
		
		table.dataTable tbody tr { cursor:pointer}
		//------------------------------------------
		
		
		
		
 
	</style>

<script type="text/javascript" src="js/comun.js"></script>

<script type="text/javascript" src="js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript" src="plugins/bootstrap-select/js/i18n/defaults-es_ES.js"></script>

<script type="text/javascript" src="plugins/dataTable/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/media/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/jszip.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/pdfmake.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/vfs_fonts.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="plugins/dataTable/extensions/Buttons/js/buttons.print.min.js"></script>
  
<script type="text/javascript" src="plugins/datetime-moment/moment.min.js"></script>  
<script type="text/javascript" src="plugins/datetime-moment/datetime-moment.js"></script>  
  




	

    </head>
<body>

<!--#include file="menu.asp"-->

<script language="javascript">
var j$=jQuery.noConflict();

j$(document).ready(function () {
	var pathname = window.location.pathname;
	
	posicion=pathname.lastIndexOf('/')
	pathname=pathname.substring(posicion + 1,pathname.length)
	
	//para que se seleccione la opcion de menu correcta
	j$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
});
</script>

<%

Response.Buffer = TRUE

Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

lResolve = 50 * 1000  'Resolve timeout in milliseconds
lConnect = 50 * 1000  'Connect timeout in milliseconds
lSend    = 20 * 1000  'Send timeout in milliseconds
lReceive = 560 * 1000 'Receive timeout in milliseconds 
xmlhttp.setTimeouts lResolve, lConnect, lSend, lReceive
'xmlhttp.setTimeouts 5000, 60000, 10000, 10000

%>

<div class="container-fluid">
	<div class="col-sm-8 col-md-8 col-lg-8">
		<div class="panel-group"  role="tablist" aria-multiselectable="true">
			<div class="panel panel-primary">
				<div class="panel-heading" role="tab" >
					<h3 class="panel-title">Proceso de Importaci&oacute;n</h3>
					
				</div>
				
				<div class=" panel-body panel-collapse" role="tabpanel">
				
					<div width="95%">
						<%
						fecha_inicial=""
						fecha_actual=""
						
						'se recojen los pirs como mucho de hasta el dia de ayer... los de hoy se recogen mañana....
						fecha_actual=date()
						'fecha_actual=DateAdd("d", -1, date())
						
						'response.write("<br><br>fecha actual ORIGINAL: " & fecha_actual)
						
						
						
						set ultima_fecha=Server.CreateObject("ADODB.Recordset")
						with ultima_fecha
							.ActiveConnection=connmaletas
							.Source="SELECT DISTINCT TOP 1 FECHA_FICHERO_IMPORTACION FROM PIRS ORDER BY 1 DESC"
							.Open
							'response.write("<br>tipos precios: " & sql)
							if not .eof then
								fecha_inicial="" & ultima_fecha("FECHA_FICHERO_IMPORTACION")
							end if
						end with
						ultima_fecha.close
						set ultima_fecha=Nothing
						
						'response.write("<br><br>fecha inicial ORIGINAL: " & fecha_inicial)
						%>
						
						<p class="h4">&Uacute;ltima Fecha Importada: <%=fecha_inicial%></p>
						<%
						if fecha_inicial="" then
							fecha_inicial=cdate("01-01-2019")
						  'else
							'fecha_inicial=DateAdd("d", 1, fecha_inicial)
							
						end if
						
						'response.write("<br><br>fecha inicial CAMBIADA: " & fecha_inicial & " ...... fecha final CAMBIADA: " & fecha_actual)
						
						'fecha_inicial=cdate("27-06-2012")
						'fecha_inicial=cdate("01-01-2013")
						'fecha_actual=cdate("31-12-2014")
						'fecha_inicial=cdate("01-02-2019")
						
						fecha_ciclo=fecha_inicial
						dias=datediff("d", fecha_inicial, fecha_actual)
						'response.write("<br><br>fecha inicial DEFINITIVA: " & fecha_inicial & " ...... fecha final DEFINITIVA: " & fecha_actual & " ---- intervalo dias: " & dias)
						%>
						
						<p class="h4">Intervalo de Fechas a Importar: Del <%=fecha_inicial%> al <%=fecha_actual%> (<%=dias%> d&iacute;as)</p>
					</div>
					
				</div>
			</div>
		</div><!--el panel-->
	</div>

	<div class="col-sm-12 col-md-12 col-lg-12">

		<%
		'porque el sql de produccion del carrito es un sql expres que debe tener el formato de
		' de fecha con mes-dia-año
		connmaletas.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
		
		'de momento no hago bucle, solo intento importar un fichero de un dia concreto que me da problemas o errores
		'for fechas=0 to dias
			'PRODUCCION
			'https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B
			
			'PREPRODUCCION
			'http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/18-06-2012?key=C59ABE15811E20AA1EC304E6CDE9945B
			'response.write("<br><br>--------------------------------------------------<br>OBTENIENDO DATOS PARA LA FECHA: " & fecha_ciclo & "<br>--------------------------------------------------")
			
			'sitio_web="https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B"
			'sitio_web="http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/" & replace(fecha_ciclo, "/", "-") & "?key=C59ABE15811E20AA1EC304E6CDE9945B"
			sitio_web="http://mylostbag.aireuropa.com/weblf/rest/dpr/" & replace(fecha_ciclo, "/", "-") & "?key=C59ABE15811E20AA1EC304E6CDE9945B"
			'sitio_web="http://www.google.es"
			
			'response.write("<br><br>sitio web: " & sitio_web)
			%>
			<div class="panel-group"  role="tablist" aria-multiselectable="true">
				<div class="panel panel-info" id="panel_<%=fechas%>">
					<div class="panel-heading" role="tab" >
						<h3 class="panel-title">DATOS DE LOS PIRs PARA LA FECHA: <%=fecha_ciclo%></h3>
					</div>
					<div class=" panel-body panel-collapse" role="tabpanel">
						<div width="95%">
							<a href="<%=sitio_web%>">Enlace Al Fichero Con Los Datos</a>
							
							<%
							'xmlhttp.Open "GET", sitio_web , False
							'xmlhttp.Send
							'txt = xmlhttp.responseText
							
							
							
							
							'FICHERO DEL DIA 03/11/2019
							txt="EXPEDIENTE;PIR;FECCREACION;NOMBRE;APELLIDOS;MOVIL;FIJO;DIRENTREGA;CPOSTAL;TIPODIRECCION;DESDEHASTA;FECHADESDEHASTA;TAG;MARCA;MATERIAL;COLOR;LARGO;ANCHO;ALTO;RUTA;VUELO;TIPOEQUIPAJE;EMAIL;MARCAWT" & _
"AGPUX29033D20191031;AGPUX29033;31-10-2019;FRANCISCO;BADILLO JIMENEZ;615842847;;Camino del Pato| 27| 1 C| Malaga| Malaga;29004;P;DESDE;04-11-2019;AF223127;;RIGIDO;AZUL;52;32;72;PEK/CDG/AGP;AF125/31OCT/UX1038/31OCT;BU22RHW;franbadi@hotmail.com;" & _
"VLCUX21369D20191103;VLCUX21369;03-11-2019;JOSEIGNACIO;TAPIA LOPEZ;609225418;962855498;Paseo Francisco Brines|92||Oliva|Valencia;46780;P;DESDE;03-11-2019;UX323756;RONCATO;DURO;GRIS;54;29;80;JFK/MAD/VLC;UX92/01NOV/UX4065/02NOV;GY22RHW;tapia@hotelplayaoliva.com;RONCATO" & _
"MADUX49722D20191030;MADUX49722;30-10-2019;JOSEFA;FALAGAN ALVAREZ;687811847;948128318;Villafranca|2|4 D|Pamplona|Navarra;31015;P;DESDE;05-11-2019;UX177216;Caminatta;PIEL;MARRON;420;210;660;TLV/MAD;UX1302/05SEP;BE22HWX;ifernandez@acciona.es;YY/YW RIBBON AND ADRESS IN HANDLE" & _
"LCGUX11020D20191004;LCGUX11020;04-10-2019;YAGO;FERNANDEZ PINILLA;635343557;981021002;Juan Fl¿rez |49|1Izda|La coru¿a|La coru¿a;15004;P;DESDE;03-11-2019;UX740515;Eastpak;BLANDO;NEGRO;30cm;36cm;67cm;BOG/MAD/LCG;UX164/03OCT/UX7235/04OCT;BK25HWX;yagofp8@gmail.com;EASTPAK" & _
"TFNUX27287D20191102;TFNUX27287;02-11-2019;MARIAANGELES;HERNANDEZ LEDESMA;649941898;922 888 287;Osa Mayor |14|B|La Laguna  ( Barrio de Gracia)|Santa Cruz de Tenerife;38205;P;DESDE;03-11-2019;UX323475;VALISA;SEMIRIGIDO;VERDE;52;30;77;JFK/MAD/TFN;UX92/01NOV/UX9048/02NOV;GN22DXX;mahledesma@gmail.com;" & _
"GYEUX10334D20191028;GYEUX10334;28-10-2019;ROSARIO;MEGIAS CUEVAS;644330338;;AVENIDA GOLA DE PUCHOL|8 - ESCALERA B |PISO 7 - PUERTA 26|VALENCIA|VALENCIA;46012;P;DESDE;13-11-2019;UX244217;JAGUAR;RIGIDO;GRIS;35;20;55;VLC/MAD/GYE;UX4060/27OCT/UX39/28OCT;GN22RXX;rmegiasc@gmail.com;" & _
"PMIUX55471D20191103;PMIUX55471;03-11-2019;SONIA;VAZQUEZ TERRASA;692644505;971604242;Gremi Cirurgians i Barbers|48|3 I|" & _
"Palma de Mallorca|Baleares;07009;P;DESDE;04-11-2019;UX345115;JOHN TRAVEL;SEMIRIGIDO;AZUL;48 CMS,;26 CMS,;70 CMS,;MAD/PMI;UX6013/03NOV;BU22RHW;masohura@gmail.com;JONH TRAVEL" & _
"ALCUX13456D20191029;ALCUX13456;29-10-2019;JOSE CARLOS;PEDRE¿O LOPEZ;34 699305603;968215423;VINADER|8|5F|MURCIA|MURCIA;30004;P;DESDE;03-11-2019;UX267726;Amazon basics;BLANDO;NEGRO;89;40,6;46,4;LPA/MAD/ALC;UX9161/29OCT/UX4049/29OCT;BK25RXX;josecarlos.pedrenolopez@ge.com;AMAZONBASIC" & _
"SVQUX11334D20191101;SVQUX11334;01-11-2019;ANA LUISA;ORIHUELA TORRES;615072505;;CONCEPCI¿N ALC¿NTARA PACHECO |10||CASTILLEJA DE LA CUESTA|SEVILLA;41950;T;HASTA;10-11-2019;UX318512;it;DURO;ESTAMPADO;33cm;47cm;73cm;TFN/SVQ;UX5103/01NOV;PR22RHW;ana-orihuela@hotmail.com;IT/BIG SIZE/4 WHEELS" & _
"MADUX49714D20191029;MADUX49714;29-10-2019;VICTOR;MOTA HARO;647772888;;CHIVA|36||CHESTE|VALENCIA;46380;P;DESDE;04-11-2019;UX264021;CARRITO DE BEBE MARCA MACLAREN;BLANDO;NEGRO;0;0;0;JFK/MAD;UX92/28OCT;BK74HWX;cegalangarcia@gmail.com;MACLAREN" & _



							
							response.write("<br><br>RESULTADO: " & txt)

							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							'txt = Replace(txt,"&#13;&#10;", "")
							
							'sustituimos cosas raras
							''''txt = Replace(txt,chr(13) & chr(10), "") 'retornos de carro y saltos de linea en medio de campos.... donde no debe
							''''txt = Replace(txt,"'", "´") 'las comillas simples que dan error al importar
							
							response.write("<br><br>RESULTADO despues de formatear: " & txt)
							
							'comprobaciones caracter a caracter cuando da error
							for i=1 to len(txt)
							   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							next
							

%>
</body>

</html>

				
