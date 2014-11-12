CREATE TABLE [dbo].[Orcamento_Financeiro] (
    [cd_orcamento]            INT        NOT NULL,
    [cd_ano]                  INT        NOT NULL,
    [cd_mes]                  INT        NOT NULL,
    [cd_plano_financeiro]     INT        NOT NULL,
    [vl_orcamento_financeiro] FLOAT (53) NULL,
    [vl_realizado_financeiro] FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Orcamento_Financeiro] PRIMARY KEY CLUSTERED ([cd_orcamento] ASC) WITH (FILLFACTOR = 90)
);

