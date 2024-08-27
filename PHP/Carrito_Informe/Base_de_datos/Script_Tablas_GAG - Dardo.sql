USE [GAG]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 22/03/2024 10:59:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[IdCliente] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NOT NULL,
	[IdSap] [nvarchar](11) NULL,
	[DelGrupo] [smallint] NULL,
	[COD] [int] NULL,
	[TITULO] [nvarchar](100) NULL,
	[NIF] [nvarchar](15) NULL,
	[DOMICILIO] [nvarchar](100) NULL,
	[Direccion_Envio] [nvarchar](200) NULL,
	[POBLACION] [nvarchar](50) NULL,
	[POBLACIONENVIO] [nvarchar](50) NULL,
	[PROVINCIA] [nvarchar](40) NULL,
	[PROVINCIAENVIO] [nvarchar](40) NULL,
	[CODPOSTAL] [nvarchar](15) NULL,
	[CODPOSTALENVIO] [nvarchar](15) NULL,
	[TELEF01] [nvarchar](50) NULL,
	[FAX01] [nvarchar](20) NULL,
	[EMAIL] [nvarchar](80) NULL,
	[TITULOL] [nvarchar](100) NULL,
	[LIMITE] [float] NULL,
	[DIAS] [nvarchar](10) NULL,
	[FORMA_PAGO] [nvarchar](100) NULL,
	[IdFormaPago] [int] NULL,
	[Texto_Pago] [nvarchar](300) NULL,
	[CUENTA_BANCARIA] [nvarchar](50) NULL,
	[CodExterno] [nvarchar](15) NULL,
	[IdCadena] [int] NULL,
	[PedMinimoConCompromiso] [int] NULL,
	[PedMinimoSinCompromiso] [int] NULL,
	[Contrasena] [nvarchar](105) NULL,
	[FAlta] [datetime] NULL,
	[FBaja] [datetime] NULL,
	[Borrado] [bit] NULL,
	[ReqAutoriza] [bit] NULL,
	[IdTipoCliente] [int] NULL,
	[JefeEconomato] [nvarchar](100) NULL,
	[idMarca] [int] NULL,
	[idTipoPrecio] [int] NULL,
	[idTipo] [int] NULL,
	[idValidadora] [int] NULL,
	[Contacto] [nvarchar](100) NULL,
	[idPais] [int] NULL,
	[idTipoIva] [int] NULL,
	[idTratoEspecial] [int] NULL,
	[CodContable] [varchar](20) NULL,
	[idTipoDocumento] [int] NULL,
	[SALT] [nvarchar](64) NULL,
	[NCliente_Globaliagifts] [nvarchar](50) NULL,
	[ZONA_ENVIO_INTERNACIONAL] [int] NULL,
	[SCHENGEN_NOSCHENGEN] [nvarchar](15) NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tablas]    Script Date: 22/03/2024 10:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tablas](
	[TipoTabla] [nvarchar](4) NOT NULL,
	[Codigo] [int] NOT NULL,
	[Texto] [varchar](50) NULL,
	[Texto2] [varchar](50) NULL,
	[Importe] [float] NULL,
	[Texto3] [varchar](50) NULL,
 CONSTRAINT [PK_Tablas] PRIMARY KEY CLUSTERED 
(
	[TipoTabla] ASC,
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
