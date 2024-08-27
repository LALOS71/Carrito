<!-- Sidebar Holder -->
        <nav id="sidebar" class="active">
            <div class="sidebar-header">
                <i class="fas fa-user fa-2x fa-fw"></i>
				<small>
					&nbsp;&nbsp;<%=session("nombre_usuario")%>
					<br>(<%=session("usuario")%>)&nbsp;(<%=session("perfil_usuario")%>)
				</small>
            </div>
			
			
            <ul class="list-unstyled components">
				
                <li id="menu_consultas">
                    <a href="Gestion_Graphisoft.asp"><i class="fas fa-map-marked-alt fa-2x fa-fw mr-2"></i>Hojas de Ruta</a>
                </li>

				<li id="menu_consultas">
                    <a href="Presupuestos.asp"><i class="fas fa-file-invoice-dollar fa-2x fa-fw mr-2"></i>Presupuestos</a>
                </li>

				<%if session("perfil_usuario")="ADMINISTRADOR" then%>
				<li id="menu_mantenimientos">
					<a href="#pageMantenimientos" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"><i class="fas fa-tools fa-2x fa-fw mr-2"></i>Mantenimientos</a>
					<ul class="collapse list-unstyled" id="pageMantenimientos">
						<li id="mantenimientos_usuarios"><a href="#"><i class="fas fa-users-cog fa-lg fa-fw mr-2"></i>&nbsp;Gestión Usuarios</a></li>
					</ul>
				</li>
				<li id="menu_informes">
					<a href="#pageInformes" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"><i class="fas fa-clipboard-list fa-2x fa-fw mr-2"></i>Informes</a>
					<ul class="collapse list-unstyled" id="pageInformes">
						<li id="informe_empleados"><a href="Informe_Empleados.asp">Informe Empleados</a></li>
						<li id="informe_stock_valorado"><a href="#">Informe 2</a></li>
						<li id="informe_stock_minimo"><a href="#">Informe 3</a></li>
					</ul>
				</li>
				<%end if%>					
				
            </ul>
        </nav>
		<!--fin del sidebar-->
