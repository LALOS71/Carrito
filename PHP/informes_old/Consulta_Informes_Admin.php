<?php
include_once("conexion.php");
include "./Menu_Hamburguesa.asp";

// para que no se desborde el buffer
ob_start();

session_start();

/* if ($_SESSION["usuario_admin"] == "") { /// inicio de sesion exitosa quitar si es distinto de vacio
    header("Location: Login_Admin.php");
    exit();
} */

/* $ver_cadena = isset($_GET["p_vercadena"]) ? $_GET["p_vercadena"] : "";
if ($ver_cadena == "") {
    $ver_cadena = isset($_POST["ocultover_cadena"]) ? $_POST["ocultover_cadena"] : "";
}

$agrupacion_seleccionada = isset($_POST["optagrupacion"]) ? $_POST["optagrupacion"] : "";
$empresa_seleccionada = isset($_POST["cmbempresas"]) ? $_POST["cmbempresas"] : "";
$articulo_seleccionado = isset($_POST["cmbarticulos"]) ? $_POST["cmbarticulos"] : "";
$ordenacion_seleccionada = isset($_POST["optordenacion"]) ? $_POST["optordenacion"] : "";

$reservas_asm_gls_seleccionada = isset($_POST["chkreservas_asm_gls"]) ? $_POST["chkreservas_asm_gls"] : "";
$fecha_i = isset($_POST["txtfecha_inicio"]) ? $_POST["txtfecha_inicio"] : "";
$fecha_f = isset($_POST["txtfecha_fin"]) ? $_POST["txtfecha_fin"] : "";
$diferenciar_empresas_seleccionada = isset($_POST["chkdiferenciar_empresas"]) ? $_POST["chkdiferenciar_empresas"] : "";
$diferenciar_sucursales_seleccionada = isset($_POST["chkdiferenciar_sucursales"]) ? $_POST["chkdiferenciar_sucursales"] : "";
$diferenciar_articulos_seleccionada = isset($_POST["chkdiferenciar_articulos"]) ? $_POST["chkdiferenciar_articulos"] : "";
$articulos_sin_consumo_seleccionada = isset($_POST["chkarticulos_sin_consumo"]) ? $_POST["chkarticulos_sin_consumo"] : "";
$diferenciar_rappel_seleccionado = isset($_POST["chkdiferenciar_rappel"]) ? $_POST["chkdiferenciar_rappel"] : "";
$diferenciar_costes_seleccionado = isset($_POST["chkdiferenciar_costes"]) ? $_POST["chkdiferenciar_costes"] : "";
$diferenciar_marca_seleccionada = isset($_POST["chkdiferenciar_marca"]) ? $_POST["chkdiferenciar_marca"] : "";
$diferenciar_tipo_seleccionada = isset($_POST["chkdiferenciar_tipo"]) ? $_POST["chkdiferenciar_tipo"] : ""; */

// Puedes usar echo o print para imprimir contenido HTML
// echo "<br>diferenciar rappel: " . $diferenciar_rappel_seleccionado;
// echo "<br>agrupacion articulo: " . $_REQUEST["optagrupacion_articulo"];
// echo "<br>agrupacion empresa: " . $_REQUEST["optagrupacion_empresa"];
// echo "<br>agrupacion: " . $_REQUEST["optagrupacion"];
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Opciones de Búsqueda</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" >
   <!--  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js" ></script> -->
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="css/style_menu_hamburguesa5.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js" defer></script>
    <!-- <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" ></script> -->



    <!-- <script src="./js/jquery-3.6.0.min.js" defer></script> -->
    <!-- <script src="./js/jquery-3.5.1.min.js" defer></script> -->
    <!-- Bootstrap JS -->
     <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js" defer></script> 
    <!-- European format dd-mm-yyyy -->
    <script language="JavaScript" src="./js/calendar1.js" defer></script>  
    <!-- Date only with year scrolling -->
    <!-- <script language="javascript" src="Funciones_Ajax.js" defer></script> -->    
    <script lang="JavaScript" src="./js/archivos.js" defer></script>

</head>

