CREATE TABLE [dbo].[Config_Mensal_Falta] (
    [cd_config_mensal_folha]  INT        NOT NULL,
    [dt_base_config_folha]    DATETIME   NOT NULL,
    [vl_minimo_real]          MONEY      NULL,
    [vl_minimo_base]          MONEY      NULL,
    [vl_educacao]             MONEY      NULL,
    [pc_reajuste_fgts]        FLOAT (53) NULL,
    [vl_arredondamento_base]  MONEY      NULL,
    [pc_vale_transporte]      FLOAT (53) NULL,
    [pc_despesa_saude]        FLOAT (53) NULL,
    [pc_adiantamento_salario] FLOAT (53) NULL,
    [vl_teto_maternidade]     MONEY      NULL,
    [vl_familia_teto]         FLOAT (53) NULL,
    [vl_familia_acima_teto]   FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Config_Mensal_Falta] PRIMARY KEY CLUSTERED ([cd_config_mensal_folha] ASC, [dt_base_config_folha] ASC) WITH (FILLFACTOR = 90)
);

