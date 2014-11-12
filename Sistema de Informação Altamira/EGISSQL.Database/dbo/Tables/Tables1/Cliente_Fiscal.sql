CREATE TABLE [dbo].[Cliente_Fiscal] (
    [cd_cliente] INT      NOT NULL,
    [cd_cnae]    INT      NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Cliente_Fiscal] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90)
);

