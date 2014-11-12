CREATE TABLE [dbo].[Fornecedor_Licenca] (
    [cd_fornecedor]              INT          NOT NULL,
    [cd_tipo_licenca]            INT          NOT NULL,
    [cd_item_fornecedor_licenca] INT          NOT NULL,
    [cd_licenca]                 VARCHAR (25) NULL,
    [dt_emissao_licenca]         DATETIME     NULL,
    [dt_recebimento_licenca]     DATETIME     NULL,
    [dt_vencimento_licenca]      DATETIME     NULL,
    [nm_obs_licenca]             VARCHAR (40) NULL,
    [ic_ativo_licenca]           CHAR (1)     NULL,
    [ic_bloqueia_processo]       CHAR (1)     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Licenca] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_tipo_licenca] ASC, [cd_item_fornecedor_licenca] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Licenca_Tipo_Licenca] FOREIGN KEY ([cd_tipo_licenca]) REFERENCES [dbo].[Tipo_Licenca] ([cd_tipo_licenca])
);

