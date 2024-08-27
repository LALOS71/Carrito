<?php
//include_once "conexion.php";
include_once('../conexionArtesGraficas.php');



// Consulta a la base de datos "artes_graficas"
try {
    $sql = "SELECT ID, CODIGO_SAP, DESCRIPCION FROM ARTICULOS ORDER BY 2";
    $articulos = $conn->query($sql)->fetchAll(PDO::FETCH_ASSOC);
     
} catch (PDOException $e) {
    echo "Error al realizar la consulta en artes_graficas: " . $e->getMessage();
}

// Consulta a la base de datos "GAG"
try {
    $query = "SELECT * FROM V_EMPRESAS ORDER BY EMPRESA";
    $empresas = $conn->query($query)->fetchAll(PDO::FETCH_ASSOC);  
    
} catch (PDOException $e) {
    echo "Error al realizar la consulta en GAG: " . $e->getMessage();
}


echo "<br>entrando....";


/* include "./Menu_Hamburguesa.asp"; */

// para que no se desborde el buffer
ob_start();

session_start();
?>

<!doctype html>
<html lang="es">

<head>
  <link rel="stylesheet" type="text/css" href="css/estilos.css">
  <link rel="stylesheet" type="text/css" href="css/style_menu_hamburguesa5.css">

  <!-- Bootstrap CSS -->   
  <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"/>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.23/css/dataTables.bootstrap4.min.css">
  <link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.6.5/css/buttons.dataTables.min.css">

  <script src="./js/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

 <!-- datatables con bootstrap -->
 <script src="https://cdn.datatables.net/1.10.23/js/jquery.dataTables.min.js"></script>
 <script src="https://cdn.datatables.net/1.10.23/js/dataTables.bootstrap4.min.js"></script>

 <!-- Para usar los botones -->
 <script src="https://cdn.datatables.net/buttons/1.6.5/js/dataTables.buttons.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
 <script src="https://cdn.datatables.net/buttons/1.6.5/js/buttons.html5.min.js"></script>


<!-- Para los estilos en Excel     -->
<script src="https://cdn.jsdelivr.net/npm/datatables-buttons-excel-styles@1.1.1/js/buttons.html5.styles.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/datatables-buttons-excel-styles@1.1.1/js/buttons.html5.styles.templates.min.js"></script>

  <!-- <script language="javascript" src="Funciones_Ajax.js" defer></script> -->
  <script lang="JavaScript" src="./js/archivos.js"></script>
  <title>Informes Pedidos</title>
 
</head>

