CREATE TABLE [dbo].[Saldo_Conta_Implantacao] (
    [cd_empresa]           INT        NOT NULL,
    [cd_conta]             INT        NOT NULL,
    [dt_implantacao]       DATETIME   NOT NULL,
    [vl_saldo_implantacao] FLOAT (53) NULL,
    [ic_saldo_implantacao] CHAR (1)   NOT NULL,
    [ic_implantado]        CHAR (1)   NOT NULL,
    [cd_usuario]           INT        NOT NULL,
    [dt_usuario]           DATETIME   NOT NULL,
    CONSTRAINT [PK_Saldo_conta_implantacao] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_conta] ASC, [dt_implantacao] ASC) WITH (FILLFACTOR = 90)
);

