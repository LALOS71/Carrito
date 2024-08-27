Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml




<System.Web.Services.WebService(Namespace:="http://carrito.globalia-artesgraficas.com/WS_Imprenta/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class WSImprenta
    Inherits System.Web.Services.WebService

    '<WebMethod()> _
    'Public Function Hola_Mundo() As String
    '    Return "Hola Mundo"
    'End Function


    '<WebMethod()> _
    'Public Function Suma(ByVal sumando1 As Double, ByVal sumando2 As Double) As Double
    '    Return sumando1 + sumando2
    'End Function

    <WebMethod()> _
    Public Function Importar_Pedidos(ByVal xml_entrada As Xml.XmlDocument) As Xml.XmlDocument

        Return xml_entrada
    End Function


    <WebMethod()> _
    Public Function Importar_Pedidos_Pruebas(ByVal xml_entrada As XmlDocument) As XmlDocument

        Dim xml_salida As New XmlDocument
        Dim cadena_xml As String


        'Dim xd As New XmlDataDocument(xml_entrada)
        'Dim xn As XmlNode = xd.SelectSingleNode("//EMPRESA")
        'Dim xml As String = xn.OuterXml


        'MsgBox("HOLA")

        Dim elementos_raiz As Integer
        Dim numero_de_atributos As Integer
        Dim nombre_atributo As String
        Dim valor_atributo As String
        Dim texto_error As String

        Dim nombre_empresa As String
        Dim codigo_empresa As String


        Dim lista_nodos = xml_entrada.GetElementsByTagName("EMPRESA")

        texto_error = ""
        valor_atributo = ""
        nombre_atributo = ""
        nombre_empresa = ""
        codigo_empresa = ""

        elementos_raiz = lista_nodos.Count
        If elementos_raiz > 1 Then 'hay mas de un nodo raiz EMPRESA
            texto_error = "Solo debe haber un nodo raiz EMPRESA"
        End If
        If elementos_raiz = 0 Then ' no hay nodo raiz EMPRESA
            texto_error = "Falta el nodo raiz EMPRESA"
        End If

        If elementos_raiz = 1 Then 'todo va bien, solo un nodo EMPRESA
            numero_de_atributos = lista_nodos(0).Attributes.Count
            If numero_de_atributos = 0 Then
                texto_error = "Al Nodo Raiz EMPRESA, le falta el atributo 'codigo'"
            Else
                If IsNothing(lista_nodos(0).Attributes.GetNamedItem("codigo")) Then
                    texto_error = "Al Nodo Raiz EMPRESA, le falta el atributo 'codigo'"
                Else
                    If lista_nodos(0).Attributes.GetNamedItem("codigo").Value = "" Then
                        texto_error = "el atributo 'codigo' del nodo Raiz EMPRESA no puede estar vacio"
                    Else
                        valor_atributo = lista_nodos(0).Attributes.GetNamedItem("codigo").Value
                    End If
                End If
            End If
        End If

        If valor_atributo <> "" Then
            Dim paramentros_empresa = Split(valor_atributo, "-")
            nombre_empresa = paramentros_empresa(0)
            codigo_empresa = paramentros_empresa(1)
        End If

        cadena_xml = ""
        cadena_xml = "<EMPRESA codigo='" & valor_atributo & "'>"

        If texto_error <> "" Then
            cadena_xml = cadena_xml & "<ERROR>" & texto_error & "</ERROR>"
        End If

        cadena_xml = cadena_xml & " -- " & elementos_raiz
        cadena_xml = cadena_xml & " -- " & valor_atributo

        cadena_xml = cadena_xml & " -- codigo_empresa " & codigo_empresa
        cadena_xml = cadena_xml & " -- nombre_empresa " & nombre_empresa


        cadena_xml = cadena_xml & "</EMPRESA>"
        xml_salida.LoadXml(cadena_xml)


        Return xml_salida

    End Function




    '<WebMethod()> _

    'Public Function DevuelveTablas() As DataSet
    '    'Dim conexion As SqlConnection = New  _
    '    SqlConnection("Data Source=PBACKHALCON\PINTRAHALCON;" & _
    '                  "Initial Catalog=ARTES_GRAFICAS;" & _
    '                  "User ID=backhalconuser;" & _
    '                  "Password=backhalconuser;")
    '    Dim adapterEmpleados As SqlDataAdapter = New SqlDataAdapter _
    '                                             ("select * from empresas", conexion)
    '    Dim adapterLibros As SqlDataAdapter = _
    '        New SqlDataAdapter("select * from hoteles", conexion)
    '    Dim ds As DataSet = New DataSet()

    '    Try
    '        conexion.Open()
    '        adapterEmpleados.Fill(ds, "empresas")
    '        adapterLibros.Fill(ds, "hoteles")
    '        conexion.Close()
    '        Return ds

    '    Catch ex As SqlException
    '        Context.Response.Write("se ha producido una excepcion: " & ex.Message)

    '        Return Nothing
    '    End Try







    'End Function


End Class