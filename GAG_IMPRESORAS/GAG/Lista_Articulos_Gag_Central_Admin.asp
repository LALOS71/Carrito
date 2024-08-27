<%@ language=vbscript %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../Conexion.inc"-->
<%
		Response.Buffer = TRUE
		if session("usuario")="" then
			Response.Redirect("../Login_" & session("usuario_carpeta") & ".asp")
		end if
		
		'recordsets
		dim articulos
		
		ver_cadena="" & Request.QueryString("p_vercadena")
		if ver_cadena="" then
			ver_cadena=Request.Form("ocultover_cadena")
		end if
		
		'aqui viene la accion junto con el pedido y la fecha "MODIFICAR--88--fecha--codigo cliente--codigo externo cliente--nombre cliente"
		acciones=Request.QueryString("acciones")
		
		codigo_sap_buscado=Request.Form("txtcodigo_sap")
		articulo_buscado=Request.form("txtdescripcion")
		familia_buscada="" & Request.form("cmbfamilias")
		familias_buscadas_otra="" & Request.Form("cmbfamilias_agrupadas_otra")
		campo_autorizacion=Request.form("cmbautorizacion")
		agrupacion_familias="" & Request.form("ocultoagrupacion_familias")
		
		if ver_cadena="SI" then
			response.write("<br><br>familia buscada: " & familia_buscada)
			response.write("<br><br>familias buscadas otra: " & familias_buscadas_otra)
		end if
		
		realizar_consulta="SI"
		'como se muestra el listado cuando se entra por primera vez
		if familia_buscada="" and familias_buscadas_otra="" and articulo_buscado="" and codigo_sap_buscado="" and campo_autorizacion="" then
			'quitamos todos porque tarda mucho en mostrarse la pagina sin ningun filtro
			familia_buscada="TODOS"
			realizar_consulta="NO"
			'if session("usuario_codigo_empresa")=4 and session("usuario")=7054 then
			if session("usuario_codigo_empresa")=4 then
				familia_buscada=3 'operaciones ASM para el perfil de ASM
				realizar_consulta="SI"
			end if
		end if
		
		familia_combo=familia_buscada
		if familia_buscada="11111111" then
			familia_combo="TODOS"
		end if
		
		
		
		set familias=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_FAMILIA=0
		CAMPO_EMPRESA_FAMILIA=1
		CAMPO_DESCRIPCION_FAMILIA=2
		with familias
			.ActiveConnection=connimprenta
			.Source="SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,"
			.Source= .Source & " CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL THEN FAMILIAS.DESCRIPCION ELSE" 
			.Source= .Source & " FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION_IDIOMA"
			
			.Source= .Source & " FROM FAMILIAS"
			.Source= .Source & " LEFT JOIN FAMILIAS_IDIOMAS"
			.Source= .Source & " ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA='" & UCASE(SESSION("idioma")) &"')"
			
			'hay familias en asm portugal que no tiene que ver
			if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
				.Source= .Source & " LEFT JOIN FAMILIAS_AGRUPADAS"
				.Source= .Source & " ON FAMILIAS.ID=FAMILIAS_AGRUPADAS.ID_FAMILIA"
			end if


			.Source=.Source & " WHERE FAMILIAS.CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
			
			'las familias en asm portugal que no tiene que ver son las de estas agrupaciones
			if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
				.Source= .Source & " AND (GRUPO_FAMILIAS NOT IN ('MARKETING', 'OFICINA', 'ROTULACION', 'VESTUARIO'))"
			end if

			
			.Source= .Source & " ORDER BY DESCRIPCION_IDIOMA"
			'response.write("<br>...FAMILIAS: " & .source)
			.Open
			vacio_familias=false
			if not .BOF then
				tabla_familias=.GetRows()
			  else
				vacio_familias=true
			end if
		end with

		familias.close
		set familias=Nothing
		
		
		set agrupacion_familias_otra=Server.CreateObject("ADODB.Recordset")
		'CAMPO_ID_AGRUPACION_FAMILIA=0
		'CAMPO_EMPRESA_AGRUPACION_FAMILIA=1
		'CAMPO_DESCRIPCION_AGRUPACION_FAMILIA=2
		'CAMPO_ID_FAMILIA_AGRUPACION_FAMILIA=3
		CAMPO_GRUPO_FAMILIAS_OTRA=0
		CAMPO_ID_FAMILIAS_OTRA=1
		CAMPO_DESCRIPCION_FAMILIA_OTRA=2
		
		
		with agrupacion_familias_otra
			.ActiveConnection=connimprenta
			if agrupacion_familias = "POR_FAMILIA" then
				.Source="SELECT C.GRUPO_FAMILIAS AS AGRUPACION, C.ID_FAMILIA, A.DESCRIPCION + ' - ' + B.EMPRESA AS DESCRIPCION"
				.Source= .Source & " FROM FAMILIAS A"
				.Source= .Source & " LEFT JOIN V_EMPRESAS B"
				.Source= .Source & " ON A.CODIGO_EMPRESA=B.ID"
				.Source= .Source & " LEFT JOIN FAMILIAS_AGRUPADAS C"
				.Source= .Source & " ON A.ID=C.ID_FAMILIA"
				.Source= .Source & " WHERE A.BORRADO='NO'"
				.Source= .Source & " AND A.CODIGO_EMPRESA IN (10, 20, 80, 90, 130, 170, 210, 230, 240, 250)"
				.Source= .Source & " ORDER BY C.GRUPO_FAMILIAS, A.DESCRIPCION"
			  else
				.Source="SELECT B.EMPRESA, C.ID_FAMILIA, C.GRUPO_FAMILIAS + ' - ' + A.DESCRIPCION AS DESCRIPCION"
				.Source = .Source & " FROM FAMILIAS A"
				.Source = .Source & " LEFT JOIN V_EMPRESAS B"
				.Source = .Source & " ON A.CODIGO_EMPRESA=B.ID"
				.Source = .Source & " LEFT JOIN FAMILIAS_AGRUPADAS C"
				.Source = .Source & " ON A.ID=C.ID_FAMILIA"
				.Source = .Source & " WHERE A.BORRADO='NO'"
				.Source = .Source & " AND A.CODIGO_EMPRESA IN (10, 20, 80, 90, 130, 170, 210, 230, 240, 250)"
				.Source = .Source & " ORDER BY B.EMPRESA, C.GRUPO_FAMILIAS, A.DESCRIPCION"
			end if

			if ver_cadena="SI" then
				response.write("<br><br>AGRUPACION FAMILIAS OTRA: " & .source)
			end if
			
			.Open
			vacio_agrupacion_familias_otra=false
			if not .BOF then
				tabla_agrupacion_familias_otra=.GetRows()
			  else
				vacio_agrupacion_familias_otra=true
			end if
		end with

		agrupacion_familias_otra.close
		set agrupacion_familias_otra=Nothing



		set tipos_precios=Server.CreateObject("ADODB.Recordset")
		with tipos_precios
			.ActiveConnection=connimprenta
			.Source="SELECT A.TIPO_PRECIO, A.ID_EMPRESA, B.EMPRESA"
			.Source=.Source & " FROM V_EMPRESAS_TIPOS_PRECIOS A INNER JOIN V_EMPRESAS B ON A.ID_EMPRESA=B.ID"
			if session("usuario_codigo_empresa")<>230 then
				.Source=.Source & " WHERE A.ID_EMPRESA=" & session("usuario_codigo_empresa")
			  else
				.Source=.Source & " WHERE A.ID_EMPRESA IN (10, 20, 80, 90, 130, 170, 210, 230, 240, 250)"
			end if
			.Source=.Source & " ORDER BY B.EMPRESA, A.TIPO_PRECIO"
			
			.Open
			vacio_tipos_precios=false
			if not .BOF then
				tabla_tipos_precios=.GetRows()
			  else
				vacio_tipos_precios=true
			end if
		end with	
		tipos_precios.close
		set tipos_precios=Nothing
		
		ARTICULOS_CAMPO_ID=0
		ARTICULOS_CAMPO_DESCRIPCION=1
		ARTICULOS_CAMPO_CODIGO_SAP=2
		ARTICULOS_CAMPO_REQUIERE_AUTORIZACION=3
		ARTICULOS_CAMPO_UNIDADES_DE_PEDIDO=4
		ARTICULOS_CAMPO_PACKING=5
		ARTICULOS_CAMPO_COMPROMISO_COMPRA=6
		ARTICULOS_CAMPO_EN_AVORIS_SOLO_VER=7
		ARTICULOS_CAMPO_STOCK=8
		ARTICULOS_CAMPO_NOMBRE_FAMILIA=9
		ARTICULOS_CAMPO_PLANTILLA_PERSONALIZACION=10
		ARTICULOS_CAMPO_PERMITE_DEVOLUCION=11
		set articulos=Server.CreateObject("ADODB.Recordset")
		if realizar_consulta="NO" then
				sql="SELECT ID FROM V_EMPRESAS WHERE 1=0" 'PARA QUE NO DEVUELVA NADA SI NO SE INTRODUCEN FILTROS DE BUSQUEDA
		  else
		  	if session("usuario_codigo_empresa")<>230 then
				sql="Select ARTICULOS.ID, ARTICULOS.DESCRIPCION, ARTICULOS.CODIGO_SAP, ARTICULOS.REQUIERE_AUTORIZACION, ARTICULOS.UNIDADES_DE_PEDIDO, ARTICULOS.PACKING"
				sql=sql & ", ARTICULOS.COMPROMISO_COMPRA, ARTICULOS.EN_AVORIS_SOLO_VER, ARTICULOS_MARCAS.STOCK, FAMILIAS.DESCRIPCION AS NOMBRE_FAMILIA"
				sql=sql & ", (ARTICULOS_PERSONALIZADOS.PLANTILLA_PERSONALIZACION) AS PLANTILLA_PERSONALIZACION"
				sql=sql & ", ARTICULOS.PERMITE_DEVOLUCION"			
				sql=sql & " FROM ARTICULOS INNER JOIN ARTICULOS_EMPRESAS ON ARTICULOS.ID = ARTICULOS_EMPRESAS.ID_ARTICULO "
				sql=sql & " INNER JOIN ARTICULOS_MARCAS ON ARTICULOS.ID=ARTICULOS_MARCAS.ID_ARTICULO"
				'sql=sql & " INNER JOIN FAMILIAS ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "
				
				sql=sql & " INNER JOIN" 
					sql=sql & " (SELECT FAMILIAS.ID, FAMILIAS.CODIGO_EMPRESA,"
					sql=sql & "        CASE WHEN FAMILIAS_IDIOMAS.DESCRIPCION IS NULL" 
					sql=sql & "           THEN FAMILIAS.DESCRIPCION ELSE FAMILIAS_IDIOMAS.DESCRIPCION END AS DESCRIPCION"
					sql=sql & "        FROM FAMILIAS LEFT JOIN FAMILIAS_IDIOMAS"
					sql=sql & "        ON (FAMILIAS.ID=FAMILIAS_IDIOMAS.ID_FAMILIA AND FAMILIAS_IDIOMAS.IDIOMA = '" & UCASE(SESSION("idioma")) &"')) AS FAMILIAS"
					
				sql=sql & " ON ARTICULOS_EMPRESAS.FAMILIA = FAMILIAS.ID "		
				sql=sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS ON ARTICULOS.ID=ARTICULOS_PERSONALIZADOS.ID_ARTICULO"
		
				'hay ARTICULOS de familias en asm portugal que no tiene que ver
					if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
						sql=sql & " LEFT JOIN FAMILIAS_AGRUPADAS"
						sql=sql & " ON FAMILIAS.ID=FAMILIAS_AGRUPADAS.ID_FAMILIA"
					end if
				
				sql=sql & " where MOSTRAR='SI'"
				
				'las familias en asm portugal que no tiene que ver son las de estas agrupaciones
					if session("usuario_codigo_empresa")=4 and session("usuario")=7637 then
						sql=sql & " AND (GRUPO_FAMILIAS NOT IN ('MARKETING', 'OFICINA', 'ROTULACION', 'VESTUARIO'))"
					end if
					
				if familia_buscada<>"TODOS" and familia_buscada<>"" then
					sql=sql & " and ARTICULOS_EMPRESAS.familia=" & familia_buscada
				end if
				if codigo_sap_buscado<>"" then
					sql=sql & " and articulos.codigo_sap like '%" & codigo_sap_buscado & "%'"
				end if
				if articulo_buscado<>"" then
					'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
					'sql=sql & " and (articulos.descripcion like '%" & articulo_buscado & "%'"
					sql=sql & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(ARTICULOS.DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
					sql=sql & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'"
	
						
						'BUSCAMOS LA DESCRIPCION DEL ARTICULO O EN LOS DATOS ASOCIADOS COMO COMPONENTE
						'	-impresora asociada
						'	-color del cartucho
						'	-referencia
						'sql=sql & " OR ARTICULOS.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
						'sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA') AND (DESCRIPCION LIKE '%" & articulo_buscado & "%'))"
						sql=sql & " OR ARTICULOS.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
						sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA')" 
						sql=sql & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
						sql=sql & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'))"
						
					sql=sql & ")"
				end if
				if campo_autorizacion="SI" then
					sql=sql & " AND ARTICULOS.REQUIERE_AUTORIZACION='SI'"
				end if
				if campo_autorizacion="NO" then
					sql=sql & " AND ARTICULOS.REQUIERE_AUTORIZACION<>'SI'"
				end if
					
				sql=sql & " and ARTICULOS_EMPRESAS.codigo_empresa = " & session("usuario_codigo_empresa") 
				sql=sql & " and (articulos.id in (select codigo_articulo from cantidades_precios where cantidades_precios.codigo_empresa=" & session("usuario_codigo_empresa") & ")) "
				'sql=sql & " and Descripcion <> ''"
				'sql=sql & " and Mostrar_Intranet='SI'"
				'sql=sql & " and Activo = 1"
				'sql=sql & " order by Orden"
				sql=sql & " order by compromiso_compra desc, Descripcion"
				'response.write("<br>...ARTICULOS:" & sql)

			  else 'avoris tiene otra consulta de articulos
			  
			  	sql = "SELECT A.ID, A.DESCRIPCION, A.CODIGO_SAP, A.REQUIERE_AUTORIZACION, A.UNIDADES_DE_PEDIDO, A.PACKING, A.COMPROMISO_COMPRA, A.EN_AVORIS_SOLO_VER"
				sql = sql & ", C.STOCK"
				sql = sql & ", (SELECT TOP(1) FAMILIAS.DESCRIPCION FROM ARTICULOS_EMPRESAS"
				sql = sql & " INNER JOIN FAMILIAS ON ARTICULOS_EMPRESAS.FAMILIA=FAMILIAS.ID AND ARTICULOS_EMPRESAS.ID_ARTICULO=A.ID"
				sql = sql & " WHERE ARTICULOS_EMPRESAS.CODIGO_EMPRESA IN (10, 20, 80, 90, 130, 170, 210, 230, 240, 250)) AS NOMBRE_FAMILIA"
				sql = sql & ", D.PLANTILLA_PERSONALIZACION, A.PERMITE_DEVOLUCION"
				sql = sql & " FROM ARTICULOS A INNER JOIN"
				sql = sql & " (SELECT T1.ID_ARTICULO"
				sql = sql & "     , '--' + STUFF((SELECT '--' + CONVERT(nvarchar(4), CODIGO_EMPRESA)"
				sql = sql & "                FROM ARTICULOS_EMPRESAS T2"
				sql = sql & "                WHERE T2.ID_ARTICULO=T1.ID_ARTICULO"
				sql = sql & "                FOR XML PATH('')),1,1,'') + '--' AS LISTA_EMPRESAS"
				sql = sql & "     , '--' + STUFF((SELECT '--' + CONVERT(nvarchar(4), FAMILIA)"
				sql = sql & "                FROM ARTICULOS_EMPRESAS T2"
				sql = sql & "                WHERE T2.ID_ARTICULO=T1.ID_ARTICULO"
				sql = sql & "                FOR XML PATH('')),1,1,'') + '--' AS LISTA_FAMILIAS"
				sql = sql & "     FROM ARTICULOS_EMPRESAS T1"
				sql = sql & "     WHERE CODIGO_EMPRESA IN (10, 20, 80, 90, 130, 170, 210, 230, 240, 250)"
				sql = sql & "     GROUP BY ID_ARTICULO) B"
				sql = sql & " ON A.ID=B.ID_ARTICULO"
				sql = sql & " LEFT JOIN ARTICULOS_MARCAS C ON A.ID=C.ID_ARTICULO"
				sql = sql & " LEFT JOIN ARTICULOS_PERSONALIZADOS D ON A.ID= D.ID_ARTICULO"
				
				sql = sql & " WHERE A.MOSTRAR='SI'"

				
				if codigo_sap_buscado<>"" then
					sql=sql & " AND A.CODIGO_SAP LIKE '%" & codigo_sap_buscado & "%'"
				end if
				if articulo_buscado<>"" then
					'sql=sql & " and descripcion like ""*" & articulo_buscado & "*"""
					'sql=sql & " AND (A.DESCRIPCION LIKE '%" & articulo_buscado & "%'"
					sql=sql & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(A.DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
					sql=sql & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'"
	
						'BUSCAMOS LA DESCRIPCION DEL ARTICULO O EN LOS DATOS ASOCIADOS COMO COMPONENTE
						'	-impresora asociada
						'	-color del cartucho
						'	-referencia
						'sql=sql & " OR A.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
						'sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA') AND (DESCRIPCION LIKE '%" & articulo_buscado & "%'))"
						
						sql=sql & " OR A.ID IN (SELECT ID_ARTICULO FROM DESCRIPCIONES_MULTIARTICULOS"
						sql=sql & " WHERE (CARACTERISTICA = 'IMPRESORA' OR CARACTERISTICA = 'COLOR' OR CARACTERISTICA = 'REFERENCIA')" 
						sql=sql & " AND (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(DESCRIPCION),'Á','A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U')"
						sql=sql & " LIKE '%" & REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UCASE(articulo_buscado),"Á","A"), "É", "E"), "Í", "I"), "Ó", "O"), "Ú", "U") & "%'))"
						
					sql=sql & ")"
				end if
				if familias_buscadas_otra<>"" then
					'sql = sql & " AND LISTA_FAMILIAS LIKE '%--173--%'
					sql = sql & " AND (" 
					elementos_familias=split(familias_buscadas_otra, ", ")
					primero="SI"
					for each x in elementos_familias
						if primero="SI" then
							sql = sql & "B.LISTA_FAMILIAS LIKE '%--" & x & "--%'"
							primero="NO"
						  else
						  	sql = sql & " OR B.LISTA_FAMILIAS LIKE '%--" & x & "--%'"
						end if
					next
					sql = sql & ")" 
				end if
				sql=sql & " ORDER BY A.COMPROMISO_COMPRA DESC, DESCRIPCION"

			end if 'empresa <> 230 - avoris
		end if 'realizar consulta
		
		if ver_cadena="SI" then
			response.write("<br>...Consulta articulos: " & sql)
		end if		
		with articulos
			.ActiveConnection=connimprenta
			
			.Source=sql
			
			.Open
			
			vacio_articulos=false
			if not .BOF then
				tabla_articulos=.GetRows()
			  else
				vacio_articulos=true
			end if
		end with
		
		articulos.close		
		set articulos=Nothing
		
		dim hoteles

		
		'if familia_buscada="0" then
		'	familia_buscada="TODOS"
		'end if
		
		set carrusel=Server.CreateObject("ADODB.Recordset")
		CAMPO_ID_CARRUSEL=0
		CAMPO_ORDEN_CARRUSEL=1
		CAMPO_EMPRESAS_CARRUSEL=2
		CAMPO_FICHERO_CARRUSEL=3
		with carrusel
			.ActiveConnection=connimprenta
			.Source="SELECT ID_CARRUSEL, ORDEN, EMPRESAS, FICHERO"
			.Source= .Source & " FROM CARRUSEL"
			.Source= .Source & " WHERE EMPRESAS LIKE '%###" & session("usuario_codigo_empresa") & "###%'"
			.Source= .Source & " ORDER BY ORDEN, ID_CARRUSEL"
			'response.write("<br>FAMILIAS: " & .source)
			.Open
			vacio_carrusel=false
			if not .BOF then
				tabla_carrusel=.GetRows()
			  else
				vacio_carrusel=true
			end if
		end with

		carrusel.close
		set carrusel=Nothing
		

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<title>Carrito Imprenta</title>

