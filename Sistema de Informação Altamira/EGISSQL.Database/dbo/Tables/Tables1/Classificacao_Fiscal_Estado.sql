CREATE TABLE [dbo].[Classificacao_Fiscal_Estado] (
    [cd_classificacao_fiscal]   INT          NULL,
    [cd_estado]                 INT          NULL,
    [pc_icms_classif_fiscal]    FLOAT (53)   NULL,
    [pc_redu_icms_class_fiscal] FLOAT (53)   NULL,
    [cd_dispositivo_legal]      INT          NULL,
    [nm_classif_fiscal_estado]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [pc_icms_clas_fiscal]       FLOAT (53)   NULL,
    [pc_red_icms_clas_fiscal]   FLOAT (53)   NULL,
    [nm_clas_fiscal_estado]     VARCHAR (40) NULL,
    [pc_icms_strib_clas_fiscal] FLOAT (53)   NULL,
    [pc_interna_icms_clas_fis]  FLOAT (53)   NULL,
    [cd_dispositivo_legal_ipi]  INT          NULL,
    [ic_ipi_isento_zfm_estado]  CHAR (1)     NULL,
    [ic_isento_icms_estado]     CHAR (1)     NULL
);

