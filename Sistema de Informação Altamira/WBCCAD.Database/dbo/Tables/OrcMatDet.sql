CREATE TABLE [dbo].[OrcMatDet] (
    [idOrcMatDet]      INT            IDENTITY (1, 1) NOT NULL,
    [idGrupo]          INT            NULL,
    [idSubGrupo]       NVARCHAR (70)  NULL,
    [codigoProduto]    NVARCHAR (70)  NULL,
    [codigoProdutoPai] NVARCHAR (70)  NULL,
    [descricao]        NVARCHAR (255) NULL,
    [cor]              NVARCHAR (100) NULL,
    [corPreco]         NVARCHAR (100) NULL,
    [quantidade]       FLOAT (53)     NULL,
    [precoLista]       MONEY          NULL,
    [preco1]           MONEY          NULL,
    [preco2]           MONEY          NULL,
    [preco3]           MONEY          NULL,
    [preco4]           MONEY          NULL,
    [preco5]           MONEY          NULL,
    [precoSemDesconto] MONEY          NULL,
    [unidade]          NVARCHAR (20)  NULL,
    [altura]           FLOAT (53)     NULL,
    [comprimento]      FLOAT (53)     NULL,
    [largura]          FLOAT (53)     NULL,
    [peso]             FLOAT (53)     NULL,
    [qtdeM2]           FLOAT (53)     NULL,
    [situacaoProduto]  NVARCHAR (100) NULL,
    [baseProduto]      NVARCHAR (255) NULL,
    [formulaPreco]     INT            NULL,
    [divisorPreco]     FLOAT (53)     NULL,
    [numeroOrcamento]  NCHAR (9)      NULL,
    CONSTRAINT [PK_OrcMatDet] PRIMARY KEY CLUSTERED ([idOrcMatDet] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcMatDet]
    ON [dbo].[OrcMatDet]([numeroOrcamento] ASC, [idOrcMatDet] ASC);

