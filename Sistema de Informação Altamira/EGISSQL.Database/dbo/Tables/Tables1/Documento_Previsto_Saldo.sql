CREATE TABLE [dbo].[Documento_Previsto_Saldo] (
    [dt_previsto_saldo] DATETIME   NOT NULL,
    [vl_previsto_saldo] FLOAT (53) NULL,
    CONSTRAINT [PK_Documento_Previsto_Saldo] PRIMARY KEY CLUSTERED ([dt_previsto_saldo] ASC) WITH (FILLFACTOR = 90)
);

