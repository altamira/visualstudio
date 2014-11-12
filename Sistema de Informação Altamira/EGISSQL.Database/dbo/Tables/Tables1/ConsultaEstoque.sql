CREATE TABLE [dbo].[ConsultaEstoque] (
    [cd_produto]               INT          NOT NULL,
    [cd_fase_produto]          INT          NOT NULL,
    [qt_saldo_reserva_produto] FLOAT (53)   NULL,
    [qt_saldo_atual_produto]   FLOAT (53)   NULL,
    [nm_banco_empresa]         VARCHAR (40) NOT NULL,
    [cd_empresa]               INT          NOT NULL
);