<body> 

  <div class="wrapper">
    <?php include "Menu_Hamburguesa.asp";?> <!-- incluye menu lateral  -->

    <!-- Page Content Holder -->
    <div class="container-fluid" id="content"style="background-color: #EBE7ED;">

      <!-- <div id="content"> -->
        <button type="button" id="sidebarCollapse" class="navbar-btn active">
          <span></span>
          <span></span>
          <span></span>
        </button>

      <!--********************************************
      contenido de la pagina
      ****************************-->

     <div class="container-fluid" style="background-color: #EBE7ED;">
      <h3 class="text-center">INFORMES</h3>
      <h6>Opciones de Búsqueda</h6>
      <form action="prueba.php" method="post" id="form">
        <div class="form-group">
          <div class="container-fluid rounded" style="background-color: #DCDCDC;">
            <label for="grupoPor">Agrupar Por:</label>
            <div class="row ml-1">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="grupoPor" id="radioEmpresa" value="Empresa">
                <label class="form-check-label" for="radioEmpresa">Empresa</label>
              </div>
              <div class="form-group col-md-4" id="EmpresaDiv">
                <select class="form-control" id="selectEmpresas">
                  <option value="">* TODAS *</option>
                  <?php //echo $empresas;
                      foreach ($empresas as $row) {
                          echo "<option value='" . $row['ID'] . "'>" . $row['EMPRESA'] . "</option>";
                      }
                  ?>
                </select>
              </div>

              <!-- <div id="combo_empresas">Seleccione Provincia</div> -->

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

            </div>
            <!-- <div class="form-check ml-1">
              <input class="form-check-input" type="checkbox" name="grupoPor" id="checkReservas" value="reservas">
              <label class="form-check-label" for="checkReservas">Reservas ASM/GLS</label>
            </div> -->
          </div>
          <div class=" container-fluid rounded" style="background-color: #B0C4DE;">
            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label for="fechaInicio">Fecha Inicio:</label>
                  <input type="date" class="form-control" id="fechaInicio">
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label for="fechaFin">Fecha Fin:</label>
                  <input type="date" class="form-control" id="fechaFin">
                </div>
              </div>
              <div class="col-md-4 align-self-end">
                  <div class="form-group">
                      <input type="submit" class="btn btn-primary" id="btnEnviar" value="Buscar">
                  </div>
              </div>
            </div>
          </div>

          <div class="container-fluid rounded p-2 " style="background-color: #D2B4DE;" id="divEmpresas">
            <div class="row ml-1">
              <div class="form-check col-md-4">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_empresas">
                <label class="form-check-label font-weight-bold text-white" for="chkdiferenciar_sucursales">Diferenciar Empresas</label>
              </div>
            </div>
          </div>

          <div class="container-fluid rounded p-2" style="background-color: #355CFF;">
            <div class="row ml-1">
              <div class="form-check col-md-4">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_sucursales">
                <label class="form-check-label font-weight-bold text-white" for="chkdiferenciar_sucursales">Diferenciar Sucursales</label>
              </div>
              <p class="text-white ">(util para obtener los consumos detallados de cada oficina de la empresa seleccionada)</p>
            </div>
          </div>

          <div class="container-fluid rounded bg-info p-2" style="margin-bottom: -15px;" id="divArticulos">
            <div class="row ml-1">
              <div class="form-check col-md-3 text-white">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_articulos" value="SI"> <!--  onclick="activar_articulos_sin_consumo()"> -->
                <label class="form-check-label font-weight-bold" for="chkdiferenciar_articulos">Diferenciar Artículos</label>
              </div>
              <p class="text-white">(util para obtener los consumos detallados de cada uno de los productos asociados a la empresa seleccionada)</p>
            </div>
            <div class="form-group text-white d-flex justify-content-end" id="filaArticulosSinConsumo">
              <div class="form-check col-md-4" >
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_rappel" value="SI">
                <label class="form-check-label font-weight-bold" for="chkdiferenciar_rappel">Mostrar Información Rappel</label>
              </div>
              <div class="form-check col-md-4">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_costes" value="SI">
                <label class="form-check-label font-weight-bold" for="chkdiferenciar_costes">Mostrar Costes, Proveedor y Ref. Prov.</label>
              </div>
            </div>
          </div>

          <div class="container-fluid rounded p-2" style="background-color: #E6E6FA;">
            <div class="row ml-1">
              <div class="form-check col-md-4">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_marca" value="SI">
                <label class="form-check-label font-weight-bold" for="chkdiferenciar_marca">Diferenciar Marca</label>
              </div>
              <p>(util para BARCELÓ, para obtener los consumos individualizados por marca (Barcelo, Confort, Premium))</p>
            </div>
          </div>

          <div class="container-fluid rounded p-2 rounded bg-secondary">
            <div class="row ml-1">
              <div class="form-check col-md-4 text-white">
                <input type="checkbox" class="form-check-input" id="chkdiferenciar_tipo" value="SI">
                <label class="form-check-label font-weight-bold" for="chkdiferenciar_tipo">Diferenciar Tipo</label>
              </div>
              <p class="text-white">(util para ASM, para obtener los consumos individualizados por tipo (Propias y Franquicias))</p>
            </div>

          </div>

          <div class="container-fluid rounded p-2" style="background-color: #B5B0B7;" id="divPedidos">
            <div class="row ml-1">
              <div class="form-check col-md-4">
                <input type="checkbox" class="form-check-input" id="chkpedidos_parciales" value="SI">
                <label class="form-check-label font-weight-bold" for="chkpedidos_parciales">Mostrar Pedidos Enviados</label>
              </div>
              <p class="text-white ">(Util para el sector contable obtener solo Pedidos Enviados)</p>
            </div>
          </div>

          <!-- ================================================================================== -->

          <!-- <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="sucursales">
                        <label class="form-check-label" for="sucursales">Diferenciar Sucursales</label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="articulos">
                        <label class="form-check-label" for="articulos">Diferenciar Artículos</label>
                    </div> -->
          <!-- Aquí puedes añadir más opciones de búsqueda -->
        </div>

       <!--  <div>
          <button type="submit" class="btn btn-primary" id="btnEnviar">Buscar</button>
        </div> -->
      </form>
      <!-- Aquí iría la tabla de resultados -->
      <div class="p-3 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="tabla_resultados">
        <table class="table table-striped text-center dataTable" id="tableGeneral">
          <thead >
          </thead>
          <tbody>
            <!-- Los datos se cargarán aquí tabla general -->
          </tbody>
        </table>
      </div>
      <div class="p-3 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="div_resultados">
        <!-- <table class="table table-striped text-center dataTable" id="tableresultados"></table> -->
        <table id="dataTable" class="table table-striped table-bordered dataTable" style="width:100%">
          <thead>
          </thead>
          <tbody>
            <!-- Los datos se cargarán aquí los filtros de empresas o Articulos-->
          </tbody>
        </table>
      </div>

      <div class="p-3 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="div_resultados2">
        <!-- <table class="table table-striped text-center dataTable" id="tableresultados"></table> -->
        <table id="dataTable2" class="table table-striped table-bordered dataTable" style="width:100%">
          <thead>
          </thead>
          <tbody>
            <!-- Los datos se cargarán aquí los filtros de empresas o Articulos-->
          </tbody>
        </table>
      </div>

      <div class="p-3 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="div_resultados3">
        <!-- <table class="table table-striped text-center dataTable" id="tableresultados"></table> -->
        <table id="dataTable3" class="table table-striped table-bordered dataTable" style="width:100%">
          <thead>
          </thead>
          <tbody>
            <!-- Los datos se cargarán aquí los filtros de empresas o Articulos-->
          </tbody>
        </table>
      </div>
      <div class="p-3 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="div_resultados4">
        <!-- <table class="table table-striped text-center dataTable" id="tableresultados"></table> -->
        <table id="dataTable4" class="table table-striped table-bordered dataTable" style="width:100%">
          <thead>
          </thead>
          <tbody>
            <!-- Los datos se cargarán aquí los filtros de empresas o Articulos-->
          </tbody>
        </table>
      </div>
  
    </div> <!-- fin content -->
  </div> <!-- fin wrapper -->

</body>

</html>