<%'aplicamos un tipio de letra diferente para ASM-GLS
	if session("usuario_codigo_empresa")=4 then%>
		<link rel="stylesheet" type="text/css" href="../estilo_gls.css" />
	<%end if%>
	
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.6/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-selectpicker-1.13.14/dist/css/bootstrap-select.css">
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
  
#capa_opaca {
	position:absolute;
	color: black;
	background-color: #C0C0C0;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 1000;
	text-align: center;
	visibility: visible;
	filter:alpha(opacity=40);
	-moz-opacity:.40;
	opacity:.40;
}

.aviso {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  	font-size: 18px;
  	color: #000000;
  	text-align: center;
	background-color:#33FF33
}  	

#contenedorr3 { 


/* Otros estilos */ 
border:1px solid #333;
background:#eee;
padding:15px;
width:500px;

margin: 250px auto;

-moz-border-radius: 20px; /* Firefox */
-webkit-border-radius: 20px; /* Google Chrome y Safari */
border-radius: 20px; /* CSS3 (Opera 10.5, IE 9 y estándar a ser soportado por todos los futuros navegadores) */
/*
behavior:url(border-radius.htc);/* IE 8.*/

}

	.image_thumb{
			position:relative;
			overflow:hidden;
			padding-bottom:100%;
		}
		.image_thumb img{
			  position: absolute;
			  max-width: 100%;
			  max-height: 100%;
			  top: 50%;
			  left: 50%;
			  transform: translateX(-50%) translateY(-50%);
		}



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
	
