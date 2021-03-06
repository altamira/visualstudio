﻿CREATE TABLE [dbo].[REMESSA_VIAGEM_PEDIDO] (
    [CD_REMESSA_VIAGEM]     INT      NOT NULL,
    [CD_PEDIDO_VENDA]       INT      NOT NULL,
    [CD_CONDICAO_PAGAMENTO] INT      NULL,
    [CD_USUARIO]            INT      NULL,
    [DT_USUARIO]            DATETIME NULL,
    CONSTRAINT [PK_REMESSA_VIAGEM_PEDIDO] PRIMARY KEY CLUSTERED ([CD_REMESSA_VIAGEM] ASC, [CD_PEDIDO_VENDA] ASC) WITH (FILLFACTOR = 90)
);

