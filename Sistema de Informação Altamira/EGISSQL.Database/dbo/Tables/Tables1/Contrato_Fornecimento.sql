CREATE TABLE [dbo].[Contrato_Fornecimento] (
    [cd_contrato_fornecimento] INT        NOT NULL,
    [dt_contrato_fornecimento] DATETIME   NOT NULL,
    [cd_contrato_interno]      CHAR (20)  NOT NULL,
    [cd_cliente]               INT        NULL,
    [cd_contato]               INT        NULL,
    [ds_contrato]              TEXT       NULL,
    [cd_vendedor]              INT        NULL,
    [cd_condicao_pagamento]    INT        NULL,
    [cd_destinacao_produto]    INT        NULL,
    [dt_inicial_contrato]      DATETIME   NULL,
    [dt_final_contrato]        DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_status_contrato]       INT        NULL,
    [vl_total_contrato]        FLOAT (53) NULL,
    CONSTRAINT [PK_Contrato_Fornecimento] PRIMARY KEY CLUSTERED ([cd_contrato_fornecimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Fornecimento_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Contrato_Fornecimento_Destinacao_Produto] FOREIGN KEY ([cd_destinacao_produto]) REFERENCES [dbo].[Destinacao_Produto] ([cd_destinacao_produto]),
    CONSTRAINT [FK_Contrato_Fornecimento_Status_Contrato] FOREIGN KEY ([cd_status_contrato]) REFERENCES [dbo].[Status_Contrato] ([cd_status_contrato])
);

