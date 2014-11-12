CREATE TABLE [dbo].[Modulo_Versao_Cliente] (
    [cd_modulo]                INT          NULL,
    [cd_cliente]               INT          NULL,
    [cd_modulo_versao_cliente] INT          NOT NULL,
    [dt_modulo_versao_cliente] DATETIME     NULL,
    [cd_modulo_versao]         VARCHAR (15) NULL,
    [nm_obs_modulo_versao]     VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Versao_Cliente] PRIMARY KEY CLUSTERED ([cd_modulo_versao_cliente] ASC) WITH (FILLFACTOR = 90)
);

