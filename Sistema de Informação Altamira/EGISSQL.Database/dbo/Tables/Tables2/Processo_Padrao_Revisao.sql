CREATE TABLE [dbo].[Processo_Padrao_Revisao] (
    [cd_processo_padrao]       INT           NOT NULL,
    [cd_item_processo_revisao] INT           NOT NULL,
    [dt_revisao_processo]      DATETIME      NULL,
    [cd_tipo_revisao_processo] INT           NULL,
    [nm_revisao_processo]      VARCHAR (40)  NULL,
    [ds_revisao_processo]      TEXT          NULL,
    [cd_processista]           INT           NULL,
    [nm_desenho_revisao]       VARCHAR (50)  NULL,
    [nm_caminho_revisao]       VARCHAR (100) NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [nm_fantasia_processista]  VARCHAR (40)  NULL,
    CONSTRAINT [PK_Processo_Padrao_Revisao] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_item_processo_revisao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Revisao_Processista] FOREIGN KEY ([cd_processista]) REFERENCES [dbo].[Processista] ([cd_processista])
);

