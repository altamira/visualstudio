CREATE TABLE [dbo].[Deposito_Adiantamento] (
    [cd_deposito_adiantamento] INT      NOT NULL,
    [dt_deposito_adiantamento] DATETIME NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Deposito_Adiantamento] PRIMARY KEY CLUSTERED ([cd_deposito_adiantamento] ASC) WITH (FILLFACTOR = 90)
);

