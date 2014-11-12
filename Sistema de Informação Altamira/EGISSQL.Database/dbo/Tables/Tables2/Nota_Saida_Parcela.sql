CREATE TABLE [dbo].[Nota_Saida_Parcela] (
    [cd_nota_saida]             INT          NOT NULL,
    [cd_parcela_nota_saida]     INT          NOT NULL,
    [cd_num_formulario_nota]    INT          NULL,
    [qt_dia_parcela_nota_saida] INT          NULL,
    [pc_parcela_nota_saida]     FLOAT (53)   NULL,
    [ic_scr_parcela_nota_saida] CHAR (1)     NULL,
    [vl_parcela_nota_saida]     FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_dup_parcela_nota_saida] CHAR (1)     NULL,
    [nm_obs_parcela_nota_saida] VARCHAR (80) NULL,
    [dt_parcela_nota_saida]     DATETIME     NULL,
    [cd_ident_parc_nota_saida]  VARCHAR (25) NULL,
    [ic_boleto_parc_nota_saida] CHAR (1)     NULL,
    [ic_vctoespecif_pagto_parc] CHAR (1)     NULL,
    [ic_editado_parc_nota]      CHAR (1)     NULL,
    [ic_parcela_quitada]        CHAR (1)     NULL,
    [cd_plano_financeiro]       INT          NULL,
    [cd_centro_custo]           INT          NULL
);

