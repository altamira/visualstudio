CREATE TABLE [dbo].[Vendedor_Comissao] (
    [cd_vendedor]               INT        NOT NULL,
    [cd_regiao_venda]           INT        NULL,
    [cd_tipo_comissao]          INT        NOT NULL,
    [dt_base_pagto_comissao]    DATETIME   NOT NULL,
    [dt_base_final_comissao]    DATETIME   NULL,
    [ic_calcula_data_final]     CHAR (1)   NOT NULL,
    [vl_piso_comissao_vendedor] FLOAT (53) NULL,
    [vl_teto_comissao_vendedor] FLOAT (53) NULL,
    [pc_comissao_vendedor]      FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_tipo_desconto_comissao] INT        NULL,
    [cd_vendedor_comissao]      INT        NOT NULL,
    [cd_tipo_faixa_comissao]    INT        NULL,
    CONSTRAINT [PK_Vendedor_Comissao] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_vendedor_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Comissao_Tipo_Comissao] FOREIGN KEY ([cd_tipo_comissao]) REFERENCES [dbo].[Tipo_Comissao] ([cd_tipo_comissao]),
    CONSTRAINT [FK_Vendedor_Comissao_Tipo_Desconto_Comissao] FOREIGN KEY ([cd_tipo_desconto_comissao]) REFERENCES [dbo].[Tipo_Desconto_Comissao] ([cd_tipo_desconto_comissao])
);

