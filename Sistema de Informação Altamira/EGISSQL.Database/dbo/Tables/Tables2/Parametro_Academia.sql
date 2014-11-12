CREATE TABLE [dbo].[Parametro_Academia] (
    [cd_empresa]       INT      NOT NULL,
    [ic_acesso_manual] CHAR (1) NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    [ic_tipo_acesso]   CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Academia] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

