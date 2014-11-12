CREATE TABLE [dbo].[Processo_Padrao_Produto_Alteracao] (
    [cd_processo_padrao]        INT          NOT NULL,
    [cd_produto_proc_padrao]    INT          NOT NULL,
    [cd_item_alteracao]         INT          NOT NULL,
    [dt_alteracao_processo]     DATETIME     NULL,
    [cd_produto_anterior]       INT          NULL,
    [cd_produto]                INT          NULL,
    [nm_obs_processo_alteracao] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Processo_Padrao_Produto_Alteracao] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_produto_proc_padrao] ASC, [cd_item_alteracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Produto_Alteracao_Processo_Padrao] FOREIGN KEY ([cd_processo_padrao]) REFERENCES [dbo].[Processo_Padrao] ([cd_processo_padrao])
);

