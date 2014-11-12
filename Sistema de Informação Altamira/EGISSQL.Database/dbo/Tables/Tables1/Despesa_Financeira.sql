CREATE TABLE [dbo].[Despesa_Financeira] (
    [dt_base_desp_financeira] DATETIME   NOT NULL,
    [vl_despesa_financeira]   FLOAT (53) NOT NULL,
    [cd_usuario]              INT        NOT NULL,
    [dt_usuario]              DATETIME   NOT NULL,
    CONSTRAINT [PK_Despesa_Financeira] PRIMARY KEY CLUSTERED ([dt_base_desp_financeira] ASC) WITH (FILLFACTOR = 90)
);

