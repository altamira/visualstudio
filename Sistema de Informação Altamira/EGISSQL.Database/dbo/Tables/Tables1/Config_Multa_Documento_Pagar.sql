CREATE TABLE [dbo].[Config_Multa_Documento_Pagar] (
    [cd_empresa]            INT      NOT NULL,
    [cd_config_geracao]     INT      NOT NULL,
    [cd_tipo_ap]            INT      NULL,
    [cd_plano_financeiro]   INT      NULL,
    [cd_centro_custo]       INT      NULL,
    [cd_tipo_conta_pagar]   INT      NULL,
    [cd_situacao_documento] INT      NULL,
    [cd_portador]           INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_tipo_documento]     INT      NULL,
    [cd_empresa_diversa]    INT      NULL,
    CONSTRAINT [PK_Config_Multa_Documento_Pagar] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_config_geracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Multa_Documento_Pagar_Empresa_Diversa] FOREIGN KEY ([cd_empresa_diversa]) REFERENCES [dbo].[Empresa_Diversa] ([cd_empresa_diversa]),
    CONSTRAINT [FK_Config_Multa_Documento_Pagar_Tipo_Documento] FOREIGN KEY ([cd_tipo_documento]) REFERENCES [dbo].[Tipo_Documento] ([cd_tipo_documento])
);

