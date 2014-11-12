CREATE TABLE [dbo].[PRE_OServico] (
    [pros_NumOS]        FLOAT (53)    NOT NULL,
    [pros_NumPedido]    FLOAT (53)    NULL,
    [pros_DataPedido]   SMALLDATETIME NULL,
    [pros_DataEntrega]  SMALLDATETIME NULL,
    [pros_DataOS]       SMALLDATETIME NULL,
    [pros_NumProjeto]   CHAR (10)     NULL,
    [pros_NumOrcamento] FLOAT (53)    NULL,
    [pros_NumVendedor]  INT           NULL,
    [pros_CodCliente]   VARCHAR (30)  NULL,
    [pros_Cliente]      VARCHAR (50)  NULL,
    [pros_Endereco]     VARCHAR (50)  NULL,
    [pros_Bairro]       VARCHAR (50)  NULL,
    [pros_Cidade]       VARCHAR (50)  NULL,
    [pros_Estado]       CHAR (2)      NULL,
    [pros_CEP]          CHAR (10)     NULL,
    [pros_DDD1]         CHAR (10)     NULL,
    [pros_DDD2]         CHAR (10)     NULL,
    [pros_DDDFax]       CHAR (10)     NULL,
    [pros_Telefone1]    VARCHAR (50)  NULL,
    [pros_Telefone2]    VARCHAR (50)  NULL,
    [pros_Fax]          VARCHAR (50)  NULL,
    [pros_Contato]      VARCHAR (50)  NULL,
    [pros_Departamento] VARCHAR (50)  NULL,
    [pros_Produto1]     INT           NULL,
    [pros_Produto2]     INT           NULL,
    [pros_Produto3]     INT           NULL,
    [pros_Produto4]     INT           NULL,
    [pros_Produto5]     INT           NULL,
    [pros_Produto6]     INT           NULL,
    [pros_Acabamento]   INT           NULL,
    [pros_Observação]   TEXT          NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [PK_PRE_OSERVICO]
    ON [dbo].[PRE_OServico]([pros_NumOS] ASC) WITH (FILLFACTOR = 90);

