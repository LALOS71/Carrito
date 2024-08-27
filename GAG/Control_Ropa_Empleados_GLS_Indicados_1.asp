<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<!--#include virtual="/includes/Idiomas.asp"-->

<%
Response.Buffer = TRUE

		ver_cadena="" & Request.QueryString("p_vercadena")
		if ver_cadena="" then
			ver_cadena=Request.Form("ocultover_cadena")
		end if
		
		
		anno_fijo=year(date())
		mes_fijo=month(DATE())
		fecha_actual_fija=DATE()
		'response.write("<br>año: " & anno_fijo & "<br>mes: " & mes_fijo & "<br>fecha actual: " & fecha_actual_fija)
		
		'PARA EMULAR QUE ESTAMOS YA EN EL PERIODO DE INVIERNO
		ANNO_FIJO=2022
		MES_FIJO=11
		
set empleados=Server.CreateObject("ADODB.Recordset")
		
		
with empleados
	.ActiveConnection=connimprenta
	.Source="SELECT A.*, B.NOMBRE AS NOMBRE_CENTRO_COSTE FROM EMPLEADOS_GLS A"
	.Source=.Source & " LEFT JOIN V_CLIENTES B ON A.CENTRO_COSTE=B.ID"
	.Source=.Source & " WHERE 1=1" 
	'.Source=.Source & " AND ID IN (3929,3732,3908,3077,3226,2747,3905,3774,3021,2616,3227,2646,3826,1890,2001,3434,3434,3356,3034,1918,3911,2644,2916,2916,2416,2130,3576,3509,3917,3132,3279,3917,3723,3897,3005,3771,2314,3590)"
	.Source=.Source & " AND A.ID <=1500"
	'.Source=.Source & " AND BORRADO='NO'"
	.Open
end with
		
		
		
		
%>

<html  xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title><%=lista_articulos_gag_title%></title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../estilos.css" />
<link rel="stylesheet" type="text/css" href="../carrusel/css/carrusel.css" />
  
  <script type="text/javascript" src="../plugins/fontawesome-5.0.13/js/fontawesome-all.js" defer></script>


<style>
body {padding-top: 10px; margin:0px; background-color:#fff;}

.botones_agrupacion{
  
  /*background-image:url("images/Boton_Informatica.jpg");*/
  background-repeat:no-repeat;
  background-position:center;
  float:left;
    
  height:100px;
  width:100px;
  float:left;
  
  /*background: url("images/Boton_Informatica.jpg") no-repeat center center fixed; */
  
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
  
  /*
  filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale');
  -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/Boton_Informatica_.jpg', sizingMethod='scale')";
 */
 }
  

/*
.centrado_vertical{
    float:none;
    display:inline-block;
    vertical-align:middle;
    margin-right:-4px;
}
*/


@media screen and (min-width: 725px){
   #columna_izquierda_fija{
       position: fixed;
   }
} 

.panel_conmargen
	{
	padding-left:5px; 
	padding-right:5px; 
	padding-bottom:5px; 
	padding-top:5px;
	}
	
.panel_sinmargen
	{
	padding-left:0px; 
	padding-right:0px; 
	padding-bottom:0px; 
	padding-top:0px;
	}
	
.panel_sinmargen_lados
	{
	padding-left:0px; 
	padding-right:0px; 
	}
	
.panel_sinmargen_arribaabajo
	{
	padding-bottom:0px; 
	padding-top:0px;
	}

.panel_connmargen_lados
	{
	padding-left:5px; 
	padding-right:5px; 
	}
	
.panel_conmargen_arribaabajo
	{
	padding-bottom:5px; 
	padding-top:5px;
	}

/*para que quite la sombra del panel*/	
.inf_general_art, .inf_pack_stock
	{
	-webkit-box-shadow: none;
    box-shadow: none;
	}


.table-borderless td,
.table-borderless th {
    border: 0px !important;
}

