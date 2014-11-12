CREATE TABLE [dbo].[Nota_Saida_Retencao] (
    [cd_nota_saida]         INT        NOT NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [vl_retido_pis]         FLOAT (53) NULL,
    [vl_retido_cofins]      FLOAT (53) NULL,
    [vl_retido_csll]        FLOAT (53) NULL,
    [vl_base_IRRF]          FLOAT (53) NULL,
    [vl_retido_irrf]        FLOAT (53) NULL,
    [vl_base_previdencia]   FLOAT (53) NULL,
    [vl_retido_previdencia] FLOAT (53) NULL,
    CONSTRAINT [PK_Nota_Saida_Retencao] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC)
);

