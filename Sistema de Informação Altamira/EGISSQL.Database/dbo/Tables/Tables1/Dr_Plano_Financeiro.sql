CREATE TABLE [dbo].[Dr_Plano_Financeiro] (
    [cd_dr_grupo]            INT      NULL,
    [cd_dr_plano_financeiro] INT      NOT NULL,
    [cd_item_dr_grupo]       INT      NULL,
    [cd_plano_financeiro]    INT      NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    [ic_dr_plano_financeiro] CHAR (1) NULL,
    CONSTRAINT [PK_Dr_Plano_Financeiro] PRIMARY KEY CLUSTERED ([cd_dr_plano_financeiro] ASC) WITH (FILLFACTOR = 90)
);

