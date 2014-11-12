CREATE TABLE [dbo].[APC_Custo] (
    [cd_controle] INT        NOT NULL,
    [dt_base]     DATETIME   NULL,
    [vl_custo]    FLOAT (53) NULL,
    [cd_usuario]  INT        NULL,
    [dt_usuario]  DATETIME   NULL,
    CONSTRAINT [PK_APC_Custo] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

