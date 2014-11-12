CREATE TABLE [dbo].[Plano_Conta_Indicador] (
    [cd_indicador]           INT        NOT NULL,
    [cd_conta]               INT        NOT NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [vl_total_periodo_conta] FLOAT (53) NULL,
    [cd_ordem_calculo]       INT        NULL,
    CONSTRAINT [PK_Plano_Conta_Indicador] PRIMARY KEY CLUSTERED ([cd_indicador] ASC, [cd_conta] ASC) WITH (FILLFACTOR = 90)
);

