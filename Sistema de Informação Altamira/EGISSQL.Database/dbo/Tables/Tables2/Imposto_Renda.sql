CREATE TABLE [dbo].[Imposto_Renda] (
    [cd_config_mensal_folha] INT        NOT NULL,
    [cd_classe_ir]           INT        NOT NULL,
    [vl_base_ir]             MONEY      NULL,
    [pc_base_ir]             FLOAT (53) NULL,
    [vl_educacao_ir]         MONEY      NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [vl_base_final_ir]       FLOAT (53) NULL,
    [vl_deducao_ir]          FLOAT (53) NULL,
    CONSTRAINT [PK_Imposto_Renda] PRIMARY KEY CLUSTERED ([cd_config_mensal_folha] ASC, [cd_classe_ir] ASC) WITH (FILLFACTOR = 90)
);