.inf_general_art, .inf_pack_stock
	{
	-webkit-box-shadow: none;
    box-shadow: none;
	}
	


.table-borderless td,
.table-borderless th {
    border: 0px !important;
}


/*para el combo multiselect de familias y subfamilias*/ 
.dropdown-header {
  font-weight: bold !important;
  /*color: #fff !important;*/
  color: #000 !important;
  text-transform: uppercase;
}
.special {
  color: #000 !important;
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

<script type="text/javascript" src="../js/jquery.min_1_11_0.js"></script>
<script type="text/javascript" src="../js/jquery-ui.min_1_10_4.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/js/bootstrap-select-new.js"></script>
<script type="text/javascript" src="../plugins/bootstrap-selectpicker-1.13.14/dist/js/i18n/defaults-es_CL.js"></script>


<script language="javascript">

function cambiar_agrupacion(){
	//alert('refrescar: ' + orden)
	if ($("#ocultoagrupacion_familias").val() == 'POR_EMPRESA')
		{
		ordenacion='POR_FAMILIA'
		$("#ocultoagrupacion_familias").val("POR_FAMILIA")
		$("#icono_reagrupar").removeClass("glyphicon-sort-by-attributes");
		$("#icono_reagrupar").addClass("glyphicon-sort-by-attributes-alt");
		$("#cmdcambiar_agrupacion").attr('data-content' , 'Reagrupar por Empresas')
		$("#cmdcambiar_agrupacion").popover("show");
		}
	  else
		if ($("#ocultoagrupacion_familias").val() == 'POR_FAMILIA')
			{
			ordenacion='POR_EMPRESA'
			$("#ocultoagrupacion_familias").val("POR_EMPRESA")
			$("#icono_reagrupar").removeClass("glyphicon-sort-by-attributes-alt");
			$("#icono_reagrupar").addClass("glyphicon-sort-by-attributes");
			$("#cmdcambiar_agrupacion").attr('data-content' , 'Reagrupar Por Familias')
			//$("#cmdcambiar_agrupacion").popover("show");
			}
		  else
		  	{
			ordenacion='POR_FAMILIA'
			$("#ocultoagrupacion_familias").val("POR_FAMILIA")
			$("#icono_reagrupar").removeClass("glyphicon-sort-by-attributes");
			$("#icono_reagrupar").addClass("glyphicon-sort-by-attributes-alt");
			$("#cmdcambiar_agrupacion").attr('data-content' , 'Reagrupar Por Empresas')
			//$("#cmdcambiar_agrupacion").popover("show");
			}

	$.ajax({
				type: 'POST',
				url: '../tojson/Obtener_Familias_Agrupadas.asp',
				data: {
					agrupacion: $("#ocultoagrupacion_familias").val()
				},
				dataType: 'json',
				success:
					function (data) {
						$('#cmbfamilias_agrupadas_otra').empty()
						grupo_ant=''
						cadena_opt=''
						$.each( data.data, function( i, item ) {
        					//console.log('agrupacion: ' + item.AGRUPACION)
							//console.log('ID FAMILIA: ' + item.ID_FAMILIA)
							//console.log('DESCRIPCION: ' + item.DESCRIPCION)
							//console.log('---------')
							//cadena_opt=''
							grupo_nuevo=item.AGRUPACION
							if (grupo_ant != grupo_nuevo)
								{
								if (grupo_ant !='')
									{
									cadena_opt= cadena_opt + '</optgroup>'
									//$('#cmbfamilias_agrupadas_otra').append('</optgroup>')
									}
								cadena_opt= cadena_opt + '<optgroup label="' + item.AGRUPACION + '">'	
								//$('#cmbfamilias_agrupadas_otra').append('<optgroup label="' + item.AGRUPACION + '">')
								}

							cadena_opt=cadena_opt + '<option class="special" value="' + item.ID_FAMILIA + '">' + item.DESCRIPCION + '</option>'
							//$('#cmbfamilias_agrupadas_otra').append(cadena_opt)

							if (grupo_ant != grupo_nuevo)
								{
								grupo_ant=grupo_nuevo
								}		
							//console.log('cadena: ' + cadena_opt)					
						})
						cadena_opt=cadena_opt + '</optgroup>'
						//console.log('cadena_opt: ' + cadena_opt)
						$('#cmbfamilias_agrupadas_otra').append(cadena_opt)
						//$(".selectpicker").selectpicker();
						//$(".selectpicker").selectpicker("render");
						$(".selectpicker").selectpicker("refresh");
						
						
						$(".dropdown-header").each(function (index, header) {
							var header = $(header);
							header.css('cursor', 'pointer');
							header.click(function () {
								var dataoptgroup = $(this).attr("data-optgroup");
								var group_lis = $('li[data-optgroup=' + dataoptgroup + ']').filter('li[data-original-index]');
					
								todas_seleccionadas="SI"
								group_lis.each(function (index, option) {
									if  (!$(option).hasClass('selected'))
										{
										todas_seleccionadas="NO"
										}
								});
								//console.log('todas seleccionadas: ' + todas_seleccionadas)
								if (todas_seleccionadas=='NO')
									{
										group_lis.each(function (index, option) {
											if  (!$(option).hasClass('selected'))
												{
												$(option).find("a").click()
												}
										});
									}
								  else
									{
										group_lis.each(function (index, option) {
											$(option).find("a").click()
										});
									}
								
							});
							
						});
						
						//$("#cmbfamilias_agrupadas_otra").selectpicker('val', [<%=familias_buscadas_otra%>]);

					},
				error:
					function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
			});
	
	
	
}
</script>

</head>
<body style="margin-top:0; background-color:<%=session("color_asociado_empresa")%>">

<!--capa mensajes -->
  <div class="modal fade" id="pantalla_avisos" data-keyboard="false" data-backdrop="static">	
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




<script language="javascript">
	cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4>Espere mientras se carga la página...</h4><br></div>'
	$("#cabecera_pantalla_avisos").html("Avisos")
	$("#pantalla_avisos .modal-header").show()
	$("#body_avisos").html(cadena + "<br><br>");
	$("#pantalla_avisos").modal("show");
</script>





<div class="container-fluid">
   <!--PANTALLA-->
  <div class="row">
    <!--COLUMNA IZQUIERDA -->
    <div class="col-xs-3" id="columna_izquierda_fija">


			  <!--DATOS DEL CLIENTE-->
			  <div class="panel panel-default" style="margin-bottom:0px ">
				<div class="panel-body panel_conmargen">
					<div class="col-md-12">
						<%
						nombre_logo="logo_" & session("usuario_carpeta") & ".png"
						if session("usuario_codigo_empresa")=4 and session("usuario_pais")="PORTUGAL" then
							nombre_logo="Logo_GLS.png"
						end if
						%>
						<div align="center"><img class="img-responsive" src="Images/<%=nombre_logo%>" style="max-height:90px"/></div>
						<br />
						<div align="center">	
							<%
							'el perfil de GLS CENTRAL ASM de ASM no tiene que ver los botones
							' solo hacer consultas sobre los articulos
							if session("usuario")<>7054 then%>
								<div class="row">
									<button type="button" id="cmdarticulos" name="cmdarticulos" class="btn btn-primary btn-md"
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Consultar Art&iacute;culos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-th-list"></i>
											<span>Art&iacute;culos</span>
									</button>
									<button type="button" id="cmdpedidos" name="cmdpedidos" class="btn btn-primary btn-md" 
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Consultar Pedidos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-list-alt"></i>
											<span>Pedidos</span>
									</button>
								</div>								
								<%'la central de GLS, es la que lleva la gestion de las impresoras
								if session("usuario")=2784 then%>				
									<div class="row" style="margin-top:5px">
										<div class="col-12 text-center">
										  <button type="button" name="cmdimpresoras" id="cmdimpresoras" class="btn btn-primary btn-md w-100">
												<i class="fas fa-print"></i> Gest. Impresoras
										  </button>
										</div>
									</div>
								<%end if%>
							<%end if%>
						</div>
						<%if session("usuario_codigo_empresa")=230 then%>
							<br />
							<div align="center">	
									<button type="button" id="cmdinforme_avoris" name="cmdinforme_avoris" class="btn btn-primary btn-md" 
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Informe Detallado de Pedidos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-list"></i>
											<span>Informe Pedidos</span>
									</button>
							</div>
						<%end if%>
						
					</div>
				</div>
			  </div>
	
			<%'seccion de informes solo para la central de GLS
			if session("usuario")=2784 then%>	
				<div class="panel panel-default" style="margin-bottom:0px; margin-top:7px ">
					<div class="panel-heading"><b>Informes</b></div>
					<div class="panel-body panel_conmargen">
						<div class="col-md-12">
							<div align="center">	
									<button type="button" id="cmdinformes_GLS" name="cmdinformes_GLS" class="btn btn-primary btn-md" 
										data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Informe de Pedidos" 
										data-original-title=""
										>
											<i class="glyphicon glyphicon-file"></i>
											<span>Informe Pedidos</span>
									</button>
							</div>
						</div>
					</div>
				</div>
			<%end if%>	
			  
				<!--OFERTAS DESTACADAS... CARRUSEL-->
				<%'10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
					' 240 FRANQUICIAS HALCON Y 250 FRANQUICIAS ECUADOR
				if session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80 and session("usuario_codigo_empresa")<>90_
						and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170 and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230_
						and session("usuario_codigo_empresa")<>240 and session("usuario_codigo_empresa")<>250 then
					if not vacio_carrusel then%>
					<div class="panel panel-default" style="margin-bottom:0px;margin-top:7px ">
						<div class="panel-heading"><b>Destacados</b></div>
						<div class="panel-body panel_sinmargen_lados panel_conmargen_arribaabajo">
						
							<DIV>
							<!--COMIENZO DEL CARRUSEL-->
							<script type="text/javascript" src="../carrusel/js/carrusel_4_seg.js"></script>
							<div id="jssor_2" style="position: relative; margin: 0 auto; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden; visibility: hidden;">
								<!-- Pantalla de "Cargando..." -->
								<div data-u="loading" style="position: absolute; top: 0px; left: 0px;">
									<div style="filter: alpha(opacity=70); opacity: 0.7; position: absolute; display: block; top: 0px; left: 0px; width: 100%; height: 100%;"></div>
									<div style="position:absolute;display:block;background:url('../carrusel/img_carrusel/loading.gif') no-repeat center center;top:0px;left:0px;width:100%;height:100%;"></div>
								</div>
								<div data-u="slides" style="cursor: default; position: relative; top: 0px; left: 0px; width: 600px; height: 500px; overflow: hidden;">
									<%for i=0 to UBound(tabla_carrusel,2)%>
										<div style="display: none;"><img data-u="image" src="../carrusel/img_carrusel/<%=tabla_carrusel(campo_fichero_carrusel,i)%>" /></div>
									<%next%>
								</div>
								<!-- Botones de Navegacion -->
								<!--
								<div data-u="navigator" class="jssorb05" style="bottom:16px;right:16px;" data-autocenter="1">
									<!-- Boton prototipo 
									<div data-u="prototype" style="width:16px;height:16px;"></div>
								</div>
								-->
								
								<!-- Flechas de Navegacion -->
								<span data-u="arrowleft" class="jssora10l" style="top:0px;left:8px;width:28px;height:40px;" data-autocenter="2"></span>
								<span data-u="arrowright" class="jssora10r" style="top:0px;right:8px;width:28px;height:40px;" data-autocenter="2"></span>
							</div>
							<script>
								jssor_slider_init('jssor_2');
							</script>
							<!-- FINALIZA EL CARRUSEL-->
							</DIV>
						</div>
					</div>
				<%	end if
				end if%>		
				<!--FINAL OFERTAS DESTACADAS -- EL CARRUSEL-->
				
		</div>  
    </div>
    <!--FINAL COLUMNA DE LA IZQUIERDA-->
    
    <!--COLUMNA DE LA DERECHA-->
    <div class="col-xs-9 col-xs-offset-3">
      <div class="panel panel-default">
        <div class="panel-heading"><span class='fontbold'>Busqueda de Productos <%=session("usuario_empresa")%></span></div>
        <div class="panel-body">
			<div class="well well-sm">
					<form class="form-horizontal" role="form" name="frmbusqueda" id="frmbusqueda" method="post" action="Lista_Articulos_Gag_Central_Admin.asp?acciones=<%=acciones%>">
						<input type="hidden" id="ocultover_cadena" name="ocultover_cadena" value="<%=ver_cadena%>" />				
						<div class="form-group">    
						  <label class="col-md-1 control-label"
						  		data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Referenc&iacute;a" 
								data-original-title=""
								>
									Ref.
								</label>	 
						  <div class="col-md-2">
							<input type="text" class="form-control" size="14" name="txtcodigo_sap" id="txtcodigo_sap" value="<%=codigo_sap_buscado%>" />
						  </div>
						  
						  <label class="col-md-2 control-label" 
						  		data-toggle="popover" 
								data-placement="bottom" 
								data-trigger="hover" 
								data-content="Descripci&oacute;n del Art&iacute;culo o Para Consumibles, modelo de impresora o color para los que es compatible" 
								data-original-title=""
								>
									Desc.
								</label>	                
						  <div class="col-md-7">
							<input type="text" class="form-control" size="44" name="txtdescripcion" id="txtdescripcion" value="<%=articulo_buscado%>" />
						  </div>
						</div>  
											
						
						<div class="form-group">    
							<label class="col-md-1 control-label">Familia</label>	 
							<div class="col-md-4">
								<%if session("usuario_codigo_empresa")=230 then%>
									<div id="capa_familias_agrupadas" class="col-sm-12 col-md-10 col-lg-10">
										<input type="hidden" name="ocultoagrupacion_familias" id="ocultoagrupacion_familias" value="" />
										<select id="cmbfamilias_agrupadas_otra" name="cmbfamilias_agrupadas_otra" class="form-control selectpicker" multiple data-selected-text-format="count > 3">
											<%
											grupo_ant=""
											For i = 0 to UBound(tabla_agrupacion_familias_otra, 2)
												grupo_nuevo=tabla_agrupacion_familias_otra(CAMPO_GRUPO_FAMILIAS_OTRA, i)
												If grupo_ant <> grupo_nuevo Then
													if grupo_ant<>"" then
										%>			
														</optgroup>
													<%end if%>	
													<optgroup label="<%=tabla_agrupacion_familias_otra(CAMPO_GRUPO_FAMILIAS_OTRA, i)%>">
										<%		
												End If
										%>
												<option class="special" value="<%=tabla_agrupacion_familias_otra(CAMPO_ID_FAMILIAS_OTRA, i)%>"><%=tabla_agrupacion_familias_otra(CAMPO_DESCRIPCION_FAMILIA_OTRA, i)%></option>
	
										<%		
												If grupo_ant <> grupo_nuevo Then
													grupo_ant = grupo_nuevo
												End If
											Next
										%>
										</select>
										<script language="javascript">
											//cambiar_agrupacion()
											$('.selectpicker').selectpicker();
											$("#cmbfamilias_agrupadas_otra").selectpicker('val', [<%=familias_buscadas_otra%>]);
											$(".dropdown-header").each(function (index, header) {
												var header = $(header);
												header.css('cursor', 'pointer');
												header.click(function () {
													var dataoptgroup = $(this).attr("data-optgroup");
													var group_lis = $('li[data-optgroup=' + dataoptgroup + ']').filter('li[data-original-index]');
										
													todas_seleccionadas="SI"
													group_lis.each(function (index, option) {
														if  (!$(option).hasClass('selected'))
															{
															todas_seleccionadas="NO"
															}
													});
													//console.log('todas seleccionadas: ' + todas_seleccionadas)
													if (todas_seleccionadas=='NO')
														{
															group_lis.each(function (index, option) {
																if  (!$(option).hasClass('selected'))
																	{
																	$(option).find("a").click()
																	}
															});
														}
													  else
														{
															group_lis.each(function (index, option) {
																$(option).find("a").click()
															});
														}
													
												});
											});
										</script>	
									</div>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<button type="button" class="btn btn-primary" id="cmdcambiar_agrupacion" name="cmdcambiar_agrupacion"
											data-toggle="popover"
											data-placement="top"
											data-trigger="hover"
											data-content="Reagrupar Por Familias"
											data-original-title=""
											onclick="cambiar_agrupacion()">
											<i class="glyphicon glyphicon-sort-by-attributes"  id="icono_reagrupar"></i>
										</button>
									</div>
									
								<%else%>
							
									<select class="form-control" name="cmbfamilias" id="cmbfamilias">
										<%if not vacio_familias then%>
											<%for i=0 to UBound(tabla_familias,2)%>
												<%if valor_seleccionado<>"" then
													if cint(valor_seleccionado)=cint(tabla_familias(campo_id_familia,i)) then%>
														<option value="<%=tabla_familias(campo_id_familia,i)%>" selected><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
													<%else%>
														<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
													<%end if%>
												<%else%>
													<option value="<%=tabla_familias(campo_id_familia,i)%>"><%=UCASE(tabla_familias(campo_descripcion_familia,i))%></option>
												<%end if%>
											<%next%>
										<%end if%>
										<option value="TODOS" selected>-- TODOS --</option>
									</select>
									
									<script language="javascript">
											document.getElementById("cmbfamilias").value='<%=familia_combo%>'
									</script>
								<%end if%>
							</div>
							
							<%
							'el perfil de ASM no tiene que ver la opcion de requiere autorizacion
							' sobre los articulos, ya que la autorizacion en ASM va sobre la oficina
							' UVE tampoco
							' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
							' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
							if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150_
								and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
								and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
								and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
								and session("usuario_codigo_empresa")<>250 then%>						  
								<label class="col-md-2 control-label" 
								  		data-toggle="popover" 
										data-placement="bottom" 
										data-trigger="hover" 
										data-content="Requiere Autorizaci&oacute;n" 
										data-original-title=""
										>Req. Auto.</label>	                
								<div class="col-md-3">
									<select class="form-control" name="cmbautorizacion" id="cmbautorizacion">
										<option value="">* Seleccione *</option>
										<option value="NO">NO</option>
										<option value="SI">SI</option>
									</select>
									<script language="JavaScript" type="text/javascript">
										document.getElementById("cmbautorizacion").value='<%=campo_autorizacion%>'
									</script>
								</div>
							<%end if%>
							<div class="col-md-2">
							  <button type="submit" name="cmbbuscar" id="cmbbuscar" class="btn btn-primary btn-sm">
									<i class="glyphicon glyphicon-search"></i>
									<span>Buscar</span>
							  </button>
							</div>
						</div>  
						
            		</form>
			</div><!--del well de los filtros-->
			
			
			<%if not vacio_articulos then
			
			  for ia=0 to UBound(tabla_articulos,2)
			  		response.flush()%>
					<script language="javascript">
						cadena='<div align="center"><br><br><img src="../images/loading4.gif"/><br /><br /><h4>Espere mientras se carga la página...</h4><br><br>Cargando Datos Artículo <%=ia%> de <%=UBound(tabla_articulos,2)%></div>'
						//$("#cabecera_pantalla_avisos").html("Avisos")
						//$("#pantalla_avisos .modal-header").show()
						$("#body_avisos").html(cadena + "<br><br>");
						//$("#pantalla_avisos").modal("show");
					</script>
				<div class="row">
					<!--comienza el articulo IZQUIERDA-->
					<a name="pto_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" id="pto_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>"></a>
						<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_1 item_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>"">

								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"><H5><%=tabla_articulos(ARTICULOS_CAMPO_DESCRIPCION, ia)%></H5></div>
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel inf_general_art"  onclick="muestra_datos_articulo(<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>, <%=session("usuario_codigo_empresa")%>)" 
												
												data-toggle="popover" 
												data-placement="bottom" 
												data-trigger="hover" 
												data-content="pulse para ver mas informacion de este articulo" 
												data-original-title=""
												
												>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													<div align="left"><b>Referencia:</b> <%=tabla_articulos(ARTICULOS_CAMPO_CODIGO_SAP, ia)%><br></div>
													<div align="left"><b>Familia:</b>  <%=tabla_articulos(ARTICULOS_CAMPO_NOMBRE_FAMILIA, ia)%><br></div>
													
													
													<%
													'ASM NO HA DE VER ESTE DATO DEL ARTICULO
													'   asm gestiona la autorizacion a nivel de oficina, no a nivel de articulo
													' UVE tampoco
													' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
													' 240 FRANQUICIAS HALCON Y 250 FRANQUICIAS ECUADOR tampoco
													if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150_
														and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
														and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
														and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
														and session("usuario_codigo_empresa")<>250 then%>						  
														<div align="left"><b>Requiere Autorización:</b>
															<%IF tabla_articulos(ARTICULOS_CAMPO_REQUIERE_AUTORIZACION, ia)="SI" THEN%>
																<B style="color:#FF0000">SI</B>
															<%ELSE%>	
																NO
															<%END IF%>
															<br>
														</div>
													<%end if%>
												</div><!-- panel body-->
											</div><!-- panel-->
											
									
										</div><!--col-md-7-->
										
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if tabla_articulos(ARTICULOS_CAMPO_UNIDADES_DE_PEDIDO, ia)<>"" then%>
														<div>
															<b>Unidad de Pedido:</b> 
															<br>
															<%=tabla_articulos(ARTICULOS_CAMPO_UNIDADES_DE_PEDIDO, ia)%>
														</div>				
													<%end if%>
													<%if tabla_articulos(ARTICULOS_CAMPO_PACKING, ia)<>"" then%>
														<div><b>Caja Completa:</b> <%=tabla_articulos(ARTICULOS_CAMPO_PACKING, ia)%></div>				
													<%end if%>
													<%if tabla_articulos(ARTICULOS_CAMPO_STOCK, ia)<>"" then%>
														<div><b>Stock:</b> <%=tabla_articulos(ARTICULOS_CAMPO_STOCK, ia)%></div>				
													<%end if%>
												</div>
											</div>
										</div>
									<!--fin informacion general del articulo-->
									</div><!--row-->
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-5 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<a href="../Imagenes_Articulos/<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>.jpg" target="_blank">
													<img class="img-responsive" src="../Imagenes_Articulos/Miniaturas/i_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>.jpg" border="0" id="img_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>">
												</a>
											</div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-7 panel_sinmargen_lados">
											

											<%if not vacio_tipos_precios then
												for i=0 to UBound(tabla_tipos_precios,2)%>
		
											
													<%'aqui ponemos la relacion de precios para cada tipo de precio
													set cantidades_precios=Server.CreateObject("ADODB.Recordset")
			
													sql="SELECT * FROM CANTIDADES_PRECIOS"
													sql=sql & " WHERE CODIGO_ARTICULO=" & tabla_articulos(ARTICULOS_CAMPO_ID, ia)
													sql=sql & " AND TIPO_SUCURSAL='" & tabla_tipos_precios(0,i) & "' "
													'sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
													sql=sql & " AND CODIGO_EMPRESA=" & tabla_tipos_precios(1,i)
													sql=sql & " ORDER BY CANTIDAD"
													'response.write("<br>" & sql)
													
													with cantidades_precios
														.ActiveConnection=connimprenta
														.CursorType=3 'adOpenStatic
														.Source=sql
														.Open
													end with
													'response.write("<br>compromiso de compra: " & articulos("compromiso_compra"))
													%>         
											

														
													<%if not cantidades_precios.eof then%>
														<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
															'o una caja de texto para poner la cantidad deseada de articulo
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="NO" then%>
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%>
																					</th>
																				
																				</tr>
																				<tr>
																					<th style="text-align:right">Cantidad</th>
																					<th style="text-align:right">Precio Pack</th>
																				</tr>
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					<tr id="fila_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" >
																						<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																						<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																						<td align="right">
																							<%
																								IF cantidades_precios("precio_pack")<>"" then
																									Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																								  else
																									Response.Write("")
																								end if
																							%>
																							&nbsp;
																						</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>																
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
																	
														<%end if
														' aqui van los de compromiso de compra
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="SI" then%>
															
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%>
																					</th>
																				</tr>
																				
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					<tr id="fila_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" >
																						<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																						<th>Precio Unidad</th>
																						<td align="right">
																							<%
																								IF cantidades_precios("precio_unidad")<>"" then
																									Response.Write(cantidades_precios("precio_unidad") & " €/u")
																								  else
																									Response.Write("")
																								end if
																							%>
																							&nbsp;
																						</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
		
														<%end if 'COMPRIMISO_COMPRA
														'articulos con precios segun tramos de unidades
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="TRAMOS" then%>
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%>
																					</th>
																				</tr>
																				<tr>
																					<th>Cantidad</th>
																					<th style="text-align:right">Precio</th>
																				</tr>
																				
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					
																					<tr id="fila_tramo_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" class="filas_cantidades">
																							<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																							<td align="left">
																								<%
																								if cantidades_precios("cantidad_superior")<>"" then
																									texto_tramos="de " & cantidades_precios("cantidad") & " a " & cantidades_precios("cantidad_superior")
																								  else
																									texto_tramos="a partir de " & cantidades_precios("cantidad")
																								end if
																								response.write(texto_tramos)
																								%>
																							
																							
																							</td>
																							<td align="right">
																								<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(FORMATNUMBER(cantidades_precios("precio_unidad"),2) & " €")
																									  else
																										Response.Write("")
																									end if
																								%>
																								
																							</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
														<%end if%>
															  
													<%end if 'CANTIDADES_PRECIOS%>
													<%
													cantidades_precios.close
													set cantidadese_precios=Nothing
													%>
												<%next '... del  for i=0 to UBound(tabla_tipos_precios,2)%>
											<%end if ' del... if not vacio_tipos_precios then%>
												
										</div>
										<!-- col-md-06, fin tabla precios y cantidades-->			
									</div><!--fin col-md-12-->
									<!--la informacion del articulo-->
									
									<!--boton de añadir y packing-->
									<div class="col-md-12" style="padding-top:10px">
									<%IF tabla_articulos(ARTICULOS_CAMPO_PLANTILLA_PERSONALIZACION, ia)<>"" then%>
										<div class="col-md-6">
											<span class="label label-warning pull-right" 
													style="font-size:18px;"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Requiere personalizaci&oacute;n" 
													data-original-title=""
													>
													<i class="glyphicon glyphicon-list-alt" style="padding-top:1px "></i>
											</span>
										</div>
									<%end if%>
									<%IF session("usuario_codigo_empresa")=4 and tabla_articulos(ARTICULOS_CAMPO_PERMITE_DEVOLUCION, ia)<>"SI" then%>
										<div class="col-md-6">
											<span class="label label-danger" 
													style="font-size:18px;margin-left:3px"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="No Permite Devolución" 
													data-original-title=""
													>
													<i class="glyphicon glyphicon glyphicon-share-alt glyphicon_rotado" style="padding-top:3px"></i>
											</span>
										</div>
									<%end if%>
									</div>
									<!--fin añadir y packing-->
									
									<%
									'para las cadenas de AVORIS, habrá articulos que mostrarán los precios pero no se poddran pedir
									if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=80_
										or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170_
										or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240_
										or session("usuario_codigo_empresa")=250) and tabla_articulos(ARTICULOS_CAMPO_EN_AVORIS_SOLO_VER, ia)="SI" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">NO SOLICITABLE</div>
										</div>
									<%end if%>
									

								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo IZQUIERDA-->
					
					
					
					<%
					'IF not articulos.eof THEN
					if ia <= UBound(tabla_articulos,2) then
						ia=ia+1
						'articulos.movenext
					end if
					%>
					
					<%'IF not articulos.eof THEN
					if ia <= UBound(tabla_articulos,2) then%>
						
						<!--comienza el articulo DERECHA-->
						<a name="pto_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" id="pto_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>"></a>
						<div class="col-md-6">
							<div class="panel panel-primary item col_articulo_2 item_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>"">

								<div class="panel-heading"  style="padding-bottom:2px;padding-top:2px"><H5><%=tabla_articulos(ARTICULOS_CAMPO_DESCRIPCION, ia)%></H5></div>
								<div class="panel-body" style="padding-left:1px; padding-left:1px; padding-top:0px;">
									<!--informacion general del articulo-->
									<div class="row">
										<div class="col-md-7">
											<div style="padding-top:5px"></div>
											<div class="panel inf_general_art"  onclick="muestra_datos_articulo(<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>, <%=session("usuario_codigo_empresa")%>)" 

												
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="pulse para ver mas informacion de este articulo" 
													data-original-title=""
													>
												<div class="panel-body" style="cursor:pointer;cursor:hand">
													<div align="left"><b>Referencia:</b> <%=tabla_articulos(ARTICULOS_CAMPO_CODIGO_SAP, ia)%><br></div>
													<div align="left"><b>Familia:</b>  <%=tabla_articulos(ARTICULOS_CAMPO_NOMBRE_FAMILIA, ia)%><br></div>

													<%
													'ASM NO HA DE VER ESTE DATO DEL ARTICULO
													'   asm gestiona la autorizacion a nivel de oficina, no a nivel de articulo
													' UVE tampoco
													' 10 HALCON, 20 ECUADOR, 80 HALCON VIAGENS, 90 TRAVELPLAN, 130 GEOMOON, 170 GLOBALIA CORPORATE TRAVEL, 210 MARSOL, 230 AVORIS
													' 240 FRANQUICIAS HALCON, 250 FRANQUICIAS ECUADOR tampoco
													if session("usuario_codigo_empresa")<>4 AND session("usuario_codigo_empresa")<>150_
														and session("usuario_codigo_empresa")<>10 and session("usuario_codigo_empresa")<>20 and session("usuario_codigo_empresa")<>80_
														and session("usuario_codigo_empresa")<>90 and session("usuario_codigo_empresa")<>130 and session("usuario_codigo_empresa")<>170_
														and session("usuario_codigo_empresa")<>210 and session("usuario_codigo_empresa")<>230 and session("usuario_codigo_empresa")<>240_
														and session("usuario_codigo_empresa")<>250 then%>						  
														<div align="left"><b>Requiere Autorización:</b>
															<%IF tabla_articulos(ARTICULOS_CAMPO_REQUIERE_AUTORIZACION, ia)="SI" THEN%>
																<B style="color:#FF0000">SI</B>
															<%ELSE%>	
																NO
															<%END IF%>
															<br>
														</div>
													<%end if%>
													
												</div><!-- panel body-->
											</div><!-- panel-->
											
									
										</div><!--col-md-7-->
										
										<div class="col-md-5">
											<div style="padding-top:5px"></div>
											<div class="panel inf_pack_stock">
												<div class="panel-body">
													<%if tabla_articulos(ARTICULOS_CAMPO_UNIDADES_DE_PEDIDO, ia)<>"" then%>
														<div>
															<b>Unidad de Pedido:</b> 
															<br />
															<%=tabla_articulos(ARTICULOS_CAMPO_UNIDADES_DE_PEDIDO, ia)%>
														</div>				
													<%end if%>
													<%if tabla_articulos(ARTICULOS_CAMPO_PACKING, ia)<>"" then%>
														<div><b>Caja Completa:</b> <%=tabla_articulos(ARTICULOS_CAMPO_PACKING, ia)%></div>				
													<%end if%>
													<%if tabla_articulos(ARTICULOS_CAMPO_STOCK, ia)<>"" then%>
														<div><b>Stock:</b> <%=tabla_articulos(ARTICULOS_CAMPO_STOCK, ia)%></div>				
													<%end if%>
												</div>
											</div>
										</div>
									<!--fin informacion general del articulo-->
									</div><!--row-->
									
									<!--imagen, precios y cantidades del articulo-->
									<div class="col-md-12">
										<!--imagen del articulo-->
										<div class="col-md-5 panel_sinmargen_lados" align="center">
											<div class="thumb-holder" >
												<a href="../Imagenes_Articulos/<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>.jpg" target="_blank">
													<img class="img-responsive" src="../Imagenes_Articulos/Miniaturas/i_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>.jpg" border="0" id="img_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>">
												</a>
											</div>
										</div>
										<!-- fin imagen del articulo-->
										
										<!--tabla de precios y cantidades a pedir-->	
										<div class="col-md-7 panel_sinmargen_lados">
											

											<%if not vacio_tipos_precios then
												for i=0 to UBound(tabla_tipos_precios,2)%>
		
											
													<%'aqui ponemos la relacion de precios para cada tipo de precio
													set cantidades_precios=Server.CreateObject("ADODB.Recordset")
			
													sql="SELECT * FROM CANTIDADES_PRECIOS"
													sql=sql & " WHERE CODIGO_ARTICULO=" & tabla_articulos(ARTICULOS_CAMPO_ID, ia)
													sql=sql & " AND TIPO_SUCURSAL='" & tabla_tipos_precios(0,i) & "' "
													'sql=sql & " AND CODIGO_EMPRESA=" & session("usuario_codigo_empresa")
													sql=sql & " AND CODIGO_EMPRESA=" & tabla_tipos_precios(1,i)
													sql=sql & " ORDER BY CANTIDAD"
													'response.write("<br>" & sql)
													
													with cantidades_precios
														.ActiveConnection=connimprenta
														.CursorType=3 'adOpenStatic
														.Source=sql
														.Open
													end with
													%>         
											
														
													<%if not cantidades_precios.eof then%>
														<%'controlamos si hay que mostrar una lista con cantidades fijas a seleccionar
															'o una caja de texto para poner la cantidad deseada de articulo
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="NO" then%>
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%>
																					</th>
																				
																				</tr>
																				<tr>
																					<th style="text-align:right">Cantidad</th>
																					<th style="text-align:right">Precio Pack</th>
																				</tr>
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo=cantidades_precios("cantidad") & "--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					<tr id="fila_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" >
																						<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																						<td align="right"><%=cantidades_precios("cantidad")%>&nbsp;</td>
																						<td align="right">
																							<%
																								IF cantidades_precios("precio_pack")<>"" then
																									Response.Write(FORMATNUMBER(cantidades_precios("precio_pack"),2) & " €")
																								  else
																									Response.Write("")
																								end if
																							%>
																							&nbsp;
																						</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>																
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
																	
														<%end if
														' aqui van los de compromiso de compra
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="SI" then%>
															
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%>
																					</th>
																				</tr>
																				
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					<tr id="fila_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" >
																						<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																						<th>Precio Unidad</th>
																						<td align="right">
																							<%
																								IF cantidades_precios("precio_unidad")<>"" then
																									Response.Write(cantidades_precios("precio_unidad") & " €/u")
																								  else
																									Response.Write("")
																								end if
																							%>
																							&nbsp;
																						</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
		
														<%end if 'COMPRIMISO_COMPRA
														'articulos con precios segun tramos de unidades
														if tabla_articulos(ARTICULOS_CAMPO_COMPROMISO_COMPRA, ia)="TRAMOS" then%>
															<div class="col-md-12 panel_sinmargen_lados">
																<div class="panel panel-default" style="padding-bottom:0px ">
																	<div class="panel-body--">
																		<table class="table table-condensed" id="tabla_cantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" style="margin-bottom:0px ">
																			<thead>
																				<tr>
																					<th colspan="2">
																						<%if session("usuario_codigo_empresa")<>230 then%>
																							<b>PRECIO <%=tabla_tipos_precios(0,i)%></b>
																						  <%else%>
																							<h5 style="margin-top: 0; margin-bottom: 0;"><b><%=tabla_tipos_precios(2,i)%></b><br><small>PRECIO <%=tabla_tipos_precios(0,i)%></small></h5>
																						<%end if%></th>
																				</tr>
																				<tr>
																					<th>Cantidad</th>
																					<th style="text-align:right">Precio</th>
																				</tr>
																				
																			</thead>
																			<tbody>
																				<%filas=1
																				'cantidades_precios.movelast
																				'cantidades_precios.movefirst
																				numero_filas=cantidades_precios.recordcount
																				while not cantidades_precios.eof%>
																				
																					<%
																					'como son articulos con compromiso de compra, la cantidad no es fija, tienen que indicarla
																					cantidades_precio_total_articulo=""
																					cantidades_precio_total_articulo="XXX--" & cantidades_precios("precio_unidad") & "--" & cantidades_precios("precio_pack")
																					%>
																					
																					<tr id="fila_tramo_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>_<%=filas%>" class="filas_cantidades">
																							<input type="hidden" id="ocultocantidades_precios_<%=tabla_articulos(ARTICULOS_CAMPO_ID, ia)%>" value="" />
																							<td align="left">
																								<%
																								if cantidades_precios("cantidad_superior")<>"" then
																									texto_tramos="de " & cantidades_precios("cantidad") & " a " & cantidades_precios("cantidad_superior")
																								  else
																									texto_tramos="a partir de " & cantidades_precios("cantidad")
																								end if
																								response.write(texto_tramos)
																								%>
																							
																							
																							</td>
																							<td align="right">
																								<%
																									IF cantidades_precios("precio_unidad")<>"" then
																										Response.Write(FORMATNUMBER(cantidades_precios("precio_unidad"),2) & " €")
																									  else
																										Response.Write("")
																									end if
																								%>
																								
																							</td>
																					</tr>
																					<%
																					filas=filas+1
																					cantidades_precios.movenext%>
																				<%wend%>
																			</tbody>
																		</table>
																	</div>
																</div><!--panel defalut-->
															</div><!--col-md-12-->
														<%end if%>
															  
													<%end if 'CANTIDADES_PRECIOS%>
													<%
													cantidades_precios.close
													set cantidadese_precios=Nothing
													%>
												<%next '... del  for i=0 to UBound(tabla_tipos_precios,2)%>
											<%end if ' del... if not vacio_tipos_precios then%>
												
										</div>
										<!-- col-md-06, fin tabla precios y cantidades-->			
									</div><!--fin col-md-12-->
									<!--la informacion del articulo-->
									<!--boton de añadir y packing-->
									<div class="col-md-12" style="padding-top:10px">
									<%IF tabla_articulos(ARTICULOS_CAMPO_PLANTILLA_PERSONALIZACION, ia)<>"" then%>
										<div class="col-md-6">
											<span class="label label-warning pull-right" 
													style="font-size:18px;"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="Requiere personalizaci&oacute;n" 
													data-original-title=""
													>
													<i class="glyphicon glyphicon-list-alt" style="padding-top:1px "></i>
											</span>
										</div>
									<%end if%>
									<%IF session("usuario_codigo_empresa")=4 and tabla_articulos(ARTICULOS_CAMPO_PERMITE_DEVOLUCION, ia)<>"SI" then%>
										<div class="col-md-6">
											<span class="label label-danger" 
													style="font-size:18px;margin-left:3px"
													data-toggle="popover" 
													data-placement="bottom" 
													data-trigger="hover" 
													data-content="No Permite Devolución" 
													data-original-title=""
													>
													<i class="glyphicon glyphicon glyphicon-share-alt glyphicon_rotado" style="padding-top:3px"></i>
											</span>
										</div>
									<%end if%>
									</div>
									<!--fin añadir y packing-->
									
									<%
									'para las cadenas de AVORIS, habrá articulos que mostrarán los precios pero no se poddran pedir
									if (session("usuario_codigo_empresa")=10 or session("usuario_codigo_empresa")=20 or session("usuario_codigo_empresa")=80_
										or session("usuario_codigo_empresa")=90 or session("usuario_codigo_empresa")=130 or session("usuario_codigo_empresa")=170_
										or session("usuario_codigo_empresa")=210 or session("usuario_codigo_empresa")=230 or session("usuario_codigo_empresa")=240_
										or session("usuario_codigo_empresa")=250) and tabla_articulos(ARTICULOS_CAMPO_EN_AVORIS_SOLO_VER, ia)="SI" then%>
										<br />&nbsp;
										<div class="col-md-10 col-md-offset-2" align="center">
											<div class="alert alert-warning" role="alert">NO SOLICITABLE</div>
										</div>
									<%end if%>
									

								</div><!--panel-body-->
							</div><!--panel-->
						</div><!--col-md-6-->
						<!--finaliza el articulo DERECHA-->
					</div><!--row-->
					
					<script language="javascript">
						//procedimiento que iguala la altura de las 2 celdas (paneles) de cada fila
						//porque con la clase table_cell... tambien se iguala, pero se descoloca
						//todo a lo ancho
						altura_1=$(".col_articulo_1").height()
						altura_2=$(".col_articulo_2").height()
						altura=altura_1
						if (altura_2>altura)
							{
							altura=altura_2
							}
						
						//$(".col_articulo_1").height(altura)
						//$(".col_articulo_2").height(altura)
						$('.col_articulo_1').css('min-height', altura + 'px')
						$('.col_articulo_2').css('min-height', altura + 'px')
						//console.log('altura1: ' + altura_1 + ' ... altura2: ' + altura_2 + ' ... altura tomada: ' + altura)
						
						$(".col_articulo_1" ).removeClass("col_articulo_1")
						$(".col_articulo_2" ).removeClass("col_articulo_2")

					</script>					
						
				<%END IF 'IF NOT ARTICULOS.EOF%>	
				<%
				'IF not articulos.eof THEN
				
				'esto ya lo hace el next
				'if ia <= UBound(tabla_articulos,2) then
				'	ia=ia+1
					'articulos.movenext
				'end if
				%>
			<%next
			end if 'del vacio_articulos%>
			
			
        </div><!--panel-body-->
      </div><!--panel-->
    </div>
    <!--FINAL COLUMNA DE LA DERECHA-->
  </div>    
  <!-- FINAL DE LA PANTALLA -->
