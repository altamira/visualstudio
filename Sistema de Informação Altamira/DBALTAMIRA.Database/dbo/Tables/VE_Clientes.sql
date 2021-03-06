﻿CREATE TABLE [dbo].[VE_Clientes] (
    [vecl_Codigo]               CHAR (14)     NOT NULL,
    [vecl_Abreviado]            CHAR (14)     NOT NULL,
    [vecl_Nome]                 VARCHAR (50)  NOT NULL,
    [vecl_Endereco]             VARCHAR (50)  NULL,
    [vecl_Bairro]               CHAR (25)     NULL,
    [vecl_Cidade]               CHAR (25)     NULL,
    [vecl_Estado]               CHAR (2)      NULL,
    [vecl_Municipio]            CHAR (25)     NULL,
    [vecl_Cep]                  CHAR (9)      NULL,
    [vecl_Inscricao]            CHAR (14)     NULL,
    [vecl_Contato]              VARCHAR (20)  NULL,
    [vecl_Departamento]         VARCHAR (20)  NULL,
    [vecl_Telefone]             CHAR (10)     NULL,
    [vecl_Fax]                  CHAR (10)     NULL,
    [vecl_DDD]                  CHAR (4)      NULL,
    [vecl_Representante]        CHAR (3)      NOT NULL,
    [vecl_Observacao]           VARCHAR (55)  NULL,
    [vecl_Credito]              VARCHAR (55)  NULL,
    [vecl_Email]                VARCHAR (40)  NULL,
    [vecl_TipoPessoa]           CHAR (1)      NOT NULL,
    [vecl_Transportadora]       INT           NOT NULL,
    [vecl_NumeroRG]             VARCHAR (12)  NULL,
    [vecl_DataNascimento]       SMALLDATETIME NULL,
    [vecl_CobEndereco]          VARCHAR (40)  NULL,
    [vecl_CobBairro]            VARCHAR (25)  NULL,
    [vecl_CobCidade]            VARCHAR (25)  NULL,
    [vecl_CobEstado]            VARCHAR (2)   NULL,
    [vecl_CobCep]               VARCHAR (9)   NULL,
    [vecl_CobDDD]               VARCHAR (4)   NULL,
    [vecl_CobTelefone]          VARCHAR (10)  NULL,
    [vecl_CobFax]               VARCHAR (10)  NULL,
    [vecl_CobEmail]             VARCHAR (40)  NULL,
    [vecl_UltimaCompra]         SMALLDATETIME NULL,
    [vecl_VlUltimaCompra]       MONEY         NULL,
    [vecl_StatusUltimaCompra]   CHAR (10)     NULL,
    [vecl_Acumulado]            MONEY         NULL,
    [vecl_QtdeCompras]          REAL          NULL,
    [vecl_MaiorCompra]          SMALLDATETIME NULL,
    [vecl_vlMaiorCompra]        MONEY         NULL,
    [vecl_StatusMaiorCompra]    CHAR (10)     NULL,
    [vecl_PrimeiraCompra]       SMALLDATETIME NULL,
    [vecl_VlPrimeiraCompra]     MONEY         NULL,
    [vecl_StatusPrimeiraCompra] CHAR (10)     NULL,
    [vecl_SUFRAMA]              VARCHAR (20)  NULL,
    [vecl_Lock]                 BINARY (8)    NULL,
    CONSTRAINT [PK_VE_Clientes] PRIMARY KEY NONCLUSTERED ([vecl_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Clientes]
    ON [dbo].[VE_Clientes]([vecl_Abreviado] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Clientes_1]
    ON [dbo].[VE_Clientes]([vecl_Nome] ASC) WITH (FILLFACTOR = 90);

