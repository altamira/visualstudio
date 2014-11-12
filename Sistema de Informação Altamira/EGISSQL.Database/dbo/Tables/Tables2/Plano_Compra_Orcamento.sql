CREATE TABLE [dbo].[Plano_Compra_Orcamento] (
    [cd_plano_compra]           INT        NOT NULL,
    [dt_inicial_plano_compra]   DATETIME   NOT NULL,
    [dt_final_plano_compra]     DATETIME   NOT NULL,
    [vl_previsto_plano_compra]  FLOAT (53) NULL,
    [vl_realizado_plano_compra] FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Plano_Compra_Orcamento] PRIMARY KEY CLUSTERED ([cd_plano_compra] ASC, [dt_inicial_plano_compra] ASC, [dt_final_plano_compra] ASC) WITH (FILLFACTOR = 90)
);

