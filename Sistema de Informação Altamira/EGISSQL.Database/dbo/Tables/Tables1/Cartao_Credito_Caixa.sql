CREATE TABLE [dbo].[Cartao_Credito_Caixa] (
    [cd_cartao_credito]       INT      NOT NULL,
    [cd_portador]             INT      NULL,
    [cd_tipo_documento]       INT      NULL,
    [cd_tipo_cobranca]        INT      NULL,
    [cd_plano_financeiro]     INT      NULL,
    [cd_centro_custo]         INT      NULL,
    [ic_gera_baixa_documento] CHAR (1) NULL,
    [cd_conta_banco]          INT      NULL,
    [cd_tipo_caixa]           INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Cartao_Credito_Caixa] PRIMARY KEY CLUSTERED ([cd_cartao_credito] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cartao_Credito_Caixa_Tipo_Caixa] FOREIGN KEY ([cd_tipo_caixa]) REFERENCES [dbo].[Tipo_Caixa] ([cd_tipo_caixa])
);

