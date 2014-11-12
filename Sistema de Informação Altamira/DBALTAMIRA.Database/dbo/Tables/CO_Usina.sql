CREATE TABLE [dbo].[CO_Usina] (
    [cous_CodFornecedor] CHAR (14)     NOT NULL,
    [cous_CodBobina]     CHAR (14)     NOT NULL,
    [cous_NormaDoAco]    INT           NOT NULL,
    [cous_TipoDoAco]     INT           NOT NULL,
    [cous_Acabamento]    INT           NOT NULL,
    [cous_Espessura]     INT           NOT NULL,
    [cous_Largura]       DECIMAL (18)  NOT NULL,
    [cous_Peso]          DECIMAL (18)  NOT NULL,
    [cous_Pedido]        CHAR (14)     NOT NULL,
    [cous_DataPedido]    SMALLDATETIME NULL,
    [cous_Decendio]      CHAR (1)      NOT NULL,
    [cous_MesDecendio]   CHAR (2)      NULL,
    [cous_Lock]          BINARY (8)    NULL
);

