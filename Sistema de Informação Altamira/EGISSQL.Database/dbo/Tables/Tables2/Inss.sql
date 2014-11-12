CREATE TABLE [dbo].[Inss] (
    [cd_config_mensal_folha] INT        NOT NULL,
    [cd_classe_inss]         INT        NOT NULL,
    [vl_base_inss]           MONEY      NULL,
    [pc_base_inss]           FLOAT (53) NULL,
    [vl_educacao_inss]       MONEY      NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [vl_base_final_inss]     FLOAT (53) NULL,
    CONSTRAINT [PK_Inss] PRIMARY KEY CLUSTERED ([cd_config_mensal_folha] ASC, [cd_classe_inss] ASC) WITH (FILLFACTOR = 90)
);

