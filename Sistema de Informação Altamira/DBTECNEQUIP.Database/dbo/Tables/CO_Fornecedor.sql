﻿CREATE TABLE [dbo].[CO_Fornecedor] (
    [cofc_Codigo]      CHAR (14)    NOT NULL,
    [cofc_Abreviado]   CHAR (14)    NOT NULL,
    [cofc_Nome]        CHAR (40)    NOT NULL,
    [cofc_Endereco]    CHAR (40)    NOT NULL,
    [cofc_Bairro]      CHAR (25)    NOT NULL,
    [cofc_Cidade]      CHAR (25)    NOT NULL,
    [cofc_Estado]      CHAR (2)     NOT NULL,
    [cofc_Cep]         CHAR (9)     NOT NULL,
    [cofc_Inscricao]   CHAR (12)    NULL,
    [cofc_TipoPessoa]  CHAR (1)     NOT NULL,
    [cofc_Contato]     CHAR (20)    NULL,
    [cofc_Telefone]    CHAR (10)    NULL,
    [cofc_DDDTelefone] CHAR (4)     NULL,
    [cofc_Fax]         CHAR (10)    NULL,
    [cofc_DDDFax]      CHAR (4)     NULL,
    [cofc_Email]       CHAR (40)    NULL,
    [cofc_Servico]     TINYINT      NULL,
    [cofc_Pasta]       TINYINT      NULL,
    [cofc_Observacao]  VARCHAR (50) NULL,
    [cofc_Lock]        ROWVERSION   NOT NULL,
    CONSTRAINT [PK___1__12] PRIMARY KEY CLUSTERED ([cofc_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [cocf_IDAbreviado]
    ON [dbo].[CO_Fornecedor]([cofc_Abreviado] ASC);

