CREATE TABLE [dbo].[Fluxo_Caixa_Historico] (
    [cd_plano_financeiro]      INT        NOT NULL,
    [dt_inicial_historico]     DATETIME   NULL,
    [dt_final_historico]       DATETIME   NULL,
    [vl_caixa_fluxo_historico] FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [vl_fluxo_caixa_historico] FLOAT (53) NULL
);

