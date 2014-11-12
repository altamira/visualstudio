CREATE TABLE [dbo].[dr_grupo_operacao_item] (
    [cd_operacao]          INT      NOT NULL,
    [cd_item_operacao]     INT      NULL,
    [cd_dr_grupo]          INT      NULL,
    [cd_dr_grupo_operacao] INT      NULL,
    [cd_item_dr_grupo]     INT      NULL,
    [ic_tipo_operacao]     CHAR (1) NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    [cd_dr_grupo_calculo]  INT      NULL,
    [cd_item_dr_calculo]   INT      NULL,
    CONSTRAINT [PK_dr_grupo_operacao_item] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90)
);

