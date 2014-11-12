CREATE TABLE [dbo].[Recibo_Pagamento_Layout] (
    [cd_empresa]                INT           NOT NULL,
    [cd_modelo_recibo]          INT           NOT NULL,
    [cd_campo_recibo_pagamento] INT           NOT NULL,
    [ic_fonte_recibo]           CHAR (1)      NULL,
    [ic_negrito_recibo]         CHAR (1)      NULL,
    [ic_enfatizado_recibo]      CHAR (1)      NULL,
    [cd_tabela]                 INT           NULL,
    [cd_atributo]               INT           NULL,
    [nm_fixo_recibo]            VARCHAR (10)  NULL,
    [qt_linha_recibo]           INT           NULL,
    [qt_coluna_recibo]          INT           NULL,
    [qt_linha_fim_recibo]       INT           NULL,
    [qt_tam_campo_recibo]       INT           NULL,
    [ic_alin_campo_recibo]      CHAR (1)      NULL,
    [nm_sp_recibo_layout]       VARCHAR (100) NULL,
    [nm_sp_atributo_layout]     VARCHAR (25)  NULL,
    [qt_dec_campo_recibo]       INT           NULL,
    CONSTRAINT [PK_Recibo_Pagamento_Layout] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_modelo_recibo] ASC, [cd_campo_recibo_pagamento] ASC) WITH (FILLFACTOR = 90)
);

