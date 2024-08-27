Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System
Imports System.Data
Imports System.Data.SqlClient



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