// js\archivos.js
// Definición de la clase Boton
class Boton {
    constructor(texto, clase, excelStyles, filename, title) {
        this.texto = texto;
        this.clase = clase;
        this.excelStyles = excelStyles;
        this.filename = filename;
        this.title = title;
    }

    // Método para inicializar el botón
    inicializarBoton() {
        return {
            extend: "excel",
            text: this.texto,
            className: 'btn ' + this.clase,
            excelStyles: this.excelStyles,
            filename: 'Listado_Consumos', 
            title: 'INFORME DE CONSUMOS CON LAS SIGUIENTES CARACTERISTICAS:',               

            exportOptions: {
                columns: ':visible',
                modifier: {
                    search: 'applied',
                    order: 'applied'
                },
                format: {
                    body: function (data, row, column, node) {                        
                        if (typeof data === 'string' && data.includes('€')) {
                            return parseFloat(data.replace('€', '').replace(/\./g, '').replace(',', '.'));
                        }                        
                        return data;                        
                    }
                }
            },
            customize: function (xlsx) {
                var sheet = xlsx.xl.worksheets['sheet1.xml'];
                $d(sheet).find('sheetData').attr('name', 'Listados_Consumos'); 
                var sheetNames = xlsx.xl['workbook.xml'].getElementsByTagName('sheet');
                sheetNames[0].setAttribute('name', 'Listado_Consumos');
            }
        };
    }
}

// Crear una instancia de la clase Boton
let botonExcel = new Boton('Exportar a Excel', 'btn-outline-success', {
    "template": [
        "blue_medium",
        "header_green",
        "title_medium"
    ]
});


var $d = jQuery.noConflict();
opcion = 1;
var valorSeleccionado = '';
var fechaInicio = '';
var fechaFin = '';

