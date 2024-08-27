<%@ language=vbscript%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="Conexion.inc"-->
<%
Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

lResolve = 50 * 1000  'Resolve timeout in milliseconds
lConnect = 50 * 1000  'Connect timeout in milliseconds
lSend    = 20 * 1000  'Send timeout in milliseconds
lReceive = 560 * 1000 'Receive timeout in milliseconds 
xmlhttp.setTimeouts lResolve, lConnect, lSend, lReceive
'xmlhttp.setTimeouts 5000, 60000, 10000, 10000

	
fecha_actual=date()

response.write("<br><br>fecha actual: " & fecha_actual)

fecha_actual=cdate("31-7-2013")
fecha_inicial=cdate("1-1-2013")

fecha_ciclo=fecha_inicial
dias=datediff("d", fecha_inicial, fecha_actual)
response.write("<br><br>fecha inicial: " & fecha_inicial & " ...... fecha final: " & fecha_actual & " ---- intervalo dias: " & dias)
for fechas=0 to dias
	'PRODUCCION
	'https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B
	
	'PREPRODUCCION
	'http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/18-06-2012?key=C59ABE15811E20AA1EC304E6CDE9945B
	response.write("<br><br>--------------------------------------------------<br>OBTENIENDO DATOS PARA LA FECHA: " & fecha_ciclo & "<br>--------------------------------------------------")
	sitio_web="http://pre.mylostbag.aireuropa.com/weblf/rest/dpr/" & replace(fecha_ciclo, "/", "-") & "?key=C59ABE15811E20AA1EC304E6CDE9945B"
	'sitio_web="https://mylostbag.aireuropa.com/weblf/rest/dpr/22-02-2018?key=C59ABE15811E20AA1EC304E6CDE9945B"
	'sitio_web="http://www.google.es"
	
	 response.write("<br><br>sitio web: " & sitio_web)
	  
	xmlhttp.Open "GET", sitio_web , False
	xmlhttp.Send
	txt = xmlhttp.responseText
	
	
	response.write("<br>RESULTADO: " & txt)
	

	
	for i=1 to len(txt)
	   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
	next
	
	'txt = Replace(txt,"&#13;&#10;", "")
	'sustituimos cosas raras
	txt = Replace(txt,chr(13) & chr(10), "") 'retornos de carro y saltos de linea en medio de campos.... donde no debe
	txt = Replace(txt,"'", "´") 'las comillas simples que dan error al importar
	
	response.write("<br>RESULTADO despues de formatear: " & txt)
	for i=1 to len(txt)
	   response.write("Caracter: " & mid(txt,i,1) & " Asci: " & Asc(mid(txt,i,1)) & "<br />")
	next
	
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
	
	cabecera=1
	
	
	response.write("<br><br>lbound: " & LBound(LineArray) & " ubound: " & UBound(LineArray))
	connmaletas.BeginTrans 'Comenzamos la Transaccion
	For i = LBound(LineArray) To UBound(LineArray) - 1
	
		
		response.write("<br><br>" & LineArray(i))
		campos=Split(LineArray(i), ";")
		cadena_campos=""
		cadena_valores=""
		if cabecera=0 then
			For j = LBound(campos) To UBound(campos)
				response.write("<br><br>" & campos(j))
			Next
			
			cadena_campos="PIR"
			cadena_valores="'" & campos(CPIR) & "'"
			
			if campos(CEXPEDIENTE)<>"" then
				cadena_campos=cadena_campos & ", EXPEDIENTE"
				cadena_valores=cadena_valores & ", '" & campos(CEXPEDIENTE) & "'"
			end if
	CFECCREACION=3
			if campos(CNOMBRE)<>"" then
				cadena_campos=cadena_campos & ", NOMBRE"
				cadena_valores=cadena_valores & ", '" & campos(CNOMBRE) & "'"
			end if
			if campos(CAPELLIDOS)<>"" then
				cadena_campos=cadena_campos & ", APELLIDOS"
				cadena_valores=cadena_valores & ", '" & campos(CAPELLIDOS) & "'"
			end if
			if campos(CMOVIL)<>"" then
				cadena_campos=cadena_campos & ", MOVIL"
				cadena_valores=cadena_valores & ", '" & right(campos(CMOVIL),15) & "'"
			end if
			if campos(CFIJO)<>"" then
				cadena_campos=cadena_campos & ", FIJO"
				cadena_valores=cadena_valores & ", '" & right(campos(CFIJO),15) & "'"
			end if
			if campos(CDIRENTREGA)<>"" then
				cadena_campos=cadena_campos & ", DIRECCION_ENTREGA"
				cadena_valores=cadena_valores & ", '" & campos(CDIRENTREGA) & "'"
			end if
			if campos(CCPOSTAL)<>"" then
				cadena_campos=cadena_campos & ", CP_ENTREGA"
				cadena_valores=cadena_valores & ", '" & campos(CCPOSTAL) & "'"
			end if
			if campos(CTIPODIRECCION)<>"" then
				cadena_campos=cadena_campos & ", TIPO_DIRECCION_ENTREGA"
				cadena_valores=cadena_valores & ", '" & campos(CTIPODIRECCION) & "'"
			end if
			if campos(CDESDEHASTA)<>"" then
				cadena_campos=cadena_campos & ", DESDE_HASTA"
				cadena_valores=cadena_valores & ", '" & campos(CDESDEHASTA) & "'"
			end if
			if campos(CFECHADESDEHASTA)<>"" then
				cadena_campos=cadena_campos & ", FECHA_DESDE_HASTA"
				cadena_valores=cadena_valores & ", '" & campos(CFECHADESDEHASTA) & "'"
			end if
			if campos(CTAG)<>"" then
				cadena_campos=cadena_campos & ", TAG"
				cadena_valores=cadena_valores & ", '" & campos(CTAG) & "'"
			end if
			if campos(CMARCA)<>"" then
				cadena_campos=cadena_campos & ", MARCA_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CMARCA) & "'"
			end if
			if campos(CMATERIAL)<>"" then
				cadena_campos=cadena_campos & ", MATERIAL_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CMATERIAL) & "'"
			end if
			if campos(CCOLOR)<>"" then
				cadena_campos=cadena_campos & ", COLOR_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CCOLOR) & "'"
			end if
			if campos(CLARGO)<>"" then
				cadena_campos=cadena_campos & ", LARGO_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CLARGO) & "'"
			end if
			if campos(CANCHO)<>"" then
				cadena_campos=cadena_campos & ", ANCHO_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CANCHO) & "'"
			end if
			if campos(CALTO)<>"" then
				cadena_campos=cadena_campos & ", ALTO_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CALTO) & "'"
			end if
			if campos(CRUTA)<>"" then
				cadena_campos=cadena_campos & ", RUTA"
				cadena_valores=cadena_valores & ", '" & campos(CRUTA) & "'"
			end if
			if campos(CVUELO)<>"" then
				cadena_campos=cadena_campos & ", VUELOS"
				cadena_valores=cadena_valores & ", '" & campos(CVUELO) & "'"
			end if
			if campos(CTIPOEQUIPAJE)<>"" then
				cadena_campos=cadena_campos & ", TIPO_EQUIPAJE_BAG_ORIGINAL"
				cadena_valores=cadena_valores & ", '" & campos(CALTO) & "'"
			end if
			if campos(CEMAIL)<>"" then
				cadena_campos=cadena_campos & ", EMAIL"
				cadena_valores=cadena_valores & ", '" & campos(EMAIL) & "'"
			end if
			
	
			
			'ID, FECHA_ORDEN, ORDEN, AGENTE, EXPEDIENTE, PIR, FECHA_PIR, TAG, NOMBRE, APELLIDOS, DNI, MOVIL, FIJO, DIRECCION_ENTREGA, CP_ENTREGA, TIPO_DIRECCION_ENTREGA, 
			'              DESDE_HASTA, FECHA_DESDE_HASTA, OBSERVACIONES, TIPO_EQUIPAJE_BAG_ORIGINAL, MARCA_BAG_ORIGINAL, MODELO_BAG_ORIGINAL, MATERIAL_BAG_ORIGINAL, 
			'              COLOR_BAG_ORIGINAL, LARGO_BAG_ORIGINAL, ALTO_BAG_ORIGINAL, ANCHO_BAG_ORIGINAL, DANNO_RUEDAS_BAG_ORIGINAL, DANNO_ASAS_BAG_ORIGINAL, 
			'              DANNO_CIERRES_BAG_ORIGINAL, DANNO_CREMALLERA_BAG_ORIGINAL, DANNO, EQUIPAJE, RUTA, VUELOS, TIPO_BAG_ORIGINAL, FECHA_INICIO, FECHA_ENVIO, FECHA_ENTREGA_PAX, 
			'              PLAZO_ENTREGA_EN_DIAS, INCIDENCIA_TRANSPORTE, INCIDENCIA_MALETA, OTRAS_INCIDENCIAS, TIPO_BAG_ENTREGADA, TAMANNO_BAG_ENTREGADA, REFERENCIA_BAG_ENTREGADA, 
			'              COLOR_BAG_ENTREGADA, NUM_EXPEDICION, ESTADO, DANNO_OTROS_BAG_ORIGINAL, DANNO_CUERPO_MALETA_BAG_ORIGINAL, DANNO_CIERRES_MALETA_BAG_ORIGINAL, 
			'              IMPORTE_FACTURACION, FECHA_FACTURACION, COSTES, PROVEEDOR, EMAIL
	
			cadena_ejecucion="INSERT INTO PIRS (" & cadena_campos & ") values (" & cadena_valores & ")"
			response.write("<br><br>cadena ejecuacion: " & cadena_ejecucion)
			
			connmaletas.Execute cadena_ejecucion,,adCmdText + adExecuteNoRecords
			
		end if
		cabecera=0
	Next
	connmaletas.CommitTrans ' finaliza la transaccion


	fecha_ciclo=DateAdd("d", 1, fecha_ciclo)
next

Set xmlhttp = Nothing

'regis.close			
connmaletas.Close
set connmaletas=Nothing

%>