CREATE TABLE [dbo].[PRE_Selecao] (
    [prse_Usuario]     NVARCHAR (20) NOT NULL,
    [prse_Sequencia]   INT           NOT NULL,
    [prse_Produto]     NVARCHAR (11) NOT NULL,
    [prse_Descricao]   NVARCHAR (50) NULL,
    [prse_Quantidade]  FLOAT (53)    NULL,
    [prse_Comprimento] FLOAT (53)    NULL,
    [prse_Largura]     FLOAT (53)    NULL,
    [prse_SubNivel]    INT           NULL,
    [prse_Peso]        REAL          NULL,
    [prse_Preco]       MONEY         NULL,
    [prse_IPI]         REAL          NULL
);

