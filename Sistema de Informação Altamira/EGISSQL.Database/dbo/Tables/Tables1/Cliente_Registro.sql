CREATE TABLE [dbo].[Cliente_Registro] (
    [cd_cliente_registro]       INT           NOT NULL,
    [nm_cliente_registro]       VARCHAR (40)  NULL,
    [nm_fantasia_cliente_reg]   VARCHAR (15)  NULL,
    [cd_ddd_cliente_registro]   INT           NULL,
    [cd_fone_cliente_registro]  VARCHAR (15)  NULL,
    [cd_fax_cliente_registro]   VARCHAR (15)  NULL,
    [nm_site_cliente_registro]  VARCHAR (100) NULL,
    [nm_email_cliente_registro] VARCHAR (100) NULL,
    [nm_contato_cliente_reg]    VARCHAR (40)  NULL,
    [ds_cliente_registro]       TEXT          NULL,
    [dt_cadastro_cliente_reg]   DATETIME      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_vendedor]               INT           NULL,
    [nm_depto_cont_cliente_reg] VARCHAR (25)  NULL,
    CONSTRAINT [PK_Cliente_Registro] PRIMARY KEY CLUSTERED ([cd_cliente_registro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Registro_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

