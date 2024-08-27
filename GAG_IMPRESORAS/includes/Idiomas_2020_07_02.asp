<%
'****************************
'PARA GESTIONAR EL IDIOMA EN EL QUE SE MUESTRA LA APLICACION

'******
'OJO****
' Se ha creado un directorio virtual en el servidor (includes), apuntando a la carpeta includes del directorio
' raiz del carrito donde se encuentran todos los includes para los idiomas de todas la paginas
'*******************************************************************************************

ruta = Request.ServerVariables("URL") 'recoge la ruta completa
'Response.Write("<br>IDIOMAS.ASP: Ruta Completa: " & ruta)

ruta = Split(ruta,"?") 'para quitar los parametros de la url
'Response.Write("<br>IDIOMAS.ASP: Ruta sin Parametros: " & ruta(0)) 

ruta_p=ruta(0)
elementos_ruta = Split(ruta_p,"/") 'convierte cada separación señalada por / en un elemento de un vector
nombre = elementos_ruta(UBound(elementos_ruta)) 'recogemos el último elemento de ese vector...
'Response.Write("<br>IDIOMAS.ASP: nombre pagina: " & nombre) 

nombre=replace(nombre,".asp","") 'le quitamos la extension para que solo tenga el nombre
'Response.Write("<br>IDIOMAS.ASP: nombre sin extension: " & nombre) 
'response.write("<br>IDIOMAS.ASP: idioma seleccionado: " & session("idioma"))
		
Select Case lcase(session("idioma"))
	
	case "en" 'para poner los literales en INGLES
			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_en.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_en.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_en.asp"-->
				<%case "datos_articulo_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_en.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_en.asp"-->
				<%case "carrito_gag_central_admin"%> <!--#include virtual="/includes/Carrito_Gag_Central_Admin_cons_en.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_en.asp"-->
				<%case "plantilla_personalizacion_con_adjunto"%> <!--#include virtual="/includes/Plantilla_Personalizacion_con_adjunto_cons_en.asp"-->
				<%case "consulta_pedidos_gag"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_cons_en.asp"-->
				<%case "consulta_pedidos_gag_central_admin"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_Central_Admin_cons_en.asp"-->
				<%case "pedido_detalles_gag"%> <!--#include virtual="/includes/Pedido_Detalles_Gag_cons_en.asp"-->
				<%case "eliminar_pedido_gag"%> <!--#include virtual="/includes/Eliminar_Pedido_Gag_cons_en.asp"-->
				<%case "annadir_articulo_gag"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_cons_en.asp"-->
				<%case "annadir_articulo_gag_central_admin"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_Central_Admin_cons_en.asp"-->

			<%end select


	case "es" 'para poner los literales en CASTELLANO
			
			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_es.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_es.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "datos_articulo_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_es.asp"-->
				<%case "carrito_gag_central_admin"%> <!--#include virtual="/includes/Carrito_Gag_Central_Admin_cons_es.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_es.asp"-->
				<%case "plantilla_personalizacion_con_adjunto"%> <!--#include virtual="/includes/Plantilla_Personalizacion_con_adjunto_cons_es.asp"-->
				<%case "consulta_pedidos_gag"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_cons_es.asp"-->
				<%case "consulta_pedidos_gag_central_admin"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_Central_Admin_cons_es.asp"-->
				<%case "pedido_detalles_gag"%> <!--#include virtual="/includes/Pedido_Detalles_Gag_cons_es.asp"-->
				<%case "eliminar_pedido_gag"%> <!--#include virtual="/includes/Eliminar_Pedido_Gag_cons_es.asp"-->
				<%case "annadir_articulo_gag"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_cons_es.asp"-->
				<%case "annadir_articulo_gag_central_admin"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_Central_Admin_cons_es.asp"-->


			<%end select


	case else 'POR DEFECTO lo ponemos en CASTELLANO

			select case lcase(nombre) 'cada pagina carga su fichero de constantes
			
				case "login_asm"%> <!--#include virtual="/includes/Login_ASM_cons_es.asp"-->
				<%case "validar"%> <!--#include virtual="/includes/Validar_cons_es.asp"-->
				<%case "lista_articulos_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "datos_articulo_gag"%> <!--#include virtual="/includes/Lista_Articulos_GAG_cons_es.asp"-->
				<%case "carrito_gag"%> <!--#include virtual="/includes/Carrito_Gag_cons_es.asp"-->
				<%case "carrito_gag_central_admin"%> <!--#include virtual="/includes/Carrito_Gag_Central_Admin_cons_es.asp"-->
				<%case "plantilla_personalizacion"%> <!--#include virtual="/includes/Plantilla_Personalizacion_cons_es.asp"-->
				<%case "plantilla_personalizacion_con_adjunto"%> <!--#include virtual="/includes/Plantilla_Personalizacion_con_adjunto_cons_es.asp"-->
				<%case "consulta_pedidos_gag"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_cons_es.asp"-->
				<%case "consulta_pedidos_gag_central_admin"%> <!--#include virtual="/includes/Consulta_Pedidos_Gag_Central_Admin_cons_es.asp"-->
				<%case "pedido_detalles_gag"%> <!--#include virtual="/includes/Pedido_Detalles_Gag_cons_es.asp"-->
				<%case "eliminar_pedido_gag"%> <!--#include virtual="/includes/Eliminar_Pedido_Gag_cons_es.asp"-->
				<%case "annadir_articulo_gag"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_cons_es.asp"-->
				<%case "annadir_articulo_gag_central_admin"%> <!--#include virtual="/includes/Annadir_Articulo_Gag_central_admin_cons_es.asp"-->
						
			<%end select




End Select%>