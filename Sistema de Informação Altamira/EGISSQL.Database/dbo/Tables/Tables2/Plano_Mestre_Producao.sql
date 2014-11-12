CREATE TABLE [dbo].[Plano_Mestre_Producao] (
    [dt_inicio_plano_mestre]   DATETIME   NOT NULL,
    [dt_final_plano_mestre]    DATETIME   NOT NULL,
    [cd_produto]               INT        NOT NULL,
    [qt_produto_plano_mestre]  FLOAT (53) NULL,
    [qt_lead_plano_mestre]     INT        NULL,
    [cd_fase_produto]          INT        NOT NULL,
    [cd_categoria_produto]     INT        NULL,
    [qt_saldo_plano_mestre]    FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_producao_plano_mestre] FLOAT (53) NULL,
    CONSTRAINT [PK_Plano_Mestre_Producao] PRIMARY KEY CLUSTERED ([dt_inicio_plano_mestre] ASC, [dt_final_plano_mestre] ASC, [cd_produto] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90)
);

