CREATE TABLE [dbo].[Cliente_Autorizacao] (
    [cd_cliente]                INT          NOT NULL,
    [cd_cliente_autorizacao]    INT          NOT NULL,
    [nm_cliente_autorizacao]    VARCHAR (40) NULL,
    [cd_ddd_cliente]            INT          NULL,
    [cd_fone_cliente]           VARCHAR (15) NULL,
    [cd_celular_cliente]        VARCHAR (15) NULL,
    [nm_obs_client_autorizacao] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Autorizacao] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_autorizacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Autorizacao_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

