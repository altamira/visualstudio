CREATE TABLE [dbo].[Nota_Entrada_Parcela] (
    [cd_fornecedor]            INT          NOT NULL,
    [cd_nota_entrada]          INT          NOT NULL,
    [cd_serie_nota_fiscal]     INT          NOT NULL,
    [cd_parcela_nota_entrada]  INT          NOT NULL,
    [cd_operacao_fiscal]       INT          NOT NULL,
    [qt_dia_parc_nota_entrada] FLOAT (53)   NULL,
    [pc_parcela_nota_entrada]  FLOAT (53)   NULL,
    [ic_scp_parc_nota_entrada] CHAR (1)     NULL,
    [vl_parcela_nota_entrada]  FLOAT (53)   NULL,
    [nm_obs_parc_nota_entrada] VARCHAR (40) NULL,
    [dt_parcela_nota_entrada]  DATETIME     NULL,
    [cd_ident_parc_nota_entr]  VARCHAR (25) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_documento_pagar]       INT          NULL,
    [cd_plano_financeiro]      INT          NULL,
    CONSTRAINT [PK_Nota_Entrada_Parcela] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_nota_entrada] ASC, [cd_serie_nota_fiscal] ASC, [cd_operacao_fiscal] ASC, [cd_parcela_nota_entrada] ASC) WITH (FILLFACTOR = 90)
);

