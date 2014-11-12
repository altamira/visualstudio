CREATE TABLE [dbo].[Modalidade_Pagamento_Parcela] (
    [cd_modalidade_pagamento] INT        NOT NULL,
    [cd_item_modalidade]      INT        NOT NULL,
    [qt_dia]                  INT        NULL,
    [qt_parcela]              FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Modalidade_Pagamento_Parcela] PRIMARY KEY CLUSTERED ([cd_modalidade_pagamento] ASC, [cd_item_modalidade] ASC) WITH (FILLFACTOR = 90)
);

