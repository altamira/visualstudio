CREATE TABLE [dbo].[Modulo_Historico] (
    [cd_modulo]                INT           NOT NULL,
    [cd_item_modulo_historico] INT           NOT NULL,
    [dt_modulo_historico]      DATETIME      NULL,
    [cd_versao_modulo]         VARCHAR (15)  NULL,
    [ds_modulo_historico]      TEXT          NULL,
    [nm_doc_modulo_historico]  VARCHAR (100) NULL,
    [nm_obs_modulo_historico]  VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Modulo_Historico] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_item_modulo_historico] ASC) WITH (FILLFACTOR = 90)
);

