﻿CREATE TABLE [dbo].[Recibo] (
    [cd_recibo]            INT        NOT NULL,
    [dt_recibo]            DATETIME   NULL,
    [cd_tipo_recibo]       INT        NULL,
    [cd_cliente]           INT        NULL,
    [cd_fornecedor]        INT        NULL,
    [ds_recibo]            TEXT       NULL,
    [vl_recibo]            FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [ic_tipo_recibo]       CHAR (1)   NULL,
    [ic_impresso_recibo]   CHAR (1)   NULL,
    [cd_departamento]      INT        NULL,
    [cd_funcionario]       INT        NULL,
    [cd_observacao_recibo] INT        NULL,
    [cd_destinatario]      INT        NULL,
    [cd_tipo_destinatario] INT        NULL,
    [cd_documento_receber] INT        NULL,
    CONSTRAINT [PK_Recibo] PRIMARY KEY CLUSTERED ([cd_recibo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Recibo_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Recibo_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Recibo_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]),
    CONSTRAINT [FK_Recibo_Tipo_Recibo] FOREIGN KEY ([cd_tipo_recibo]) REFERENCES [dbo].[Tipo_Recibo] ([cd_tipo_recibo])
);

