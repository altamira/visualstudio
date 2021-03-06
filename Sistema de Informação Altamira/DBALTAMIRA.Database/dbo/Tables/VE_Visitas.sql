﻿CREATE TABLE [dbo].[VE_Visitas] (
    [vevi_Numero]         INT           NOT NULL,
    [vevi_Abreviado]      VARCHAR (14)  NOT NULL,
    [vevi_Nome]           VARCHAR (40)  NOT NULL,
    [vevi_Endereco]       VARCHAR (40)  NULL,
    [vevi_Bairro]         VARCHAR (25)  NULL,
    [vevi_Cidade]         NVARCHAR (25) NULL,
    [vevi_Estado]         NVARCHAR (2)  NULL,
    [vevi_CEP]            VARCHAR (9)   NULL,
    [vevi_DDD]            NVARCHAR (4)  NULL,
    [vevi_Telefone]       NVARCHAR (25) NULL,
    [vevi_DDDFax]         NVARCHAR (4)  NULL,
    [vevi_NumeroFax]      NVARCHAR (25) NULL,
    [vevi_Contato]        VARCHAR (30)  NULL,
    [vevi_Departamento]   NVARCHAR (20) NULL,
    [vevi_Representante]  VARCHAR (3)   NOT NULL,
    [vevi_Data]           SMALLDATETIME NOT NULL,
    [vevi_Propaganda]     SMALLINT      NULL,
    [vevi_Produto]        SMALLINT      NULL,
    [vevi_Chamado]        SMALLINT      NULL,
    [vevi_Observacao]     TEXT          NULL,
    [vevi_Email]          NVARCHAR (25) NULL,
    [vevi_Potencial]      SMALLINT      NULL,
    [vevi_RAtividade]     SMALLINT      NULL,
    [vevi_DataImportacao] SMALLDATETIME NULL,
    [vevi_Lock]           VARBINARY (8) NULL
);

