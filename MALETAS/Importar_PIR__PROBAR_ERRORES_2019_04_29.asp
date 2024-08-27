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
							
							
							
							
							'FICHERO DEL DIA 15/04/2019
							txt="EXPEDIENTE;PIR;FECCREACION;NOMBRE;APELLIDOS;MOVIL;FIJO;DIRENTREGA;CPOSTAL;TIPODIRECCION;DESDEHASTA;FECHADESDEHASTA;TAG;MARCA;MATERIAL;COLOR;LARGO;ANCHO;ALTO;RUTA;VUELO;TIPOEQUIPAJE;EMAIL;MARCAWT" & chr(10) & _
"AGPUX28665D20190413;AGPUX28665;13-04-2019;LORENA;ALBA;652459814;;Pintor Antonio Vald¿s|39||V¿lez M¿laga|M¿laga;29700;P;DESDE;16-04-1019;AZ150354;Gabol;RIGIDO;VERDE;25;45;75;ASU/VVI/MAD/AGP;Z8740/12APR/UX26/12APR/UX5035/13APR;YW22RHW;lorenalba62@hotmail.com;" & chr(10) & _
"IBZUX15742D20190117;IBZUX15742;17-01-2019;ABELISARIO / ARGENTINA;OGANDOOGANDO / INFANTEMINYETTY;631468710 / 691063841;;AVENIDA ESPA¿A |89|4-2|ISLAS BALEARES |EIVISSA;07800;P;DESDE;1-4-1900;UX381119;GLARIATOR;DURO;Gris;48'5;29'5;75;SDQ/MAD/IBZ;UX88/16JAN/UX6025/17JAN;RD22RHW;belyordani@gmail.com;TRAVELWORLD" & chr(10) & _
"IBZUX15742D20190117;IBZUX15742;17-01-2019;ABELISARIO / ARGENTINA;OGANDOOGANDO / INFANTEMINYETTY;631468710 / 691063841;;AVENIDA ESPA¿A |89|4-2|ISLAS BALEARES |EIVISSA;07800;P;DESDE;30-04-1899;UX381119;GLARIATOR;DURO;Gris;48'5;29'5;75;SDQ/MAD/IBZ;UX88/16JAN/UX6025/17JAN;GY22RHW;belyordani@gmail.com;GLADIATOR" & chr(10) & _
"SVQUX10496D20190412;SVQUX10496;12-04-2019;MARTIN;TEJADA;610498998;955912142;DELICIAS|5|CASA|ESTEPA|SEVILLA;41560;P;DESDE;15-04-1899;UX730452;MARCA HUAXIN;RIGIDO;ROJO;30;40;65;TFN/SVQ;UX5103/12APR;RD22RXX;;MARCA HUAXIN" & chr(10) & _
"LPAUX30643D20190414;LPAUX30643;14-04-2019;DOMINGUEZ;VEGA GABRIEL;686851553;928791168;Joaqu¿n Blume|68||Vecindario|Las palmas;35110;P;DESDE;15-04-2019;UX763115;;DURO;AZUL;55 cm;45 cm;64 cm;FCO/MAD/LPA;UX1040/14APR/UX9164/14APR;BU22RHW;angeladominguez636@gmail.com;" & chr(10) & _
"PMIUX54962D20190415;PMIUX54962;15-04-2019;ANTONIA;FERRAGUT;676802953;971608634;miquel dels sants oliver|6|bajos|ses cases noves marratxi|baleares;07141;P;DESDE;15-04-2019;UX785657;sin marca;RIGIDO;GRIS;45;30;60;LEI/PMI;UX4672/15APR;GY22RHW;mantoniaferragut@hotmail.com;" & chr(10) & _
"MADUX47655D20190415;MADUX47655;15-04-2019;Jos¿ Antonio;DOVAL Varela;646609106;981432881;Urb olmo |7|4¿ izq|Pontedeume|A Coru¿a;15614;P;DESDE;16-04-2019;UX780690;American tourister;RIGIDO;Azul;55;40;20;LCG/MAD;UX7232/15APR;BU02HWX;jadovalvarela@gmail.com;AMERICAN TOURISTER" & chr(10) & _
"PMIUX54964D20190415;PMIUX54964;15-04-2019;MARIA PILAR;ASENSIO RUIZ;34620259552;34637993813;Calle de Antoni Llabres i Morey|24B||Palma de Mallorca |Islas Baleares;07610;P;DESDE;31-12-2019;UX786800;John Travel;BLANDO;AZUL;66;40;25;BCN/PMI;UX6071/15APR;BK22HWX;pasensior@gmail.com;JONTRAVEL" & chr(10) & _
"MADUX47648D20190413;MADUX47648;13-04-2019;Javier;Aceituno Moreno;670391850;918571628;C/Santa Quiteria|20|Bajo derecha|Alpedrete|Madrid;28430;P;DESDE;16-04-2019;UX753832;Carrefour;SEMIRIGIDO;ROJO;74;47;29;VCE/MAD;UX1084/13APR;RD02HWX;javieraceitunomoreno@gmail.com;CARREFOUR" & _
"MADUX47637D20190412;MADUX47637;12-04-2019;CLARA;SANCHEZ SANCHEZ;675157312;916084799;Portugal|3|6¿4|Madrid|fuenlabrada;28943;P;DESDE;23-04-2019;UX733467;ENCY;DURO;AZUL;41;28;64;TFN/MAD;UX9117/12APR;BU02HWX;clara43514@gmail.com;ENCI" & chr(10) & _
"LPAUX30642D20190414;LPAUX30642;14-04-2019;ENCARNACION;FIGUEROA;637191119;928907093;Pedro Perdomo Acedo |34|2¿A|Carrizal (Ingenio)|Las Palmas de Gran Canaria;35240;P;DESDE;16-04-2019;UX769719;Unit;RIGIDO;Verde;73 cm;45 cm;73 cm;MAD/LPA;UX9164/14APR;GN22RHW;candelarf75@hotmail.com;UNIT" & chr(10) & _
"BIOUX20557D20190412;BIOUX20557;12-04-2019;Diego;Jimenez Gonzalez;646145544;947721128;Ciudad de vierzon |50|5B|Miranda de Ebro |Burgos;09200;P;DESDE;15-04-2019;TK844209;American tourister;SEMIRIGIDO;NEGRO;80;40;50;MED/IST/MAD/BIO;TK99/11APR/TK1859/11APR/UX7159/11APR;BU22HWX;jimmy13-vane@hotmail.com;YY/2WHEELS/MEDIUM SZ/GY KEY LOCK" & chr(10) & _
"VGOUX18584D20190403;VGOUX18584;03-04-2019;RODRIGUEZ;ANTON MANUEL;603797875;986132746;Dr. Carracido|64|Casa|Vigo|Pontevedra;36205;T;HASTA;07-05-2019;AM167864;Dillards;RIGIDO;AZUL;48 cms;24 cms,;73 cms,;MTY/MEX/MAD/VGO;AM927/02APR/AM1/02APR/UX7300/03APR;BU02WXX;losceltistas@hotmail.com;ALEXANDER" & chr(10) & _
"IBZUX15742D20190117;IBZUX15742;17-01-2019;ABELISARIO / ARGENTINA;OGANDOOGANDO / INFANTEMINYETTY;631468710 / 691063841;;AVENIDA ESPA¿A |89|4-2|ISLAS BALEARES |EIVISSA;07800;P;DESDE;15-04-2019;UX381122;TRAVEL WORLD;DURO;ROJO/MAROON/ROSA/VINO DISE¿O;48'5;29'5;75;SDQ/MAD/IBZ;UX88/16JAN/UX6025/17JAN;GY22RHW;belyordani@gmail.com;GLADIATOR" & chr(10) & _
"MADUX47646D20190413;MADUX47646;13-04-2019;CARMEN CONCEPCION;BARTOLOME;619217844;;GUADAMEDINA|13||VILLAVICIOSA DE ODON|MADRID;28670;P;DESDE;15-05-2019;UX751156;GLORIA ORTIZ;DURO;VERDE;50;37;78;LIS/MAD;UX1156/13APR;GN22RHW;mariabartolome14@hotmail.com;GLORIA ORTIZ" & chr(10) & _
"MADUX47606D20190409;MADUX47606;09-04-2019;JOSE LUIS;FERNANDEZ LOPEZ;659827397;;MIGJORN|5 PORTAL 1|6¿ C|VILLAJOYOSA|ALICANTE;03570;P;DESDE;15-04-2019;UX672692;MALETA CABINA TSA;DURO;AZUL;55 centimetros;40 centimetros;20 centimetros;PMI/MAD;UX6030/09APR;BU02HWX;ferjoseluis2020@gmail.com;" & chr(10) & _
"BIOUX20560D20190415;BIOUX20560;15-04-2019;JOSE ANGEL;LOPEZ ALISTE;685730753;946030610;Juan Mari Altuna  |7|3¿ - C|Durango|BIZKAIA;48200;P;DESDE;15-04-2019;UX779028;Valisa;DURO;VIOLETA;45;30;67;CDE/MAD/BIO;UX64/14APR/UX7153/15APR;PU02HWX;cgmarkel@gmail.com;VALISA/2 WHEELS" & chr(10) & _
"BCNUX55887D20190413;BCNUX55887;13-04-2019;CARMEN;MORENO TROYANO;650435158;972400490;Josep Maria Gironella y Pou|1- 3|Escalera B 4o 2a|Girona |Girona;17005;P;DESDE;23-04-2019;UX754736;Orati;RIGIDO;AZUL;80;55;30;AGP/BCN;UX4606/13APR;BU22RHW;troyano56@hotmail.es;ORATI" & chr(10) & _
"MADUX47642D20190413;MADUX47642;13-04-2019;TERESA;DEPORRAS CARRIQUE;607816464;958304052;CAMPANARIO|2||C¿JAR|GRANADA;18199;P;DESDE;16-04-2019;UX738068;EMIDIO TUCCI;DURO;AZUL;24,5cm;46,5cm;67cm;CUN/MAD;UX64/12APR;BU22RHW;teresadeporras@hotmail.es;EMIDIO TUCCI/MEDIUM SZ/4WHEELS" & chr(10) & _
"BCNUX55888D20190414;BCNUX55888;14-04-2019;MONTSERRAT;NACHER LLACH;605328779;977661873;Baix ebre|17|casa|el vendrell|tarragona;43700;P;DESDE;16-04-0019;UX758800;Greenwich;polipropileno con cremallera;plateada;50;27;79;PUJ/MAD/BCN;UX34/13APR/UX7703/14APR;GY22RHW;info@ball-em.com;GREENWICH" & chr(10) & _
"MADUX47605D20190409;MADUX47605;09-04-2019;ANTONIO JOSE;ROJASMONSALVE;698384356;;Dr. Fleming|44|Segundo derecha|San Vicente del Raspeig|Alicante;;P;DESDE;16-04-2019;UX668009;Samsonite;BLANDO;NEGRO;18,5 pulgadas;11 pulgadas;29,5 pulgadas;MIA/MAD;UX98/08APR;BK22HWX;covimax@hotmail.com;SAMSONITE" & chr(10) & _
"MADUX47639D20190413;MADUX47639;13-04-2019;CARMEN;REYES PAULINO;696131831;912592532;Clarinetes|1g|7b|Madrid|Madrid;28054;P;DESDE;22-04-2019;UX730158;In extenso;SEMIRIGIDO;MARRON;65;42;28;LIM/MAD;UX176/12APR;BN22HWX;sexto1347@gmail.com;INEXTENSO" & chr(10) & _
"MADUX47621D20190411;MADUX47621;11-04-2019;Valeriano;Pizarro;600486029;;Paralela |89|6H|Talavera de la Reina |Toledo;45600;P;DESDE;15-04-2019;UX699995;Gabol;RIGIDO;Fucsia;67;48;27;CUN/MAD;UX64/10APR;RD22RHW;varopi76@hotmail.com;GABOL" & chr(10) & _
"SVQUX10508D20190415;SVQUX10508;15-04-2019;MAR¿A ESPERANZA;GARC¿A PADILLA;676850815;956573945;TRUCHA|71||ALGECIRAS|C¿DIZ;11207;P;DESDE;15-04-2019;UX763786;UNIT;DURO;MARR¿N CON FILOS NARANJA;20;35;57;BCN/SVQ;UX4731/14APR;GN22THW;rosanogarcia@gmail.com;02WHEELS/CABINSIZE" & chr(10) & _
"SCQUX10274D20190411;SCQUX10274;11-04-2019;Asunci¿n;CARDOSO RODRIGUEZ;655809494;988250200;Ricardo Courtier|8|4¿B|Ourense|Ourense;32004;P;DESDE;16-04-2019;UX707031;;R¿gido;Gris plateado;46;28;65;AGP/SCQ;UX4719/11APR;GY02HWX;asuncioncardosorodriguez321@gmail.com;NIL" & chr(10) & _
"PMIUX54961D20190415;PMIUX54961;15-04-2019;FERNANDO;MARTOS;609305697;971761783;PLAZA FORTI |5|ENTRESUELO IZQUIERDO|PALMA|ISLAS BALEARES;07001;P;DESDE;15-04-2019;UX734268;TROLLEY XL;BLANDO;MARRON;75;52;31;BCN/PMI;UX6073/12APR;RD22HWX;fernandomartos@cpmabogados.com;" & chr(10) & _
"IBZUX15793D20190412;IBZUX15793;12-04-2019;JOAQUIN;DELPALACIOHUERTA;625373334;;Santo ¿ngel |57|Bajo|Madrid|Madrid;28043;P;DESDE;15-04-2019;UX724751;Tempo;RIGIDO;AZUL;55;40;25;MAD/IBZ;UX6025/12APR;GY22RHW;mirun2014@gmail.com;TEMPO" & chr(10) & _
"BCNUX55889D20190414;BCNUX55889;14-04-2019;MARTA;MUSSACH NACHER;656442678;933712176;EMILI JUNCADELLA|20-22|3¿ , 1a|ESPLUGUES DE LLOBREGAT|BARCELONA;08950;P;DESDE;16-04-2019;UX758824;;SEMIRIGIDO;GRIS;60 cm;45 cm;25 cm;PUJ/MAD/BCN;UX34/13APR/UX7703/14APR;BK22RHW;martamussach@gmail.com;" & chr(10) & _
"MADUX47649D20190414;MADUX47649;14-04-2019;BRUNO;PUJOL BENGOECHEA;647317150;;Bahia de Malaga|8a|2b|Madrid|Madrid;28042;P;DESDE;21-04-2019;UX757333;Salvador Bachiller;RIGIDO;GRIS;50;20;100;ASU/MAD;UX24/13APR;GY22RHW;bpb3334@gmail.com;SALVADOR BACHILLER/MEDIUM SZ/4WHEELS" & chr(10) & _
"PMIUX54956D20190413;PMIUX54956;13-04-2019;TOBIAS;TENGEL;0046722322890 or 0046702499665;;Sunwing alcudia Beach nuevas palmeras, Calle miner|||Alcudia|Mallorca;;T;HASTA;20-04-2019;UX744690;;DURO;Light turquoise;70;45;30;UME/PMI;UX814/13APR;BU22RHW;viktoria.tengel@gmail.com;LA PERLE" & chr(10) & _
"LISUX13288D20190409;LISUX13288;09-04-2019;MISS/INES;SOUSA INES;351914190930;;Rua do Barril|7||Lousa|Lousa LRS;2670-750;P;DESDE;15-04-2019;UX668711;Gladiator;DURO;GRIS;46;69;27;HAV/MAD/LIS;UX525/08APR/UX1157/09APR;GY22RHW;ic.sousa@live.com.pt;GLADIATOR" & chr(10) & _
"IBZUX15742D20190117;IBZUX15742;17-01-2019;ABELISARIO / ARGENTINA;OGANDOOGANDO / INFANTEMINYETTY;631468710 / 691063841;;AVENIDA ESPA¿A |89|4-2|ISLAS BALEARES |EIVISSA;07800;P;DESDE;15-04-2019;UX381122;TRAVEL WORLD;DURO;ROJO/MAROON/ROSA/VINO DISE¿O;48'5;29'5;75;SDQ/MAD/IBZ;UX88/16JAN/UX6025/17JAN;RD22RHW;belyordani@gmail.com;TRAVELWORLD" & chr(10) & _
"PMIUX54954D20190412;PMIUX54954;12-04-2019;MISS MARGALIDA;ALFARO ROSSELLO;685118494;699344990;ANDREU VIDAL|11||SES SALINES|MALLORCA, ISLAS BALEARES;07640;P;DESDE;22-04-2019;UX736121;GABOL;DURO;AZUL;70 CM;40 CM;70 CM;BCN/PMI;UX6103/12APR;BU22RHW;margaalfaro90@hotmail.com;YY" & chr(10) & _
"PMIUX54963D20190415;PMIUX54963;15-04-2019;ANGELES;MONFORTPUIG ANGELES;686644370;;Nu¿o Sanz|26|4-pta. 3|Santa Ponsa (Calvia)|Palma de Mallorca;07180;T;HASTA;28-04-2019;UX786359;Jonh;Plastico reforzado;Frusia;47;30;73;LEI/PMI;UX4672/15APR;RD22RHW;cele.moratalla@yahoo.es;YY/BIG SIZE/4WEELS" & chr(10) & _
"EZEUX14992D20190410;EZEUX14992;10-04-2019;SERGIO;GYALUI;636966942;915900020;Castello |48|5 C|Madrid|Espa¿a;28001;P;DESDE;15-04-2019;UX682280;Samsonite;DURO;NEGRO;51;30;75;MAD/EZE;UX41/09APR;GY02HWX;sgyalui@enjoysports.net;SAMSONITE" & chr(10) & _
"MADUX47633D20190412;MADUX47633;12-04-2019;JES¿S;GARC¿A ¿LVAREZ;679346620;918792244;IRLANDA|35|----|VILLALBILLA|MADRID;28810;P;DESDE;15-04-2019;UX735243;RONCATO;SEMIRIGIDO;NEGRO;67;44;27;LCG/MAD;UX7238/12APR;BK22HWX;jegarcialva@gmail.com;RONCATO" & chr(10) & _
"BCNUX55883D20190411;BCNUX55883;11-04-2019;MIGUEL;MARTINEZ CEREZUELA;626670577;;Joan XXIII|1||Les Roquetes (Sant Pere de Ribes)|Barcelona;08812;P;DESDE;15-04-2019;UX715247;;RIGIDO;Dorado;75 incluyendo ruedas;45;30;LEI/BCN;UX4726/11APR;BE22RHW;cuinvilanova2@hotmail.com;YY/BIG SIZE" & chr(10) & _
"BCNUX55852D20190401;BCNUX55852;01-04-2019;LIBRERIA;CAMPUS;667072345;;RONDA MERCEDES|45-47|BAJO (LIBRERIA)|LUGO|LUGO;27002;P;DESDE;16-04-2019;UX543776;GABOL;ABS;AZUL/TURQUESA;46;25;65;SCQ/BCN;UX4628/01APR;BU22RHW;silvina.barrio.rodriguez@gmail.com;GABOL/MEDIUM" & chr(10) & _
"VLCUX20964D20190414;VLCUX20964;14-04-2019;CARLOS;GALLEGO;619156687;;JESUS|54|BAJO|YATOVA|Yatova;46367;P;DESDE;15-04-2019;MU765389;;SEMIRIGIDO;GRIS;45;28;69;PVG/CDG/VLC;MU553/14APR/UX1006/14APR;GY22RHW;kartemoda@gmail.com;YY"

							
							
							response.write("<br>RESULTADO: " & txt)

							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							'txt = Replace(txt,"&#13;&#10;", "")
							
							'sustituimos cosas raras
							txt = Replace(txt,chr(13) & chr(10), "") 'retornos de carro y saltos de linea en medio de campos.... donde no debe
							txt = Replace(txt,"'", "´") 'las comillas simples que dan error al importar
							
							response.write("<br>RESULTADO despues de formatear: " & txt)
							
							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							
							LineArray = Split(txt , chr(10))
							
							'and then you can loop from lBound(LineArray) to uBound(LineArray) to take each line individually
							
							
							CEXPEDIENTE=0
							CPIR=1
							CFECCREACION=2
							CNOMBRE=3
							CAPELLIDOS=4
							CMOVIL=5
							CFIJO=6
							CDIRENTREGA=7
							CCPOSTAL=8
							CTIPODIRECCION=9
							CDESDEHASTA=10
							CFECHADESDEHASTA=11
							CTAG=12
							CMARCA=13
							CMATERIAL=14
							CCOLOR=15
							CLARGO=16
							CANCHO=17
							CALTO=18
							CRUTA=19
							CVUELO=20
							CTIPOEQUIPAJE=21
							CEMAIL=22
							CMARCAWT=23
							
							cabecera=1
							
							
							'response.write("<br><br>lbound: " & LBound(LineArray) & " ubound: " & UBound(LineArray))
							
							
							%>
							
							<br /><br />
							<div>
								<p class="h4">Datos Obtenidos: <b><%=(UBound(LineArray) - 1)%></b> Registros</p>
								<%if UBound(LineArray)>1 then%>
									<script>
										j$('#panel_<%=fechas%>').removeClass('panel-info').addClass('panel-primary')
									</script>
									
									
								<%end if%>
							</div>
							<%if UBound(LineArray)>1 then%>
								<div  class="table-responsive" id="tabla_datos_<%=fechas%>">
									<table class="table table-bordered table-striped table-sm">
											<%
											connmaletas.BeginTrans 'Comenzamos la Transaccion
											
											For i = LBound(LineArray) To UBound(LineArray) - 1
							
												response.flush()
												
												'response.write("<br><br>" & LineArray(i))
												campos=Split(LineArray(i), ";")
												cadena_campos=""
												cadena_valores=""
												if cabecera=0 then
													%>
													<TR>
													<%
													For j = LBound(campos) To UBound(campos)
														%>
														<TD><%=campos(j)%></TD>
														<%
													Next
													%>
													</TR>
													<%
													cadena_campos="PIR"
													cadena_valores="'" & left(campos(CPIR), 15) & "'"
													
													
													if campos(CEXPEDIENTE)<>"" then
														cadena_campos=cadena_campos & ", EXPEDIENTE"
														cadena_valores=cadena_valores & ", '" & left(campos(CEXPEDIENTE), 25) & "'"
													end if
													if campos(CFECCREACION)<>"" then
														cadena_campos=cadena_campos & ", FECHA_PIR"
														cadena_valores=cadena_valores & ", '" & campos(CFECCREACION) & "'"
													end if
													if campos(CNOMBRE)<>"" then
														cadena_campos=cadena_campos & ", NOMBRE"
														cadena_valores=cadena_valores & ", '" & left(campos(CNOMBRE), 50) & "'"
													end if
													if campos(CAPELLIDOS)<>"" then
														cadena_campos=cadena_campos & ", APELLIDOS"
														cadena_valores=cadena_valores & ", '" & left(campos(CAPELLIDOS), 100) & "'"
													end if
													if campos(CMOVIL)<>"" then
														cadena_campos=cadena_campos & ", MOVIL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMOVIL), 80) & "'"
													end if
													if campos(CFIJO)<>"" then
														cadena_campos=cadena_campos & ", FIJO"
														cadena_valores=cadena_valores & ", '" & left(campos(CFIJO), 80) & "'"
													end if
													if campos(CDIRENTREGA)<>"" then
														cadena_campos=cadena_campos & ", DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CDIRENTREGA), 255) & "'"
													end if
													if campos(CCPOSTAL)<>"" then
														cadena_campos=cadena_campos & ", CP_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CCPOSTAL), 12) & "'"
													end if
													if campos(CTIPODIRECCION)<>"" then
														cadena_campos=cadena_campos & ", TIPO_DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(campos(CTIPODIRECCION), 3) & "'"
													end if
													if campos(CDESDEHASTA)<>"" then
														cadena_campos=cadena_campos & ", DESDE_HASTA"
														cadena_valores=cadena_valores & ", '" & left(campos(CDESDEHASTA), 5) & "'"
													end if
													if campos(CFECHADESDEHASTA)<>"" then
														response.write("<br>FECHA DESDE HASTA: isdate: " & IsDate(valor_fecha_desde_hasta))
														response.write("<br>isdate('25/01/2019'): " & IsDate("25/01/2019"))
														response.write("<br>day('25/01/2019'): " & day("25/01/2019"))
														response.write("<br>month('25/01/2019'): " & month("25/01/2019"))
														response.write("<br>year('25/01/2019'): " & year("25/01/2019"))
														response.write("<br>cdate('25/01/2019'): " & cDate("25/01/2019"))
														
														response.write("<br>isdate('01/25/2019'): " & IsDate("01/25/2019"))
														response.write("<br>day('01/25/2019'): " & day("01/25/2019"))
														response.write("<br>month('01/25/2019'): " & month("01/25/2019"))
														response.write("<br>year('01/25/2019'): " & year("01/25/2019"))
														response.write("<br>cdate('01/25/2019'): " & cdate("01/25/2019"))
														
														response.write("<br>isdate('33/01/2019'): " & IsDate("33/01/2019"))
														'response.write("<br>day('33/01/2019'): " & day("33/01/2019"))
														'response.write("<br>month('33/01/2019'): " & month("33/01/2019"))
														'response.write("<br>year('33/01/2019'): " & year("33/01/2019"))
														'response.write("<br>cdate('33/01/2019'): " & cDate("33/01/2019"))
														
														
														
														
														response.write("<br>isdate('25/18/2019'): " & IsDate("25/18/2019"))
														'response.write("<br>day('25/18/2019'): " & day("25/18/2019"))
														'response.write("<br>month('25/18/2019'): " & month("25/18/2019"))
														'response.write("<br>year('25/18/2019'): " & year("25/18/2019"))
														'response.write("<br>cdate('25/18/2019'): " & cDate("25/18/2019"))
														
														
														
														response.write("<br>isdate('25/01/1019'): " & IsDate("25/01/1019"))
														response.write("<br>day('25/01/1019'): " & day("25/01/1019"))
														response.write("<br>month('25/01/1019'): " & month("25/01/1019"))
														response.write("<br>year('25/01/1019'): " & year("25/01/1019"))
														response.write("<br>cdate('25/01/1019'): " & cDate("25/01/1019"))
														fecha_comprobacion=cDate("25/01/1019")
														if cDate("25/01/1019")< cDate("01/01/1900") then
															response.write("<br>cdate('25/01/1019') es anterior a 01/01/1900")
														end if
														
														response.write("<br>isdate('16-04-0019'): " & IsDate("16-04-0019"))
														response.write("<br>day('16-04-0019'): " & day("16-04-0019"))
														response.write("<br>month('16-04-0019'): " & month("16-04-0019"))
														response.write("<br>year('16-04-0019'): " & year("16-04-0019"))
														response.write("<br>datepart('yyyy', '16-04-0019'): " & datepart("yyyy", "16-04-0019"))
														response.write("<br>datepart('yyyy', '16-04-0019'): " & datepart("yyyy", "16-04-0019"))
														response.write("<br>datepart('mm', '16-04-0019'): " & datepart("m", "16-04-0019"))
														response.write("<br>datepart('dd', '16-04-0019'): " & datepart("d", "16-04-0019"))
														response.write("<br>cdate('16-04-0019'): " & cDate("16-04-0019"))
														
														
														response.write("<br>isdate('25/01/19'): " & IsDate("25/01/19"))
														response.write("<br>day('25/01/19'): " & day("25/01/19"))
														response.write("<br>month('25/01/19'): " & month("25/01/19"))
														response.write("<br>year('25/01/19'): " & year("25/01/19"))
														response.write("<br>cdate('25/01/19'): " & cDate("25/01/19"))
														
														response.write("<br>isdate('25/01/019'): " & IsDate("25/01/019"))
														response.write("<br>day('25/01/019'): " & day("25/01/019"))
														response.write("<br>month('25/01/019'): " & month("25/01/019"))
														response.write("<br>year('25/01/019'): " & year("25/01/019"))
														response.write("<br>cdate('25/01/019'): " & cDate("25/01/019"))
														
														
														cadena_campos=cadena_campos & ", FECHA_DESDE_HASTA"
														valor_comprobar_fecha=campos(CFECHADESDEHASTA)
														if isDate(valor_comprobar_fecha) then
															valor_comprobar_fecha=cdate(valor_comprobar_fecha)
															if valor_comprobar_fecha < cDate("01/01/1900") then
																cadena_valores=cadena_valores & ", NULL"
															  else
																cadena_valores=cadena_valores & ", '" & valor_comprobar_fecha & "'"  
															end if
														  else
														  	cadena_valores=cadena_valores & ", NULL"
														end if
														
														
													end if
													if campos(CTAG)<>"" then
														cadena_campos=cadena_campos & ", TAG"
														cadena_valores=cadena_valores & ", '" & left(campos(CTAG), 15) & "'"
													end if
													if campos(CMARCA)<>"" then
														cadena_campos=cadena_campos & ", MARCA_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMARCA), 100) & "'"
													end if
													if campos(CMATERIAL)<>"" then
														cadena_campos=cadena_campos & ", MATERIAL_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CMATERIAL),20) & "'"
													end if
													if campos(CCOLOR)<>"" then
														cadena_campos=cadena_campos & ", COLOR_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CCOLOR),25) & "'"
													end if
													if campos(CLARGO)<>"" then
														cadena_campos=cadena_campos & ", LARGO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CLARGO), 25) & "'"
													end if
													if campos(CANCHO)<>"" then
														cadena_campos=cadena_campos & ", ANCHO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CANCHO), 25) & "'"
													end if
													if campos(CALTO)<>"" then
														cadena_campos=cadena_campos & ", ALTO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CALTO), 25) & "'"
													end if
													if campos(CRUTA)<>"" then
														cadena_campos=cadena_campos & ", RUTA"
														cadena_valores=cadena_valores & ", '" & left(campos(CRUTA), 25) & "'"
													end if
													if campos(CVUELO)<>"" then
														cadena_campos=cadena_campos & ", VUELOS"
														cadena_valores=cadena_valores & ", '" & left(campos(CVUELO), 50) & "'"
													end if
													if campos(CTIPOEQUIPAJE)<>"" then
														cadena_campos=cadena_campos & ", TIPO_EQUIPAJE_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(campos(CTIPOEQUIPAJE),15) & "'"
													end if
													if campos(CEMAIL)<>"" then
														cadena_campos=cadena_campos & ", EMAIL"
														cadena_valores=cadena_valores & ", '" & left(campos(CEMAIL), 255) & "'"
													end if
													if campos(CMARCAWT)<>"" then
														cadena_campos=cadena_campos & ", MARCAWT"
														cadena_valores=cadena_valores & ", '" & left(campos(CMARCAWT), 100) & "'"
													end if
													'los importamos en PENDIENTE AUTORIZACION
													cadena_campos=cadena_campos & ", ESTADO"
													cadena_valores=cadena_valores & ", 1"
													
													'no se si es esta, o el campo que no hemos tratado de FECCREACION
													'cadena_campos=cadena_campos & ", FECHA_PIR"
													'cadena_valores=cadena_valores & ", '" & fecha_ciclo & "'"
													
													'tomamos como fecha de orden del pir la fecha que se pasa como parametro a la url
													cadena_campos=cadena_campos & ", FECHA_ORDEN"
													cadena_valores=cadena_valores & ", '" & fecha_ciclo & "'"
													
													
													'guardo la fecha del fichero en el que viene este PIR a importar
													cadena_campos=cadena_campos & ", FECHA_FICHERO_IMPORTACION"
													cadena_valores=cadena_valores & ", '" & FECHA_CICLO & "'"
													
													'no viene informacion de daños al importar
													cadena_campos=cadena_campos & ", DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL, DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL, DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_OTROS_BAG_ORIGINAL"
													cadena_valores=cadena_valores & ", 'false', 'false', 'false', 'false', 'false', 'false'"
													
													'ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO, DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, 
													'              DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES, TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL, 
													'              COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL, 
													'              DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL, DANNO, EQUIPAJE, RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX, 
													'              PLAZO_ENTREGA_EN_DIAS, INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, 
													'              COLOR_BAG_ENTREGADA, NUM_EXPEDICION, ESTADO, DANNO_OTROS_BAG_ORIGINAL, DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_CIERRES_MALETA_BAG_ORIGINAL, 
													'              IMPORTE_FACTURACION, FECHA_FACTURACION, COSTES, PROVEEDOR, EMAIL
											
													'cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") values (" & cadena_valores & ")"
													
													'cadeja de ejecucion para solo insertar nuevos, los duplicados se los salta
													cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") SELECT " & cadena_valores 
													cadena_ejecucion=cadena_ejecucion & " WHERE NOT EXISTS (Select PIR From PIRS WHERE PIRS.PIR='" & left(campos(CPIR), 15) & "'"
													cadena_ejecucion=cadena_ejecucion & " AND PIRS.TAG='" & left(campos(CTAG), 15) & "')"
													
													
													'INSERT INTO confio SET estado = 0, user_id = 1, user_id_1 = 14
													'ON DUPLICATE KEY UPDATE estado = 0
													
													'INSERT INTO #table1 (Id, guidd, TimeAdded, ExtraData)
													'SELECT Id, guidd, TimeAdded, ExtraData
													'FROM #table2
													'WHERE NOT EXISTS (Select Id, guidd From #table1 WHERE #table1.id = #table2.id)
													
													response.write("<br><br>cadena ejecuacion: " & cadena_ejecucion)
													
													connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
													
													
													Set valor_nuevo = connmaletas.Execute("SELECT @@IDENTITY") ' Create a recordset and SELECT the new Identity
													id_pir_nuevo=valor_nuevo(0) ' Store the value of the new identity in variable intNewID
													valor_nuevo.Close
													Set valor_nuevo = Nothing
													
													IF id_pir_nuevo<>"" then
														'GRABAMOS EN EL HISTORICO EL ALTA DEL PIR
														cadena_historico="INSERT INTO HISTORICO_PIRS (ID_PIR, PIR, FECHA, ACCION, CAMPO, VALOR_ANTIGUO, VALOR_NUEVO,"
														cadena_historico=cadena_historico & "USUARIO, DESCRIPCION, TIPO_INCIDENCIA)"
														cadena_historico=cadena_historico & " VALUES (" & id_pir_nuevo & ", '" & campos(CPIR) & "',"
														cadena_historico=cadena_historico & " GETDATE(), 'IMPORT PIR', NULL, NULL, NULL,"
														cadena_historico=cadena_historico & " '" & session("usuario") & "', 'Fichero CSV de la Fecha " & fecha_ciclo & "', NULL)"
														
														response.write("<br>cadena_historico: " & cadena_historico)
														connmaletas.Execute cadena_historico,,adCmdText + adExecuteNoRecords
													end if
												  else
													%>
													<TR>
													<%
													For j = LBound(campos) To UBound(campos)
														%>
														<TH><%=campos(j)%></TH>
														<%
													Next
													%>
													</TR>
													<%
												end if
												cabecera=0
											Next
											connmaletas.CommitTrans ' finaliza la transaccion
											%>
									</table>
								</div>
							<%end if%>
							
						</div>
					</div>
				</div>
			</div><!--el panel--> 
			 
			<%  
			
			
		
		
			fecha_ciclo=DateAdd("d", 1, fecha_ciclo)
		'next
		
		Set xmlhttp = Nothing
		
		'regis.close			
		connmaletas.Close
		set connmaletas=Nothing
		
		%>
		
		<div class="alert alert-success" role="alert">
			  <p class="h4"><b>Proceso de Importacion Finalizado</b></p>
		</div>
		
	</div>
	
	
</div> <!-- el container-->


</body>

</html>

				
