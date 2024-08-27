        <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GAGLogin.aspx.cs" Inherits="GAGLogin.GAGLogin"
    EnableEventValidation="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Login GLOBALIA</title>

    
    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/font-awesome.min.css" rel="stylesheet" />
        
    <link href="css/jquery-ui.css" rel="stylesheet" />      

    <!-- jQuery para  Bootstrap's Mínimo 1.9.1 -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/jquery-ui.js"></script>

    <script src="js/bootstrap.min.js"></script>

    <%--Plugins añadidos--%>
    
    <script src="js/jquery.numeric.js"></script>

<style type="text/css" media="all">

/* Aumenta separación de etiquetas por la izqu. de los form-inline de bootstrap*/
.form-inline label {
    padding: 1px 1px 1px 15px;
}

/* Aumenta separación de iconos */
.glyphicon, .fa  {
    padding: 1px 5px 1px 1px;    
}

</style>
<script type="text/javascript">

$(function () {
    // permite solo numeros, usa plugin  "jquery.numeric.js".  false, sin decimales "." o ","->separador decimal,   --   
    //$("[id$=tbPrecioCompra], [id$=tbPrecioVenta]").numeric(",");
    $('#tbUsuario').numeric(false); // sin puntuación   alguna --
    
});  // (document).ready,  $(function () ---------------------

        
function validUsuario() {
    // si el combo contiene algo, ya se ha validado , envia el formulario con el nº de cliente del combo --
    if (!$("#cmbClienteSel").html() == "") {        
        var cliente = $("#cmbClienteSel").val().split("-")[0]  // extrae el codigo de la cadena de texto (el primero separado por -)
        $('#ocultoCliente').val(cliente);        
        document.forms['form1'].submit();
        return 0;
    }
    if ($('#tbUsuario').val() == "") {
        alert('Indique algún nº de Usuario/Empleado');
        $('#tbUsuario').focus();
        return 0;
    }

    $.ajax({
        type: "POST", contentType: "application/json; charset=utf-8",
        url: "wsLogin.asmx/validarUsuarioLDAP",
        data: '{usuario:' + $('#tbUsuario').val() + ', contrasena:"' + $('#tbContrasena').val() + '" }',        
        dataType: "json",
        success:
            function (data) {
                $('#pnClienteSel').hide();
                $("#cmbClienteSel").empty();
                switch (data.d.resulLDAP) {                     
                    case 0: {                                                                                                            
                        $('#ocultoUsuario').val($('#tbUsuario').val());                                                                        
                        var lClientes = data.d.lisClientes.split("|"); // separamos el resultado por el caracter "|", se genera uno de mas,                   
                        if (lClientes.length > 2) {
                            $('#pnClienteSel').show();
                            $("#cmbClienteSel").empty(); // Elimina información anterior del combo --
                            for (i = 0; i <= lClientes.length - 2; i++) {
                                $("#cmbClienteSel").append('<option value="' + lClientes[i] + '">' + lClientes[i] + '</option>');
                            }                                                       
                        }
                        else {
                            $('#ocultoCliente').val(data.d.Cliente);                            
                            document.forms['form1'].submit();
                        }
                        break;
                    }
                    case 1: {                        
                        alert('El Usuario NO tiene permisos para el uso de este aplicativo');
                        break
                    }
                    case 1017: {                        
                        alert('Usuario o contraseña Incorrectos ');
                        break
                    }
                    case 20102: {
                        alert('Contraseña Caducada ');
                        break
                    }
                    default: {                        
                        alert('Validación fallida:' + data.d.resulLDAP);
                        break
                    }
                }// case --               
            },
        error:
            function (request, status, error) { alert(JSON.parse(request.responseText).Message); }
    }); // $.ajax({
}// validUsuario --

</script>

</head>
        
<body>      

  
   

<form id="form1" action="http://192.168.153.132/asp/CARRITO_IMPRENTA_GAG_BOOT/GAG/Abrir_Lista_Articulos.asp" runat="server">  

    
<%-- 
    <form id="form1" action="http://carrito.globalia-artesgraficas.com/GAG/Abrir_Lista_Articulos.asp" runat="server">    PROD
    <form id="form1" action="http://192.168.153.132/asp/carrito_imprenta/GAG/Abrir_Lista_Articulos.asp" runat="server">   DES

    <form id="form1" action="http://192.168.153.132/asp/carrito_imprenta_GAG/GAG/Abrir_Lista_Articulos.asp" runat="server">   DES (obsoleto)

--%> 

    
<div id="frmLogin" role="dialog" >
    <div class="modal-dialog" style="width:480px;">  
        <div class="modal-content">
            <div class="modal-header" style="padding: 35px 50px;">
                    
                <h3><span class="glyphicon glyphicon-lock"></span>Identificación </h3>
                <h3> Peticiones Material Globalia (r.1.1) </h3>
                <img src="/Images/Logo.png" width="400" height="100" />
            </div>
            <div class="modal-body" style="padding: 20px 30px;">
                <div role="form">
                    <div class="form-group">
                        <label for="usrname"><span class="glyphicon glyphicon-user fa-2x"></span>Usuario /Nº empleado</label>
                        <input type="text" class="form-control" id="tbUsuario" runat="server" style="width: 250px;" MaxLength="6"
                            autofocus="" placeholder="Indique Nº. empleado" />
                    </div>
                    <div class="form-group">
                        <label for="psw"><span class="glyphicon glyphicon-eye-open fa-2x"></span>Contraseña</label>
                        <input type="password" class="form-control " id="tbContrasena" style="width: 250px;" placeholder="Indique Contraseña" />
                    </div>  

                    <div id="pnClienteSel" class="form-group" hidden="hidden">
                        <label><span class="fa fa-users fa-2x"></span>Varios Clientes para este Usuario (Seleccionar uno)</label>
                        <select id="cmbClienteSel" class="form-control" style="font-size:16px;"></select>
                    </div>  
                        
                    <div id="pnClienteSel_" class="panel panel-primary" hidden="hidden">
                        <div class="panel-heading">Selecionar cliente</div>                            
                    </div>


                    <%--<button onclick="abrirPag()"  type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off">
                    </span>Entrar ANT</button>--%>                         
                    <a href="#" onclick="validUsuario()" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off"></span>Aceptar</a>
                </div>
            </div>
            <div class="modal-footer">                
            </div>
        </div>

        </div>
</div>
<!-- fin de frmLogin -->

<input type="hidden" id="ocultoCliente" runat="server" />
<input type="hidden" name="ocultoUsuario" id="ocultoUsuario" value="" />

    

</form>

</body>
</html>


