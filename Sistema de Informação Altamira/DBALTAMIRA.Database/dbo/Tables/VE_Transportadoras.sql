CREATE TABLE [dbo].[VE_Transportadoras] (
    [vetr_Codigo]    INT          NOT NULL,
    [vetr_CGC]       CHAR (14)    NOT NULL,
    [vetr_Abreviado] CHAR (14)    NOT NULL,
    [vetr_Nome]      VARCHAR (50) NOT NULL,
    [vetr_Endereco]  VARCHAR (50) NULL,
    [vetr_Bairro]    VARCHAR (25) NULL,
    [vetr_Cidade]    VARCHAR (25) NULL,
    [vetr_Estado]    CHAR (2)     NULL,
    [vetr_Cep]       CHAR (9)     NULL,
    [vetr_DDD]       CHAR (4)     NULL,
    [vetr_Telefone]  CHAR (10)    NULL,
    [vetr_Fax]       CHAR (10)    NULL,
    [vetr_Email]     VARCHAR (50) NULL,
    [vetr_Contato]   VARCHAR (25) NULL,
    [vetr_Inscricao] CHAR (14)    NULL,
    [vetr_Lock]      BINARY (8)   NULL,
    CONSTRAINT [PK_VE_Transportadoras] PRIMARY KEY NONCLUSTERED ([vetr_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Transportadoras_1]
    ON [dbo].[VE_Transportadoras]([vetr_Abreviado] ASC) WITH (FILLFACTOR = 90);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Transportadoras] TO [interclick]
    AS [dbo];

