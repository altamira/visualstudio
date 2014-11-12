CREATE TABLE [dbo].[Plano_Simulacao_Producao] (
    [dt_inicio_plano_simulacao]  DATETIME   NOT NULL,
    [dt_final_plano_simulacao]   DATETIME   NOT NULL,
    [cd_produto]                 INT        NOT NULL,
    [qt_produto_plano_simulacao] FLOAT (53) NULL,
    [qt_lead_plano_simulacao]    INT        NULL,
    [cd_fase_produto]            INT        NOT NULL,
    [cd_categoria_produto]       INT        NULL,
    [qt_saldo_plano_simulacao]   FLOAT (53) NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [qt_produc_plano_simulacao]  FLOAT (53) NULL,
    CONSTRAINT [PK_Plano_Simulacao_Producao] PRIMARY KEY CLUSTERED ([dt_inicio_plano_simulacao] ASC, [dt_final_plano_simulacao] ASC, [cd_produto] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90)
);

