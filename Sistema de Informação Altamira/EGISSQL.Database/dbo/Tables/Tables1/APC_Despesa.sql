CREATE TABLE [dbo].[APC_Despesa] (
    [cd_controle] INT        NOT NULL,
    [dt_base]     DATETIME   NULL,
    [vl_despesa]  FLOAT (53) NULL,
    [cd_usuario]  INT        NULL,
    [dt_usuario]  DATETIME   NULL,
    CONSTRAINT [PK_APC_Despesa] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

