CREATE TABLE [dbo].[Processo_Producao_Fase_Apontamento] (
    [cd_processo]                   INT         NOT NULL,
    [cd_item_processo]              INT         NOT NULL,
    [cd_fase_producao]              INT         NOT NULL,
    [cd_processo_padrao]            INT         NULL,
    [cd_operador]                   INT         NOT NULL,
    [dt_processo_apontamento]       DATETIME    NOT NULL,
    [hr_inicial_apontamento]        VARCHAR (8) NOT NULL,
    [hr_final_apontamento]          VARCHAR (8) NOT NULL,
    [ic_operacao_concluida]         CHAR (1)    NULL,
    [ds_processo_apontamento]       TEXT        NULL,
    [cd_usuario]                    INT         NULL,
    [dt_usuario]                    DATETIME    NULL,
    [qt_total_apontamento]          FLOAT (53)  NULL,
    [dt_processo_apontamento_final] DATETIME    NULL,
    CONSTRAINT [PK_Processo_Producao_Fase_Apontamento] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Fase_Apontamento_Operador] FOREIGN KEY ([cd_operador]) REFERENCES [dbo].[Operador] ([cd_operador])
);

