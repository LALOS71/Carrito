<?php
include_once("conexion.php");
include "./Menu_Hamburguesa.asp";

// para que no se desborde el buffer
ob_start();

session_start();
?>

<!doctype html>
<html lang="es">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  
  <link rel="stylesheet" href="css/estilos.css">
  <link rel="stylesheet" href="css/style_menu_hamburguesa5.css">
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
  <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
  <!-- <script src="./js/jquery-3.5.1.min.js" defer></script> -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" defer></script>
  <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"></script> -->
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js" defer></script>
  <script language="JavaScript" src="./js/calendar1.js" defer></script>
  <!-- Date only with year scrolling -->
  <!-- <script language="javascript" src="Funciones_Ajax.js" defer></script> -->
  <script lang="JavaScript" src="./js/archivos.js" defer></script>

  <title>Informe Articulos</title>
</head>

<body>
  

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

  <!-- Optional JavaScript; choose one of the two! -->



  <!-- Option 2: jQuery, Popper.js, and Bootstrap JS
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js" integrity="sha384-w1Q4orYjBQndcko6MimVbzY0tgp4pWB4lZ7lr30WKz0vr/aWKhXdBNmNb5D92v7s" crossorigin="anonymous"></script>
    -->
</body>

</html>