CREATE TABLE [dbo].[Saldo_Conta] (
    [cd_empresa]             INT        NOT NULL,
    [cd_conta]               INT        NOT NULL,
    [dt_saldo_conta]         DATETIME   NOT NULL,
    [vl_saldo_conta]         FLOAT (53) NOT NULL,
    [ic_saldo_conta]         CHAR (1)   NOT NULL,
    [cd_usuario]             INT        NOT NULL,
    [dt_usuario]             DATETIME   NOT NULL,
    [vl_debito_saldo_conta]  FLOAT (53) NULL,
    [vl_credito_saldo_conta] FLOAT (53) NULL,
    [vl_inicial_saldo_conta] FLOAT (53) NULL,
    [ic_inicial_saldo_conta] CHAR (1)   NULL,
    CONSTRAINT [PK_Saldo_conta] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_conta] ASC, [dt_saldo_conta] ASC) WITH (FILLFACTOR = 90)
);

