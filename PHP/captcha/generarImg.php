<?php
// require_once __DIR__.'/vendor/autoload.php';
include_once './vendor/autoload.php';
include_once  "./Gregwar/Captcha/PhraseBuilderInterface.php";
include_once  "./Gregwar/Captcha/PhraseBuilder.php";
include_once  "./Gregwar/Captcha/CaptchaBuilderInterface.php";
include_once  "./Gregwar/Captcha/CaptchaBuilder.php";
use Gregwar\Captcha\PhraseBuilder;
use Gregwar\Captcha\CaptchaBuilder;
$builder = new CaptchaBuilder;
$builder->build(450,150);

?>