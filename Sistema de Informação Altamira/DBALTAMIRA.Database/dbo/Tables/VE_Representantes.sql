CREATE TABLE [dbo].[VE_Representantes] (
    [verp_Codigo]      CHAR (3)       NOT NULL,
    [verp_RazaoSocial] VARCHAR (50)   NOT NULL,
    [verp_Endereco]    VARCHAR (50)   NOT NULL,
    [verp_Bairro]      VARCHAR (25)   NOT NULL,
    [verp_Cidade]      VARCHAR (25)   NOT NULL,
    [verp_Estado]      CHAR (2)       NOT NULL,
    [verp_Cep]         CHAR (9)       NOT NULL,
    [verp_DDD]         CHAR (4)       NULL,
    [verp_Telefone]    CHAR (10)      NULL,
    [verp_Celular]     CHAR (10)      NULL,
    [verp_PagerNumero] CHAR (10)      NULL,
    [verp_PagerCodigo] CHAR (10)      NULL,
    [verp_Fax]         CHAR (10)      NULL,
    [verp_Email]       VARCHAR (50)   NULL,
    [verp_Contato]     VARCHAR (25)   NULL,
    [verp_Comissao]    DECIMAL (6, 3) NOT NULL,
    [verp_CotaMensal]  MONEY          NOT NULL,
    [verp_CGC]         CHAR (14)      NULL,
    [verp_Inscricao]   CHAR (14)      NULL,
    [verp_Lock]        BINARY (8)     NULL,
    CONSTRAINT [PK_VE_Representantes] PRIMARY KEY NONCLUSTERED ([verp_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Representantes]
    ON [dbo].[VE_Representantes]([verp_RazaoSocial] ASC) WITH (FILLFACTOR = 90);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Representantes] TO [interclick]
    AS [dbo];

