CREATE TABLE [dbo].[Imposto_Documento_Pagar] (
    [cd_imposto]            INT          NOT NULL,
    [cd_empresa_diversa]    INT          NULL,
    [cd_favorecido_empresa] INT          NULL,
    [cd_tipo_documento]     INT          NULL,
    [cd_tipo_conta_pagar]   INT          NULL,
    [cd_plano_financeiro]   INT          NULL,
    [cd_centro_custo]       INT          NULL,
    [cd_fornecedor]         INT          NULL,
    [nm_obs_documento]      VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Imposto_Documento_Pagar] PRIMARY KEY CLUSTERED ([cd_imposto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Imposto_Documento_Pagar_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Imposto_Documento_Pagar_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

