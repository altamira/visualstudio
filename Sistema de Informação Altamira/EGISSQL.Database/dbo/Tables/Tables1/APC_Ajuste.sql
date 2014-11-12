CREATE TABLE [dbo].[APC_Ajuste] (
    [cd_controle] INT        NOT NULL,
    [dt_base]     DATETIME   NULL,
    [vl_ajuste]   FLOAT (53) NULL,
    [cd_usuario]  INT        NULL,
    [dt_usuario]  DATETIME   NULL,
    CONSTRAINT [PK_APC_Ajuste] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