.row_articulos___ {
    display: table;
}
.row_articulos____ [class*="col-"] {
    display: table-cell;
    float: none;
}

.popover {
  max-width: 1000px;
}

.popover_resumen_articulos {
  max-width: 1000px;
}

#popover_resumen_articulos .popover {
  max-width: 1000px;
}
 
.table-xtra-condensed {font-size: 10px;} 
.table-xtra-condensed > thead > tr > th,
.table-xtra-condensed > tbody > tr > th,
.table-xtra-condensed > tfoot > tr > th,
.table-xtra-condensed > thead > tr > td,
.table-xtra-condensed > tbody > tr > td,
.table-xtra-condensed > tfoot > tr > td {
  padding: 2px;
} 


.glyphicon_rotado {
        -moz-transform: scaleX(-1);
        -o-transform: scaleX(-1);
        -webkit-transform: scaleX(-1);
        transform: scaleX(-1);
        filter: FlipH;
        -ms-filter: "FlipH";
}
</style>


<script src="../funciones.js" type="text/javascript"></script>


<!--PARA LA ANIMACION DE METER LA IMAGEN DEL ARTICULO EN EL CARRITO DE LA COMPRA-->		
<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>


<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>	
	

</head>
<body style="margin-top:0; margin-left:0;">


			<div align="center" class="col-md-12">	
				<table class='table table-striped_ table-bordered table-sm table-responsive table-xtra-condensed'>
					<thead>
						<tr>
							<th>ID EMP.</th>
							<th>NOMBRE</th>
							<th>ID CENTRO</th>
							<th>CENTRO DE COSTE</th>
							<th>GRUPO ROPA EMP</th>
							<th>NUEVO</th>
							<th>BORRADO</th>
							<th>PERIODO</th>
							<th>GRUPO ROPA</th>
							<th>PERIODICIDAD</th>
							<th>FECHA LIMITE</th>
							<th 
									data-toggle='popover_grupo_ropa'
									data-placement='top'
									data-trigger='hover'
									data-content='Cantidad M&aacute;xima de Art&iacute;culos de este Tipo que puede Solicitar en un Periodo'
									data-original-title=''
									style="cursor:pointer"
									>LIMITE</th>
							<th
									data-toggle='popover_grupo_ropa'
									data-placement='top'
									data-trigger='hover'
									data-content='Cantidad ya pedida'
									data-original-title=''
									style="cursor:pointer"
									>YA PEDIDOS</th>
							<th>PEDIDOS</th>
							<th>DEVOLUCIONES</th>
							<th>ESTADO</th>
						</tr>
					</thead>
					<tbody>

<%while not empleados.eof
	response.flush()%>

