CREATE TABLE [dbo].[Parametro_CPV] (
    [cd_empresa] INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Parametro_CPV] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

