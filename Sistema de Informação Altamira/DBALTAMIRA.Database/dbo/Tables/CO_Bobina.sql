CREATE TABLE [dbo].[CO_Bobina] (
    [CodFornecedor]   CHAR (14)     NOT NULL,
    [CodPrestador]    CHAR (14)     NOT NULL,
    [CodBobina]       CHAR (14)     NOT NULL,
    [NumeroDaCorrida] CHAR (15)     NULL,
    [NormaDoAco]      INT           NOT NULL,
    [TipoDoAco]       INT           NOT NULL,
    [Acabamento]      INT           NOT NULL,
    [Espessura]       INT           NOT NULL,
    [Largura]         FLOAT (53)    NOT NULL,
    [PesoTotal]       FLOAT (53)    NOT NULL,
    [PedidoUsina]     CHAR (14)     NULL,
    [DataEntrega]     SMALLDATETIME NULL,
    [Observacao]      TEXT          NULL,
    [SaldoTonelada]   FLOAT (53)    NULL,
    [SaldoLargura]    FLOAT (53)    NULL,
    [BobinaUsina]     CHAR (14)     NULL,
    [Lock]            BINARY (8)    NULL
);

