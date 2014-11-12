CREATE TABLE [dbo].[PRE_ProdutosTexto] (
    [prpt_Numero]        INT           NOT NULL,
    [prpt_Item]          INT           NOT NULL,
    [prpt_Opcao]         INT           NOT NULL,
    [prpt_Sequencia]     INT           NOT NULL,
    [prpt_Produto]       NVARCHAR (11) NOT NULL,
    [prpt_Quantidade]    FLOAT (53)    NULL,
    [prpt_Comprimento]   NVARCHAR (10) NULL,
    [prpt_Largura]       NVARCHAR (10) NULL,
    [prpt_SubNivel]      INT           NULL,
    [prpt_Peso]          REAL          NULL,
    [prpt_ValorUnitario] MONEY         NULL,
    [prpt_IPI]           REAL          NULL,
    [prpt_QtdeCalculo]   REAL          NULL,
    [prpt_DataCarteira]  SMALLDATETIME NULL,
    [prpt_TabelaPrecos]  REAL          NULL,
    [prpt_TipoChapa]     REAL          NULL,
    [prpt_PesoTinta]     REAL          NULL,
    [prpt_CorFormica]    REAL          NULL
);

