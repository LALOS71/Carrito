<%@ language=vbscript %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script src="smtp.js">
//componente extraido de https://smtpjs.com/
</script>



<script language="javascript">
/*
Email.send({
    SecureToken : "C973D7AD-F097-4B95-91F4-40ABC5567812",
    To : 'them@website.com',
    From : "you@isp.com",
    Subject : "This is the subject",
    Body : "And this is the body",
	Attachments : [
	{
		name : "smtpjs.png",
		path : "https://networkprogramming.files.wordpress.com/2017/11/smtpjs.png"
	}]
}).then(
  message => alert(message)
);
*/


enviar_email_adjunto = function() {
	mensaje=Email.send({
		Host : "smtp.gmail.com",
		Username : "malba@globalia-artesgraficas.com",
		Password : "bjtlioqjeqmltddt",
		To : 'manuel.alba.gallego@gmail.com',
		From : "malba@globalia-artesgraficas.com",
		Subject : "Probando Envio Correo Desde Javascript",
		Body : "<br><br><b>hola</b>",
		Attachments : [
			{
				name : "imagen_ejemplo.jpg",
				path : "http://1.bp.blogspot.com/_8GtRvOur8pQ/S0XwES-MewI/AAAAAAAAABc/5Ez0Fhw7XhY/S220-s80/DSC00174t.jpg"
			}]
	})
	console.log('mensaje recibido: ' + mensaje)
	/*.then(
	  message => alert(message)
	);*/
}
enviar_email = function() {
	Email.send({
		Host : "smtp.gmail.com",
		Username : "malba@globalia-artesgraficas.com",
		Password : "bjtlioqjeqmltddt",
		To : 'manuel.alba.gallego@gmail.com',
		From : "malba@globalia-artesgraficas.com",
		Subject : "Probando Envio Correo Desde Javascript",
		Body : "hola"
	}).then(
	  message => alert(message)
	);
}

enviar_email2 = function() {
	Email.send({
		Host : "smtp.gmail.com",
		Username : "malba@globalia-artesgraficas.com",
		Password : "bjtlioqjeqmltddt",
		To : 'manuel.alba.gallego@gmail.com',
		From : "malba@globalia-artesgraficas.com",
		Subject : "Probando Envio Correo Desde Javascript",
		Body : "hola"
	}).then(function (message)
			{alert(message)}
			, function (reason)
				{alert(reason)}
	);
}


</script>
<TITLE>Envio Correo desde Javascript</TITLE>
</HEAD>
   
<BODY>
PROBANDO EL ENVIO DE EMAILS DESDE JAVASCRIPT

<input type="button" value="enviar" onclick="enviar_email()"/>
<input type="button" value="enviar adjunto" onclick="enviar_email_adjunto()"/>
</BODY>
</HTML>
