CREATE TABLE [dbo].[DRE_Plano_Conta] (
    [cd_dre_plano_conta] INT      NOT NULL,
    [cd_dre_grupo]       INT      NOT NULL,
    [cd_item_dr_grupo]   INT      NULL,
    [cd_plano_conta]     INT      NULL,
    [ic_dre_plano_conta] CHAR (1) NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_DRE_Plano_Conta] PRIMARY KEY CLUSTERED ([cd_dre_plano_conta] ASC) WITH (FILLFACTOR = 90)
);

