CREATE TABLE [dbo].[APC_Balancete] (
    [cd_controle]    INT        NOT NULL,
    [dt_base]        DATETIME   NULL,
    [vl_saldo_total] FLOAT (53) NULL,
    [cd_usuario]     INT        NULL,
    [dt_usuario]     DATETIME   NULL,
    CONSTRAINT [PK_APC_Balancete] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

