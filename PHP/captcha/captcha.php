<?php 
    include_once "./generarImg.php";
    $json = array(
        "img"=> $builder->inline(),
        "solucion"=> $builder->getPhrase(),
    );
    echo json_encode($json);
?>