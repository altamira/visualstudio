CREATE TABLE [dbo].[Plano_Financeiro_Orcamento] (
    [cd_plano_financeiro]       INT        NOT NULL,
    [dt_inicio_p_financeiro]    DATETIME   NOT NULL,
    [dt_final_p_financeiro]     DATETIME   NOT NULL,
    [vl_previsto_p_financeiro]  FLOAT (53) NULL,
    [vl_realizado_p_financeiro] FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Plano_Financeiro_Orcamento] PRIMARY KEY CLUSTERED ([dt_inicio_p_financeiro] ASC, [dt_final_p_financeiro] ASC, [cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90)
);

