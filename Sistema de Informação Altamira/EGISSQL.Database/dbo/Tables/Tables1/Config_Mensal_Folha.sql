﻿CREATE TABLE [dbo].[Config_Mensal_Folha] (
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
    [vl_familia_teto]         MONEY      NULL,
    [vl_familia_acima_teto]   MONEY      NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [vl_minimo_trib_ir]       MONEY      NULL,
    [vl_minimo_ir]            MONEY      NULL,
    [vl_ir_dependente]        MONEY      NULL,
    [vl_ir_funcionario_65]    MONEY      NULL,
    [vl_inss_prolabore]       MONEY      NULL,
    [vl_inss_autonomo]        MONEY      NULL,
    [dt_inicio_vigencia]      DATETIME   NULL,
    [dt_final_vigencia]       DATETIME   NULL,
    [pc_fgts]                 FLOAT (53) NULL,
    [pc_noturno]              FLOAT (53) NULL,
    [pc_insalubridade]        FLOAT (53) NULL,
    [pc_periculosidade]       FLOAT (53) NULL,
    [pc_inss_prolabore]       FLOAT (53) NULL,
    [pc_inss_autonomo]        FLOAT (53) NULL,
    [pc_convenio_medico]      FLOAT (53) NULL,
    [vl_refeicao_mensal]      FLOAT (53) NULL,
    [pc_refeicao_funcionario] FLOAT (53) NULL,
    [qt_hora_folha_periodo]   FLOAT (53) NULL,
    CONSTRAINT [PK_Config_Mensal_Folha] PRIMARY KEY CLUSTERED ([cd_config_mensal_folha] ASC, [dt_base_config_folha] ASC) WITH (FILLFACTOR = 90)
);

