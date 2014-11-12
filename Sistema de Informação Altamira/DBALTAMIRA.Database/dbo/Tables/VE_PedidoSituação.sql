﻿CREATE TABLE [dbo].[VE_PedidoSituação] (
    [vesi_Pedido]       INT           NOT NULL,
    [vesi_Situação]     SMALLINT      NOT NULL,
    [vesi_DataSituação] SMALLDATETIME NULL,
    [vesi_DataPrevisão] SMALLDATETIME NULL,
    [vesi_Parcial]      SMALLINT      NULL,
    CONSTRAINT [PK_VE_PedidoSituação_1] PRIMARY KEY CLUSTERED ([vesi_Pedido] ASC, [vesi_Situação] ASC) WITH (FILLFACTOR = 90)
);

