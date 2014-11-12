CREATE TABLE [dbo].[Modulo_Versao] (
    [cd_modulo]            INT          NOT NULL,
    [cd_modulo_versao]     INT          NOT NULL,
    [cd_versao_modulo]     VARCHAR (15) NULL,
    [nm_obs_versao_modulo] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Versao] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_modulo_versao] ASC) WITH (FILLFACTOR = 90)
);

