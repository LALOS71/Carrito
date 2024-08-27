<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Maletas</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="menu_aplicacion">
      <ul class="nav navbar-nav">
	  		<%if session("perfil_usuario")="ADMINISTRADOR" then%>
				<li id="menu3" title="Altas"><a href="Altas_Pir.asp">Altas</a></li>
			<%end if%>
		    <li id="menu2" title="Consultar Incidencias"><a href="Consulta_Incidencias.asp">Consultar</a></li>
			<%if session("perfil_usuario")="ADMINISTRADOR" then%>
				<li id="menu1" title="Importar Fichero de Incidencias"><a href="Importar_PIR.asp">Importar</a></li>
				<li id="menu4" title="Mantenimientos"><a href="Mantenimientos.asp">Mantenimientos</a></li>
			<%end if%>
			<li id="menu5" title="Log Out"><a href="Login.asp">Logout</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">Usuario:&nbsp;<%=session("nombre_usuario")%>(<%=session("usuario")%>)&nbsp;|&nbsp;Perfil:&nbsp;<%=session("perfil_usuario")%></a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