</div>
<!--FINAL CONTAINER-->


<script language="javascript">
	$("#pantalla_avisos").modal("hide");
</script>

<script>
$(document).ready(function() {
    //para que se configuren los popover-titles...
	
	
	$('[data-toggle="popover"]').popover({html:true});
	
	
	
	
	
});

$("#cmdarticulos").on("click", function () {
	location.href='Lista_Articulos_Gag_Central_Admin.asp'
});

$("#cmdpedidos").on("click", function () {
	location.href='Consulta_Pedidos_Gag_Central_Admin.asp'
});
$("#cmdimpresoras").on("click", function () {
	location.href='Consulta_Impresoras_GLS_Central_Admin.asp'
});

$("#cmdinformes_GLS").on("click", function () {
	location.href='Consulta_Informes_Gag_Central_Admin.asp'
});

$("#cmdinforme_avoris").on("click", function () {
	location.href='Informe_Pedidos_Avoris.asp'
});


$("#cmbbuscar").on("click", function () {
	//mostrar_mensaje_espera()
});

$('.inf_general_art').hover(
       function(){ $(this).addClass('panel-primary') },
       function(){ $(this).removeClass('panel-primary') }
)

muestra_datos_articulo = function(articulo, empresa) {
	cadena='<iframe id="iframe_datos_articulo" src="Datos_Articulo_Gag.asp?articulo=' + articulo + '&empresa=' + empresa + '" width="99%" height="500px" frameborder="0" transparency="transparency"></iframe>'
	$("#pantalla_avisos .modal-header").hide()
	$("#body_avisos").html(cadena);
	$("#pantalla_avisos").modal("show");
  };  
  




</script>       


</body>
<%
	
	
	connimprenta.close
			  
	
	
	set connimprenta=Nothing
%>
</html>

