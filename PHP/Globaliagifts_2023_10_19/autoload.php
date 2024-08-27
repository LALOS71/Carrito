<?php

require_once("classes/MyAutoLoader.php");

new MyAutoLoader(__DIR__ . '\classes');
new MyAutoLoader(__DIR__ . '\controllers');
new MyAutoLoader(__DIR__ . '\entities');
new MyAutoLoader(__DIR__ . '\models');

