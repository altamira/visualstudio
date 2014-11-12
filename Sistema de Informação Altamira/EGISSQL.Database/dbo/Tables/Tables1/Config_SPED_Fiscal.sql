CREATE TABLE [dbo].[Config_SPED_Fiscal] (
    [cd_empresa]    INT      NOT NULL,
    [cd_usuario]    INT      NULL,
    [dt_usuario]    DATETIME NULL,
    [cd_perfil]     INT      NULL,
    [cd_finalidade] INT      NULL,
    [cd_indicador]  INT      NULL,
    [cd_versao]     INT      NULL,
    [cd_contador]   INT      NULL,
    CONSTRAINT [PK_Config_SPED_Fiscal] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_SPED_Fiscal_Contador] FOREIGN KEY ([cd_contador]) REFERENCES [dbo].[Contador] ([cd_contador])
);

