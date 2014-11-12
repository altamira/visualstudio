CREATE TABLE [dbo].[GrpPreco] (
    [idGrpPreco]         INT            IDENTITY (1, 1) NOT NULL,
    [GrpPreco_descricao] NVARCHAR (100) NOT NULL,
    [GenGrpPrecoCodigo]  NCHAR (50)     NOT NULL,
    [Produto]            NCHAR (50)     NOT NULL,
    [GenGrpPrecoFator]   FLOAT (53)     NOT NULL
);

