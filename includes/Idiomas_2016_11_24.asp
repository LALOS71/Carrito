<%
'****************************
'PARA GESTIONAR EL IDIOMA EN EL QUE SE MUESTRA LA APLICACION

'******
'OJO****
' Se ha creado un directorio virtual en el servidor (includes), apuntando a la carpeta includes del directorio
' raiz del carrito donde se encuentran todos los includes para los idiomas de todas la paginas
'*******************************************************************************************

ruta = Request.ServerVariables("URL") 'recoge la ruta completa
'Response.Write("<br>Ruta Completa: " & ruta)

ruta = Split(ruta,"?") 'para quitar los parametros de la url
'Response.Write("<br>Ruta sin Parametros: " & ruta(0)) 

ruta_p=ruta(0)
elementos_ruta = Split(ruta_p,"/") 'convierte cada separación señalada por / en un elemento de un vector
nombre = elementos_ruta(UBound(elementos_ruta)) 'recogemos el último elemento de ese vector...
'Response.Write("<br>nombre pagina: " & nombre) 

nombre=replace(nombre,".asp","") 'le quitamos la extension para que solo tenga el nombre
'Response.Write("<br>nombre sin extension: " & nombre) 

Select Case lcase(session("idioma"))
	
	case "en" 'para poner los literales en INGLES
			'response.write("<br>idioma seleccionado: " & session("idioma"))
			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_en.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_en.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_en.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_en.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_en.asp"-->

			<%end select


	case "es" 'para poner los literales en CASTELLANO
			'response.write("<br>idioma seleccionado: " & session("idioma"))
			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_es.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_es.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_es.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_es.asp"-->

			<%end select


	case else 'POR DEFECTO lo ponemos en CASTELLANO
			'response.write("<br>idioma seleccionado: " & session("idioma"))
			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_es.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_es.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_es.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_es.asp"-->

			<%end select




End Select%>