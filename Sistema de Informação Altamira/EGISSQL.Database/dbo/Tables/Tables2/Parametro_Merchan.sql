CREATE TABLE [dbo].[Parametro_Merchan] (
    [cd_empresa]              INT          NOT NULL,
    [cd_ip_smtp_empresa]      VARCHAR (15) NULL,
    [cd_porta_smtp_empresa]   VARCHAR (6)  NULL,
    [nm_usuario_smtp_empresa] VARCHAR (20) NULL,
    [cd_senha_smtp_empresa]   VARCHAR (15) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [qt_tempo_conexao]        INT          NULL,
    CONSTRAINT [PK_Parametro_Merchan] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Merchan_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

