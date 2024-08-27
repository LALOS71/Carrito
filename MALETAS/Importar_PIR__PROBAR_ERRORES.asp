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
							
							
							
							
							'FICHERO DEL DIA 26/04/2019
							txt="EXPEDIENTE;PIR;FECCREACION;NOMBRE;APELLIDOS;MOVIL;FIJO;DIRENTREGA;CPOSTAL;TIPODIRECCION;DESDEHASTA;FECHADESDEHASTA;TAG;MARCA;MATERIAL;COLOR;LARGO;ANCHO;ALTO;RUTA;VUELO;TIPOEQUIPAJE;EMAIL;MARCAWT" & chr(10) & _
"LISUX13324D20190419;LISUX13324;19-04-2019;Joao;Barata;968251508;;Rua Dra. Ludovina Barroso|LT A77 |3¿ Dir|Castelo Branco|Castelo Branco;6000-475;P;DESDE;26-04-2019;AM198411;No lo se;RIGIDO;NEGRO;40;25;60;MEX/MAD/LIS;AM1/18APR/UX1155/19APR;BK22HWX;jambarata@gmail.com;YY" & chr(10) & _
"VLCUX20979D20190424;VLCUX20979;24-04-2019;SRA;LOPEZ MARIANATALIA;615143732;963841493;Heroe Romeu|20|6  pta-26|Valencia|Valencia;46008;P;DESDE;02-05-2019;AF518774;joumma;RIGIDO;fucsia;45;65;28;JFK/CDG/VLC;AF9/24APR/UX1004/24APR;RD02XXX;natalialomar@gmail.com;MOVOM" & chr(10) & _
"TFNUX26825D20190413;TFNUX26825;13-04-2019;ELBA;GONZALEZ GARRIGUES;655956377;;ILLUECA|5|ESCALERA 2¿, PISO 1¿D|ZARAGOZA|ZARAGOZA;50008;P;DESDE;26-04-2019;UX748825;CLEMENTINA FROG;RIGIDO;AZUL OSCURO;73CM;28CM;60 CM;MAD/TFN;UX9048/13APR;BU01WXX;elbaggg@gmail.com;CLEMENTINA FROG" & chr(10) & _
"BCNUX55907D20190424;BCNUX55907;24-04-2019;CRISTINA;IGLESIAS;655945866;;VILAMAR|93|bajo 5|CALAFELL|terragona;;P;DESDE;29-04-2019;UX068278;//;DURO;AZUL;grande;grande;grande;PMI/BCN;UX6102/24APR;BU22RHW;;" & chr(10) & _
"IBZUX15800D20190421;IBZUX15800;21-04-2019;YEISON ALEXANDER;GOMEZ MENESES;692573316-630536771;;TRAVES¿A MALLORCA-MENORCA |1|3 PUERTA 4|IBIZA |ISLAS BALEARES;07800;P;DESDE;26-04-2019;UX889150;GABOL;SEMIRIGIDO;AZUL;75;30;52;BOG/MAD/IBZ;UX194/21APR/UX6027/21APR;BU22RXX;yeison_pachaibiza@hotmail.com;GABO" & chr(10) & _
"PMIUX54998D20190425;PMIUX54998;25-04-2019;NUCIA;FERRAN MORAGUES;637872737;;PASEO MARITIMO|35|7 inf|mallorca|baleares;;P;DESDE;29-04-2019;TK505240;rebook;BLANDO;AZUL;grande;grande;grande;DAC/IST/BCN/PMI;TK713/25APR/TK1855/25APR/UX6103/25APR;BU25XXX;;YY" & chr(10) & _
"AGPUX28685D20190423;AGPUX28685;23-04-2019;DANIEL;MADRID SALAS;682197566;617289254;Paseo puerto de la horca|7||Casabermeja|M¿laga;29160;P;DESDE;30-04-2019;AM204553;;RIGIDO;ROJO;25cm;45 cm;56 cm;CUN/MEX/CDG/AGP;AM586/22APR/AM3/22APR/UX1038/23APR;RD22RXX;anasanchez_96@hotmail.com;YY/PINK COLOUR" & chr(10) & _
"LPAUX30655D20190421;LPAUX30655;21-04-2019;M¿ ASCENSION;PRIETO PRIETO;620916163;928419125;PRESIDENTE ALVEAR|13|4B|LAS PALMAS DE GRAN CANARIA|LAS PALMAS;35006;P;DESDE;29-04-2019;UX894131;TORRENTE;RIGIDO;AZUL;41;25;60   LAS RUEDAS;MAD/LPA;UX9164/21APR;BU01HWX;lpalmas@prosandimas.com;TORRENTE" & chr(10) & _
"LPAUX30661D20190424;LPAUX30661;24-04-2019;LOZANO;MONTANO BEATRIZ;659254766;659254766;Avenida madres de mayo|1, bloque 1|1 D|Fuenlabrada - Loranca |Madrid;28942;P;DESDE;27-04-2019;UX048621;Gabol;RIGIDO;AZUL;68;44;25;MAD/LPA;UX9172/23APR;BU22RHW;nemesisbm@hotmail.com;GASOL" & chr(10) & _
"TFNUX26801D20190408;TFNUX26801;08-04-2019;MARTINEZ;ANDRES;616753721;;Matem¿ticas  |30|Chalet|Albacete |Albacete;02008;P;DESDE;26-04-2019;UX655192;Paco Martinez;RIGIDO;ESTAMPADO;60cm;40cm;24cm;MAD/TFN;UX9118/08APR;MC02WXX;doryandres52@gmail.com;" & chr(10) & _
"SPCUX10577D20190422;SPCUX10577;22-04-2019;ALEJANDRO;MARTIN;696734642;922411826;AVDA. EL PUENTE, EDIF. EL PUENTE|56|PORTAL ""B"" PISO ""9-B2""|S/C DE LA PALMA|S/C DE LA PALMA;38700;P;DESDE;26-04-2019;UX020252;GABOL;DURO;VERDE;45;30;83;OVD/MAD/TFN/SPC;UX7404/22APR/UX9048/22APR/UX9467/22APR;GN02RHW;alexpley1983@gmail.com;GABOL" & chr(10) & _
"SDQUX14056D20190424;SDQUX14056;24-04-2019;PENA;NUNEZ BERTHA;635354183     ¿     652885578;983130084;Tierra Baja|4|Bajo|Valladolid|Valladolid;47010;P;DESDE;27-04-2019;UX062457;Ormi;DURO;ROJO;30 cm;50 cm;74 cm;MAD/SDQ;UX89/24APR;RD22RHW;lvegsan@hotmail.com;ORMY" & chr(10) & _
"SVQUX10535D20190423;SVQUX10535;23-04-2019;MARIAJOSE;TORVISCO;652584870;956276577;Avda. Jos¿ Le¿n de Carranza|20 Dpdo.|Noveno Q|C¿diz |C¿diz;11011;P;DESDE;27-04-2019;UX047864;Itaca;Resistente;Rosa;40;20;50;VLC/SVQ;UX4666/23APR;RD22RHW;matorfu@hotmail.com;MODERN AND FISH" & chr(10) & _
"GRXUX13186D20190419;GRXUX13186;19-04-2019;BENITEZ;BENITEZ MIGUEL;630771903;;M¿SICO ARRIETA|44|2¿ A|PALMA DE MALLORCA|ISLAS BALEARES;07008;P;DESDE;26-04-2019;UX856425;NORWAY GEOGRAPHICAL;RIGIDO;AZUL;65;43;28;PMI/GRX;UX5201/19APR;BU22RHW;trastete@gmail.com;" & chr(10) & _
"MAHUX12857D20190426;MAHUX12857;26-04-2019;DANIEL;DELOLMO GOMEZ;648949461;;marina |2||Arenal del Castells|Menorca;;T;HASTA;02-05-2019;UX089419;;DURO;GRIS;grande;grande;grande;MAD/MAH;UX815/26APR;GY22RHW;;YY/4 WHEELS/LARGE SIZE/GY SILVER PLASTIC WITH BN ZIPPERS" & chr(10) & _
"MADUX47720D20190422;MADUX47720;22-04-2019;LOPEZ;VILLALBA;663483940;953553652;ALFARERIA|5||MARTOS|JAEN;23600;P;DESDE;27-04-2019;UX012765;BOSSANA;RIGIDO;GRIS;51,5;32,5;77;JFK/MAD;UX92/21APR;GY22RWX;elisabethvl91@hotmail.com;BOSSANA/BIG SIZE" & chr(10) & _
"VGOUX18667D20190426;VGOUX18667;26-04-2019;MONTESERIN;MERA MARIA;626523930;985353399;Donato Arguelles |14|7,C|Gij¿n |Asturias;33206;P;DESDE;06-05-2019;UX088923;Jotm travel;DURO;ROJO;40;30;80;OVD/MAD/VGO;UX7402/26APR/UX7306/26APR;RD02WXX;elenapesozense@gmail.com;JOHN TRAVEL" & chr(10) & _
"TFNUX26840D20190421;TFNUX26840;21-04-2019;EDMUNDO;GONZALEZ MARRERO;608766830;922634019;Camino Jardina|20||San Crist¿bal de La Laguna|Santa Cruz de Tenerife;38293;P;DESDE;27-04-2019;UX009040;IT;RIGIDO;GRIS;35 cm;25 cm;50 cm;BIO/TFN;UX7008/21APR;GY22RHW;edmundogonzalezmarrero@gmail.com;IT/MEDIUM SIZE/04 WHEELS" & chr(10) & _
"TFNUX26838D20190421;TFNUX26838;21-04-2019;EDUARDO;PINA GUERRERA ESCOBAR;629850834;;PINTOR HERNANDEZ QUINTANA|8|2¿ IZQUIERDA|LA OROTAVA|TENERIFE;38300;P;DESDE;26-04-2019;UX897642;SAMSONITE;SEMIRIGIDO;NEGRO;60;40;30;OVD/MAD/TFN;UX7404/21APR/UX9048/21APR;BK22RHW;richard@viajesdivertour.com;SAMSONITE/04 WHEELS" & chr(10) & _
"BCNUX55906D20190424;BCNUX55906;24-04-2019;JUAN MANUEL;JAEN;600955304;937110245;Santiago de Compostela|37|casa|Sabadell|Barcelona;08204;P;DESDE;29-04-2019;UX064862;VILONG;SEMIRIGIDO;MARRON;40;30;65;LEI/BCN;UX4610/24APR;GY22HWX;juanmajasa@gmail.com;VILONG" & chr(10) & _
"TFNUX26846D20190426;TFNUX26846;26-04-2019;KELLY;VARGAS PENA;617951058;;Av. Venezuela|9|2do. Derecha|Santa Cruz de Tenerife|Santa Cruz De Tenerife;38007;P;DESDE;26-04-2019;AZ793900;Benzi;ABS ultraligero 4 ruedas;Champan (beige);70;46;28;FCO/MAD/TFN;AZ58/26APR/UX9118/26APR;BN22RHW;kellyvargaspena@gmail.com;BENZI" & chr(10) & _
"BIOUX20569D20190422;BIOUX20569;22-04-2019;ENRIQUE;CABRERAASPIAZU;666458355 / 627612616;944041792;Astillero 8 (entrada por estrada de abaro)|Lonja Drogueria Perfumeri||Zorrotza- Bilbao |Bizkaia;48013;P;DESDE;26-04-2019;UX021235;Gabol;RIGIDO;Azul;68;25;48;AGP/BIO;UX4649/22APR;BU22RHW;seikide@gmail.com;NODISPO"


							
							
							response.write("<br><br>RESULTADO: " & txt)

							'comprobaciones caracter a caracter cuando da error
							'for i=1 to len(txt)
							'   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
							'next
							'txt = Replace(txt,"&#13;&#10;", "")
							
							'sustituimos cosas raras
							txt = Replace(txt,chr(13) & chr(10), "") 'retornos de carro y saltos de linea en medio de campos.... donde no debe
							txt = Replace(txt,"'", "´") 'las comillas simples que dan error al importar
							
							response.write("<br><br>RESULTADO despues de formatear: " & txt)
							
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
													cadena_valores="'" & left(replace(campos(CPIR),"""", "´"), 15) & "'"
													
													
													if campos(CEXPEDIENTE)<>"" then
														cadena_campos=cadena_campos & ", EXPEDIENTE"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CEXPEDIENTE),"""", "´"), 25) & "'"
													end if
													if campos(CFECCREACION)<>"" then
														cadena_campos=cadena_campos & ", FECHA_PIR"
														cadena_valores=cadena_valores & ", '" & replace(campos(CFECCREACION),"""", "´") & "'"
													end if
													if campos(CNOMBRE)<>"" then
														cadena_campos=cadena_campos & ", NOMBRE"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CNOMBRE),"""", "´"), 50) & "'"
													end if
													if campos(CAPELLIDOS)<>"" then
														cadena_campos=cadena_campos & ", APELLIDOS"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CAPELLIDOS),"""", "´"), 100) & "'"
													end if
													if campos(CMOVIL)<>"" then
														cadena_campos=cadena_campos & ", MOVIL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CMOVIL),"""", "´"), 80) & "'"
													end if
													if campos(CFIJO)<>"" then
														cadena_campos=cadena_campos & ", FIJO"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CFIJO),"""", "´"), 80) & "'"
													end if
													if campos(CDIRENTREGA)<>"" then
														cadena_campos=cadena_campos & ", DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CDIRENTREGA),"""", "´"), 255) & "'"
													end if
													if campos(CCPOSTAL)<>"" then
														cadena_campos=cadena_campos & ", CP_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CCPOSTAL),"""", "´"), 12) & "'"
													end if
													if campos(CTIPODIRECCION)<>"" then
														cadena_campos=cadena_campos & ", TIPO_DIRECCION_ENTREGA"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CTIPODIRECCION),"""", "´"), 3) & "'"
													end if
													if campos(CDESDEHASTA)<>"" then
														cadena_campos=cadena_campos & ", DESDE_HASTA"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CDESDEHASTA),"""", "´"), 5) & "'"
													end if
													if campos(CFECHADESDEHASTA)<>"" then
														cadena_campos=cadena_campos & ", FECHA_DESDE_HASTA"
														valor_comprobar_fecha=replace(campos(CFECHADESDEHASTA),"""", "´")
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
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CTAG),"""", "´"), 15) & "'"
													end if
													if campos(CMARCA)<>"" then
														cadena_campos=cadena_campos & ", MARCA_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CMARCA),"""", "´"), 100) & "'"
													end if
													if campos(CMATERIAL)<>"" then
														cadena_campos=cadena_campos & ", MATERIAL_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CMATERIAL),"""", "´"),20) & "'"
													end if
													if campos(CCOLOR)<>"" then
														cadena_campos=cadena_campos & ", COLOR_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CCOLOR),"""", "´"),25) & "'"
													end if
													if campos(CLARGO)<>"" then
														cadena_campos=cadena_campos & ", LARGO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CLARGO),"""", "´"), 25) & "'"
													end if
													if campos(CANCHO)<>"" then
														cadena_campos=cadena_campos & ", ANCHO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CANCHO),"""", "´"), 25) & "'"
													end if
													if campos(CALTO)<>"" then
														cadena_campos=cadena_campos & ", ALTO_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CALTO),"""", "´"), 25) & "'"
													end if
													if campos(CRUTA)<>"" then
														cadena_campos=cadena_campos & ", RUTA"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CRUTA),"""", "´"), 25) & "'"
													end if
													if campos(CVUELO)<>"" then
														cadena_campos=cadena_campos & ", VUELOS"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CVUELO),"""", "´"), 50) & "'"
													end if
													if campos(CTIPOEQUIPAJE)<>"" then
														cadena_campos=cadena_campos & ", TIPO_EQUIPAJE_BAG_ORIGINAL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CTIPOEQUIPAJE),"""", "´"),15) & "'"
													end if
													if campos(CEMAIL)<>"" then
														cadena_campos=cadena_campos & ", EMAIL"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CEMAIL),"""", "´"), 255) & "'"
													end if
													if campos(CMARCAWT)<>"" then
														cadena_campos=cadena_campos & ", MARCAWT"
														cadena_valores=cadena_valores & ", '" & left(replace(campos(CMARCAWT),"""", "´"), 100) & "'"
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
													cadena_ejecucion=cadena_ejecucion & " AND PIRS.TAG='" & left(replace(campos(CTAG),"""", "´"), 15) & "')"
													
													
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
														
														response.write("<br><br>cadena_historico: " & cadena_historico)
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

				
