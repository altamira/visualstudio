CREATE TABLE [dbo].[Modulo_Liberacao] (
    [cd_modulo]                INT          NOT NULL,
    [cd_item_modulo_liberacao] INT          NOT NULL,
    [cd_versao_modulo]         VARCHAR (15) NULL,
    [ic_versao_ativa]          CHAR (1)     NULL,
    [nm_motivo_liberacao]      VARCHAR (40) NULL,
    [nm_obs_modulo_liberacao]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [dt_versao_modulo]         DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Liberacao] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_item_modulo_liberacao] ASC) WITH (FILLFACTOR = 90)
);

