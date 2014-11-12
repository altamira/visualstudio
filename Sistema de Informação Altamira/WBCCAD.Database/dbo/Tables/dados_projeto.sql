﻿CREATE TABLE [dbo].[dados_projeto] (
    [numeroOrcamento]     NVARCHAR (9)   NOT NULL,
    [DADOS_PROJETO_CHAVE] NVARCHAR (30)  NOT NULL,
    [DADOS_PROJETO_VALOR] NVARCHAR (255) NULL,
    CONSTRAINT [dados_projeto_PK] PRIMARY KEY CLUSTERED ([numeroOrcamento] ASC, [DADOS_PROJETO_CHAVE] ASC)
);

