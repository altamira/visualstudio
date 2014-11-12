CREATE TABLE [dbo].[Processo_Producao_Revisao] (
    [cd_processo]              INT           NOT NULL,
    [cd_item_processo_revisao] INT           NOT NULL,
    [dt_revisao_processo]      DATETIME      NULL,
    [cd_tipo_revisao_processo] INT           NULL,
    [nm_revisao_processo]      VARCHAR (40)  NULL,
    [ds_revisao_processo]      TEXT          NULL,
    [nm_desenho_revisao]       VARCHAR (50)  NULL,
    [nm_caminho_revisao]       VARCHAR (100) NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_processista]           INT           NULL,
    CONSTRAINT [PK_Processo_Producao_Revisao] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo_revisao] ASC) WITH (FILLFACTOR = 90)
);

