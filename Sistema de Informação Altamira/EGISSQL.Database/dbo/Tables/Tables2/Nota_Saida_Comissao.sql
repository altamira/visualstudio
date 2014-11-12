CREATE TABLE [dbo].[Nota_Saida_Comissao] (
    [cd_comissao_nota]          INT          NOT NULL,
    [cd_nota_saida]             INT          NULL,
    [cd_vendedor]               INT          NULL,
    [vl_base_comissao_nota]     FLOAT (53)   NULL,
    [vl_comissao_nota]          FLOAT (53)   NULL,
    [pc_comissao_nota]          FLOAT (53)   NULL,
    [nm_obs_comissao_nota]      VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [vl_ipi_comissao_nota]      FLOAT (53)   NULL,
    [vl_icms_comissao_nota]     FLOAT (53)   NULL,
    [vl_red_piscofins_comissao] FLOAT (53)   NULL,
    [qt_parcela_comissao_nota]  INT          NULL,
    [pc_red_comissao_nota]      FLOAT (53)   NULL,
    [pc_fin_comissao_nota]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Nota_Saida_Comissao] PRIMARY KEY CLUSTERED ([cd_comissao_nota] ASC) WITH (FILLFACTOR = 90)
);

