CREATE TABLE [dbo].[Co_Usina] (
    [cous_CodFornecedor] CHAR (14)     NOT NULL,
    [cous_CodBobina]     CHAR (14)     NOT NULL,
    [cous_NormalDoAco]   INT           NOT NULL,
    [cous_TipoDoAco]     INT           NOT NULL,
    [cous_Acabamento]    INT           NOT NULL,
    [cous_Espessura]     INT           NOT NULL,
    [cous_Largura]       NUMERIC (18)  NOT NULL,
    [cous_Peso]          NUMERIC (18)  NOT NULL,
    [cous_Pedido]        CHAR (14)     NOT NULL,
    [cous_DataPedido]    SMALLDATETIME NULL,
    [cous_Decendio]      CHAR (1)      NOT NULL,
    [cous_MesDecendio]   CHAR (2)      NULL,
    [cous_Lock]          ROWVERSION    NOT NULL,
    CONSTRAINT [PK_Co_Usina_8__17] PRIMARY KEY CLUSTERED ([cous_CodFornecedor] ASC, [cous_CodBobina] ASC, [cous_Pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UQ___6__17] UNIQUE NONCLUSTERED ([cous_CodFornecedor] ASC)
);

