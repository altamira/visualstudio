CREATE TABLE [dbo].[SPED_Razao_Auxiliar] (
    [cd_controle]   INT          NOT NULL,
    [cd_livro]      INT          NOT NULL,
    [cd_cliente]    INT          NULL,
    [nm_cliente]    VARCHAR (50) NULL,
    [cd_documento]  VARCHAR (15) NULL,
    [dt_emissao]    DATETIME     NULL,
    [dt_vencimento] DATETIME     NULL,
    [dt_pagamento]  DATETIME     NULL,
    [vl_debito]     FLOAT (53)   NULL,
    [vl_credito]    FLOAT (53)   NULL,
    [vl_saldo]      FLOAT (53)   NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_SPED_Razao_Auxiliar] PRIMARY KEY CLUSTERED ([cd_controle] ASC),
    CONSTRAINT [FK_SPED_Razao_Auxiliar_SPED_Livro] FOREIGN KEY ([cd_livro]) REFERENCES [dbo].[SPED_Livro] ([cd_livro])
);

