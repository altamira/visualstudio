CREATE TABLE [dbo].[Parametro_Cheque_Pagar] (
    [cd_empresa]             INT        NOT NULL,
    [ic_altera_saldo_cheque] CHAR (1)   NULL,
    [vl_limite_cheque]       FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Parametro_Cheque_Pagar] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

