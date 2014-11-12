CREATE TABLE [dbo].[Materia_Prima_Fornecedor_Custo] (
    [cd_controle]                 INT          NOT NULL,
    [cd_produto]                  INT          NOT NULL,
    [cd_mat_prima]                INT          NOT NULL,
    [cd_bitola]                   INT          NULL,
    [cd_fornecedor]               INT          NULL,
    [cd_condicao_pagamento]       INT          NULL,
    [vl_mat_prima_fornecedor]     FLOAT (53)   NULL,
    [dt_mat_prima_fornecedor]     DATETIME     NULL,
    [cd_moeda]                    INT          NULL,
    [nm_obs_mat_prima_fornecedor] VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Materia_Prima_Fornecedor_Custo] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Materia_Prima_Fornecedor_Custo_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

