CREATE TABLE [dbo].[Resultado_Pesquisa_Cliente] (
    [cd_resultado_pesquisa_cli] INT        NOT NULL,
    [cd_pesquisa]               INT        NOT NULL,
    [dt_pesquisa]               DATETIME   NOT NULL,
    [cd_item_questao_pesquisa]  INT        NOT NULL,
    [cd_alternativa]            INT        NOT NULL,
    [qt_ponto_pesquisa_cliente] FLOAT (53) NOT NULL,
    [cd_resposta_pesquisa]      INT        NOT NULL,
    [ds_sugestao_pesquisa_cli]  TEXT       COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ds_necessidade_pesq_cli]   TEXT       COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ds_expectativa_pesq_cli]   TEXT       COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_pesquisa_cliente]       INT        NOT NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [cd_alternativa_pesquisa]   INT        NULL
);

