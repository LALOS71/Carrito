<%@ language=vbscript %>
<!--#include file="../Conexion_PRU.inc"-->
<!--#include file="JSONData.inc"-->

<%
	Response.CharSet = "iso-8859-1"
	
	tabla="<style>"
	tabla=tabla & "#popover_articulos .popover_resumen_articulos {"
	tabla=tabla & " width:1000px;"
	tabla=tabla & "}"
	tabla=tabla & ".header-fixed {"
	tabla=tabla & "width: 100%"
	tabla=tabla & "}"
	tabla=tabla & ".header-fixed > thead,"
	tabla=tabla & ".header-fixed > tbody,"
	tabla=tabla & ".header-fixed > thead > tr,"
	tabla=tabla & ".header-fixed > tbody > tr,"
	tabla=tabla & ".header-fixed > thead > tr > th,"
	tabla=tabla & ".header-fixed > tbody > tr > td {"
	tabla=tabla & "display: block;"
	tabla=tabla & "}"
	tabla=tabla & ".header-fixed > tbody > tr:after,"
	tabla=tabla & ".header-fixed > thead > tr:after {"
	tabla=tabla & "content: ' ';"
	tabla=tabla & "display: block;"
	tabla=tabla & "visibility: hidden;"
	tabla=tabla & "clear: both;"
	tabla=tabla & "}"
	tabla=tabla & ".header-fixed > tbody {"
	tabla=tabla & "overflow-y: auto;"
	tabla=tabla & "height: 150px;"
	tabla=tabla & "}"
	tabla=tabla & ".header-fixed > tbody > tr > td,"
	tabla=tabla & ".header-fixed > thead > tr > th {"
	tabla=tabla & "width: 20%;"
	tabla=tabla & "float: left;"
	tabla=tabla & "}"
	
	tabla=tabla & "</style>"
		
	
	
	tabla=tabla & "<table class='table table-striped table-bordered table-sm table-responsive'>"
	tabla=tabla & "<thead><tr>"
	tabla=tabla & "<th scope='col'>Art&iacute;culo</th>"
	tabla=tabla & "<th scope='col'"
	tabla=tabla & " data-toggle='popover_resumen'"
	tabla=tabla & " data-placement='top'"
	tabla=tabla & " data-trigger='hover'"
	tabla=tabla & " data-content='cantidad'"
	tabla=tabla & " data-original-title=''"
	tabla=tabla & " >Cant.</th>"
	tabla=tabla & "<th scope='col'>Precio</th>"
	tabla=tabla & "<th scope='col'>Total</th>"
	tabla=tabla & "</tr></thead>"
	tabla=tabla & "<tbody>"
	
	
	for i=1 to Session("numero_articulos")
		articulo=Session(i)
		cantidades_precios=Session(i & "_cantidades_precios")
		
		set articulos=Server.CreateObject("ADODB.Recordset")
		
		with articulos
			.ActiveConnection=connimprenta
			.Source="SELECT ARTICULOS.ID, ARTICULOS.CODIGO_SAP, ARTICULOS.DESCRIPCION"
			.Source= .Source & " FROM ARTICULOS"
			.Source= .Source & " WHERE ID=" & articulo
			.Open
		end with
		
		if not articulos.eof then
			id_articulo=articulos("ID")
			referencia=articulos("CODIGO_SAP")
			descripcion=articulos("DESCRIPCION")
		end if
		
		articulos.close
		set articulos=Nothing
		tabla_cantidades_precios=split(cantidades_precios,"--")
		tamanno=Ubound(tabla_cantidades_precios)
		'response.write("<br>tamaño: " & tamanno)
		'response.write("<br>cantidades precios: " & cantidades_precios)
		cantidad="" & tabla_cantidades_precios(0)
		precio="" & tabla_cantidades_precios(1)
		
		'response.write("<br>cantidad: " & cantidad)
		'response.write("<br>precio: " & precio)
		
		
		if tamanno=1 then 'si es un articulo de merchan viene con menos informacion y da error en el indice (2)
			total=""
		  else
		  	total="" & tabla_cantidades_precios(2)
		end if
		if total<>"" then
			precio=""
		  else
		  	total=cdbl(precio)* cdbl(cantidad)
		end if
		
		
		'resumen=resumen & "<br>" & referencia & " " & descripcion & " " & cantidad & " " & precio
		tabla=tabla & "<tr>"
		tabla=tabla & "<td"
		tabla=tabla & " data-container='popover_articulos'"
		tabla=tabla & " data-toggle='popover_resumen_articulos'"
		tabla=tabla & " data-placement='bottom'"
		tabla=tabla & " data-trigger='hover'"
		'tabla=tabla & " data-content='" & imagen_articulo & "'"
		tabla=tabla & " data-original-title='" & descripcion & "'"
		tabla=tabla & " popover_id='" & id_articulo & "'"
		tabla=tabla & " style='cursor:pointer;cursor:hand'>" & referencia & "</td>"
		tabla=tabla & "<td style='text-align:right'>" & cantidad & "</td>"
		
		precio_formateado=""
		total_formateado=""
		if precio<>"" then
			'precio_formateado=FORMATNUMBER(precio ,2 ,-1 ,, -1)
			precio_formateado=precio
		end if
		if total<>"" then
			total_formateado=FORMATNUMBER(total ,2 ,-1 ,, -1)
		end if
		tabla=tabla & "<td style='text-align:right'>" & precio_formateado & "</td>"
		tabla=tabla & "<td style='text-align:right'>" & total_formateado & "</td>"
		tabla=tabla & "</tr>"
    
	next 
	tabla=tabla & "</tbody></table>"
	tabla=tabla & "<script language='javascript'>" & chr(10) & chr(13)
	tabla=tabla & "$('[data-toggle=popover_resumen]').popover({html: true, container: 'body'})" & chr(10) & chr(13)
	tabla=tabla & "$('[data-toggle=popover_resumen_articulos]').each(function(i, obj) {" & chr(10) & chr(13)
	tabla=tabla & "$(this).popover({" & chr(10) & chr(13)
	tabla=tabla & "html: true," & chr(10) & chr(13)
	tabla=tabla & "container: 'body'," & chr(10) & chr(13)
	tabla=tabla & "content: function() {" & chr(10) & chr(13)
	tabla=tabla & "var id = $(this).attr('popover_id')" & chr(10) & chr(13)
	tabla=tabla & "return '<div class=""col-md-10 col-md-offset-1""><div class=""image_thumb""  align=""center"">" 
	tabla=tabla & "<img src=""../Imagenes_Articulos/Miniaturas/i_' + id + '.jpg"" class=""img img-responsive full-width""/>"
	tabla=tabla & "</div><br></div>'" & chr(10) & chr(13)
	tabla=tabla & "}" & chr(10) & chr(13)
	tabla=tabla & "});" & chr(10) & chr(13)
	tabla=tabla & "});" & chr(10) & chr(13)
	tabla=tabla & "</script>"
	
	if Session("numero_articulos")>0 then
		response.write(tabla)
	end if
	connimprenta.close
	set connimprenta=Nothing
%>