<%
	'************************************************************
	'PONEMOS LAS VARIALES DE SESION PARA CONTROLAR LOS TIPOS DE ROPA Y LIMITES DE CANTIDADES QUE PUEDE PEDIR EL EMPLEADO
	
	set gestion_ropa=Server.CreateObject("ADODB.Recordset")
	
	'para que no se lie con la pisicion de meses y dias en las fechas
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExec
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'CONSULTO SOBRE LA TABLA EMPLEADOS_GLS_PERIODOS_VENTA_AUX EN VEZ DE EMPLEADOS_GLS_PERIODOS_VENTA PORQUE
	'ASI PUEDO CAMBIAR EL PERIODO A MI ANTOJO PARA SACAR INFORMES DE PERIODOS QUE NO SON EL ACTUAL Y QUE ESTO NO
	'TRASTOQUE EL FUNCIONAMIENTO MIENTRAS HAGO EL INFORME
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	sql = "SELECT GRUPOS.* "
	sql = sql & ", ISNULL(GRUPOS.PEDIDOS_ANT,0) - ISNULL(DEVOLUCIONES.UNIDADES_RESTAR,0) AS CANTIDAD_YA_PEDIDA"
	sql = sql & ", ISNULL(GRUPOS.PEDIDOS_ANT,0) AS PEDIDOS,  ISNULL(DEVOLUCIONES.UNIDADES_RESTAR,0) AS DEVOLUCIONES"
	sql = sql & " FROM"
	sql = sql & " (SELECT ID, DESCRIPCION, ABREVIATURA, FECHA_DESDE, PERIODICIDAD, CANTIDAD_LIMITE, PERIODO_VENTA, FECHA_ACTUAL"
	'sql = sql & "--***************************************"
	'sql = sql & "-- CAMPO PARA CALCULAR LA CANTIDAD YA PEDIDA EN FUNCION DE LAS FECHAS DE LOS PEDIDOS"
	'sql = sql & "--***************************************"
	sql = sql & ", ISNULL((SELECT SUM(Z.CANTIDAD)"
	sql = sql & " FROM PEDIDOS_DETALLES Z"
	sql = sql & " INNER JOIN"
	sql = sql & " (SELECT ID_ARTICULO FROM GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS"
	sql = sql & " WHERE GRUPO = " & empleados("GRUPO_ROPA")
	'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
	sql = sql & " AND (PERIODO='TODO' OR PERIODO=TABLA.PERIODO_VENTA)"
	sql = sql & ") Y"
	
	sql = sql & " ON Z.ARTICULO=Y.ID_ARTICULO"
	sql = sql & " INNER JOIN PEDIDOS X ON Z.ID_PEDIDO=X.ID"
	sql = sql & " INNER JOIN V_CLIENTES W ON X.CODCLI=W.ID"
	sql = sql & " INNER JOIN GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS V ON Z.ARTICULO=V.ID_ARTICULO"
	'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
	sql = sql & " AND (PERIODO='TODO' OR PERIODO=TABLA.PERIODO_VENTA)"
	
	sql = sql & " INNER JOIN EMPLEADOS_GLS U ON X.USUARIO_DIRECTORIO_ACTIVO= U.ID"
	sql = sql & " WHERE X.USUARIO_DIRECTORIO_ACTIVO = " & empleados("ID") 
	sql = sql & " AND V.ID_GRUPO_ROPA=TABLA.ID"
	sql = sql & " AND V.GRUPO = " & empleados("GRUPO_ROPA") 
	sql = sql & " AND W.EMPRESA=4"
	'sql = sql & "-------------------------------------------"
	'sql = sql & "-- condicion para comprobar los limites de las fechas de los pedidos"
	'sql = sql & "-------------------------------------------"
	sql = sql & " AND CONVERT(VARCHAR(8), X.FECHA, 112) >= " 'yyyymmdd
	sql = sql & "CONVERT(VARCHAR(8), ("
	sql = sql & "SELECT TOP 1"
	sql = sql & " CASE WHEN TABLA.PERIODICIDAD=24 THEN"
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI'"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 2) AS varchar), 103)"
	sql = sql & "	 	END"
	
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=12 THEN "
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI'"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 	END"
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=6 THEN"
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 	END"
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103)"
	sql = sql & " END AS FECHA_LIMITE"
	
	sql = sql & " FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & " WHERE"
	sql = sql & "("
	sql = sql & "(PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO')"
	end if
	sql = sql & " OR (PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & " AND MES>7))"
	
	sql = sql & " AND PERIODO_VENTA=TABLA.PERIODO_VENTA"
	
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & " ORDER BY MES"
	sql = sql & ")"
	sql = sql & ", 112)"
	'sql = sql & "-------------------------------------------"
	'sql = sql & "-- fin condicion para comprobar los limites de las fechas de los pedidos"
	'sql = sql & "-------------------------------------------"
	sql = sql & " GROUP BY V.ID_GRUPO_ROPA), 0) AS PEDIDOS_ANT"
	'sql = sql & "--***************************************"
	'sql = sql & "-- FIN CAMPO PARA CALCULAR LA CANTIDAD YA PEDIDA EN FUNCION DE LAS FECHAS DE LOS PEDIDOS"
	'sql = sql & "--***************************************"
	'sql = sql & "--***************************************"
	'sql = sql & "-- CAMPO PARA VER LA FECHA LIMITE DESDE LA QUE SE COMPRUEBA LA PERIODICIDAD"
	'sql = sql & "--***************************************"
	sql = sql & ", CONVERT(VARCHAR(8), ("
	sql = sql & "SELECT TOP 1"
	sql = sql & " CASE WHEN TABLA.PERIODICIDAD=24 THEN"
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI'"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 2) AS varchar), 103)"
	sql = sql & "	 	END"
	
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=12 THEN "
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI'"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "					(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "							WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "					) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 	END"
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=6 THEN"
	sql = sql & "		CASE WHEN PERIODO_VENTA='VERANO'"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "		WHEN PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "			THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 	END"
	
	sql = sql & "	 WHEN TABLA.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103)"
	sql = sql & " END AS FECHA_LIMITE"
	
	sql = sql & " FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & " WHERE"
	sql = sql & "("
	sql = sql & "(PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO')"
	end if
	sql = sql & " OR (PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & " AND MES>7))"
	
	sql = sql & " AND PERIODO_VENTA=TABLA.PERIODO_VENTA"
	
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & " ORDER BY MES"
	sql = sql & ")"
	sql = sql & ", 112) AS FECHA_LIMITE_PERIODICIDAD"
	'sql = sql & "--***************************************"
	'sql = sql & "-- FIN CAMPO PARA VER LA FECHA LIMITE DESDE LA QUE SE COMPRUEBA LA PERIODICIDAD"
	'sql = sql & "--***************************************"
	
	sql = sql & " FROM"
	sql = sql & "(SELECT C.ID, C.DESCRIPCION, C.ABREVIATURA, C.FECHA_DESDE"
	'sql = sql & "--***************************************"
	'sql = sql & "-- CAMPO PERIODICIDAD DE CADA TIPO DE ROPA"
	'sql = sql & "--***************************************"
	sql = sql & ", (SELECT TOP 1 PERIODICIDAD"
	sql = sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES"
	sql = sql & " WHERE PERIODO_VENTA=A.PERIODO_VENTA"
	sql = sql & " AND GRUPO_ROPA = C.ID"
	sql = sql & " AND GRUPO_EMPLEADO = " & empleados("GRUPO_ROPA")
	sql = sql & " ) AS PERIODICIDAD"
	'sql = sql & "--***************************************"
	'sql = sql & "-- FINAL PERIODICIDAD DE CADA TIPO DE ROPA"
	'sql = sql & "--***************************************"
	'sql = sql & "--***************************************"
	'sql = sql & "-- CANTIDAD LIMITE DE CADA TIPO DE ROPA"
	'sql = sql & "--***************************************"
	sql = sql & ", CASE WHEN A.PERIODO_VENTA='VERANO'"
	sql = sql & "	THEN CASE WHEN B.EMPLEADO_NUEVO='SI'"
	sql = sql & "		THEN NUEVO_VERANO"
	sql = sql & "		ELSE REPOSICION_VERANO"
	sql = sql & "		END"
	sql = sql & "	ELSE CASE WHEN B.EMPLEADO_NUEVO='SI'"
	sql = sql & "		THEN NUEVO_INVIERNO"
	sql = sql & "		ELSE REPOSICION_INVIERNO"
	sql = sql & "		END"
	sql = sql & "	END as CANTIDAD_LIMITE"
	'sql = sql & "--***************************************"
	'sql = sql & "-- FIN CANTIDAD LIMITE DE CADA TIPO DE ROPA"
	'sql = sql & "--***************************************"
	sql = sql & ", A.PERIODO_VENTA"
	sql = sql & ", GETDATE() FECHA_ACTUAL"
	
	sql = sql & " FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES A"
	sql = sql & " LEFT JOIN EMPLEADOS_GLS_PERIODOS_VENTA_AUX B"
	sql = sql & " ON A.PERIODO_VENTA=B.PERIODO_VENTA"
	sql = sql & " LEFT JOIN GRUPOS_ROPA_EMPLEADOS_GLS C"
	sql = sql & " ON A.GRUPO_ROPA=C.ID"
	
	sql = sql & " WHERE A.GRUPO_EMPLEADO = " & empleados("GRUPO_ROPA")
	sql = sql & " AND (B.MES=" & mes_fijo & ")"
	IF empleados("NUEVO") then
		sql = sql & " AND (B.EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & " AND (B.EMPLEADO_NUEVO='NO')"
	end if
	sql = sql & ")  TABLA"
	
	sql = sql & " WHERE TABLA.CANTIDAD_LIMITE IS NOT NULL"
	sql = sql & ") GRUPOS"
	
	'sql = sql & "--***************************************"
	'sql = sql & "---LA PARTE AÑADIDA PARA CRUZAR CON LAS DEVOLUCIONES A RESTAR"
	'sql = sql & "--***************************************"
	 
	sql = sql & " LEFT JOIN"
	
	sql = sql & " (SELECT D.ID, D.DESCRIPCION, D.ABREVIATURA, SUM(UNIDADES_ACEPTADAS) AS UNIDADES_RESTAR"
	sql = sql & " FROM DEVOLUCIONES A"
	sql = sql & " INNER JOIN DEVOLUCIONES_DETALLES B"
	sql = sql & " ON A.ID=B.ID_DEVOLUCION"
	sql = sql & " INNER JOIN GRUPOS_ROPA_ARTICULOS_EMPLEADOS_GLS C"
	sql = sql & " ON B.ID_ARTICULO=C.ID_ARTICULO AND C.GRUPO=" & empleados("GRUPO_ROPA")
	'tenemos los pantalones de invierno en 2 grupos, uno en verano y otro en invierno
	'sql = sql & " AND (PERIODO='TODO' OR PERIODO=E.PERIODO_VENTA)"
	
	sql = sql & " INNER JOIN GRUPOS_ROPA_EMPLEADOS_GLS D"
	sql = sql & " ON C.ID_GRUPO_ROPA=D.ID"
	sql = sql & " INNER JOIN"
	
	sql = sql & " (SELECT GRUPO_ROPA,PERIODICIDAD, PERIODO_VENTA FROM GRUPOS_EMPLEADOS_GRUPOS_ROPA_LIMITES"
	sql = sql & " WHERE GRUPO_EMPLEADO=" & empleados("GRUPO_ROPA")
	sql = sql & ") E"
	sql = sql & " ON E.GRUPO_ROPA=D.ID"
	
	sql = sql & " WHERE A.USUARIO_DIRECTORIO_ACTIVO = " & empleados("ID")
	sql = sql & " AND A.ESTADO='CERRADA'"
	sql = sql & " AND E.PERIODO_VENTA = (SELECT PERIODO_VENTA"
	sql = sql & "  FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "  WHERE MES=" & mes_fijo
	IF empleados("NUEVO") then
		sql = sql & " AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & " AND EMPLEADO_NUEVO='NO')"
	end if
	
	sql = sql & " AND CONVERT(VARCHAR(8), FECHA_ACEPTACION, 112) >="
	sql = sql & " 		CONVERT(VARCHAR(8),"
	sql = sql & "			(SELECT TOP 1"
	sql = sql & "					CASE WHEN E.PERIODICIDAD=24 "
	sql = sql & "						THEN CASE WHEN E.PERIODO_VENTA='VERANO'"
	sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST( (SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "													WHERE E.PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
		sql = sql & "												AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & "												AND EMPLEADO_NUEVO='NO')"
	end if
	sql = sql & "													 AS varchar)"
	sql = sql & "													+ '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	
	sql = sql & "						WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "									(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "									WHERE E.PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "									) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "						WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "							THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "									(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "									WHERE E.PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "									) AS varchar) +  '-' + cast((" & anno_fijo & " - 2) AS varchar), 103)"
	sql = sql & "	 			END"
	
	sql = sql & "				WHEN E.PERIODICIDAD=12"
	sql = sql & "					THEN CASE WHEN E.PERIODO_VENTA='VERANO'"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST( (SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "													WHERE PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
		sql = sql & "												AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & "												AND EMPLEADO_NUEVO='NO')"
	end if
	sql = sql & "													 AS varchar)"
	sql = sql & "													+ '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	
	sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "								(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "										WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "								) AS varchar) +  '-' + cast((" & anno_fijo & ") AS varchar), 103)"
	sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST("
	sql = sql & "								(SELECT TOP 1 MES FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "										WHERE PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
							sql = sql & " AND EMPLEADO_NUEVO='SI' AND MES>7"
					else
							sql = sql & " AND EMPLEADO_NUEVO='NO' AND MES>7"
	end if
	sql = sql & "								) AS varchar) +  '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 			END"
	
	
	sql = sql & "	 			WHEN E.PERIODICIDAD=6 THEN"
	sql = sql & "					CASE WHEN E.PERIODO_VENTA='VERANO'"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & ">7"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast(" & anno_fijo & " AS varchar), 103)"
	sql = sql & "					WHEN E.PERIODO_VENTA='INVIERNO' AND " & mes_fijo & "<7"
	sql = sql & "						THEN CONVERT(DATETIME, '1' + '-' + CAST(MES AS varchar) + '-' + cast((" & anno_fijo & " - 1) AS varchar), 103)"
	sql = sql & "	 			END"
	
	
	
	sql = sql & "				WHEN E.PERIODICIDAD=0 THEN CONVERT(DATETIME, '01-01-2000', 103) END AS FECHA_LIMITE"

	
	 
	sql = sql & "			FROM EMPLEADOS_GLS_PERIODOS_VENTA_AUX"
	sql = sql & "			WHERE"
	sql = sql & "				((PERIODO_VENTA='VERANO'"
	IF empleados("NUEVO") then
		sql = sql & "				AND EMPLEADO_NUEVO='SI')"
	  else
		sql = sql & "				AND EMPLEADO_NUEVO='NO')"
	end if
	
	sql = sql & "				OR (PERIODO_VENTA='INVIERNO'"
	IF empleados("NUEVO") then
		sql = sql & "				AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & "				AND EMPLEADO_NUEVO='NO'"
	end if
	sql = sql & "					AND MES>7))"
	
	sql = sql & "				AND PERIODO_VENTA=E.PERIODO_VENTA"
	IF empleados("NUEVO") then
		sql = sql & "				AND EMPLEADO_NUEVO='SI'"
	  else
		sql = sql & "				AND EMPLEADO_NUEVO='NO'"
	end if
	
	sql = sql & "			ORDER BY MES), 112)"
	
	sql = sql & "	GROUP BY D.ID, D.DESCRIPCION, D.ABREVIATURA"
	sql = sql & ") DEVOLUCIONES"
	
	sql = sql & " ON GRUPOS.ID=DEVOLUCIONES.ID"
	
	sql = sql & " WHERE FECHA_DESDE IS NULL"
	sql = sql & " OR FECHA_DESDE=''"
	sql = sql & " OR (CONVERT(VARCHAR(8), FECHA_DESDE, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'" & empleados("FECHA_ALTA") & "', 103) , 112))" 'pone las 2 fechas en formato yyyymmdd (112--yyyymmdd y 103--dd/mm/yyyy) 
	
	
	if ver_cadena="SI" then
		response.write("<br>....GESTION ROPA: " & sql)
	end if
	
	connimprenta.Execute "set dateformat dmy",,adCmdText + adExecuteNoRecords
	
	with gestion_ropa
		.ActiveConnection=connimprenta
		.Source=sql
		.Open
	end with
	%>






			  
			<!--capa para el recuento de ropa de temporada disponible para el empleado-->
			<%			
			if not gestion_ropa.eof then
				%>
				
								<%while not gestion_ropa.eof%>
									<%
										abreviatura_grupo_ropa = "" & gestion_ropa("ABREVIATURA")
										descripcion_grupo_ropa = "" & gestion_ropa("DESCRIPCION")
										
										if gestion_ropa("ID") = 3 and empleados("GRUPO_ROPA")=3 then 'camisetas del grupo 3
											abreviatura_grupo_ropa = "CAMISETAS Y POLOS"
											descripcion_grupo_ropa = "CAMISETAS Y POLOS"
										end if
										if gestion_ropa("ID") = 9 and empleados("GRUPO_ROPA")=5 then 'PANTALONES DE VERANO DEL GRUPO 5
											abreviatura_grupo_ropa = "PANT. VER. / BER"
											descripcion_grupo_ropa = "PANTALONES DE VERANO Y BERMUDAS"
										end if
									%>
									<%if cint(gestion_ropa("CANTIDAD_LIMITE"))<cint(gestion_ropa("CANTIDAD_YA_PEDIDA")) then%>
										<tr bgcolor="#99CC99">
									<%else%>
										<tr>
									<%end if%>
										<td><%=empleados("ID")%></td>
										<td><%=empleados("NOMBRE")%>&nbsp;<%=empleados("APELLIDOS")%></td>
										<td><%=empleados("CENTRO_COSTE")%></td>
										<td><%=empleados("NOMBRE_CENTRO_COSTE")%></td>
										<td><%=empleados("GRUPO_ROPA")%></td>
										<td><%=empleados("NUEVO")%></td>
										<td><%=empleados("BORRADO")%></td>
										<td><%=GESTION_ROPA("PERIODO_VENTA")%></td>
										<td
											<%if abreviatura_grupo_ropa <> descripcion_grupo_ropa then%>
													data-toggle='popover_grupo_ropa'
													data-placement='top'
													data-trigger='hover'
													data-content='<%=descripcion_grupo_ropa%>'
													data-original-title=''
													style="cursor:pointer"
											<%end if%>
											><%=abreviatura_grupo_ropa%></td>
										<td><%=gestion_ropa("PERIODICIDAD")%></td>
										<td><%=gestion_ropa("FECHA_LIMITE_PERIODICIDAD")%></td>
										<td><%=gestion_ropa("CANTIDAD_LIMITE")%></td>
										<td><%=gestion_ropa("CANTIDAD_YA_PEDIDA")%></td>
										<td><%=gestion_ropa("PEDIDOS")%></td>
										<td><%=gestion_ropa("DEVOLUCIONES")%></td>
										<%if cint(gestion_ropa("CANTIDAD_LIMITE"))<cint(gestion_ropa("CANTIDAD_YA_PEDIDA")) then%>
											<td>MAL</td>
										<%else
												if cint(gestion_ropa("CANTIDAD_LIMITE"))=cint(gestion_ropa("CANTIDAD_YA_PEDIDA")) then%>
													<td>COMPLETADO</td>
												<%else%>
													<td>BIEN</td>
												<%end if
										end if%>
									</tr>
									<%
									gestion_ropa.movenext
								wend
								%>
								
				
			<!--capa para el recuento de ropa de temporada disponible para el empleado-->
			  
			  
			  
			  
					
				<%
				end if
				gestion_ropa.close
				set gestion_ropa=Nothing
				%>


	<%empleados.movenext
	wend%>



					</tbody>
				</table>
</div>
<!--FINAL CONTAINER-->

				
</body>
<%
	
	empleados.close
	connimprenta.close
			  
			
	set empleados=Nothing
	set connimprenta=Nothing
%>
</html>

