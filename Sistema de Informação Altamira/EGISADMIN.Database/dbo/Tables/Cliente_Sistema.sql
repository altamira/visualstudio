CREATE TABLE [dbo].[Cliente_Sistema] (
    [cd_cliente_sistema]      INT           NOT NULL,
    [nm_cliente_sistema]      VARCHAR (15)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_ie_cliente_sistema]   VARCHAR (18)  NULL,
    [cd_cnpj_cliente_sistema] VARCHAR (18)  NULL,
    [cd_fax_cliente_sistema]  VARCHAR (15)  NULL,
    [cd_fone_cliente_sistema] VARCHAR (15)  NULL,
    [nm_site_cliente_sistema] VARCHAR (100) NULL,
    CONSTRAINT [PK_Cliente_Sistema] PRIMARY KEY CLUSTERED ([cd_cliente_sistema] ASC) WITH (FILLFACTOR = 90)
);

