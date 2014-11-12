CREATE TABLE [dbo].[Processo_Producao_Composicao_Placa] (
    [cd_processo]               INT          NOT NULL,
    [cd_item_processo]          INT          NOT NULL,
    [cd_placa]                  INT          NOT NULL,
    [cd_processo_padrao]        INT          NULL,
    [cd_composicao_proc_padrao] INT          NULL,
    [cd_item_orcamento]         INT          NULL,
    [cd_operacao]               INT          NULL,
    [qt_hora_item_orcamento]    FLOAT (53)   NULL,
    [nm_obs_composicao_placa]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_compra_item_orcamento]  CHAR (1)     NULL,
    CONSTRAINT [PK_Processo_Producao_Composicao_Placa] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo] ASC, [cd_placa] ASC) WITH (FILLFACTOR = 90)
);

