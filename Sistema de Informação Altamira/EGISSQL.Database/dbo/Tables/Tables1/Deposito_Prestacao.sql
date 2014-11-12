CREATE TABLE [dbo].[Deposito_Prestacao] (
    [cd_deposito_prestacao] INT      NOT NULL,
    [dt_deposito_prestacao] DATETIME NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Deposito_Prestacao] PRIMARY KEY CLUSTERED ([cd_deposito_prestacao] ASC) WITH (FILLFACTOR = 90)
);

