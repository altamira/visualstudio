CREATE TABLE [dbo].[Condicao_Pagamento_Aprox] (
    [cd_condicao_parcela_aprox] INT      NOT NULL,
    [cd_condicao_pagamento]     INT      NOT NULL,
    [qt_dia_aproximacao]        INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Condicao_Pagamento_Aprox] PRIMARY KEY CLUSTERED ([cd_condicao_parcela_aprox] ASC, [cd_condicao_pagamento] ASC) WITH (FILLFACTOR = 90)
);

