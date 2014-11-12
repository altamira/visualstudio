CREATE TABLE [dbo].[Saldo_Plano_Especial] (
    [cd_empresa]              INT        NOT NULL,
    [cd_plano_padrao]         INT        NOT NULL,
    [cd_plano_especial]       INT        NOT NULL,
    [dt_saldo_plano_especial] DATETIME   NOT NULL,
    [cd_usuario]              INT        NOT NULL,
    [vl_saldo_plano_especial] FLOAT (53) NOT NULL,
    [ic_saldo_plano_especial] CHAR (1)   NOT NULL,
    [dt_usuario]              DATETIME   NOT NULL,
    CONSTRAINT [PK_Saldo_Plano_especial] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_plano_padrao] ASC, [cd_plano_especial] ASC, [dt_saldo_plano_especial] ASC) WITH (FILLFACTOR = 90)
);

