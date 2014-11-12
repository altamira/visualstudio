CREATE TABLE [dbo].[APC_Faturamento] (
    [cd_controle]    INT        NOT NULL,
    [dt_base]        DATETIME   NULL,
    [vl_faturamento] FLOAT (53) NULL,
    [cd_usuario]     INT        NULL,
    [dt_usuario]     DATETIME   NULL,
    CONSTRAINT [PK_APC_Faturamento] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

