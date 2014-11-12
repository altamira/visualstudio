CREATE TABLE [dbo].[Lote_Receber] (
    [cd_lote_receber]       INT          NOT NULL,
    [dt_lote_receber]       DATETIME     NULL,
    [cd_identificacao_lote] VARCHAR (25) NULL,
    [cd_cliente]            INT          NULL,
    [dt_emissao_lote]       DATETIME     NULL,
    [dt_vencimento_lote]    DATETIME     NULL,
    [vl_lote_receber]       FLOAT (53)   NULL,
    [vl_saldo_lote_receber] FLOAT (53)   NULL,
    [nm_obs_lote_receber]   VARCHAR (40) NULL,
    [cd_portador]           INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_moeda]              INT          NULL,
    [cd_tipo_cobranca]      INT          NULL,
    [cd_plano_financeiro]   INT          NULL,
    [cd_vendedor]           INT          NULL,
    [cd_tipo_documento]     INT          NULL,
    [cd_centro_custo]       INT          NULL,
    CONSTRAINT [PK_Lote_Receber] PRIMARY KEY CLUSTERED ([cd_lote_receber] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Lote_Receber_Portador] FOREIGN KEY ([cd_portador]) REFERENCES [dbo].[Portador] ([cd_portador])
);

