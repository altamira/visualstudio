CREATE TABLE [dbo].[Processo_Producao_Servico] (
    [cd_processo]              INT      NOT NULL,
    [cd_item_processo]         INT      NOT NULL,
    [cd_ordem_servico]         INT      NOT NULL,
    [dt_ordem_servico]         DATETIME NULL,
    [ic_emitida_ordem_servico] CHAR (1) NULL,
    [ds_ordem_servico]         TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Processo_Producao_Servico] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo] ASC) WITH (FILLFACTOR = 90)
);