$d(document).ready(function () {
    

    $d('#btnEnviar').attr('disabled', true);
    
    $d('#div_resultados').hide();
    $d('#div_resultados2').hide();
    $d('#div_resultados3').hide();
    $d('#div_resultados4').hide();
    $d('#selectEmpresas').prop('disabled', true).trigger('change.select2');
    $d('#selectArticulo').prop('disabled', true).trigger('change.select2');

    fechaInicio = $d('#fechaInicio').val();
    fechaFin = $d('#fechaFin').val();

    $d('#radioEmpresa').click(function () {
        if ($d(this).is(':checked')) {
            $d('#selectEmpresas').prop('disabled', false).trigger('change.select2');
            $d('#selectArticulo').prop('disabled', true).trigger('change.select2');
            $d('#divEmpresas').hide();
            $d('#divArticulos').show();
            $d('#btnEnviar').attr('disabled', false);

            $d('#fechaInicio').attr('disabled', false);
            $d('#fechaFin').attr('disabled', false);
        }
    });

    $d('#radioArticulo').click(function () {
        if ($d(this).is(':checked')) {
            $d('#selectArticulo').prop('disabled', false).trigger('change.select2');
            $d('#selectEmpresas').prop('disabled', true).trigger('change.select2');
            $d('#divEmpresas').show();
            $d('#divArticulos').hide();
            $d('#btnEnviar').attr('disabled', false);

            $d('#fechaInicio').attr('disabled', false);
            $d('#fechaFin').attr('disabled', false);
        }
    });

    tablaGeneral = $d('#tableGeneral').DataTable({
        "ajax": {
            "url": "prueba.php",
            "method": 'POST',
            "data": { opcion: opcion },
            "dataSrc": ""
        },
        columns: [
            { title: "Nombre de la Empresa", data: "NOMBRE_EMPRESA" },
            { title: "Cantidad Total", data: "CANTIDAD_TOTAL" },
            { title: "Total Importe (€)", data: "TOTAL_IMPORTE" },
            { title: "Total Coste (€)", data: "TOTAL_PRECIO_COSTE_PEDIDO" },
            { title: "Unidades Devueltas", data: "UNIDADES_DEVUELTAS" },
            { title: "Total Importe Devoluciones (€)", data: "TOTAL_IMPORTE_DEVOLUCIONES" },
            { title: "Cantidad Neta", data: "CANTIDAD_NETA" },
            { title: "Total Importe Neto (€)", data: "TOTAL_NETO" },
        ],
        columnDefs: [           
            {
                targets: [1, 4, 6],
                render: function (data, type, row, meta) {
                    return parseInt(data).toLocaleString('es-ES'); // Mostrar números enteros con puntos de miles
                }
            },
            {
                targets: [2, 3, 5, 7],
                render: function (data, type, row, meta) {
                    return parseFloat(data).toLocaleString('es-ES', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    }) + ' €'; // Mostrar valores decimales con comas y puntos de miles
                }
            }
        ],
        dom: "Bfrtip",
        buttons: [botonExcel.inicializarBoton()],
        //Para cambiar el lenguaje a español
        "language": {
            "lengthMenu": "Mostrar _MENU_ registros",
            "zeroRecords": "No se encontraron resultados",
            "info": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "infoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
            "sSearch": "Buscar:",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "Último",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
            "sProcessing": "Procesando...",
        }
    });
//$d("#menu_pedidos").addClass('active')

  /*   $d('#sidebarCollapse').on('click', function () {
        $d('#sidebar').toggleClass('active');
        $d(this).toggleClass('active');
    }); */

     /* $d('#sidebarCollapse').on('click', function () {
        $d('.wrapper').toggleClass('toggled');
    });  */

    $d("select").select2({
        tags: "true",
        //allowClear: true
    });


    $d('#form').on('submit', function (event) {
        event.preventDefault(); // Evitar que el formulario se envíe normalmente 

        var filtros = {};

        // Verificar los checkboxes marcados y construir el objeto filtros
        $d('input[type="checkbox"]').each(function () {
            var difCheckbox = $d(this).attr('id');
            if ($d(this).is(':checked')) {
                filtros[difCheckbox] = true;
                console.log(filtros);
            }
        });

        $d('#chkdiferenciar_articulos').change(function() {
            // Obtener el estado del checkbox chkdiferenciar_articulos
            var isChecked = $d(this).is(':checked');            
            // Habilitar o deshabilitar los otros checkboxes según el estado de chkdiferenciar_articulos
            if (isChecked) {                
                $d('#chkdiferenciar_rappel, #chkdiferenciar_costes').prop('disabled', false);
            } else {
                $d('#chkdiferenciar_rappel, #chkdiferenciar_costes').prop('disabled', true);
                // Desmarcar los checkboxes si están marcados
                $d('#chkdiferenciar_rappel, #chkdiferenciar_costes').prop('checked', false);
            }
        });

        // Determinar el valor seleccionado        
        if ($d('#radioEmpresa').is(':checked')) {
            valorSeleccionado = $d('#selectEmpresas').val();
            if (!$d.isEmptyObject(filtros)) {
                valorSeleccionado = $d('#selectEmpresas').val();
               // alert("hay filtros seleccionados Empresas " + valorSeleccionado + " - " + $d('#fechaInicio').val() + " - " + $d('#fechaFin').val());
                enviarFiltros(4, valorSeleccionado, $d('#fechaInicio').val(), $d('#fechaFin').val(), filtros);
            } else {
                empresas(2, valorSeleccionado, $d('#fechaInicio').val(), $d('#fechaFin').val());
            }

        } else if ($d('#radioArticulo').is(':checked')) {
            valorSeleccionado = $d('#selectArticulo').val();
            if (!$d.isEmptyObject(filtros)) {
                valorSeleccionado = $d('#selectArticulo').val();
              // alert("hay filtros seleccionados Articulos " + valorSeleccionado + " - " + $d('#fechaInicio').val() + " - " + $d('#fechaFin').val());
                enviarFiltrosart(5, valorSeleccionado, $d('#fechaInicio').val(), $d('#fechaFin').val(), filtros);
            } else {
                articulos(3, valorSeleccionado, $d('#fechaInicio').val(), $d('#fechaFin').val());
            }
        }       

        $d('#tabla_resultados').hide(); // Ocultar la tabla principal 

    });


    function empresas(option, selectedValue, fechaInicio, fechaFin) {
       // alert("ingrese a funcion Empresas " + option + " - " + selectedValue + " - " + fechaInicio + " - " + fechaFin);
        $d.ajax({
            url: 'prueba.php',
            method: 'POST',
            data: { opcion: option, selectedValue: selectedValue, fechaInicio: fechaInicio, fechaFin: fechaFin },
            dataType: "JSON",
            success: function (response) {
                console.log(response);
                if (response.length === 0) {
                    alert("NO Hay Consumos Que Cumplan El Critero de Búsqueda...");
                    $d('#tabla_resultados').show();
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados3').hide();
                    $d('#div_resultados4').hide();
                    return;
                } else {
                    $d('#div_resultados2').hide();

                    $d('#div_resultados').show();
                    if ($d.fn.DataTable.isDataTable('#dataTable')) {
                        $d('#dataTable').DataTable().destroy();
                    }

                    $d('#dataTable').DataTable({
                        data: response,
                        dataSrc: '',
                        columns: [
                            { title: "Nombre de la Empresa", data: "NOMBRE_EMPRESA" },
                            { title: "Cantidad Total", data: "CANTIDAD_TOTAL" },
                            { title: "Total Importe (€)", data: "TOTAL_IMPORTE" },
                            { title: "Total Coste (€)", data: "TOTAL_PRECIO_COSTE_PEDIDO" },
                            { title: "Unidades Devueltas", data: "UNIDADES_DEVUELTAS" },
                            { title: "Total Importe Devoluciones (€)", data: "TOTAL_IMPORTE_DEVOLUCIONES" },
                            { title: "Cantidad Neta", data: "CANTIDAD_NETA" },
                            { title: "Total Importe Neto (€)", data: "TOTAL_NETO" },
                           // { title: "Estado", data: "ESTADO" },

                        ],
                        columnDefs: [                           
                            {
                                targets: [1, 4, 6],
                                render: function (data, type, row, meta) {
                                    return parseInt(data).toLocaleString('es-ES'); // Mostrar números enteros con puntos de miles
                                }
                            },
                            {
                                targets: [2, 3, 5, 7],
                                render: function (data, type, row, meta) {
                                    return parseFloat(data).toLocaleString('es-ES', 
                                        { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' €';
                                }
                            }

                        ],
                        dom: "Bfrtip",
                        buttons: [botonExcel.inicializarBoton()],
                        //Para cambiar el lenguaje a español
                        "language": {
                            "lengthMenu": "Mostrar _MENU_ registros",
                            "zeroRecords": "No se encontraron resultados",
                            "info": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                            "infoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
                            "sSearch": "Buscar:",
                            "oPaginate": {
                                "sFirst": "Primero",
                                "sLast": "Último",
                                "sNext": "Siguiente",
                                "sPrevious": "Anterior"
                            },
                            "sProcessing": "Procesando...",
                        }

                    });
                }
            },
            error: function (xhr, status, error) {
                console.error(error);
            }
        });
    }

    function articulos(option, selectedValue, fechaInicio, fechaFin) {
       // alert("ingrese a funcion Articulos " + option + " " + selectedValue + " - " + fechaInicio + " - " + fechaFin);
        $d.ajax({
            url: 'prueba.php',
            method: 'POST',
            data: { opcion: option, selectedValue2: selectedValue, fechaInicio: fechaInicio, fechaFin: fechaFin },
            dataType: "JSON",
            success: function (response) {
                console.log(response);
                if (response.length === 0) {
                    alert("NO Hay Consumos Que Cumplan El Critero de Búsqueda...");
                    $d('#tabla_resultados').show();
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados3').hide();
                    $d('#div_resultados4').hide();
                    return;
                } else {
                    $d('#div_resultados').hide();                    
                    $d('#div_resultados3').hide();
                    $d('#div_resultados4').hide();

                    $d('#div_resultados2').show();
                    if ($d.fn.DataTable.isDataTable('#dataTable2')) {
                        $d('#dataTable2').DataTable().destroy();
                    }                                           
                    // Parsear la respuesta en caso de que no sea un objeto
                    var data = typeof response === 'string' ? JSON.parse(response) : response;

                        data.forEach(function(data) { 
                            var totalImporte = parseFloat(data['TOTAL_IMPORTE']);
                            //var valorRappel = isNaN(parseInt(data['VALOR_RAPPEL'])) ? 0 : parseInt(data['VALOR_RAPPEL']);
                            var totalImporteDevoluciones = parseFloat(data['TOTAL_IMPORTE_DEVOLUCIONES']);

                            var calculo = (totalImporte - totalImporteDevoluciones);
                            var cantidadNeta = (data["CANTIDAD_TOTAL"] - data["UNIDADES_DEVUELTAS"]);
                           /*  console.log('TOTALIMPORTE ' + totalImporte);
                            console.log('CANTIDAD NETA ' + cantidadNeta);
                            console.log('calculo ' + calculo);
                            console.log('IMPORTDEV ' + totalImporteDevoluciones); */
                            
                            data["TOTAL_IMPORTE_NETO"] = calculo;
                           // console.log('TOTAL IMPORTE NETO ' + data["TOTAL_IMPORTE_NETO"]);
                            data["CANTIDAD_NETA"] = cantidadNeta;
                           // console.log('CANTIDAD NETA ' + data["CANTIDAD_NETA"]);

                        });
                                                          

                    $d('#dataTable2').DataTable({
                        data: response,
                        dataSrc: '',
                        columns: [
                            { title: "Cod. Sap", data: "CODIGO_SAP" },//0
                            { title: "Descripción", data: "ARTICULO" },//1
                            { title: "Unidades Pedido", data: "UNIDADES_DE_PEDIDO" },//2
                            { title: "Cantidad Total", data: "CANTIDAD_TOTAL" },//3
                            { title: "Total Importe", data: "TOTAL_IMPORTE" },//4
                            { title: "Total Coste (€)", data: "TOTAL_PRECIO_COSTE_PEDIDO" },//5
                            { title: "Unidades Devueltas", data: "UNIDADES_DEVUELTAS" },//6
                            { title: "Total Importe Devoluciones (€)", data: "TOTAL_IMPORTE_DEVOLUCIONES" },//7
                            { title: "Cantidad Neta", data: "CANTIDAD_NETA" },//8
                            { title: "Total Importe Neto (€)", data: "TOTAL_IMPORTE_NETO" },//9
                            //{ title: "Estado", data: "ESTADO" },//10
                        ],
                        columnDefs: [                           
                            {
                                targets: [3, 6, 8],
                                render: function (data, type, row, meta) {
                                    return parseInt(data).toLocaleString('es-ES'); // Mostrar números enteros con puntos de miles
                                    //return parseInt(data);
                                }
                            },  
                            {
                                targets: [4,5,7,9],
                                render: function (data, type, row, meta) {
                                    // Si el valor es nulo, vacío o no numérico, mostrar cero
                                    if (data === null || data === '' || isNaN(data)) {
                                        return '0';
                                    } //else {
                                        //return parseFloat(data).toFixed(2).replace('.', ',') + ' €';
                                        return parseFloat(data).toLocaleString('es-ES', {
                                            minimumFractionDigits: 2,
                                            maximumFractionDigits: 2
                                        }) + ' €'; // Mostrar valores decimales con comas y puntos de miles
                                    //}
                                }                                
                            }
                        ],
                        dom: "Bfrtip",
                        buttons: [botonExcel.inicializarBoton()],
                        //Para cambiar el lenguaje a español
                        "language": {
                            "lengthMenu": "Mostrar _MENU_ registros",
                            "zeroRecords": "No se encontraron resultados",
                            "info": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                            "infoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
                            "sSearch": "Buscar:",
                            "oPaginate": {
                                "sFirst": "Primero",
                                "sLast": "Último",
                                "sNext": "Siguiente",
                                "sPrevious": "Anterior"
                            },
                            "sProcessing": "Procesando...",
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error(error);
            }
        });
    }

    function enviarFiltros(option, selectedValue, fechaInicio, fechaFin, filtros) {
         /* alert("ingrese a funcion Filtros " + option + " - " + selectedValue + " - "
            + fechaInicio + " - " + fechaFin + " - " + filtros);  */
        $d.ajax({
            url: 'prueba.php',
            method: 'POST',
            data: {
                opcion: option,
                filtros: filtros,
                selectedValue: selectedValue,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin
            },
            dataType: 'json',
            success: function (response) {
                console.log(response);
                if (response.length === 0) {
                    alert("NO Hay Consumos Que Cumplan El Critero de Búsqueda...");
                    $d('#tabla_resultados').show();
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados3').hide();
                    $d('#div_resultados4').hide();
                    return;
                } else {
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados4').hide();

                    $d('#div_resultados3').show();
                    if ($d.fn.DataTable.isDataTable('#dataTable3')) {
                        $d('#dataTable3').DataTable().destroy();
                    }

                    // Parsear la respuesta en caso de que no sea un objeto
                    var data = typeof response === 'string' ? JSON.parse(response) : response;                   
                   
                    // Verificar si los datos contienen los campos deseados
                    var hasCodCliente = data.length > 0 && data[0].hasOwnProperty('CODCLIENTE');
                    var hasNombre = data.length > 0 && data[0].hasOwnProperty('NOMBRE');
                  //  var hasEstado = data.length > 0 && data[0].hasOwnProperty('ESTADO');
                                        
                    var isChecked = filtros['chkdiferenciar_sucursales'] ? true : false;                        
                    var isChecked1 = filtros['chkdiferenciar_articulos'] ? true : false;                        
                        var isChecked2 = (filtros['chkdiferenciar_rappel']) ? true : false;
                        var isChecked3 = (filtros['chkdiferenciar_costes']) ? true : false;                    
                    var isChecked4 = (filtros['chkdiferenciar_marca']) ? true : false;
                    var isChecked5 = (filtros['chkdiferenciar_tipo']) ? true : false;                     
                    var isChecked5 = (filtros['chkdiferenciar_tipo']) ? true : false;
                    var showEstado = (filtros['chkpedidos_parciales']) ? true : false;                     
                    //console.log(showEstado1);  
                     /* console.log( ' isChecked ' +  isChecked + ' isChecked1 ' + isChecked1 
                                + ' isChecked2 ' + isChecked2 + ' isChecked3 ' + isChecked3 
                                + ' isChecked4 ' + isChecked4 + ' isChecked5 ' + isChecked5);  */
                    
                    // Realizar el cálculo de Calculo_rappel en el lado del cliente   
                    //* /if(isChecked2 && response['VALOR_RAPPEL'] != '' && (response['TIPO'] == 'AGENCIA' || response['TIPO'] == 'ARRASTRES')){
                    
                    if(isChecked2) { 
                        data.forEach(function(data) { 
                            if (data['TIPO'] == "AGENCIA" || data['TIPO'] == "ARRASTRES") {                      
                                var totalImporte = parseFloat(data['TOTAL_IMPORTE']);
                                var valorRappel = isNaN(parseFloat(data['VALOR_RAPPEL'])) ? 0 : parseFloat(data['VALOR_RAPPEL']);
                                var totalImporteDevoluciones = parseFloat(data['TOTAL_IMPORTE_DEVOLUCIONES']);
                                var calculo = ((totalImporte - totalImporteDevoluciones) * valorRappel)/100;
                                /*var calculoRappel = (calculo * valorRappel / 100);
                                console.log('CLIENTE ' + data['CODCLIENTE']);
                                if(data['CODCLIENTE'] == 9071 )   { 
                                 console.log('TOTALIMPORTE ' + totalImporte);
                                console.log('VALORRAPPEL ' + valorRappel);
                                console.log('calculo ' + calculo);
                                console.log('IMPORTDEV ' + totalImporteDevoluciones);
                                console.log('calculo rappel  ' + calculoRappel); 
                                } */
                                
                                data['CALCULO_RAPPEL'] = calculo;
                            }
                        });
                        
                    }                 
                   
                    /* diferenciar_tipo_seleccionada="SI" then
                    if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" and (consumos("TIPO")="AGENCIA" OR consumos("TIPO")="ARRASTRES") then
                            'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                            if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
                                    Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                                else
                                    Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                            end if
                        else
                            Response.Write("")
                    end if
                    else
                    if consumos("TOTAL_IMPORTE")<>"" and valor_del_rappel<>"" then
                            'Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                            if consumos("TOTAL_IMPORTE_DEVOLUCIONES")<>"" then
                                    Response.Write(FORMATNUMBER(((consumos("TOTAL_IMPORTE") - consumos("TOTAL_IMPORTE_DEVOLUCIONES")) * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                                else
                                    Response.Write(FORMATNUMBER((consumos("TOTAL_IMPORTE") * consumos("VALOR_RAPPEL") / 100),2,-1,0,-1) & "&nbsp;�")
                            end if
                        else
                            Response.Write("")
                    end if
                    end if   */                  
                    // Configurar DataTables para no mostrar advertencias
                    $d.fn.dataTable.ext.errMode = 'none';                                       

                    $d('#dataTable3').DataTable({
                        data: data,
                        dataSrc: '',
                        columns: [
                            { title: "Empresa", data: "NOMBRE_EMPRESA" }, //0
                            { title: "Código", data: "CODCLIENTE", visible: isChecked && hasCodCliente}, //1 
                            { title: "Cliente", data: "NOMBRE", visible: isChecked && hasNombre },//2                            
                            { title: "Cod. Sap", data: "CODIGO_SAP", visible: isChecked1 }, //3
                            { title: "Articulo", data: "DESCRIPCION", visible: isChecked1 }, //4
                            { title: "Unidades Pedido", data: "UNIDADES_DE_PEDIDO", visible: isChecked1 }, //5
                            { title: "Coste", data: "PRECIO_COSTE", visible: isChecked3 }, //6
                            { title: "Proveedor", data: "PROVEEDOR", visible: isChecked3 }, //7
                            { title: "Ref. Prov.", data: "REFERENCIA_DEL_PROVEEDOR", visible: isChecked3 }, //8
                            { title: "Marca", data: "MARCA", visible: isChecked4 },//9
                            { title: "Tipo", data: "TIPO", visible: isChecked5 },//10
                            { title: "Cantidad Total", data: "CANTIDAD_TOTAL" }, //11
                            { title: "Total Importe", data: "TOTAL_IMPORTE" }, //12
                            { title: "Total Coste (€)", data: "TOTAL_PRECIO_COSTE_PEDIDO" }, //13
                            { title: "Unidades Devueltas", data: "UNIDADES_DEVUELTAS" }, //14
                            { title: "Total Importe Dev. (€)", data: "TOTAL_IMPORTE_DEVOLUCIONES" }, //15
                            { title: "Cantidad Neta", data: "CANTIDAD_NETA" }, //16
                            { title: "Total Importe Neto (€)", data: "TOTAL_NETO" }, //17
                            { title: "Rappel", data: "RAPPEL", visible: isChecked2 }, //18
                            { title: "Valor Rappel", data: "VALOR_RAPPEL", visible: isChecked2 }, //19 
                            { title: "Cálculo Rappel", data: "CALCULO_RAPPEL", visible: isChecked2 }, //20
                            { title: "Estado", data: "ESTADO", visible: showEstado }, //21                            
                        ],                       
                        columnDefs: [
                              {
                                targets: [11,14,16],
                                render: function (data, type, row, meta) {
                                    return parseInt(data).toLocaleString('es-ES'); // Mostrar números enteros con puntos de miles
                                    //return parseInt(data);
                                }
                            },  
                            {
                                targets: [6,12,13,15,17,19,20],
                                render: function (data, type, row, meta) {
                                    // Si el valor es nulo, vacío o no numérico, mostrar cero
                                    if (data === NULL || data === '' || isNaN(data)) {
                                        return '0';
                                    } //else {
                                        //return parseFloat(data).toFixed(2).replace('.', ',') + ' €';
                                        return parseFloat(data).toLocaleString('es-ES', {
                                            minimumFractionDigits: 2,
                                            maximumFractionDigits: 2
                                        }) + ' €'; // Mostrar valores decimales con comas y puntos de miles
                                    //}
                                }                                
                            }
                        ],
                        
                        dom: "Bfrtip",
                        buttons: [botonExcel.inicializarBoton()],
                        //Para cambiar el lenguaje a español
                        "language": {
                            "lengthMenu": "Mostrar _MENU_ registros",
                            "zeroRecords": "No se encontraron resultados",
                            "info": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                            "infoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
                            "sSearch": "Buscar:",
                            "oPaginate": {
                                "sFirst": "Primero",
                                "sLast": "Último",
                                "sNext": "Siguiente",
                                "sPrevious": "Anterior"
                            },
                            "sProcessing": "Procesando...",
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error(error);
            }
        });
    }
    function enviarFiltrosart(option, selectedValue, fechaInicio, fechaFin, filtros) {
       /*  alert("ingrese a funcion Filtros " + option + " - " + selectedValue + " - "
            + fechaInicio + " - " + fechaFin + " - " + filtros); */
        $d.ajax({
            url: 'prueba.php',
            method: 'POST',
            data: {
                opcion: option, selectedValue2: selectedValue, fechaInicio: fechaInicio, fechaFin: fechaFin
                , filtros2: filtros
            },
            dataType: "JSON",
            success: function (response) {
                console.log(response);
                if (response.length === 0) {
                    alert("NO Hay Consumos Que Cumplan El Critero de Búsqueda...");
                    $d('#tabla_resultados').show();
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados3').hide();
                    $d('#div_resultados4').hide();
                    return;
                } else {
                    $d('#div_resultados').hide();
                    $d('#div_resultados2').hide();
                    $d('#div_resultados3').hide();
                    

                    $d('#div_resultados4').show();
                    if ($d.fn.DataTable.isDataTable('#dataTable4')) {
                        $d('#dataTable4').DataTable().destroy();
                    } 

                    // Parsear la respuesta en caso de que no sea un objeto
                    var data = typeof response === 'string' ? JSON.parse(response) : response;
                    /* var isChecked = filtros['chkdiferenciar_sucursales'] ? true : false;                        
                    var isChecked1 = filtros['chkdiferenciar_articulos'] ? true : false;                        
                        var isChecked2 = (filtros['chkdiferenciar_rappel']) ? true : false;
                        var isChecked3 = (filtros['chkdiferenciar_costes']) ? true : false;                    
                    var isChecked4 = (filtros['chkdiferenciar_marca']) ? true : false;
                    var isChecked5 = (filtros['chkdiferenciar_tipo']) ? true : false;                     
                    var isChecked5 = (filtros['chkdiferenciar_tipo']) ? true : false;
                    var showEstado = (filtros['chkpedidos_parciales']) ? true : false;    */

                   var isChecked = (filtros['chkdiferenciar_marca']) ? true : false;
                   var isChecked2 = (filtros['chkdiferenciar_tipo']) ? true : false;
                   var isChecked3 = filtros['chkdiferenciar_empresas'] ? true : false; 
                   var showEstado = (filtros['chkpedidos_parciales']) ? true : false;

                    $d('#dataTable4').DataTable({
                        data: data,
                        dataSrc: '',
                        columns: [
                            { title: "Cod. Sap", data: "CODIGO_SAP" },//0   
                            { title: "Descripción", data: "ARTICULO" },//1
                            { title: "Unidades Pedido", data: "UNIDADES_DE_PEDIDO" },//2
                            { title: "Empresa", data: "NOMBRE_EMPRESA" },//3
                            { title: "Codigo", data: "CODCLIENTE",visible: isChecked },//4
                            { title: "Cliente", data: "NOMBRE",visible: isChecked },//5
                            { title: "Marca", data: "MARCA", visible: isChecked },//6
                            { title: "Tipo", data: "TIPO", visible: isChecked2 },//7
                            { title: "Cantidad Total", data: "CANTIDAD_TOTAL" },//8
                            { title: "Total Importe", data: "TOTAL_IMPORTE" },//9
                            { title: "Total Coste (€)", data: "TOTAL_PRECIO_COSTE_PEDIDO" },//10
                            { title: "Unidades Devueltas", data: "UNIDADES_DEVUELTAS" },//11
                            { title: "Total Importe Dev (€)", data: "TOTAL_IMPORTE_DEVOLUCIONES" },//12
                            { title: "Cantidad Neta", data: "CANTIDAD_NETA" },//13
                            { title: "Total Importe Neto (€)", data: "TOTAL_NETO" },//14
                            { title: "Estado", data: "ESTADO", visible: showEstado },//14

                        ],
                        columnDefs: [
                            {
                                targets: [8,11,13],
                                render: function (data, type, row, meta) {
                                    return parseInt(data).toLocaleString('es-ES'); // Mostrar números enteros con puntos de miles
                                    //return parseInt(data);
                                }
                            },
                            {
                                targets: [9,10,12,14], // Índices de las columnas "Total Importe Devoluciones" y "Total Importe Neto"
                                render: function (data, type, row, meta) {                                    
                                    // Si el valor es nulo, vacío o no numérico, mostrar cero
                                    if (data === null || data === '' || isNaN(data)) {
                                        return '0';
                                    } //else {
                                        //return parseFloat(data).toFixed(2).replace('.', ',') + ' €';
                                        return parseFloat(data).toLocaleString('es-ES', {
                                            minimumFractionDigits: 2,
                                            maximumFractionDigits: 2
                                        }) + ' €'; // Mostrar valores decimales con comas y puntos de miles
                                    //}
                                }
                            }
                        ],
                        dom: "Bfrtip",
                        buttons: [botonExcel.inicializarBoton()],
                        //Para cambiar el lenguaje a español
                        "language": {
                            "lengthMenu": "Mostrar _MENU_ registros",
                            "zeroRecords": "No se encontraron resultados",
                            "info": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
                            "infoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
                            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
                            "sSearch": "Buscar:",
                            "oPaginate": {
                                "sFirst": "Primero",
                                "sLast": "Último",
                                "sNext": "Siguiente",
                                "sPrevious": "Anterior"
                            },
                            "sProcessing": "Procesando...",
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error(error);
            }
        });
    }
     

     $d('#sidebarCollapse').on('click', function () {
        $d('.wrapper').toggleClass('toggled');
        $d('#sidebar').toggleClass('active');
        $d('#content').toggleClass('active');
        $d(this).toggleClass('active');        
    });
 




});