<body>
    <!-- navbar -->
    <!-- <div class="pos-f-t">
        <div class="collapse" id="navbarToggleExternalContent">
            <div class="bg-light p-4">
                <h4 class="text-white">Collapsed content</h4>
                <span class="text-muted">Toggleable via the navbar brand.</span>
            </div>
        </div>
         <nav class="navbar navbar-light bg-dark">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </nav> 
    </div> -->
    <!-- navbar -->

    <div id="content-fluid">
        <button type="button" id="sidebarCollapse" class="navbar-btn active">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
    <div class="wrapper">

        <!-- Page Content Holder -->


        <div class="container-fluid">
            <h3 class="text-center">INFORMES</h3>
            <h6>Opciones de Búsqueda</h6>
            <form action="conexion.php" method="post" id="form">
                <div class="form-group">
                    <div class="container-fluid rounded" style="background-color: #DCDCDC;">
                        <label for="grupoPor">Agrupar Por:</label>
                        <div class="row ml-1">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="grupoPor" id="radioEmpresa" value="Empresa">
                                <label class="form-check-label" for="radioEmpresa">Empresa</label>
                            </div>
                            <div class="form-group col-md-4">
                                <select class="form-control" id="selectEmpresa">
                                    <option value="">* TODAS *</option>
                                    <?php //echo $empresas; 
                                    foreach ($empresas as $row) {
                                        echo "<option value='" . $row['Codigo'] . "'>" . $row['Texto'] . "</option>";
                                    }
                                    ?>
                                </select>
                            </div>

                            <div id="combo_empresas">Seleccione Provincia</div>

                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="grupoPor" id="radioArticulo" value="Artículo">
                                <label class="form-check-label" for="radioArticulo">Artículo</label>
                            </div>
                            <div class="form-check ml-3" id="descripcionRadioDiv" style="display: none;">
                                <input class="form-check-input" type="radio" name="grupoPor" id="radioDescripcion" value="descripcion">
                                <label class="form-check-label" for="radioDescripcion">Ordenar por descripción</label>
                            </div>
                            <div class="form-group col-md-4">
                                <select class="form-control" id="selectArticulo">
                                    <option value="">* TODOS *</option>
                                    <?php //echo $articulos; 
                                    foreach ($articulos as $row) {
                                        echo "<option value='" . $row['ID'] . "'>" . $row['CODIGO_SAP'] . " - " . $row['DESCRIPCION'] . "</option>";
                                    }
                                    ?>
                                </select>
                            </div>
                           <!--  <script>
                                $("select").select2({
                                    tags: "true",
                                    allowClear: true
                                });
                            </script> -->
                        </div>
                        <div class="form-check ml-1">
                            <input class="form-check-input" type="checkbox" name="grupoPor" id="checkReservas" value="reservas">
                            <label class="form-check-label" for="checkReservas">Reservas ASM/GLS</label>
                        </div>
                    </div>

                    <div class=" container-fluid rounded" style="background-color: #B0C4DE;">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="fechaInicio">Fecha Inicio:</label>
                                    <input type="date" class="form-control" id="fechaInicio">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="fechaFin">Fecha Fin:</label>
                                    <input type="date" class="form-control" id="fechaFin">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid rounded" style="background-color: #355CFF;">
                        <div class="row ml-1">
                            <div class="form-check col-md-4">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_sucursales" value="SI">
                                <label class="form-check-label font-weight-bold text-white" for="chkdiferenciar_sucursales">Diferenciar Sucursales</label>
                            </div>
                            <p class="text-white ">(util para obtener los consumos detallados de cada oficina de la empresa seleccionada)</p>
                        </div>
                    </div>
                    <!--  <% if agrupacion_seleccionada="empresa" then %>

                    <script>
                        document.getElementById('tabla_diferenciar_articulos_relleno').style.display = 'block';
                        document.getElementById('tabla_diferenciar_articulos').style.display = 'block';
                    </script>

                        <% end if %> -->
                    <div class="container-fluid rounded bg-info" style="margin-bottom: -15px">
                        <div class="row ml-1">
                            <div class="form-check col-md-3 text-white">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_articulos" value="SI" onclick="activar_articulos_sin_consumo()">
                                <label class="form-check-label font-weight-bold" for="chkdiferenciar_articulos">Diferenciar Artículos</label>
                            </div>
                            <p class="text-white">(util para obtener los consumos detallados de cada uno de los productos asociados a la empresa seleccionada)</p>
                        </div>
                        <div class="form-group text-white d-flex justify-content-end" id="fila_articulos_sin_consumo">
                            <div class="form-check col-md-4">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_rappel" value="SI">
                                <label class="form-check-label font-weight-bold" for="chkdiferenciar_rappel">Mostrar Información Rappel</label>
                            </div>
                            <div class="form-check col-md-4">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_costes" value="SI">
                                <label class="form-check-label font-weight-bold" for="chkdiferenciar_costes">Mostrar Costes, Proveedor y Ref. Prov.</label>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid rounded m-0" style="background-color: #E6E6FA;">
                        <div class="row ml-1">
                            <div class="form-check col-md-4">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_marca" value="SI">
                                <label class="form-check-label font-weight-bold" for="chkdiferenciar_marca">Diferenciar Marca</label>
                            </div>
                            <p>(util para BARCELÓ, para obtener los consumos individualizados por marca (Barcelo, Confort, Premium))</p>
                        </div>
                    </div>


                    <div class="container-fluid pt-1 rounded bg-secondary">
                        <div class="row ml-1">
                            <div class="form-check col-md-4 text-white">
                                <input type="checkbox" class="form-check-input" id="chkdiferenciar_tipo" value="SI">
                                <label class="form-check-label font-weight-bold" for="chkdiferenciar_tipo">Diferenciar Tipo</label>
                            </div>
                            <p>(util para ASM, para obtener los consumos individualizados por tipo (Propias y Franquicias))</p>
                        </div>
                    </div>

                    <!-- <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="sucursales">
                        <label class="form-check-label" for="sucursales">Diferenciar Sucursales</label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="articulos">
                        <label class="form-check-label" for="articulos">Diferenciar Artículos</label>
                    </div> -->
                    <!-- Aquí puedes añadir más opciones de búsqueda -->
                    <div>
                        <button type="submit" class="btn btn-primary">Buscar</button>
                    </div>
            </form>
            <!-- Aquí iría la tabla de resultados -->
            <div class="p-3">
                <table class="table table-striped text-center">
                    <thead class="thead-dark">
                        <tr>
                            <?php
                            foreach ($results[0] as $key => $value) {
                                // echo '<th>' . $key . '</th>';
                                // Reemplaza las claves con los nombres deseados
                                switch ($key) {
                                    case 'NOMBRE_EMPRESA':
                                        echo '<th>Nombre de la Empresa</th>';
                                        break;
                                    case 'CANTIDAD_TOTAL':
                                        echo '<th>Cantidad Total</th>';
                                        break;
                                    case 'TOTAL_IMPORTE':
                                        echo '<th>Total Importe (€)</th>';
                                        break;
                                    case 'TOTAL_PRECIO_COSTE_PEDIDO':
                                        echo '<th>Total Precio Coste Pedido (€)</th>';
                                        break;
                                    case 'UNIDADES_DEVUELTAS':
                                        echo '<th>Unidades Devueltas</th>';
                                        break;
                                    case 'TOTAL_IMPORTE_DEVOLUCIONES':
                                        echo '<th>Total Importe Devoluciones (€)</th>';
                                        break;
                                    case 'CANTIDAD_NETA':
                                        echo '<th>Cantidad Neta</th>';
                                        break;
                                    case 'TOTAL_IMPORTE_NETO':
                                        echo '<th>Total Importe Neto</th>';
                                        break;
                                    default:
                                        echo '<th>' . $key . '</th>';
                                        break;
                                }
                            } ?>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($results as $row) { ?>
                            <tr>
                                <td><?= $row['NOMBRE_EMPRESA']; ?></td>
                                <td><?= $row['CANTIDAD_TOTAL']; ?></td>
                                <td><?= number_format($row['TOTAL_IMPORTE'], 2) . ' €'; ?></td>
                                <td><?= number_format($row['TOTAL_PRECIO_COSTE_PEDIDO'], 2) . ' €'; ?></td>
                                <td><?= $row['UNIDADES_DEVUELTAS']; ?></td>
                                <td><?= $row['TOTAL_IMPORTE_DEVOLUCIONES']; ?></td>
                                <td><?= $row['CANTIDAD_NETA']; ?></td>
                                <td><?= $row['TOTAL_IMPORTE_NETO']; ?></td>
                            </tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>


        </div>
    </div>
  


<script lang="JavaScript" type="text/javascript">         
   

        //getempresas();

        // ===============================================================================
        j$(document).ready(function() {
            j$("#menu_pedidos").addClass('active')

            j$('#sidebarCollapse').on('click', function() {
                j$('#sidebar').toggleClass('active');
                j$(this).toggleClass('active');
            });


            //para que se configuren los popover-titles...
            j$('[data-toggle="popover"]').popover({
                html: true
            });

            j$('[data-toggle="popover_datatable"]').popover({
                html: true,
                container: 'body'
            });

            j$('#cmbestados').multiselect({
                enableClickableOptGroups: true,
                buttonWidth: '100%',
                nonSelectedText: 'Seleccionar'
            });

            $('#radioArticulo').change(function() {
                if ($(this).is(':checked')) {
                    $('#descripcionRadioDiv').show();
                } else {
                    $('#descripcionRadioDiv').hide();
                }
            });
        });
    </script>
</body>

</html>